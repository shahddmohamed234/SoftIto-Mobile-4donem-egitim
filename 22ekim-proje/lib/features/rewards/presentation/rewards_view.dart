import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';
import 'widgets/reward_badge_widget.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final mascot = AppState.instance.selectedMascot;
        final items = AppState.instance.badgesAndCoupons;

        final badges = items.where((e) => e['type'] == 'badge').toList();
        final coupons = items.where((e) => e['type'] == 'coupon').toList();

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          catLottieAsset: mascot.lottieAssetPath,
          message: '${mascot.name}: ${AppStrings.tr('cat_deserve_rewards')}',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildBadgesSection(context, badges),
                  const SizedBox(height: 24),
                  _buildCouponsSection(context, coupons),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tr('rewards_title'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.tr('rewards_subtitle'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBadgesSection(BuildContext context, List<Map<String, dynamic>> badges) {
    final isEn = AppState.instance.language == 'EN';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.military_tech, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              AppStrings.tr('achievement_badges'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final badge = badges[index];
            final bool isUnlocked = badge['isUnlocked'] ?? false;
            final String title = isEn && badge['titleEn'] != null
                ? badge['titleEn']!
                : (badge['title'] ?? '');
            final String desc = isEn && badge['descriptionEn'] != null
                ? badge['descriptionEn']!
                : (badge['description'] ?? '');

            return RewardBadgeWidget(
              badgeName: title,
              description: desc,
              isUnlocked: isUnlocked,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCouponsSection(BuildContext context, List<Map<String, dynamic>> coupons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.confirmation_number_outlined, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              AppStrings.tr('monthly_coupons'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: coupons.length,
          itemBuilder: (context, index) {
            final coupon = coupons[index];
            return _buildCouponCard(context, coupon);
          },
        ),
      ],
    );
  }

  Widget _buildCouponCard(BuildContext context, Map<String, dynamic> coupon) {
    final bool isUnlocked = coupon['isUnlocked'] ?? false;
    final isEn = AppState.instance.language == 'EN';
    final String title = isEn && coupon['titleEn'] != null
        ? coupon['titleEn']!
        : (coupon['title'] ?? '');
    final String desc = isEn && coupon['descriptionEn'] != null
        ? coupon['descriptionEn']!
        : (coupon['description'] ?? '');
    final String code = isUnlocked
        ? (coupon['discountCode'] ?? '')
        : AppStrings.tr('coupon_code_locked');

    final double cardOpacity;
    if (isUnlocked) {
      cardOpacity = 1.0;
    } else {
      cardOpacity = 0.45;
    }

    return Opacity(
      opacity: cardOpacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withAlpha(90),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(40),
              child: Icon(
                Icons.local_offer,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  _buildCouponCodeRow(context, isUnlocked, code),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCodeRow(BuildContext context, bool isUnlocked, String code) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isUnlocked) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2E38) : const Color(0xFFF1EDE6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6),
              ),
            ),
            child: Text(
              code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                fontSize: 12,
                color: isDark ? Colors.white : const Color(0xFF3A3A3A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.tr('coupon_copied')),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Icon(
              Icons.copy,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      );
    } else {
      return Text(
        AppStrings.tr('coupon_locked'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      );
    }
  }
}
