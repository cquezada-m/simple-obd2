import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_diagnostic.dart';
import '../models/dtc_code.dart';
import '../models/vehicle_parameter.dart';
import '../data/dtc_database.dart';

/// Cliente para la API REST de Gemini (Google Generative AI).
///
/// Requiere un API key de Google AI Studio:
/// https://aistudio.google.com/apikey
class GeminiService {
  final String apiKey;
  final String model;

  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  GeminiService({
    required this.apiKey,
    this.model = 'gemini-2.0-flash',
  });

  /// Genera un diagnóstico AI basado en los parámetros del vehículo,
  /// códigos de falla y la información disponible (VIN, protocolo, etc.).
  Future<AiDiagnostic> getDiagnostic({
    required List<VehicleParameter> parameters,
    required List<DtcCode> dtcCodes,
    required String vin,
    String? protocol,
    int? ecuCount,
  }) async {
    final prompt = _buildPrompt(
      parameters: parameters,
      dtcCodes: dtcCodes,
      vin: vin,
      protocol: protocol,
      ecuCount: ecuCount,
    );

    final responseText = await _generateContent(prompt);
    return AiDiagnostic.fromGeminiResponse(responseText);
  }

  /// Llama al endpoint generateContent de Gemini.
  Future<String> _generateContent(String prompt) async {
    final url = Uri.parse('$_baseUrl/models/$model:generateContent?key=$apiKey');

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1024,
      },
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw GeminiException(
        'Error en la API de Gemini (${response.statusCode}): ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) {
      throw GeminiException('Gemini no generó respuesta.');
    }

    final content = candidates[0]['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw GeminiException('Respuesta de Gemini vacía.');
    }

