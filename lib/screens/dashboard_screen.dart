import 'package:flutter/material.dart';
import 'package:Apadamitra/models/iot_data_model.dart';
import 'package:Apadamitra/models/alert_model.dart';
import 'package:Apadamitra/models/prediction_model.dart';
import 'package:Apadamitra/services/iot_data_service.dart';
import 'package:Apadamitra/services/alert_service.dart';
import 'package:Apadamitra/services/prediction_service.dart';
import 'package:Apadamitra/widgets/iot_data_card.dart';
import 'package:Apadamitra/widgets/alert_card.dart';
import 'package:Apadamitra/widgets/risk_indicator.dart';
import 'package:Apadamitra/screens/river_flow_screen.dart';
import 'package:Apadamitra/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _iotService = IoTDataService();
  final _alertService = AlertService();
  final _predictionService = PredictionService();

  List<IoTDataModel> _iotData = [];
  List<AlertModel> _alerts = [];
  List<PredictionModel> _predictions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    await Future.wait([
      _iotService.initialize(),
      _alertService.initialize(),
      _predictionService.initialize(),
    ]);

    final iotData = await _iotService.getAll();
    final alerts = await _alertService.getActiveAlerts();
    final predictions = await _predictionService.getAll();

    setState(() {
      _iotData = iotData;
      _alerts = alerts;
      _predictions = predictions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
              ? [const Color(0xFF1A1F26), const Color(0xFF2A3340)]
              : [const Color(0xFF4A90A4), const Color(0xFF5FA8B8)],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'APADAMITRA',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // View Dams Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to dams screen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D9B9B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'VIEW DAMS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Grid of Cards
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                          children: [
                            _buildDashboardCard(
                              icon: Icons.water_drop,
                              iconColor: const Color(0xFF4A9FE5),
                              title: l10n.translate('water_level'),
                              subtitle: l10n.translate('current_status'),
                              onTap: () {},
                            ),
                            _buildDashboardCard(
                              icon: Icons.bar_chart,
                              iconColor: const Color(0xFF5CB85C),
                              title: l10n.translate('water_usage'),
                              subtitle: l10n.translate('statistics'),
                              onTap: () {},
                            ),
                            _buildDashboardCard(
                              icon: Icons.warning,
                              iconColor: const Color(0xFFE74C3C),
                              title: 'Alerts',
                              subtitle: 'Notifications of\npotential hazards',
                              onTap: () {},
                            ),
                            _buildDashboardCard(
                              icon: Icons.waves,
                              iconColor: const Color(0xFF3498DB),
                              title: l10n.translate('water_flow'),
                              subtitle: l10n.translate('rates_direction'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RiverFlowScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
