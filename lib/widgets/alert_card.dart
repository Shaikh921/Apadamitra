import 'package:flutter/material.dart';
import 'package:riverwise/models/alert_model.dart';
import 'package:intl/intl.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;

  const AlertCard({super.key, required this.alert});

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return const Color(0xFF34C759);
      case AlertSeverity.medium:
        return const Color(0xFFFF9500);
      case AlertSeverity.high:
        return const Color(0xFFFF3B30);
      case AlertSeverity.critical:
        return const Color(0xFF8B0000);
    }
  }

  IconData _getTypeIcon(AlertType type) {
    switch (type) {
      case AlertType.flood:
        return Icons.flood;
      case AlertType.damOverflow:
        return Icons.water_damage;
      case AlertType.prediction:
        return Icons.analytics;
      case AlertType.safety:
        return Icons.warning;
      case AlertType.system:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = _getSeverityColor(alert.severity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getTypeIcon(alert.type), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alert.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: severityColor)),
                    const SizedBox(height: 2),
                    Text(alert.severity.name.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: severityColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(alert.message, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
          if (alert.riverName != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(alert.riverName!, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(DateFormat('MMM dd, yyyy HH:mm').format(alert.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    );
  }
}
