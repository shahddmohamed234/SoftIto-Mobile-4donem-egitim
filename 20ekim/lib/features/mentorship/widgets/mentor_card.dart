import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/mentorship_model.dart';

class MentorCard extends StatelessWidget {
  final MentorProfile mentor;
  final bool hasBookedSession;
  final VoidCallback onOpenSchedule;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.hasBookedSession,
    required this.onOpenSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileRow(context),
            const SizedBox(height: 10),
            _buildExpertise(context),
            const SizedBox(height: 12),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(40),
          child: Text(
            mentor.name.substring(0, 1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mentor.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                mentor.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
                    ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 2),
            Text(
              mentor.rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpertise(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Uzmanlık: ${mentor.expertise}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (mentor.isSmsSubscribed)
            const Row(
              children: [
                Icon(Icons.sms, color: AppColors.success, size: 14),
                SizedBox(width: 4),
                Text(
                  'SMS Takibinde',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          mentor.isAvailable
              ? '${mentor.slots.where((s) => s.isAvailable).length} boş seans'
              : 'Müsaitlik Kapalı',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: mentor.isAvailable ? AppColors.success : Colors.grey,
          ),
        ),
        ElevatedButton.icon(
          onPressed: onOpenSchedule,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasBookedSession ? AppColors.success : null,
            foregroundColor: hasBookedSession ? Colors.white : null,
          ),
          icon: Icon(
            hasBookedSession ? Icons.check : Icons.event_available,
            size: 16,
          ),
          label: Text(
            hasBookedSession
                ? 'Randevu Alındı (SMS İletildi)'
                : (mentor.isAvailable ? 'Seans Ayarla' : 'Müsaitlik Bildirimi'),
          ),
        ),
      ],
    );
  }
}
