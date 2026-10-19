import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_tracker_model.dart';

class WaterProgressCard extends StatelessWidget {
  final WaterTrackerState state;

  const WaterProgressCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _ProgressCircle(state: state),
            const SizedBox(height: 20),
            _GoalBreakdownRow(state: state),
          ],
        ),
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final WaterTrackerState state;

  const _ProgressCircle({required this.state});

  @override
  Widget build(BuildContext context) {
    final percent = (state.progressRatio * 100).toInt();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightBackground;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 190,
          height: 190,
          child: CircularProgressIndicator(
            value: state.progressRatio,
            strokeWidth: 14,
            strokeCap: StrokeCap.round,
            backgroundColor: bgColor,
            color: primaryColor,
          ),
        ),
        _CircleStats(
          percent: percent,
          consumed: state.consumedMl,
          target: state.totalTargetMl,
        ),
      ],
    );
  }
}

class _CircleStats extends StatelessWidget {
  final int percent;
  final int consumed;
  final int target;

  const _CircleStats({
    required this.percent,
    required this.consumed,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtextColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.water_drop, color: primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          '%$percent',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: -1,
          ),
        ),
        Text(
          '$consumed / $target ml',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: subtextColor,
          ),
        ),
      ],
    );
  }
}

class _GoalBreakdownRow extends StatelessWidget {
  final WaterTrackerState state;

  const _GoalBreakdownRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtextColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _MetricBadge(
          title: 'Temel Hedef',
          value: '${state.baseGoalMl} ml',
          color: subtextColor,
          icon: Icons.flag_outlined,
        ),
        _MetricBadge(
          title: 'Spor Bonusu',
          value: '+${state.workoutBonusMl} ml',
          color: AppColors.calorieOrange,
          icon: Icons.local_fire_department_rounded,
        ),
        _MetricBadge(
          title: 'Kalan',
          value: '${state.remainingMl} ml',
          color: isDark ? AppColors.neonLime : const Color(0xFF16A34A),
          icon: Icons.timelapse_rounded,
        ),
      ],
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricBadge({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: mutedColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
