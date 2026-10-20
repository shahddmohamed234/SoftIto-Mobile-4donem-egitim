import 'package:flutter/foundation.dart';
import '../models/legal_support_model.dart';

class LegalSupportController {
  final ValueNotifier<List<LegalRequest>> _requests =
      ValueNotifier<List<LegalRequest>>([
    LegalRequest(
      id: 'leg_1',
      topic: 'Anonim Şirket Kuruluşu & Esas Sözleşme',
      details: 'Ortaklık pay oranları ve kurucu hakları incelemesi talep edildi.',
      lawyerAssigned: 'Av. Mehmet Can Yılmaz',
      status: 'Avukat Atandı',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    LegalRequest(
      id: 'leg_2',
      topic: 'Kullanıcı Sözleşmesi & KVKK Aydınlatma',
      details: 'Mobil uygulama için gizlilik politikası ve açık rıza metni hazırlandı.',
      lawyerAssigned: 'Av. Zeynep Kaya',
      status: 'Tamamlandı',
      date: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ]);

  ValueNotifier<List<LegalRequest>> get requests => _requests;

  void addRequest(LegalRequest req) {
    _requests.value = [req, ..._requests.value];
  }

  void resolveRequest(String id) {
    _requests.value = _requests.value.map((r) {
      if (r.id == id) {
        return r.copyWith(status: 'Tamamlandı');
      }
      return r;
    }).toList();
  }

  void dispose() {
    _requests.dispose();
  }
}
