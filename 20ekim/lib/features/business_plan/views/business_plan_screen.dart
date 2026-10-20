import 'package:flutter/material.dart';
import '../controllers/business_plan_controller.dart';
import '../models/business_plan_model.dart';
import '../widgets/business_plan_card.dart';
import '../widgets/business_plan_create_dialog.dart';

class BusinessPlanScreen extends StatelessWidget {
  final BusinessPlanController controller;

  const BusinessPlanScreen({super.key, required this.controller});

  void _openCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BusinessPlanCreateDialog(
        onCreated: (newPlan) => controller.addPlan(newPlan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<BusinessPlanItem>>(
        valueListenable: controller.plans,
        builder: (context, plans, _) {
          if (plans.isEmpty) {
            return const Center(child: Text('Henüz bir iş planı bulunmuyor.'));
          }
          return _buildPlanList(context, plans);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('İş Planı Oluştur'),
      ),
    );
  }

  Widget _buildPlanList(BuildContext context, List<BusinessPlanItem> plans) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return BusinessPlanCard(
          plan: plan,
          onTap: () => _showPlanDetails(context, plan),
        );
      },
    );
  }

  void _showPlanDetails(BuildContext context, BusinessPlanItem plan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.title,
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text('Durum: ${plan.status}'),
            Text('Sektör: ${plan.industry}'),
            Text('Hedef Kitle: ${plan.targetMarket}'),
            Text('Bütçe: ₺${plan.budget.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      controller.updatePlanStatus(plan.id, 'Reddedildi');
                      Navigator.pop(ctx);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text('Reddet'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.updatePlanStatus(plan.id, 'Onaylandı');
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Onayla'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
