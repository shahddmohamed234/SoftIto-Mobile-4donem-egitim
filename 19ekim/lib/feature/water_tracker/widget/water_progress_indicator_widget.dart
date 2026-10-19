import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Su tüketim ilerlemesini gösteren dairesel neon gösterge bileşeni.
class WaterProgressIndicatorWidget extends StatelessWidget {
  final int totalMl;
  final int goalMl;
  final double ratio;
  final int percentage;
  final int extraWaterMl;

  const WaterProgressIndicatorWidget({
    super.key,
    required this.totalMl,
    required this.goalMl,
    required this.ratio,
    required this.percentage,
    this.extraWaterMl = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildCircularProgress(),
            _buildCenterInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    return SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: ratio.clamp(0.0, 1.0),
        strokeWidth: 14,
        backgroundColor: AppColors.surfaceVariant,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildCenterInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 36),
        const SizedBox(height: 4),
        Text(
          '$totalMl ml',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '/ $goalMl ml  (%$percentage)',
          style: theme.textTheme.bodyMedium,
        ),
        if (extraWaterMl > 0)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '+$extraWaterMl ml egzersiz ekli',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.neonOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
