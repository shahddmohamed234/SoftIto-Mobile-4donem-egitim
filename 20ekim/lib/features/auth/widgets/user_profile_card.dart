import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/user_profile_model.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfile profile;

  const UserProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAvatar(context),
            const SizedBox(height: 12),
            _buildNameAndRole(context),
            const SizedBox(height: 12),
            _buildVerifiedBadge(),
            const SizedBox(height: 16),
            _buildStartupInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(30),
      child: Icon(
        Icons.person,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildNameAndRole(BuildContext context) {
    return Column(
      children: [
        Text(
          profile.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.role,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
        ),
        Text(
          profile.email,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
              ),
        ),
      ],
    );
  }

  Widget _buildVerifiedBadge() {
    if (!profile.isVerified) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: AppColors.success, size: 16),
          SizedBox(width: 4),
          Text(
            'Onaylı Girişimci',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartupInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.rocket_launch, size: 18),
          const SizedBox(width: 8),
          Text(
            'Girişim: ${profile.startupName}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
