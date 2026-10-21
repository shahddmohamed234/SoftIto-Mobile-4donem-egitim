import 'package:flutter/material.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// Sayacın 00:25:00 formatında gösterildiği ve üzerine dokunulduğunda sürenin değiştirilebildiği bileşen
class TimerDisplayWidget extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isBreak;
  final VoidCallback? onTap;

  const TimerDisplayWidget({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.isBreak = false,
    this.onTap,
  });

  String _formatTime(int totalSecs) {
    final int hours = totalSecs ~/ 3600;
    final int minutes = (totalSecs % 3600) ~/ 60;
    final int seconds = totalSecs % 60;

    final String hStr = hours.toString().padLeft(2, '0');
    final String mStr = minutes.toString().padLeft(2, '0');
    final String sStr = seconds.toString().padLeft(2, '0');

    return '$hStr:$mStr:$sStr';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double progress = totalSeconds > 0 ? (remainingSeconds / totalSeconds) : 0.0;

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(130),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildProgressCircle(theme, progress),
              _buildTimeColumn(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCircle(ThemeData theme, double progress) {
    return SizedBox(
      width: 250,
      height: 250,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 10,
        backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          isBreak ? theme.colorScheme.secondary : theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTimeColumn(ThemeData theme, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(remainingSeconds),
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 40),
        ),
        if (onTap != null)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.pastelPink.withValues(alpha: 0.15)
                  : AppColors.burgundy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: 13,
                  color: isDark ? AppColors.pastelPink : AppColors.burgundy,
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.get('changeDuration'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.pastelPink : AppColors.burgundy,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
