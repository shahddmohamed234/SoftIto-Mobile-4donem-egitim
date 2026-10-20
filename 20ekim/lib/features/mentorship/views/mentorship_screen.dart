import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/mentorship_controller.dart';
import '../models/mentorship_model.dart';
import '../widgets/mentor_card.dart';
import '../widgets/mentor_session_dialog.dart';

class MentorshipScreen extends StatelessWidget {
  final MentorshipController controller;

  const MentorshipScreen({super.key, required this.controller});

  void _openScheduleDialog(BuildContext context, MentorProfile mentor) {
    showDialog(
      context: context,
      builder: (ctx) => MentorSessionDialog(
        mentor: mentor,
        bookedSlotIds: controller.bookedSlotIds.value,
        userPhone: '+90 532 555 0123',
        onBookSlot: (slot) {
          controller.bookSlot(
            mentorId: mentor.id,
            slot: slot,
            mentorName: mentor.name,
            phone: '+90 532 555 0123',
          );
        },
        onSubscribeSms: () {
          controller.subscribeToAvailabilitySms(
            mentorId: mentor.id,
            mentorName: mentor.name,
            phone: '+90 532 555 0123',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSmsAlertBanner(),
          Expanded(child: _buildMentorList()),
        ],
      ),
    );
  }

  Widget _buildSmsAlertBanner() {
    return ValueListenableBuilder<String?>(
      valueListenable: controller.lastSmsNotification,
      builder: (context, smsMessage, _) {
        if (smsMessage == null) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.withAlpha(25),
            border: Border.all(color: AppColors.success.withAlpha(80)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.sms_outlined, color: AppColors.success, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  smsMessage,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => controller.clearLastSms(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMentorList() {
    return ValueListenableBuilder<List<MentorProfile>>(
      valueListenable: controller.mentors,
      builder: (context, mentors, _) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: controller.bookedSlotIds,
          builder: (context, bookedIds, _) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final mentor = mentors[index];
                final hasBooked = mentor.slots.any((s) => bookedIds.contains(s.id));
                return MentorCard(
                  mentor: mentor,
                  hasBookedSession: hasBooked,
                  onOpenSchedule: () => _openScheduleDialog(context, mentor),
                );
              },
            );
          },
        );
      },
    );
  }
}
