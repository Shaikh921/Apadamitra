class DamModel {
  final String id;
  final String name;
  final String stateName;
  final String riverName;
  final double latitude;
  final double longitude;
  final double heightMeters;
  final double capacityMcm;
  final double currentStorageMcm;
  final String managingAgency;
  final String? contactNumber;
  final String? safetyStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  DamModel({
    required this.id,
    required this.name,
    required this.stateName,
    required this.riverName,
    required this.latitude,
    required this.longitude,
    required this.heightMeters,
    required this.capacityMcm,
    required this.currentStorageMcm,
    required this.managingAgency,
    this.contactNumber,
    this.safetyStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  double get storagePercentage => (currentStorageMcm / capacityMcm * 100).clamp(0, 100);

  bool get isCritical => storagePercentage > 90;

  factory DamModel.fromJson(Map<String, dynamic> json) => DamModel(
    id: json['id'] as String,
    name: json['name'] as String,
    stateName: json['state_name'] as String,
    riverName: json['river_name'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    heightMeters: (json['height_meters'] as num).toDouble(),
    capacityMcm: (json['capacity_mcm'] as num).toDouble(),
    currentStorageMcm: (json['current_storage_mcm'] as num).toDouble(),
    managingAgency: json['managing_agency'] as String,
    contactNumber: json['contact_number'] as String?,
    safetyStatus: json['safety_status'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'state_name': stateName,
    'river_name': riverName,
    'latitude': latitude,
    'longitude': longitude,
    'height_meters': heightMeters,
    'capacity_mcm': capacityMcm,
    'current_storage_mcm': currentStorageMcm,
    'managing_agency': managingAgency,
    'contact_number': contactNumber,
    'safety_status': safetyStatus,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  DamModel copyWith({
    String? id,
    String? name,
    String? stateName,
    String? riverName,
    double? latitude,
    double? longitude,
    double? heightMeters,
    double? capacityMcm,
    double? currentStorageMcm,
    String? managingAgency,
    String? contactNumber,
    String? safetyStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DamModel(
    id: id ?? this.id,
    name: name ?? this.name,
    stateName: stateName ?? this.stateName,
    riverName: riverName ?? this.riverName,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    heightMeters: heightMeters ?? this.heightMeters,
    capacityMcm: capacityMcm ?? this.capacityMcm,
    currentStorageMcm: currentStorageMcm ?? this.currentStorageMcm,
    managingAgency: managingAgency ?? this.managingAgency,
    contactNumber: contactNumber ?? this.contactNumber,
    safetyStatus: safetyStatus ?? this.safetyStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
