import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/funding_model.dart';

class FundingCard extends StatelessWidget {
  final FundingOpportunity opportunity;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const FundingCard({
    super.key,
    required this.opportunity,
    required this.onApply,
    required this.onCancel,
  });

  Color _getStatusColor() {
    switch (opportunity.status) {
      case 'Onaylandı':
        return AppColors.success;
      case 'İnceleniyor':
        return AppColors.warning;
      case 'Reddedildi':
        return AppColors.lightSecondary;
      default:
        return AppColors.lightPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildTitle(context),
            if (opportunity.status == 'Reddedildi' && opportunity.rejectionReason != null) ...[
              const SizedBox(height: 10),
              _buildRejectionBox(context),
            ],
            const SizedBox(height: 12),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final statusColor = _getStatusColor();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              opportunity.provider,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            opportunity.status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          opportunity.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Destek Üst Limiti: ₺${opportunity.maxAmount.toStringAsFixed(0)} • ${opportunity.category}',
          style: const TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        Text(
          'Son Başvuru: ${opportunity.deadline}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
              ),
        ),
      ],
    );
  }

  Widget _buildRejectionBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightSecondary.withAlpha(20),
        border: Border.all(color: AppColors.lightSecondary.withAlpha(80)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cancel, color: AppColors.lightSecondary, size: 16),
              SizedBox(width: 6),
              Text(
                'Başvuru Reddedildi',
                style: TextStyle(
                  color: AppColors.lightSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            opportunity.rejectionReason!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (opportunity.isApplied) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                opportunity.status == 'Onaylandı'
                    ? Icons.check_circle
                    : (opportunity.status == 'Reddedildi' ? Icons.error : Icons.hourglass_top),
                color: _getStatusColor(),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                opportunity.status == 'Onaylandı'
                    ? 'Fon Hesaba Aktarıldı'
                    : (opportunity.status == 'Reddedildi' ? 'Sonuç: Red' : 'Komisyon İncelemesinde'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onCancel,
            child: const Text('Başvuruyu Sıfırla'),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: onApply,
          icon: const Icon(Icons.assignment_turned_in, size: 16),
          label: const Text('Kriterleri Gör & Başvur'),
        ),
      ],
    );
  }
}
