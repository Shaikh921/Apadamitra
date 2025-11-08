import 'package:flutter/material.dart';
import 'package:riverwise/models/prediction_model.dart';

class RiskIndicator extends StatelessWidget {
  final PredictionModel prediction;

  const RiskIndicator({super.key, required this.prediction});

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return const Color(0xFF34C759);
      case RiskLevel.medium:
        return const Color(0xFFFF9500);
      case RiskLevel.high:
        return const Color(0xFFFF3B30);
      case RiskLevel.critical:
        return const Color(0xFF8B0000);
    }
  }

  String _getRiskEmoji(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return '🟢';
      case RiskLevel.medium:
        return '🟡';
      case RiskLevel.high:
        return '🔴';
      case RiskLevel.critical:
        return '⚠️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final riskColor = _getRiskColor(prediction.riskLevel);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: riskColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_getRiskEmoji(prediction.riskLevel), style: const TextStyle(fontSize: 24)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${(prediction.confidenceScore * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: riskColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(prediction.riverName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(prediction.riskLevel.name.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: riskColor)),
        ],
      ),
    );
  }
}
