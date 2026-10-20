// Flutter arayüz bileşenleri kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// SSS veri modelini içeri aktarır
import '../../data/models/faq_item_model.dart';

/// FaqRulesExpansionCard: Kiralama kurallarını ve sıkça sorulan soruları
/// akordiyon şeklinde açılır-kapanır liste olarak sunan kart bileşenidir.
class FaqRulesExpansionCard extends StatelessWidget {
  // Görüntülenecek SSS ve kurallar listesi
  final List<FaqItemModel> faqs;

  // FaqRulesExpansionCard sabit kurucu metodu
  const FaqRulesExpansionCard({super.key, required this.faqs});

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    // Kart tasarımı içerisinde akordiyon menü
    return Card(
      // Genişletilebilir açılır kapanır liste başlığı
      child: ExpansionTile(
        // Sol taraftaki soru işareti ikonu
        leading: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
        // Ana başlık
        title: const Text('Kiralama Kuralları & SSS', style: TextStyle(fontWeight: FontWeight.bold)),
        // Alt açıklama başlığı
        subtitle: const Text('İade şartları, süre uzatma, HGS ve sözleşme koşulları'),
        // Tıklandığında aşağı doğru açılan kural maddeleri listesi
        children: faqs.map((faq) => _buildFaqItem(context, faq)).toList(),
      ),
    );
  }

  /// Tekil SSS maddesi görünümünü inşa eder
  Widget _buildFaqItem(BuildContext context, FaqItemModel item) {
    return Padding(
      // Yatayda 16px, dikeyde 8px boşluk
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        // Metinleri sola hizalar
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kural / Soru başlığı
          Text(item.question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          // Kuralın detaylı açıklaması / Cevap metni
          Text(item.answer, style: Theme.of(context).textTheme.bodySmall),
          // Maddeler arası 16px yükseklikte ince ayraç çizgisi
          const Divider(height: 16),
        ],
      ),
    );
  }
}
