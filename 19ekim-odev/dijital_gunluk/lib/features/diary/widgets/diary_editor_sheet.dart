import 'package:flutter/material.dart';
import '../models/diary_model.dart';

class DiaryEditorSheet extends StatefulWidget {
  final DiaryEntry? initialEntry;
  final DateTime? targetDate;
  final void Function(String title, String content, String mood, List<String> tags) onSave;

  const DiaryEditorSheet({
    super.key,
    this.initialEntry,
    this.targetDate,
    required this.onSave,
  });

  @override
  State<DiaryEditorSheet> createState() => _DiaryEditorSheetState();
}

class _DiaryEditorSheetState extends State<DiaryEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;
  late String _selectedMood;

  final List<String> _moods = const [
    'Mutlu',
    'Huzurlu',
    'Enerjik',
    'Düşünceli',
    'Üzgün',
    'Yorgun',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialEntry?.title ?? '');
    _contentController = TextEditingController(text: widget.initialEntry?.content ?? '');
    _tagController = TextEditingController(text: widget.initialEntry?.tags.join(', ') ?? '');
    _selectedMood = widget.initialEntry?.mood ?? 'Mutlu';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialEntry != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(theme, isEditing),
            const SizedBox(height: 16),
            _buildTitleField(),
            const SizedBox(height: 12),
            _buildMoodPicker(theme),
            const SizedBox(height: 12),
            _buildContentField(),
            const SizedBox(height: 12),
            _buildTagField(),
            const SizedBox(height: 20),
            _buildSaveButton(theme, isEditing),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, bool isEditing) {
    final dateStr = widget.targetDate != null ? _formatDay(widget.targetDate!) : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Anıyı Düzenle' : 'Yeni Anı Ekle',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (dateStr != null)
              Text(
                'Tarih: $dateStr',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  String _formatDay(DateTime dt) {
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Başlık',
        hintText: 'Bugün nasıldı?',
        prefixIcon: Icon(Icons.title_rounded),
      ),
    );
  }

  Widget _buildMoodPicker(ThemeData theme) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _moods.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final mood = _moods[index];
          final isSelected = mood == _selectedMood;
          return ChoiceChip(
            label: Text(mood),
            selected: isSelected,
            onSelected: (val) {
              if (val) setState(() => _selectedMood = mood);
            },
          );
        },
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: 'Anı Detayları',
        hintText: 'Aklından ve kalbinden geçenleri yaz...',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildTagField() {
    return TextField(
      controller: _tagController,
      decoration: const InputDecoration(
        labelText: 'Etiketler (virgülle ayırın)',
        hintText: 'ör: Seyahat, Huzur, Kahve',
        prefixIcon: Icon(Icons.tag_rounded),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme, bool isEditing) {
    return FilledButton.icon(
      onPressed: _submit,
      icon: const Icon(Icons.check_rounded),
      label: Text(isEditing ? 'Güncelle' : 'Kaydet'),
    );
  }

  void _submit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final tags = _tagController.text
        .split(',')
        .map((t) => t.trim().replaceAll('#', ''))
        .where((t) => t.isNotEmpty)
        .toList();

    widget.onSave(
      title.isEmpty ? 'Başlıksız Gün' : title,
      content,
      _selectedMood,
      tags,
    );
    Navigator.pop(context);
  }
}
