/// A saved vehicle profile with VIN and metadata.
class VehicleProfile {
  final String id;
  final String vin;
  final String? nickname;
  final String? manufacturer;
  final int? modelYear;
  final String? region;
  final DateTime createdAt;

  const VehicleProfile({
    required this.id,
    required this.vin,
    this.nickname,
    this.manufacturer,
    this.modelYear,
    this.region,
    required this.createdAt,
  });

  VehicleProfile copyWith({
    String? nickname,
    String? manufacturer,
    int? modelYear,
    String? region,
  }) {
    return VehicleProfile(
      id: id,
      vin: vin,
      nickname: nickname ?? this.nickname,
      manufacturer: manufacturer ?? this.manufacturer,
      modelYear: modelYear ?? this.modelYear,
      region: region ?? this.region,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'vin': vin,
    'nickname': nickname,
    'manufacturer': manufacturer,
    'modelYear': modelYear,
    'region': region,
    'createdAt': createdAt.toIso8601String(),
  };

  factory VehicleProfile.fromJson(Map<String, dynamic> json) {
    return VehicleProfile(
      id: json['id'] as String,
      vin: json['vin'] as String,
      nickname: json['nickname'] as String?,
      manufacturer: json['manufacturer'] as String?,
      modelYear: json['modelYear'] as int?,
      region: json['region'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
