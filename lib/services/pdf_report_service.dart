import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/dtc_code.dart';
import '../models/mileage_check.dart';
import '../models/vehicle_parameter.dart';
import '../models/ai_diagnostic.dart';

/// Generates PDF diagnostic reports.
class PdfReportService {
  PdfReportService._();

  static Future<File> generateReport({
    required String vin,
    required String protocol,
    required int ecuCount,
    required List<VehicleParameter> parameters,
    required List<DtcCode> dtcCodes,
    AiDiagnostic? aiDiagnostic,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(vin, protocol, ecuCount),
          pw.SizedBox(height: 20),
          _buildParametersSection(parameters),
          pw.SizedBox(height: 20),
          _buildDtcSection(dtcCodes),
          if (aiDiagnostic != null) ...[
            pw.SizedBox(height: 20),
            _buildAiSection(aiDiagnostic),
          ],
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/obd2_report_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildHeader(String vin, String protocol, int ecuCount) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Reporte de Diagnóstico OBD2',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Fecha: ${DateTime.now().toString().substring(0, 16)}'),
        pw.Text('VIN: $vin'),
        pw.Text('Protocolo: $protocol'),
        pw.Text('ECUs detectadas: $ecuCount'),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _buildParametersSection(List<VehicleParameter> params) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Parametros en Tiempo Real',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Parametro', 'Valor', 'Unidad'],
          data: params.map((p) => [p.label, p.value, p.unit]).toList(),
        ),
      ],
    );
  }

  static pw.Widget _buildDtcSection(List<DtcCode> codes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Codigos de Diagnostico (DTC)',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        if (codes.isEmpty)
          pw.Text('Sin codigos de falla activos.')
        else
          pw.TableHelper.fromTextArray(
            headers: ['Codigo', 'Descripcion', 'Severidad'],
            data: codes
                .map((c) => [c.code, c.description, c.severity.name])
                .toList(),
          ),
      ],
    );
  }

  static pw.Widget _buildAiSection(AiDiagnostic diag) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Diagnostico AI',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(diag.summary),
        pw.SizedBox(height: 8),
        pw.Text('Urgencia: ${diag.urgencyLevel}'),
        pw.Text('Costo estimado: ${diag.estimatedCost}'),
      ],
    );
  }

  /// Generates a mileage verification PDF report.
  static Future<File> generateMileageReport({
    required MileageCheck check,
    String? vin,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Text(
            'Reporte de Verificacion de Kilometraje',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Fecha: ${check.timestamp.toString().substring(0, 16)}'),
          if (vin != null) pw.Text('VIN: $vin'),
          pw.Divider(),
          pw.SizedBox(height: 12),
          // Verdict
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  'Veredicto: ${_verdictLabel(check.verdict)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (check.referenceKm != null)
                  pw.Text(
                    'Kilometraje referencia: ${check.referenceKm!.toStringAsFixed(0)} km',
                  ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          // Sources table
          pw.Text(
            'Lecturas por Modulo',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Modulo', 'Valor (km)', 'Confianza'],
            data: check.sources
                .map(
                  (s) => [
                    s.key.name,
                    s.valueKm?.toStringAsFixed(0) ?? 'N/A',
                    s.confidence.name,
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/mileage_report_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static String _verdictLabel(MileageVerdict verdict) => switch (verdict) {
    MileageVerdict.consistent => 'Kilometraje Consistente',
    MileageVerdict.suspicious => 'Posible Reemplazo de Modulo',
    MileageVerdict.tampered => 'Posible Manipulacion de Odometro',
    MileageVerdict.insufficientData => 'Datos Insuficientes',
  };

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Text(
          'Generado por OBD2 Scanner. Consulte un mecanico certificado.',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
      ],
    );
  }
}