    return parts[0]['text'] as String;
  }

  /// Construye el prompt de mecánico experto con toda la info del vehículo.
  String _buildPrompt({
    required List<VehicleParameter> parameters,
    required List<DtcCode> dtcCodes,
    required String vin,
    String? protocol,
    int? ecuCount,
  }) {
    final buffer = StringBuffer();

    // Rol del sistema
    buffer.writeln('Eres un mecánico automotriz experto con más de 20 años de experiencia.');
    buffer.writeln('Tu tarea es analizar los datos de diagnóstico OBD2 de un vehículo y proporcionar un diagnóstico claro y accionable.');
    buffer.writeln();

    // Info del vehículo
    buffer.writeln('== INFORMACIÓN DEL VEHÍCULO ==');
    buffer.writeln('VIN: $vin');
    if (vin.isNotEmpty && vin != 'No disponible') {
      buffer.writeln(_decodeVinHints(vin));
    }
    if (protocol != null && protocol.isNotEmpty) {
      buffer.writeln('Protocolo OBD2: $protocol');
    }
    if (ecuCount != null && ecuCount > 0) {
      buffer.writeln('ECUs detectadas: $ecuCount');
    }
    buffer.writeln();

    // Parámetros en vivo
    buffer.writeln('== PARÁMETROS EN TIEMPO REAL ==');
    for (final param in parameters) {
      buffer.writeln('- ${param.label}: ${param.value} ${param.unit}');
    }
    buffer.writeln();

    // Códigos de falla
    buffer.writeln('== CÓDIGOS DE FALLA (DTC) ==');
    if (dtcCodes.isEmpty) {
      buffer.writeln('No hay códigos de falla activos.');
    } else {
      for (final dtc in dtcCodes) {
        final dbDesc = DtcDatabase.getDescriptionEs(dtc.code);
        buffer.writeln('- ${dtc.code}: ${dbDesc ?? dtc.description} (Severidad: ${dtc.severity.name})');
      }
    }
    buffer.writeln();

    // Instrucciones de formato
    buffer.writeln('== INSTRUCCIONES ==');
    buffer.writeln('Responde SIEMPRE en español y usa EXACTAMENTE este formato:');
    buffer.writeln();
    buffer.writeln('Diagnóstico: [Resumen breve del estado general del vehículo en 2-3 oraciones]');
    buffer.writeln();
    buffer.writeln('Posibles causas:');
    buffer.writeln('- [Causa 1]');
    buffer.writeln('- [Causa 2]');
    buffer.writeln('- [Causa N]');
    buffer.writeln();
    buffer.writeln('Puntos a revisar:');
    buffer.writeln('- [Punto 1 con detalle de qué revisar y cómo]');
    buffer.writeln('- [Punto 2]');
    buffer.writeln('- [Punto N]');
    buffer.writeln();
    buffer.writeln('Urgencia: [Alta/Media/Baja]');
    buffer.writeln();
    buffer.writeln('Costo estimado: [Rango en USD]');

    return buffer.toString();
  }

  /// Extrae pistas del VIN para enriquecer el prompt.
  /// El VIN tiene info codificada: posición 1-3 = fabricante (WMI),
  /// 4-8 = atributos del vehículo, 10 = año modelo.
  String _decodeVinHints(String vin) {
    if (vin.length < 17) return '(VIN incompleto, no se puede decodificar)';

    final buffer = StringBuffer();

    // WMI (World Manufacturer Identifier) - primeros 3 caracteres
    final wmi = vin.substring(0, 3).toUpperCase();
    final manufacturer = _wmiToManufacturer(wmi);
    if (manufacturer != null) {
      buffer.writeln('Fabricante (decodificado del VIN): $manufacturer');
    }

    // Año modelo - posición 10
    final yearChar = vin[9].toUpperCase();
    final year = _vinYearCode(yearChar);
    if (year != null) {
      buffer.writeln('Año modelo (decodificado del VIN): $year');
    }

    // Región de origen
    final region = _vinRegion(vin[0]);
    if (region != null) {
      buffer.writeln('Región de origen: $region');
    }

    return buffer.toString();
  }

  static String? _wmiToManufacturer(String wmi) {
    const map = {
      '1HG': 'Honda', '1G1': 'Chevrolet', '1FA': 'Ford', '1FM': 'Ford',
      '1FT': 'Ford', '1GC': 'Chevrolet', '1GT': 'GMC', '1J4': 'Jeep',
      '1N4': 'Nissan', '1N6': 'Nissan', '2HG': 'Honda', '2T1': 'Toyota',
      '3FA': 'Ford', '3VW': 'Volkswagen', '3N1': 'Nissan',
      '5YJ': 'Tesla', '5NP': 'Hyundai', '5XY': 'Kia',
      'JHM': 'Honda', 'JTD': 'Toyota', 'JN1': 'Nissan',
      'KMH': 'Hyundai', 'KNA': 'Kia',
      'WAU': 'Audi', 'WBA': 'BMW', 'WDB': 'Mercedes-Benz', 'WDD': 'Mercedes-Benz',
      'WF0': 'Ford (Europa)', 'WVW': 'Volkswagen',
      'YV1': 'Volvo', 'ZFF': 'Ferrari',
      '3G1': 'Chevrolet (México)', '3HG': 'Honda (México)',
    };
    return map[wmi] ?? map[wmi.substring(0, 2)];
  }

  static int? _vinYearCode(String c) {
    const codes = {
      'A': 2010, 'B': 2011, 'C': 2012, 'D': 2013, 'E': 2014,
      'F': 2015, 'G': 2016, 'H': 2017, 'J': 2018, 'K': 2019,
      'L': 2020, 'M': 2021, 'N': 2022, 'P': 2023, 'R': 2024,
      'S': 2025, 'T': 2026, 'V': 2027, 'W': 2028, 'X': 2029,
      'Y': 2030, '1': 2031, '2': 2032, '3': 2033, '4': 2034,
      '5': 2035, '6': 2036, '7': 2037, '8': 2038, '9': 2039,
    };
    return codes[c];
  }

  static String? _vinRegion(String c) {
    final code = c.toUpperCase();
    if ('12345'.contains(code)) return 'Norteamérica';
    if ('ABCDEFGH'.contains(code)) return 'África';
    if ('JKLMNPR'.contains(code)) return 'Asia';
    if ('STUVWXYZ'.contains(code)) return 'Europa';
    if ('6789'.contains(code)) return 'Oceanía/Sudamérica';
    return null;
  }
}

class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
