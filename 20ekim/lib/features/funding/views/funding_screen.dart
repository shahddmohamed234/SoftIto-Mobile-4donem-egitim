import 'package:flutter/material.dart';
import '../controllers/funding_controller.dart';
import '../models/funding_model.dart';
import '../widgets/funding_apply_dialog.dart';
import '../widgets/funding_card.dart';

class FundingScreen extends StatelessWidget {
  final FundingController controller;

  const FundingScreen({super.key, required this.controller});

  void _openApplyDialog(BuildContext context, FundingOpportunity opp) {
    showDialog(
      context: context,
      builder: (ctx) => FundingApplyDialog(
        opportunity: opp,
        onComplete: (isEligible, reason) {
          controller.applyWithCriteria(opp.id, isEligible, reason);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEligible
                  ? '${opp.provider} başvurunuz kriterleri sağlayarak işleme alındı.'
                  : '${opp.provider} başvurunuz kriter uyuşmazlığı nedeniyle reddedildi.'),
              backgroundColor: isEligible ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<FundingOpportunity>>(
        valueListenable: controller.opportunities,
        builder: (context, opportunities, _) {
          if (opportunities.isEmpty) {
            return const Center(child: Text('Aktif fon fırsatı bulunamadı.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opp = opportunities[index];
              return FundingCard(
                opportunity: opp,
                onApply: () => _openApplyDialog(context, opp),
                onCancel: () => controller.cancelApplication(opp.id),
              );
            },
          );
        },
      ),
    );
  }
}
