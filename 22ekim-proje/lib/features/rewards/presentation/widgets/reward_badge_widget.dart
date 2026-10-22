import 'package:flutter/material.dart';

class RewardBadgeWidget extends StatelessWidget {
  final String badgeName;
  final String description;
  final bool isUnlocked;
  final IconData icon;

  const RewardBadgeWidget({
    super.key,
    required this.badgeName,
    required this.description,
    required this.isUnlocked,
    this.icon = Icons.workspace_premium_rounded,
  });

  @override
  Widget build(BuildContext context) {
    double badgeOpacity;

    // Kırmızı Çizgi Kuralı: Standart if/else kullanımı (inline ternary yasaktır)
    if (isUnlocked) {
      badgeOpacity = 1.0;
    } else {
      badgeOpacity = 0.3;
    }

    return Opacity(
      opacity: badgeOpacity,
      child: _buildBadgeContent(context),
    );
  }

  // Kırmızı Çizgi Kuralı: Build metodu 40 satırı geçmemesi için parçalandı
  Widget _buildBadgeContent(BuildContext context) {
    final Color badgeColor = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withAlpha(80),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: badgeColor.withAlpha(40),
            child: Icon(icon, color: badgeColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            badgeName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}
