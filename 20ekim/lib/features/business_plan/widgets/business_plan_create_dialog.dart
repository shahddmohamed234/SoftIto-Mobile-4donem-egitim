import 'package:flutter/material.dart';
import '../models/business_plan_model.dart';

class BusinessPlanCreateDialog extends StatefulWidget {
  final Function(BusinessPlanItem) onCreated;

  const BusinessPlanCreateDialog({super.key, required this.onCreated});

  @override
  State<BusinessPlanCreateDialog> createState() =>
      _BusinessPlanCreateDialogState();
}

class _BusinessPlanCreateDialogState extends State<BusinessPlanCreateDialog> {
  final _titleController = TextEditingController();
  final _industryController = TextEditingController();
  final _targetController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _industryController.dispose();
    _targetController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;
    final item = BusinessPlanItem(
      id: 'bp_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      industry: _industryController.text.trim().isEmpty
          ? 'Genel Girişim'
          : _industryController.text.trim(),
      targetMarket: _targetController.text.trim().isEmpty
          ? 'B2B & B2C'
          : _targetController.text.trim(),
      budget: double.tryParse(_budgetController.text.trim()) ?? 500000,
      status: 'İncelemede',
      createdAt: DateTime.now(),
    );
    widget.onCreated(item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni İş Planı Başlat'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Girişim / Proje Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _industryController,
              decoration: const InputDecoration(
                labelText: 'Sektör',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: 'Hedef Pazar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tahmini Bütçe (₺)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Oluştur ve İncelemeye Gönder'),
        ),
      ],
    );
  }
}
