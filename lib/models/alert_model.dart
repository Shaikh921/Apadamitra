
enum AlertType { flood, damOverflow, prediction, safety, system }
enum AlertSeverity { low, medium, high, critical }

class AlertModel {
  final String id;
  final AlertType type;
  final AlertSeverity severity;
  final String title;
  final String message;
  final String? riverName;
  final String? damName;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AlertModel({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    this.riverName,
    this.damName,
    this.latitude,
    this.longitude,
    this.isActive = true,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
    id: json['id'] as String,
    type: AlertType.values.firstWhere((e) => e.name == (json['type'] as String), orElse: () => AlertType.system),
    severity: AlertSeverity.values.firstWhere((e) => e.name == (json['severity'] as String), orElse: () => AlertSeverity.low),
    title: json['title'] as String,
    message: json['message'] as String,
    riverName: json['river_name'] as String?,
    damName: json['dam_name'] as String?,
    latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
    longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    isActive: json['is_active'] as bool? ?? true,
    expiresAt: DateTime.parse(json['expires_at'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'severity': severity.name,
    'title': title,
    'message': message,
    'river_name': riverName,
    'dam_name': damName,
    'latitude': latitude,
    'longitude': longitude,
    'is_active': isActive,
    'expires_at': expiresAt.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  AlertModel copyWith({
    String? id,
    AlertType? type,
    AlertSeverity? severity,
    String? title,
    String? message,
    String? riverName,
    String? damName,
    double? latitude,
    double? longitude,
    bool? isActive,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AlertModel(
    id: id ?? this.id,
    type: type ?? this.type,
    severity: severity ?? this.severity,
    title: title ?? this.title,
    message: message ?? this.message,
    riverName: riverName ?? this.riverName,
    damName: damName ?? this.damName,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isActive: isActive ?? this.isActive,
    expiresAt: expiresAt ?? this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
