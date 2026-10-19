import 'package:flutter/material.dart';

class DiaryEmptyView extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onAddPressed;

  const DiaryEmptyView({
    super.key,
    this.selectedDate,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = selectedDate != null ? _formatDay(selectedDate!) : null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              dateStr != null ? '$dateStr İçin Anı Yok' : 'Henüz Bir Anı Eklenmedi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              dateStr != null
                  ? 'Seçtiğiniz bu güne ait düşüncelerinizi ve anılarınızı kaydetmek için ilk sayfayı yazın.'
                  : 'Gününüzü, hislerinizi ve unutmak istemediğiniz anları ölümsüzleştirmek için ilk sayfayı yazmaya başlayın.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(dateStr != null ? '$dateStr Gününe Yaz' : 'İlk Anını Yaz'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDay(DateTime dt) {
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}
