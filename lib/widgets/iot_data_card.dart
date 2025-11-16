import 'package:flutter/material.dart';
import 'package:Apadamitra/models/iot_data_model.dart';
import 'package:Apadamitra/models/prediction_model.dart';
import 'package:intl/intl.dart';

class IoTDataCard extends StatelessWidget {
  final IoTDataModel data;
  final PredictionModel? prediction;

  const IoTDataCard({super.key, required this.data, this.prediction});

  Color _getRiskColor(double waterLevel, ThemeData theme) {
    if (waterLevel < 10) return const Color(0xFF34C759);
    if (waterLevel < 15) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  String _getRiskLabel(double waterLevel) {
    if (waterLevel < 10) return 'Safe';
    if (waterLevel < 15) return 'Caution';
    return 'Danger';
  }

  String _getRiskEmoji(double waterLevel) {
    if (waterLevel < 10) return '🟢';
    if (waterLevel < 15) return '🟡';
    return '🔴';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final riskColor = _getRiskColor(data.waterLevel, theme);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.riverName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Sensor: ${data.sensorId}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getRiskEmoji(data.waterLevel), style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(_getRiskLabel(data.waterLevel), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: riskColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetric(theme, Icons.water_drop, 'Water Level', '${data.waterLevel.toStringAsFixed(1)} m'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetric(theme, Icons.cloud, 'Rainfall', '${data.rainfall.toStringAsFixed(1)} mm'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetric(theme, Icons.speed, 'Flow Rate', '${data.flowRate.toStringAsFixed(0)} m³/s'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetric(theme, Icons.thermostat, 'Temperature', data.temperature != null ? '${data.temperature!.toStringAsFixed(1)}°C' : 'N/A'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(DateFormat('MMM dd, HH:mm').format(data.timestamp), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
              if (data.status == DataStatus.verified)
                Row(
                  children: [
                    Icon(Icons.verified, size: 14, color: theme.colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text('Verified', style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(ThemeData theme, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
