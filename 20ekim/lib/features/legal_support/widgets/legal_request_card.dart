import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/legal_support_model.dart';

class LegalRequestCard extends StatelessWidget {
  final LegalRequest request;
  final VoidCallback? onResolve;

  const LegalRequestCard({
    super.key,
    required this.request,
    this.onResolve,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Tamamlandı':
        return AppColors.success;
      case 'Avukat Atandı':
        return AppColors.lightPrimary;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(request.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, statusColor),
            const SizedBox(height: 8),
            _buildDetails(context),
            const SizedBox(height: 12),
            _buildFooter(context),
          ],
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
            request.topic,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            request.status,
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

  Widget _buildDetails(BuildContext context) {
    return Text(
      request.details,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.gavel, size: 16),
            const SizedBox(width: 4),
            Text(
              request.lawyerAssigned,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        if (request.status != 'Tamamlandı' && onResolve != null)
          TextButton(
            onPressed: onResolve,
            child: const Text('Sonuçlandır'),
          ),
      ],
    );
  }
}
