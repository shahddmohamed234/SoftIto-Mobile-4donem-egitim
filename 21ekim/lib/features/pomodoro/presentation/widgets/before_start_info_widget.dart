import 'package:flutter/material.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// Seans başlamadan önce kullanıcıyı katı çıkış kuralı hakkında uyaran sarı kutu bileşeni
class BeforeStartInfoWidget extends StatelessWidget {
  const BeforeStartInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.warmYellow.withValues(alpha: 0.2)
            : AppColors.warmYellow.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.warmYellow, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.warmYellow, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppStrings.get('beforeStartNotice'),
              style: TextStyle(
                color: isDark ? const Color(0xFFFFE082) : AppColors.darkAnthracite,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
