import 'package:riverwise/models/iot_data_model.dart';
import 'package:riverwise/supabase/supabase_config.dart';

class IoTDataService {
  static final IoTDataService _instance = IoTDataService._internal();
  factory IoTDataService() => _instance;
  IoTDataService._internal();

  Future<void> initialize() async {
    // No initialization needed for Supabase
  }

  Future<List<IoTDataModel>> getAll() async {
    try {
      final data = await SupabaseService.select(
        'iot_data',
        orderBy: 'timestamp',
        ascending: false,
      );
      return data.map((json) => IoTDataModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load IoT data: ${e.toString()}');
    }
  }

  Future<List<IoTDataModel>> getByRiver(String riverName) async {
    try {
      final data = await SupabaseService.select(
        'iot_data',
        filters: {'river_name': riverName},
        orderBy: 'timestamp',
        ascending: false,
      );
      return data.map((json) => IoTDataModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load IoT data: ${e.toString()}');
    }
  }

  Future<IoTDataModel?> getLatestByRiver(String riverName) async {
    try {
      final data = await SupabaseService.select(
        'iot_data',
        filters: {'river_name': riverName},
        orderBy: 'timestamp',
        ascending: false,
        limit: 1,
      );
      if (data.isEmpty) return null;
      return IoTDataModel.fromJson(data.first);
    } catch (e) {
      throw Exception('Failed to load latest IoT data: ${e.toString()}');
    }
  }

  Future<IoTDataModel> create(IoTDataModel data) async {
    try {
      final result = await SupabaseService.insert('iot_data', data.toJson());
      return IoTDataModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to create IoT data: ${e.toString()}');
    }
  }

  Future<IoTDataModel> update(IoTDataModel data) async {
    try {
      final result = await SupabaseService.update(
        'iot_data',
        data.toJson(),
        filters: {'id': data.id},
      );
      return IoTDataModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update IoT data: ${e.toString()}');
    }
  }

  Future<void> delete(String id) async {
    try {
      await SupabaseService.delete('iot_data', filters: {'id': id});
    } catch (e) {
      throw Exception('Failed to delete IoT data: ${e.toString()}');
    }
  }
}
