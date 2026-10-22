import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';

class MotivationView extends StatefulWidget {
  const MotivationView({super.key});

  @override
  State<MotivationView> createState() => _MotivationViewState();
}

class _MotivationViewState extends State<MotivationView> {
  int _quoteIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final mascot = AppState.instance.selectedMascot;
        final quotes = AppConstants.motivationalQuotes;
        final currentQuote = quotes[_quoteIndex % quotes.length];

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          message: '${mascot.name}: Yanındayım!',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildQuoteCard(context, currentQuote),
                  const SizedBox(height: 24),
                  _buildNextQuoteButton(context, quotes.length),
                  const SizedBox(height: 24),
                  _buildDailyTipsCard(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Günün İlhamı 🌸',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ruhunu dinlendirecek ve seni ileriye taşıyacak sözler',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget _buildQuoteCard(BuildContext context, Map<String, String> item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(90),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFloralDecorations(context),
          const SizedBox(height: 16),
          Text(
            '"${item['quote']}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            '— ${item['author']}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1EDE6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '#${item['tag']}',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloralDecorations(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('🌿', style: TextStyle(fontSize: 20)),
        SizedBox(width: 8),
        Text('🌸', style: TextStyle(fontSize: 26)),
        SizedBox(width: 8),
        Text('🌿', style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _buildNextQuoteButton(BuildContext context, int totalCount) {
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _quoteIndex = (_quoteIndex + 1) % totalCount;
        });
      },
      icon: const Icon(Icons.refresh),
      label: const Text('Yeni Bir İlham Al'),
    );
  }

  Widget _buildDailyTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.lightbulb_outline, color: Color(0xFF9DB2A1)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'İpucu: Alışkanlıklarını günün aynı saatinde tekrarlamak beynin otomatikleşmesini hızlandırır.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
