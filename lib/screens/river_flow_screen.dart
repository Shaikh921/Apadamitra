import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverwise/services/river_flow_service.dart';
import 'package:riverwise/models/river_flow_model.dart';

class RiverFlowScreen extends StatefulWidget {
  const RiverFlowScreen({super.key});

  @override
  State<RiverFlowScreen> createState() => _RiverFlowScreenState();
}

class _RiverFlowScreenState extends State<RiverFlowScreen> {
  final _service = RiverFlowService();
  List<Map<String, dynamic>> _rivers = [];
  RiverFlowModel? _selectedRiver;
  bool _isLoading = true;
  String? _selectedRiverId;
  bool _showStations = true;
  bool _showDams = true;

  @override
  void initState() {
    super.initState();
    _loadRivers();
  }

  Future<void> _loadRivers() async {
    final rivers = await _service.getAvailableRivers();
    setState(() {
      _rivers = rivers;
      _isLoading = false;
    });
  }

  Future<void> _selectRiver(String riverId) async {
    setState(() => _isLoading = true);
    try {
      final riverData = await _service.getRiverFlowData(riverId);
      setState(() {
        _selectedRiver = riverData;
        _selectedRiverId = riverId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading river data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1F26) : theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('River Flow Monitor'),
        backgroundColor: isDark ? const Color(0xFF2A3340) : theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_selectedRiverId != null) {
                _selectRiver(_selectedRiverId!);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // River Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF2A3340) : theme.colorScheme.primaryContainer,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedRiverId,
                  dropdownColor: isDark ? const Color(0xFF2A3340) : null,
                  decoration: InputDecoration(
                    labelText: 'Select River',
                    prefixIcon: const Icon(Icons.water),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1A1F26) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _rivers.map((river) {
                    return DropdownMenuItem<String>(
                      value: river['id'] as String,
                      child: Text('${river['name']} - ${river['state']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) _selectRiver(value);
                  },
                ),
                if (_selectedRiver != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          'Stations',
                          Icons.location_on,
                          _showStations,
                          () => setState(() => _showStations = !_showStations),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildToggleButton(
                          'Dams',
                          Icons.water_damage,
                          _showDams,
                          () => setState(() => _showDams = !_showDams),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Map
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedRiver == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.water,
                              size: 64,
                              color: theme.colorScheme.primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select a river to view flow data',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: _selectedRiver!.flowPath.isNotEmpty
                              ? _selectedRiver!.flowPath.first
                              : LatLng(20.5937, 78.9629), // Center of India
                          initialZoom: 10,
                          minZoom: 5,
                          maxZoom: 18,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.apadamitra.riverwise',
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _selectedRiver!.flowPath,
                                color: const Color(0xFF4A9FE5),
                                strokeWidth: 4,
                              ),
                            ],
                          ),
                          if (_showStations)
                            MarkerLayer(
                              markers: _selectedRiver!.stations.map((station) {
                                return Marker(
                                  point: station.location,
                                  width: 40,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap: () => _showStationInfo(station),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Color(0xFFFF7043),
                                      size: 40,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
          ),

          // Info Card
          if (_selectedRiver != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A3340) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedRiver!.name,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _selectedRiver!.state,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedRiver!.floodStatus.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _selectedRiver!.floodStatus.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        '🌊 Flow Rate',
                        '${_selectedRiver!.flowRate.toStringAsFixed(1)} m³/s',
                        isDark,
                      ),
                      _buildInfoItem(
                        '📈 Water Level',
                        '${_selectedRiver!.waterLevel.toStringAsFixed(1)} m',
                        isDark,
                      ),
                      _buildInfoItem(
                        '🌧️ Rainfall',
                        '${_selectedRiver!.rainfall?.toStringAsFixed(1) ?? 0} mm',
                        isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Updated: ${_formatTime(_selectedRiver!.lastUpdated)}',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4A9FE5) : const Color(0xFF1A1F26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFF4A9FE5) : Colors.white24,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showStationInfo(RiverStation station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(station.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Water Level: ${station.waterLevel.toStringAsFixed(1)} m'),
            Text('Discharge: ${station.discharge.toStringAsFixed(1)} m³/s'),
            Text('Updated: ${_formatTime(station.lastUpdated)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }
}
