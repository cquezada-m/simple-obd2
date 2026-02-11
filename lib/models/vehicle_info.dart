/// Información del vehículo decodificada del VIN.
class VehicleInfo {
  final String? manufacturer;
  final String? region;
  final int? modelYear;

  const VehicleInfo({this.manufacturer, this.region, this.modelYear});

  bool get isEmpty =>
      manufacturer == null && region == null && modelYear == null;

  /// Decodifica información básica del VIN (17 caracteres).
  /// Posición 1-3: WMI (World Manufacturer Identifier)
  /// Posición 10: Año del modelo
  factory VehicleInfo.fromVIN(String? vin) {
    if (vin == null || vin.length < 17) {
      return const VehicleInfo();
    }

    final upper = vin.toUpperCase();
    final wmi = upper.substring(0, 3);
    final yearChar = upper[9];

    return VehicleInfo(
      manufacturer: _decodeManufacturer(wmi),
      region: _decodeRegion(upper[0]),
      modelYear: _decodeYear(yearChar),
    );
  }

  /// Decodifica el fabricante a partir del WMI (primeros 3 caracteres).
  static String? _decodeManufacturer(String wmi) {
    // Base de datos WMI compacta — fabricantes más comunes
    const wmiMap = {
      // Japón
      'JHM': 'Honda', 'JHL': 'Honda', 'SHH': 'Honda',
      'JTD': 'Toyota', 'JTE': 'Toyota', 'JTN': 'Toyota',
      'JT2': 'Toyota', 'JT3': 'Toyota', 'JT4': 'Toyota',
      'JT5': 'Toyota', 'JT8': 'Toyota',
      'JN1': 'Nissan', 'JN3': 'Nissan', 'JN6': 'Nissan', 'JN8': 'Nissan',
      'JMA': 'Mazda',
      'JM1': 'Mazda',
      'JM3': 'Mazda',
      'JM6': 'Mazda',
      'JM7': 'Mazda',
      'JF1': 'Subaru', 'JF2': 'Subaru',
      'JS1': 'Suzuki', 'JS2': 'Suzuki', 'JS3': 'Suzuki',
      'JMZ': 'Mazda',
      // Corea
      'KMH': 'Hyundai', 'KNA': 'Kia', 'KNB': 'Kia', 'KND': 'Kia',
      'KNM': 'Renault Samsung',
      '5NP': 'Hyundai', '5XY': 'Kia',
      // USA
      '1FA': 'Ford', '1FB': 'Ford', '1FC': 'Ford', '1FD': 'Ford',
      '1FM': 'Ford', '1FT': 'Ford', '1FV': 'Ford',
      '1G1': 'Chevrolet', '1G2': 'Pontiac', '1G3': 'Oldsmobile',
      '1G4': 'Buick', '1G6': 'Cadillac', '1GC': 'Chevrolet',
      '1GM': 'Pontiac', '1GT': 'GMC', '1GY': 'Cadillac',
      '1HG': 'Honda', '1HF': 'Honda',
      '1J4': 'Jeep', '1J8': 'Jeep',
      '1C3': 'Chrysler', '1C4': 'Chrysler', '1C6': 'Dodge',
      '1D3': 'Dodge', '1D4': 'Dodge', '1D7': 'Dodge',
      '1N4': 'Nissan', '1N6': 'Nissan',
      '1LN': 'Lincoln',
      '1ME': 'Mercury',
      '1GK': 'GMC',
      '2FA': 'Ford', '2FM': 'Ford', '2FT': 'Ford',
      '2G1': 'Chevrolet', '2G2': 'Pontiac',
      '2HG': 'Honda', '2HK': 'Honda', '2HJ': 'Honda',
      '2T1': 'Toyota', '2T2': 'Toyota', '2T3': 'Toyota',
      '3FA': 'Ford', '3G1': 'Chevrolet', '3GT': 'GMC',
      '3HG': 'Honda',
      '3N1': 'Nissan', '3N6': 'Nissan',
      '3VW': 'Volkswagen', '3VV': 'Volkswagen',
      '4F2': 'Mazda', '4F4': 'Mazda',
      '4T1': 'Toyota', '4T3': 'Toyota', '4T4': 'Toyota',
      '5FN': 'Honda', '5FR': 'Honda', '5J6': 'Honda', '5J8': 'Honda',
      '5TD': 'Toyota', '5TF': 'Toyota', '5YJ': 'Tesla',
      // Alemania
      'WBA': 'BMW', 'WBS': 'BMW M', 'WBY': 'BMW',
      'WDB': 'Mercedes-Benz', 'WDC': 'Mercedes-Benz', 'WDD': 'Mercedes-Benz',
      'WDF': 'Mercedes-Benz',
      'WAU': 'Audi', 'WUA': 'Audi',
      'WVW': 'Volkswagen', 'WV1': 'Volkswagen', 'WV2': 'Volkswagen',
      'WP0': 'Porsche', 'WP1': 'Porsche',
      'W0L': 'Opel',
      // UK
      'SAJ': 'Jaguar', 'SAL': 'Land Rover', 'SAR': 'Land Rover',
      // Italia
      'ZAR': 'Alfa Romeo', 'ZAM': 'Maserati', 'ZFF': 'Ferrari',
      'ZFA': 'Fiat', 'ZLA': 'Lancia',
      // Francia
      'VF1': 'Renault', 'VF3': 'Peugeot', 'VF7': 'Citroën',
      // Suecia
      'YV1': 'Volvo', 'YV4': 'Volvo',
      // México
      '3G3': 'General Motors MX', '3GN': 'General Motors MX',
      // Brasil
      '9BW': 'Volkswagen BR', '9BG': 'Chevrolet BR',
      // China
      'LFV': 'FAW-Volkswagen', 'LSG': 'SAIC GM',
      'LVS': 'Ford China', 'LBV': 'BMW China',
    };

    // Búsqueda exacta de 3 caracteres
    if (wmiMap.containsKey(wmi)) return wmiMap[wmi];

    // Búsqueda por 2 caracteres (algunos fabricantes usan el 3ro para planta)
    final wmi2 = wmi.substring(0, 2);
    for (final entry in wmiMap.entries) {
      if (entry.key.substring(0, 2) == wmi2) return entry.value;
    }

    return null;
  }

  /// Decodifica la región del primer carácter del VIN.
  static String? _decodeRegion(String c) {
    if ('ABCDE'.contains(c)) return 'África';
    if ('JKLMNPR'.contains(c)) return 'Asia';
    if ('STUVWXYZ'.contains(c)) return 'Europa';
    if ('12345'.contains(c)) return 'Norteamérica';
    if ('67'.contains(c)) return 'Oceanía';
    if ('89'.contains(c)) return 'Sudamérica';
    return null;
  }

  /// Decodifica el año del modelo (posición 10 del VIN).
  /// Cubre 1980-2039.
  static int? _decodeYear(String c) {
    const yearMap = {
      'A': 2010,
      'B': 2011,
      'C': 2012,
      'D': 2013,
      'E': 2014,
      'F': 2015,
      'G': 2016,
      'H': 2017,
      'J': 2018,
      'K': 2019,
      'L': 2020,
      'M': 2021,
      'N': 2022,
      'P': 2023,
      'R': 2024,
      'S': 2025,
      'T': 2026,
      'V': 2027,
      'W': 2028,
      'X': 2029,
      'Y': 2030,
      '1': 2031,
      '2': 2032,
      '3': 2033,
      '4': 2034,
      '5': 2035,
      '6': 2036,
      '7': 2037,
      '8': 2038,
      '9': 2039,
    };
    return yearMap[c];
  }
}
