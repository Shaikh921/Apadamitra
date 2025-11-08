import 'package:flutter/material.dart';
import 'package:riverwise/models/dam_model.dart';
import 'package:riverwise/services/dam_service.dart';
import 'package:riverwise/widgets/dam_details_card.dart';

class DamInfoScreen extends StatefulWidget {
  const DamInfoScreen({super.key});

  @override
  State<DamInfoScreen> createState() => _DamInfoScreenState();
}

class _DamInfoScreenState extends State<DamInfoScreen> {
  final _damService = DamService();
  
  List<String> _states = [];
  List<String> _rivers = [];
  List<DamModel> _dams = [];
  
  String? _selectedState;
  String? _selectedRiver;
  String? _selectedDamId;
  DamModel? _selectedDam;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    setState(() => _isLoading = true);
    await _damService.initialize();
    final states = await _damService.getStates();
    setState(() {
      _states = states;
      _isLoading = false;
    });
  }

  Future<void> _onStateChanged(String? state) async {
    setState(() {
      _selectedState = state;
      _selectedRiver = null;
      _selectedDamId = null;
      _selectedDam = null;
      _rivers = [];
      _dams = [];
    });

    if (state != null) {
      final rivers = await _damService.getRiversByState(state);
      setState(() => _rivers = rivers);
    }
  }

  Future<void> _onRiverChanged(String? river) async {
    setState(() {
      _selectedRiver = river;
      _selectedDamId = null;
      _selectedDam = null;
      _dams = [];
    });

    if (_selectedState != null && river != null) {
      final dams = await _damService.getDamsByStateAndRiver(_selectedState!, river);
      setState(() => _dams = dams);
    }
  }

  Future<void> _onDamChanged(String? damId) async {
    setState(() {
      _selectedDamId = damId;
      _selectedDam = null;
    });

    if (damId != null) {
      final dam = await _damService.getById(damId);
      setState(() => _selectedDam = dam);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dam Information', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            Text('Explore dams across India', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🗺️ Select Location', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedState,
                          decoration: InputDecoration(
                            labelText: 'State',
                            prefixIcon: Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                          items: _states.map((state) => DropdownMenuItem(value: state, child: Text(state))).toList(),
                          onChanged: _onStateChanged,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedRiver,
                          decoration: InputDecoration(
                            labelText: 'River',
                            prefixIcon: Icon(Icons.water, color: theme.colorScheme.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                          items: _rivers.map((river) => DropdownMenuItem(value: river, child: Text(river))).toList(),
                          onChanged: _selectedState == null ? null : _onRiverChanged,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedDamId,
                          decoration: InputDecoration(
                            labelText: 'Dam',
                            prefixIcon: Icon(Icons.architecture, color: theme.colorScheme.primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                          items: _dams.map((dam) => DropdownMenuItem(value: dam.id, child: Text(dam.name))).toList(),
                          onChanged: _selectedRiver == null ? null : _onDamChanged,
                        ),
                      ],
                    ),
                  ),
                  if (_selectedDam != null) ...[
                    const SizedBox(height: 24),
                    DamDetailsCard(dam: _selectedDam!),
                  ],
                  if (_selectedDam == null && _selectedState != null) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.search, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text('Select a dam to view details', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
