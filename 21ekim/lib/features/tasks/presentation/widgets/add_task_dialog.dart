import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// Yeni görev ekleme modal diyalog penceresi
class AddTaskDialog extends StatefulWidget {
  final Function(String title, String date) onAdd;
  final String? initialDate;

  const AddTaskDialog({
    super.key,
    required this.onAdd,
    this.initialDate,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    final String todayFormatted = widget.initialDate ?? DateFormat('dd.MM.yyyy').format(DateTime.now());
    _dateController = TextEditingController(text: todayFormatted);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.now();
    try {
      final parts = _dateController.text.split('.');
      if (parts.length == 3) {
        final d = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final y = int.parse(parts[2]);
        initial = DateTime(y, m, d);
      }
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  void _handleSubmit() {
    final String title = _titleController.text.trim();
    final String date = _dateController.text.trim();
    if (title.isNotEmpty) {
      widget.onAdd(title, date.isEmpty ? DateFormat('dd.MM.yyyy').format(DateTime.now()) : date);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = AppStrings.get('enterTaskTitleError');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      title: Text(AppStrings.get('addNewTask'), style: theme.textTheme.titleLarge),
      content: _buildFormFields(isDark),
      actions: _buildDialogActions(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildFormFields(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleSubmit(),
          decoration: InputDecoration(
            labelText: AppStrings.get('taskTitle'),
            errorText: _errorMessage,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _dateController,
          readOnly: true,
          onTap: _pickDate,
          decoration: InputDecoration(
            labelText: AppStrings.get('taskDate'),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.date_range, color: AppColors.burgundy),
              onPressed: _pickDate,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(AppStrings.get('cancel')),
      ),
      ElevatedButton(
        onPressed: _handleSubmit,
        child: Text(AppStrings.get('save')),
      ),
    ];
  }
}
