import 'package:flutter/material.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Seans sırasında uygulamadan çıkıldığında ekranda beliren kırmızı uyarı bileşeni
class ViolationWarningWidget extends StatelessWidget {
  final VoidCallback onDismiss;

  const ViolationWarningWidget({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.violationRed.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.violationRed, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.violationRed, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.get('violationWarning'),
                  style: const TextStyle(
                    color: AppColors.violationRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.get('violationNotice'),
            style: const TextStyle(color: AppColors.violationRed, fontSize: 13),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.violationRed),
            onPressed: onDismiss,
            child: Text(AppStrings.get('understandContinue')),
          ),
        ],
      ),
    );
  }
}
