import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/workout_controller.dart';
import '../widget/calories_summary_widget.dart';
import '../widget/workout_card_widget.dart';
import '../widget/workout_quick_add_widget.dart';

/// Egzersiz ve Kalori Takip Ekranı. Sayfa seviyesinde setState kullanmaz,
/// ListenableBuilder ile yerel controller durumunu dinler.
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummarySection(),
              const SizedBox(height: 24),
              _buildQuickAddSection(context),
              const SizedBox(height: 24),
              _buildWorkoutListSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummarySection() {
    return CaloriesSummaryWidget(
      totalCalories: controller.totalCaloriesBurned,
      goalCalories: controller.dailyCalorieGoal,
      totalMinutes: controller.totalDurationMinutes,
      ratio: controller.completionRatio,
    );
  }

  Widget _buildQuickAddSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Egzersiz Kaydı',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        WorkoutQuickAddWidget(
          onAdd: ({
            required title,
            required durationMinutes,
            required caloriesBurned,
          }) {
            controller.addWorkout(
              title: title,
              durationMinutes: durationMinutes,
              caloriesBurned: caloriesBurned,
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutListSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bugünkü Antrenmanlar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (controller.workouts.isNotEmpty)
              TextButton(
                onPressed: controller.resetDaily,
                child: const Text(
                  'Sıfırla',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (controller.workouts.isEmpty)
          _buildEmptyState(context)
        else
          _buildList(),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        'Bugün henüz egzersiz kaydedilmedi.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.workouts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = controller.workouts[index];
        return WorkoutCardWidget(
          workout: item,
          onDelete: () => controller.removeWorkout(item.id),
        );
      },
    );
  }
}
