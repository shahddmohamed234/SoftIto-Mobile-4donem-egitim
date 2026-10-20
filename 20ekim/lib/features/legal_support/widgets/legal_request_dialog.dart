import 'package:flutter/material.dart';
import '../models/legal_support_model.dart';

class LegalRequestDialog extends StatefulWidget {
  final Function(LegalRequest) onCreated;

  const LegalRequestDialog({super.key, required this.onCreated});

  @override
  State<LegalRequestDialog> createState() => _LegalRequestDialogState();
}

class _LegalRequestDialogState extends State<LegalRequestDialog> {
  final _topicController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedTopic = 'Şirket Kuruluşu & Esas Sözleşme';

  final List<String> _topics = [
    'Şirket Kuruluşu & Esas Sözleşme',
    'KVKK & Gizlilik Politikası',
    'Yatırımcı & Pay Sahipleri Sözleşmesi (SHA)',
    'Marka & Patent / Fikri Mülkiyet',
    'İş ve Çalışan Sözleşmeleri',
  ];

  @override
  void dispose() {
    _topicController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_detailsController.text.trim().isEmpty) return;
    final item = LegalRequest(
      id: 'leg_${DateTime.now().millisecondsSinceEpoch}',
      topic: _selectedTopic,
      details: _detailsController.text.trim(),
      lawyerAssigned: 'Avukat Atanıyor...',
      status: 'İnceleniyor',
      date: DateTime.now(),
    );
    widget.onCreated(item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hukuki Danışmanlık Talebi'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Konu Başlığı:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedTopic,
              isExpanded: true,
              items: _topics
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t, style: const TextStyle(fontSize: 13)),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedTopic = v);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Danışmak istediğiniz durumun detayları',
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
          child: const Text('Talebi Gönder'),
        ),
      ],
    );
  }
}
