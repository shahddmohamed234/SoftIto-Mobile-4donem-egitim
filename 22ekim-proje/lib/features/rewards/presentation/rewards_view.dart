import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          message: '${mascot.name}: Ödülleri hak ettin!',
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
          'Rozetler ve Kuponlar 🎁',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Serilerini koruyarak başarı rozetlerini ve gerçek indirim kuponlarını aç!',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection(BuildContext context, List<Map<String, dynamic>> badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.military_tech, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              'Başarı Rozetleri',
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
            final String title = badge['title'] ?? '';
            final String desc = badge['description'] ?? '';

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
              'Aylık Gerçek İndirim Kuponları',
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
    final String title = coupon['title'] ?? '';
    final String desc = coupon['description'] ?? '';
    final String code = coupon['discountCode'] ?? 'KİLİTLİ';

    final double cardOpacity;
    if (isUnlocked) {
      cardOpacity = 1.0;
    } else {
      cardOpacity = 0.35;
    }

    return Opacity(
      opacity: cardOpacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
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
    if (isUnlocked) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1EDE6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE4DFD6)),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kupon kodu kopyalandı!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Icon(Icons.copy, size: 18, color: Colors.black54),
          ),
        ],
      );
    } else {
      return Text(
        '🔒 Tam ay serisi tamamlandığında açılır',
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      );
    }
  }
}
