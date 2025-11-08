import 'package:riverwise/models/dam_model.dart';
import 'package:riverwise/supabase/supabase_config.dart';

class DamService {
  static final DamService _instance = DamService._internal();
  factory DamService() => _instance;
  DamService._internal();

  Future<void> initialize() async {
    // No initialization needed for Supabase
  }

  Future<List<DamModel>> getAll() async {
    try {
      final data = await SupabaseService.select('dams', orderBy: 'name');
      return data.map((json) => DamModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load dams: ${e.toString()}');
    }
  }

  Future<List<String>> getStates() async {
    try {
      final dams = await getAll();
      return dams.map((d) => d.stateName).toSet().toList()..sort();
    } catch (e) {
      throw Exception('Failed to load states: ${e.toString()}');
    }
  }

  Future<List<String>> getRiversByState(String state) async {
    try {
      final dams = await getAll();
      return dams.where((d) => d.stateName == state).map((d) => d.riverName).toSet().toList()..sort();
    } catch (e) {
      throw Exception('Failed to load rivers: ${e.toString()}');
    }
  }

  Future<List<DamModel>> getDamsByStateAndRiver(String state, String river) async {
    try {
      dynamic query = SupabaseConfig.client
          .from('dams')
          .select()
          .eq('state_name', state)
          .eq('river_name', river);

      final data = await query as List<dynamic>;
      return data.map((json) => DamModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load dams: ${e.toString()}');
    }
  }

  Future<DamModel?> getById(String id) async {
    try {
      final data = await SupabaseService.selectSingle('dams', filters: {'id': id});
      if (data == null) return null;
      return DamModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load dam: ${e.toString()}');
    }
  }

  Future<DamModel> update(DamModel dam) async {
    try {
      final result = await SupabaseService.update(
        'dams',
        dam.toJson(),
        filters: {'id': dam.id},
      );
      return DamModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to update dam: ${e.toString()}');
    }
  }
}
