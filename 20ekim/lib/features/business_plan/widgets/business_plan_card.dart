import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/business_plan_model.dart';

class BusinessPlanCard extends StatelessWidget {
  final BusinessPlanItem plan;
  final VoidCallback? onTap;

  const BusinessPlanCard({
    super.key,
    required this.plan,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Onaylandı':
        return AppColors.success;
      case 'İncelemede':
        return AppColors.warning;
      case 'Revize İsteniyor':
      case 'Reddedildi':
        return AppColors.lightSecondary;
      default:
        return AppColors.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(plan.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, statusColor),
              const SizedBox(height: 8),
              _buildIndustryAndTarget(context),
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            plan.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            plan.status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndustryAndTarget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sektör: ${plan.industry}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
        ),
        const SizedBox(height: 2),
        Text(
          'Hedef Pazar: ${plan.targetMarket}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
              ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bütçe: ₺${plan.budget.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          '${plan.createdAt.day}.${plan.createdAt.month}.${plan.createdAt.year}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
              ),
        ),
      ],
    );
  }
}
