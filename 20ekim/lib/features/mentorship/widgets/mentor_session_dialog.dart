import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/mentorship_model.dart';

class MentorSessionDialog extends StatefulWidget {
  final MentorProfile mentor;
  final List<String> bookedSlotIds;
  final String userPhone;
  final Function(MentorSlot slot) onBookSlot;
  final VoidCallback onSubscribeSms;

  const MentorSessionDialog({
    super.key,
    required this.mentor,
    required this.bookedSlotIds,
    required this.userPhone,
    required this.onBookSlot,
    required this.onSubscribeSms,
  });

  @override
  State<MentorSessionDialog> createState() => _MentorSessionDialogState();
}

class _MentorSessionDialogState extends State<MentorSessionDialog> {
  MentorSlot? _selectedSlot;

  bool _isSlotAvailable(MentorSlot slot) {
    if (!slot.isAvailable) return false;
    if (widget.bookedSlotIds.contains(slot.id)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final availableSlots = widget.mentor.slots.where(_isSlotAvailable).toList();
    final hasNoSlots = availableSlots.isEmpty || !widget.mentor.isAvailable;

    return AlertDialog(
      title: _buildTitle(context),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMentorInfo(context),
              const SizedBox(height: 12),
              if (hasNoSlots)
                _buildNoAvailabilitySection(context)
              else
                ..._buildSlotList(),
            ],
          ),
        ),
      ),
      actions: _buildActions(context, hasNoSlots),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_month, color: AppColors.lightPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${widget.mentor.name} - Seans Takvimi',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildMentorInfo(BuildContext context) {
    return Text(
      'Uzmanlık: ${widget.mentor.expertise}',
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
      ),
    );
  }

  Widget _buildNoAvailabilitySection(BuildContext context) {
    final isSubscribed = widget.mentor.isSmsSubscribed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(25),
        border: Border.all(color: AppColors.warning.withAlpha(80)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event_busy, color: AppColors.warning, size: 18),
              SizedBox(width: 6),
              Text(
                'Tüm Seanslar Dolu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isSubscribed
                ? 'Talebiniz alındı! Yeni bir seans açıldığında ${widget.userPhone} numarasına SMS gönderilecektir.'
                : 'Bu mentorun yakın tarihli tüm seansları dolmuştur. Müsaitlik açıldığında SMS ile anlık bilgilendirme yapılmasını talep edebilirsiniz.',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSlotList() {
    return [
      const Text(
        'Müsait Gün ve Saatler:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      const SizedBox(height: 8),
      ...widget.mentor.slots.map((slot) {
        final available = _isSlotAvailable(slot);
        final isSelected = _selectedSlot?.id == slot.id;
        return Card(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(30)
              : null,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            dense: true,
            leading: Icon(
              available ? Icons.check_circle_outline : Icons.block,
              color: available ? AppColors.success : Colors.grey,
            ),
            title: Text(slot.date, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            subtitle: Text(slot.time, style: const TextStyle(fontSize: 11)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (available ? AppColors.success : Colors.grey).withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                available ? 'Boş' : 'Dolu',
                style: TextStyle(
                  color: available ? AppColors.success : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onTap: available
                ? () {
                    setState(() {
                      _selectedSlot = slot;
                    });
                  }
                : null,
          ),
        );
      }),
    ];
  }

  List<Widget> _buildActions(BuildContext context, bool hasNoSlots) {
    if (hasNoSlots) {
      final isSubscribed = widget.mentor.isSmsSubscribed;
      return [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Kapat'),
        ),
        if (!isSubscribed)
          ElevatedButton.icon(
            onPressed: () {
              widget.onSubscribeSms();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.sms, size: 16),
            label: const Text('Müsaitlikte SMS ile Bildir'),
          ),
      ];
    }

    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('İptal'),
      ),
      ElevatedButton.icon(
        onPressed: _selectedSlot != null
            ? () {
                widget.onBookSlot(_selectedSlot!);
                Navigator.of(context).pop();
              }
            : null,
        icon: const Icon(Icons.sms, size: 16),
        label: const Text('Randevu Al & SMS Onayı Gönder'),
      ),
    ];
  }
}
