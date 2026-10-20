import 'package:flutter/foundation.dart';
import '../models/mentorship_model.dart';

class MentorshipController {
  final ValueNotifier<List<MentorProfile>> _mentors =
      ValueNotifier<List<MentorProfile>>([
    const MentorProfile(
      id: 'mnt_1',
      name: 'Dr. Ahmet Özkan',
      title: 'Seri Girişimci & Eski VC Partneri',
      expertise: 'Büyüme (Growth), Finans & Fonlama',
      rating: 4.9,
      sessionCount: 68,
      isAvailable: true,
      slots: [
        MentorSlot(
          id: 's_101',
          date: '22 Ekim 2026, Perşembe',
          time: '10:00 - 11:00',
          isAvailable: true,
        ),
        MentorSlot(
          id: 's_102',
          date: '22 Ekim 2026, Perşembe',
          time: '14:00 - 15:00',
          isAvailable: false,
        ),
        MentorSlot(
          id: 's_103',
          date: '23 Ekim 2026, Cuma',
          time: '16:00 - 17:00',
          isAvailable: true,
        ),
      ],
    ),
    const MentorProfile(
      id: 'mnt_2',
      name: 'Selin Demir',
      title: 'Head of Product @ FinTech Unicorn',
      expertise: 'Ürün Yönetimi, UI/UX & Metrikler',
      rating: 4.8,
      sessionCount: 42,
      isAvailable: true,
      slots: [
        MentorSlot(
          id: 's_201',
          date: '24 Ekim 2026, Cumartesi',
          time: '11:00 - 12:00',
          isAvailable: true,
        ),
        MentorSlot(
          id: 's_202',
          date: '24 Ekim 2026, Cumartesi',
          time: '15:00 - 16:00',
          isAvailable: false,
        ),
      ],
    ),
    const MentorProfile(
      id: 'mnt_3',
      name: 'Emre Can Tunç',
      title: 'CTO & Yapay Zeka Danışmanı',
      expertise: 'SaaS Mimarisi, LLM Entegrasyonu',
      rating: 5.0,
      sessionCount: 35,
      isAvailable: false,
      slots: [
        MentorSlot(
          id: 's_301',
          date: '22 Ekim 2026, Perşembe',
          time: '09:00 - 10:00',
          isAvailable: false,
        ),
        MentorSlot(
          id: 's_302',
          date: '23 Ekim 2026, Cuma',
          time: '13:00 - 14:00',
          isAvailable: false,
        ),
      ],
    ),
  ]);

  final ValueNotifier<List<String>> _bookedSlotIds = ValueNotifier<List<String>>([]);
  final ValueNotifier<String?> _lastSmsNotification = ValueNotifier<String?>(null);

  ValueNotifier<List<MentorProfile>> get mentors => _mentors;
  ValueNotifier<List<String>> get bookedSlotIds => _bookedSlotIds;
  ValueNotifier<String?> get lastSmsNotification => _lastSmsNotification;

  void bookSlot({
    required String mentorId,
    required MentorSlot slot,
    required String mentorName,
    required String phone,
  }) {
    _bookedSlotIds.value = [..._bookedSlotIds.value, slot.id];

    // Simüle edilen SMS Bildirimi
    _lastSmsNotification.value =
        'SMS Gönderildi ($phone): "Sayın Girişimci, $mentorName ile ${slot.date} ${slot.time} seansınız onaylandı. Takvim davetiniz iletilmiştir."';
  }

  void subscribeToAvailabilitySms({
    required String mentorId,
    required String mentorName,
    required String phone,
  }) {
    _mentors.value = _mentors.value.map((m) {
      if (m.id == mentorId) {
        return m.copyWith(isSmsSubscribed: true);
      }
      return m;
    }).toList();

    // Simüle edilen SMS Bildirimi
    _lastSmsNotification.value =
        'SMS Bildirim Talebi Alındı ($phone): "$mentorName için yeni seans müsaitliği açıldığında telefonunuza anlık SMS ile bilgi verilecektir."';
  }

  void clearLastSms() {
    _lastSmsNotification.value = null;
  }

  void dispose() {
    _mentors.dispose();
    _bookedSlotIds.dispose();
    _lastSmsNotification.dispose();
  }
}
