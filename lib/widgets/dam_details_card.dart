import 'package:flutter/material.dart';
import 'package:Apadamitra/models/dam_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DamDetailsCard extends StatelessWidget {
  final DamModel dam;

  const DamDetailsCard({super.key, required this.dam});

  Color _getStorageColor(double percentage) {
    if (percentage < 70) return const Color(0xFF34C759);
    if (percentage < 90) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final storageColor = _getStorageColor(dam.storagePercentage);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.architecture, color: theme.colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dam.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${dam.stateName} • ${dam.riverName}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: storageColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: storageColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current Storage', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('${dam.storagePercentage.toStringAsFixed(1)}%', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: storageColor)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: dam.storagePercentage / 100,
                    minHeight: 10,
                    backgroundColor: theme.colorScheme.surface,
                    color: storageColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${dam.currentStorageMcm.toStringAsFixed(0)} MCM / ${dam.capacityMcm.toStringAsFixed(0)} MCM', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Dam Specifications', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInfoRow(theme, Icons.height, 'Height', '${dam.heightMeters.toStringAsFixed(1)} meters'),
          _buildInfoRow(theme, Icons.water, 'Capacity', '${dam.capacityMcm.toStringAsFixed(0)} MCM'),
          _buildInfoRow(theme, Icons.location_on_outlined, 'Location', '${dam.latitude.toStringAsFixed(4)}, ${dam.longitude.toStringAsFixed(4)}'),
          _buildInfoRow(theme, Icons.business, 'Managing Agency', dam.managingAgency),
          if (dam.contactNumber != null)
            _buildInfoRow(theme, Icons.phone, 'Contact', dam.contactNumber!, isPhone: true),
          if (dam.safetyStatus != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: dam.isCritical ? const Color(0xFFFF3B30).withValues(alpha: 0.1) : const Color(0xFF34C759).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(dam.isCritical ? Icons.warning : Icons.check_circle, color: dam.isCritical ? const Color(0xFFFF3B30) : const Color(0xFF34C759), size: 20),
                  const SizedBox(width: 10),
                  Text('Safety Status: ${dam.safetyStatus}', style: TextStyle(fontWeight: FontWeight.w600, color: dam.isCritical ? const Color(0xFFFF3B30) : const Color(0xFF34C759))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                const SizedBox(height: 2),
                isPhone
                    ? GestureDetector(
                        onTap: () => _makePhoneCall(value),
                        child: Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
                      )
                    : Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
