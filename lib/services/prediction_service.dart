import 'package:Apadamitra/models/prediction_model.dart';
import 'package:Apadamitra/supabase/supabase_config.dart';

class PredictionService {
  static final PredictionService _instance = PredictionService._internal();
  factory PredictionService() => _instance;
  PredictionService._internal();

  Future<void> initialize() async {
    // No initialization needed for Supabase
  }

  Future<List<PredictionModel>> getAll() async {
    try {
      final data = await SupabaseService.select(
        'predictions',
        orderBy: 'created_at',
        ascending: false,
      );
      return data.map((json) => PredictionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load predictions: ${e.toString()}');
    }
  }

  Future<PredictionModel?> getLatestByRiver(String riverName) async {
    try {
      final data = await SupabaseService.select(
        'predictions',
        filters: {'river_name': riverName},
        orderBy: 'created_at',
        ascending: false,
        limit: 1,
      );
      if (data.isEmpty) return null;
      return PredictionModel.fromJson(data.first);
    } catch (e) {
      throw Exception('Failed to load latest prediction: ${e.toString()}');
    }
  }

  Future<List<PredictionModel>> getByRiver(String riverName) async {
    try {
      final data = await SupabaseService.select(
        'predictions',
        filters: {'river_name': riverName},
        orderBy: 'created_at',
        ascending: false,
      );
      return data.map((json) => PredictionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load predictions: ${e.toString()}');
    }
  }

  Future<PredictionModel> create(PredictionModel prediction) async {
    try {
      final result = await SupabaseService.insert('predictions', prediction.toJson());
      return PredictionModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to create prediction: ${e.toString()}');
    }
  }
}
