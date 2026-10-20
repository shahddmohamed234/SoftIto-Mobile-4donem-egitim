import 'package:flutter/material.dart';
import '../../data/models/faq_item_model.dart';

/// FaqRulesExpansionCard: Kiralama kurallarını ve sıkça sorulan soruları
/// akordiyon şeklinde açılır-kapanır liste olarak sunan kart bileşenidir.
class FaqRulesExpansionCard extends StatelessWidget {
  final List<FaqItemModel> faqs;

  const FaqRulesExpansionCard({super.key, required this.faqs});

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
        title: const Text('Kiralama Kuralları & SSS', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('İade şartları, süre uzatma, HGS ve sözleşme koşulları'),
        children: faqs.map((faq) => _buildFaqItem(context, faq)).toList(),
      ),
    );
  }

  /// Tekil SSS maddesi görünümü
  Widget _buildFaqItem(BuildContext context, FaqItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(item.answer, style: Theme.of(context).textTheme.bodySmall),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
