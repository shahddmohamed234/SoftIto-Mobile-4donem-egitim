import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı su ekleme butonlarını içeren modüler widget.
class WaterQuickAddWidget extends StatelessWidget {
  final void Function(int amountMl, String label) onAdd;

  const WaterQuickAddWidget({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickButton(context, 200, 'Bardak', Icons.local_drink),
        _buildQuickButton(context, 330, 'Küçük Şişe', Icons.wine_bar),
        _buildQuickButton(context, 500, 'Matara', Icons.sports_gymnastics),
      ],
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    int ml,
    String label,
    IconData icon,
  ) {
    return OutlinedButton(
      onPressed: () => onAdd(ml, label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.neonCyan,
        side: const BorderSide(color: AppColors.neonCyan, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.surfaceVariant.withAlpha(120),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.neonCyan),
          const SizedBox(height: 4),
          Text(
            '+$ml ml',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
