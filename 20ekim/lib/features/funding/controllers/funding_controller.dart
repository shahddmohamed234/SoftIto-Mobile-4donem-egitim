import 'package:flutter/foundation.dart';
import '../models/funding_model.dart';

class FundingController {
  final ValueNotifier<List<FundingOpportunity>> _opportunities =
      ValueNotifier<List<FundingOpportunity>>([
    const FundingOpportunity(
      id: 'fnd_1',
      provider: 'TÜBİTAK 1512 BİGG',
      title: 'Teknogirişim Sermayesi Desteği Programı',
      maxAmount: 900000,
      deadline: '15 Kasım 2026',
      category: 'Hibe (%100 Geri Ödemesiz)',
      isApplied: true,
      status: 'Onaylandı',
      rejectionReason: null,
      criteria: [
        'Anonim veya Limited Şirket statüsünde olmak',
        'Hazır ve test edilmiş MVP / Prototip bulunması',
        'Onaylı iş planına sahip olmak',
      ],
    ),
    const FundingOpportunity(
      id: 'fnd_2',
      provider: 'KOSGEB İleri Girişimci',
      title: 'İleri Teknoloji Faaliyet Alanı Kuruluş ve Makine Desteği',
      maxAmount: 1500000,
      deadline: '30 Aralık 2026',
      category: 'Hibe & Faizsiz Kredi',
      isApplied: true,
      status: 'Reddedildi',
      rejectionReason: 'Kriter Uyuşmazlığı: Şirket kuruluş süresi 6 aydan az olduğu ve sermaye yeterliliği belgelenemediği için komisyon tarafından reddedildi.',
      criteria: [
        'En az 6 aydır faaliyet gösteren aktif şirket',
        'İleri teknoloji NACE kodunda tescil',
        'Minimum 2 tam zamanlı mühendis istihdamı',
      ],
    ),
    const FundingOpportunity(
      id: 'fnd_3',
      provider: 'İstanbul Melek Yatırım Ağı',
      title: 'Erken Aşama SaaS & Yapay Zeka Girişim Fonu',
      maxAmount: 3000000,
      deadline: 'Sürekli Açık',
      category: 'Tohum Yatırım (Hisse Karşılığı)',
      isApplied: false,
      status: 'Başvurulmadı',
      rejectionReason: null,
      criteria: [
        'Aylık tekrarlayan gelir (MRR) en az ₺50.000',
        'Ölçeklenebilir SaaS veya Yapay Zeka altyapısı',
        'Takımda teknik kurucu ortak bulunması',
      ],
    ),
  ]);

  ValueNotifier<List<FundingOpportunity>> get opportunities => _opportunities;

  void applyWithCriteria(String id, bool allCriteriaMet, String? failureReason) {
    _opportunities.value = _opportunities.value.map((op) {
      if (op.id == id) {
        if (allCriteriaMet) {
          return op.copyWith(
            isApplied: true,
            status: 'İnceleniyor',
            rejectionReason: null,
          );
        } else {
          return op.copyWith(
            isApplied: true,
            status: 'Reddedildi',
            rejectionReason: failureReason ?? 'Zorunlu kriterler sağlanmadığı için başvuru otomatik reddedildi.',
          );
        }
      }
      return op;
    }).toList();
  }

  void cancelApplication(String id) {
    _opportunities.value = _opportunities.value.map((op) {
      if (op.id == id) {
        return op.copyWith(
          isApplied: false,
          status: 'Başvurulmadı',
          rejectionReason: null,
        );
      }
      return op;
    }).toList();
  }

  void dispose() {
    _opportunities.dispose();
  }
}
