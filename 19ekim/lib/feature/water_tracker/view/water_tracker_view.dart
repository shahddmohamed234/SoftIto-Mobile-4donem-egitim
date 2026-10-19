import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/water_tracker_controller.dart';
import '../widget/water_calorie_sync_card_widget.dart';
import '../widget/water_history_list_widget.dart';
import '../widget/water_progress_indicator_widget.dart';
import '../widget/water_quick_add_widget.dart';

/// Su Takibi Ana Ekranı. Sayfa düzeyinde setState kullanmaz,
/// ListenableBuilder ile yerel controller durumunu dinler.
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
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
              _buildProgressCard(context),
              const SizedBox(height: 16),
              _buildCalorieSyncSection(),
              const SizedBox(height: 20),
              _buildQuickAddSection(context),
              const SizedBox(height: 24),
              _buildHistorySection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: WaterProgressIndicatorWidget(
          totalMl: controller.totalIntakeMl,
          goalMl: controller.dynamicGoalMl,
          ratio: controller.completionRatio,
          percentage: controller.completionPercentage,
          extraWaterMl: controller.extraWaterFromCaloriesMl,
        ),
      ),
    );
  }

  Widget _buildCalorieSyncSection() {
    return WaterCalorieSyncCardWidget(
      baseGoalMl: controller.baseDailyGoalMl,
      burnedCalories: controller.burnedCalories,
      extraWaterMl: controller.extraWaterFromCaloriesMl,
      dynamicGoalMl: controller.dynamicGoalMl,
    );
  }

  Widget _buildQuickAddSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Su Ekle',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        WaterQuickAddWidget(
          onAdd: (amount, label) => controller.addWater(amount, label: label),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bugünkü Tüketimler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (controller.intakes.isNotEmpty)
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
        WaterHistoryListWidget(
          intakes: controller.intakes,
          onDelete: controller.removeWater,
        ),
      ],
    );
  }
}
