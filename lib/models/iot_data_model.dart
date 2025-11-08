
enum DataStatus { pending, verified, rejected }

class IoTDataModel {
  final String id;
  final String sensorId;
  final String riverName;
  final double waterLevel;
  final double rainfall;
  final double flowRate;
  final double? temperature;
  final DataStatus status;
  final String? verifiedBy;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;

  IoTDataModel({
    required this.id,
    required this.sensorId,
    required this.riverName,
    required this.waterLevel,
    required this.rainfall,
    required this.flowRate,
    this.temperature,
    this.status = DataStatus.pending,
    this.verifiedBy,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IoTDataModel.fromJson(Map<String, dynamic> json) => IoTDataModel(
    id: json['id'] as String,
    sensorId: json['sensor_id'] as String,
    riverName: json['river_name'] as String,
    waterLevel: (json['water_level'] as num).toDouble(),
    rainfall: (json['rainfall'] as num).toDouble(),
    flowRate: (json['flow_rate'] as num).toDouble(),
    temperature: json['temperature'] != null ? (json['temperature'] as num).toDouble() : null,
    status: DataStatus.values.firstWhere((e) => e.name == (json['status'] as String), orElse: () => DataStatus.pending),
    verifiedBy: json['verified_by'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sensor_id': sensorId,
    'river_name': riverName,
    'water_level': waterLevel,
    'rainfall': rainfall,
    'flow_rate': flowRate,
    'temperature': temperature,
    'status': status.name,
    'verified_by': verifiedBy,
    'timestamp': timestamp.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  IoTDataModel copyWith({
    String? id,
    String? sensorId,
    String? riverName,
    double? waterLevel,
    double? rainfall,
    double? flowRate,
    double? temperature,
    DataStatus? status,
    String? verifiedBy,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IoTDataModel(
    id: id ?? this.id,
    sensorId: sensorId ?? this.sensorId,
    riverName: riverName ?? this.riverName,
    waterLevel: waterLevel ?? this.waterLevel,
    rainfall: rainfall ?? this.rainfall,
    flowRate: flowRate ?? this.flowRate,
    temperature: temperature ?? this.temperature,
    status: status ?? this.status,
    verifiedBy: verifiedBy ?? this.verifiedBy,
    timestamp: timestamp ?? this.timestamp,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
