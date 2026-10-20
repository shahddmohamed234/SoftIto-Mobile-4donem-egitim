import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/funding_model.dart';

class FundingApplyDialog extends StatefulWidget {
  final FundingOpportunity opportunity;
  final Function(bool isEligible, String? reason) onComplete;

  const FundingApplyDialog({
    super.key,
    required this.opportunity,
    required this.onComplete,
  });

  @override
  State<FundingApplyDialog> createState() => _FundingApplyDialogState();
}

class _FundingApplyDialogState extends State<FundingApplyDialog> {
  late final List<bool> _checkedState;

  @override
  void initState() {
    super.initState();
    _checkedState = List.filled(widget.opportunity.criteria.length, false);
  }

  bool get _allChecked => _checkedState.every((element) => element);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildDialogTitle(context),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNoticeBox(context),
              const SizedBox(height: 12),
              ..._buildCriteriaList(),
            ],
          ),
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  Widget _buildDialogTitle(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.verified_user_outlined, color: AppColors.lightPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${widget.opportunity.provider} Başvuru Kriterleri',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildNoticeBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Lütfen sağladığınız uygunluk kriterlerini işaretleyin. Eksik kriter bulunması durumunda başvurunuz komisyon tarafından reddedilecektir.',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  List<Widget> _buildCriteriaList() {
    return List.generate(widget.opportunity.criteria.length, (index) {
      final criteria = widget.opportunity.criteria[index];
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(criteria, style: const TextStyle(fontSize: 13)),
        value: _checkedState[index],
        onChanged: (val) {
          setState(() {
            _checkedState[index] = val ?? false;
          });
        },
      );
    });
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Vazgeç'),
      ),
      OutlinedButton(
        onPressed: () {
          widget.onComplete(
            false,
            'Kriter Uygunsuzluğu: Başvuru sahibi zorunlu ön yeterlilik kriterlerini sağlayamadığı için başvuru doğrudan reddedildi.',
          );
          Navigator.of(context).pop();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightSecondary,
          side: const BorderSide(color: AppColors.lightSecondary),
        ),
        child: const Text('Eksik Başvur (Red Simülasyonu)'),
      ),
      ElevatedButton(
        onPressed: _allChecked
            ? () {
                widget.onComplete(true, null);
                Navigator.of(context).pop();
              }
            : null,
        child: const Text('Kriterleri Onayla & Başvur'),
      ),
    ];
  }
}
