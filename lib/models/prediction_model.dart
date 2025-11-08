
enum RiskLevel { low, medium, high, critical }

class PredictionModel {
  final String id;
  final String riverName;
  final RiskLevel riskLevel;
  final double confidenceScore;
  final double predictedWaterLevel;
  final double predictedRainfall;
  final String predictionDetails;
  final DateTime predictedFor;
  final DateTime createdAt;
  final DateTime updatedAt;

  PredictionModel({
    required this.id,
    required this.riverName,
    required this.riskLevel,
    required this.confidenceScore,
    required this.predictedWaterLevel,
    required this.predictedRainfall,
    required this.predictionDetails,
    required this.predictedFor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) => PredictionModel(
    id: json['id'] as String,
    riverName: json['river_name'] as String,
    riskLevel: RiskLevel.values.firstWhere((e) => e.name == (json['risk_level'] as String), orElse: () => RiskLevel.low),
    confidenceScore: (json['confidence_score'] as num).toDouble(),
    predictedWaterLevel: (json['predicted_water_level'] as num).toDouble(),
    predictedRainfall: (json['predicted_rainfall'] as num).toDouble(),
    predictionDetails: json['prediction_details'] as String,
    predictedFor: DateTime.parse(json['predicted_for'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'river_name': riverName,
    'risk_level': riskLevel.name,
    'confidence_score': confidenceScore,
    'predicted_water_level': predictedWaterLevel,
    'predicted_rainfall': predictedRainfall,
    'prediction_details': predictionDetails,
    'predicted_for': predictedFor.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  PredictionModel copyWith({
    String? id,
    String? riverName,
    RiskLevel? riskLevel,
    double? confidenceScore,
    double? predictedWaterLevel,
    double? predictedRainfall,
    String? predictionDetails,
    DateTime? predictedFor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PredictionModel(
    id: id ?? this.id,
    riverName: riverName ?? this.riverName,
    riskLevel: riskLevel ?? this.riskLevel,
    confidenceScore: confidenceScore ?? this.confidenceScore,
    predictedWaterLevel: predictedWaterLevel ?? this.predictedWaterLevel,
    predictedRainfall: predictedRainfall ?? this.predictedRainfall,
    predictionDetails: predictionDetails ?? this.predictionDetails,
    predictedFor: predictedFor ?? this.predictedFor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
