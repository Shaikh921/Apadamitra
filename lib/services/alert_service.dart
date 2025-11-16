import 'package:Apadamitra/models/alert_model.dart';
import 'package:Apadamitra/supabase/supabase_config.dart';

class AlertService {
  static final AlertService _instance = AlertService._internal();
  factory AlertService() => _instance;
  AlertService._internal();

  Future<void> initialize() async {
    // No initialization needed for Supabase
  }

  Future<List<AlertModel>> getActiveAlerts() async {
    try {
      dynamic query = SupabaseConfig.client
          .from('alerts')
          .select()
          .eq('is_active', true)
          .gte('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      final data = await query as List<dynamic>;
      return data.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load active alerts: ${e.toString()}');
    }
  }

  Future<List<AlertModel>> getAlertsByRiver(String riverName) async {
    try {
      dynamic query = SupabaseConfig.client
          .from('alerts')
          .select()
          .eq('is_active', true)
          .eq('river_name', riverName)
          .gte('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      final data = await query as List<dynamic>;
      return data.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load alerts by river: ${e.toString()}');
    }
  }

  Future<AlertModel> create(AlertModel alert) async {
    try {
      final result = await SupabaseService.insert('alerts', alert.toJson());
      return AlertModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to create alert: ${e.toString()}');
    }
  }

  Future<AlertModel> update(AlertModel alert) async {
    try {
      final result = await SupabaseService.update(
        'alerts',
        alert.toJson(),
        filters: {'id': alert.id},
      );
      return AlertModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update alert: ${e.toString()}');
    }
  }

  Future<void> deactivate(String id) async {
    try {
      await SupabaseService.update(
        'alerts',
        {
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        },
        filters: {'id': id},
      );
    } catch (e) {
      throw Exception('Failed to deactivate alert: ${e.toString()}');
    }
  }

  Future<List<AlertModel>> getAll() async {
    try {
      final data = await SupabaseService.select(
        'alerts',
        orderBy: 'created_at',
        ascending: false,
      );
      return data.map((json) => AlertModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading all alerts: $e');
      throw Exception('Failed to load alerts: ${e.toString()}');
    }
  }
}
