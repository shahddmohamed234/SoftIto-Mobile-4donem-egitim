import 'package:flutter/material.dart';
import 'package:full_concentrate/core/constants/app_constants.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';
import 'package:full_concentrate/core/theme/app_colors.dart';

/// Kullanıcının çalışma süresini doğrudan ayarlamasını sağlayan ve 25 dk altı için uyarı veren diyalog
class DurationPickerDialog extends StatefulWidget {
  final int currentMinutes;
  final ValueChanged<int> onDurationSelected;

  const DurationPickerDialog({
    super.key,
    required this.currentMinutes,
    required this.onDurationSelected,
  });

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late final TextEditingController _controller;
  int _selectedMinutes = AppConstants.minWorkDurationMinutes;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.currentMinutes;
    _controller = TextEditingController(text: widget.currentMinutes.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMinutesChanged(String text) {
    final int? val = int.tryParse(text);
    setState(() {
      _selectedMinutes = val ?? 0;
    });
  }

  void _selectPreset(int minutes) {
    setState(() {
      _selectedMinutes = minutes;
      _controller.text = minutes.toString();
    });
  }

  void _handleConfirm() {
    if (_selectedMinutes >= AppConstants.minWorkDurationMinutes) {
      widget.onDurationSelected(_selectedMinutes);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isInvalid = _selectedMinutes < AppConstants.minWorkDurationMinutes;

    return AlertDialog(
      title: Text(AppStrings.get('setWorkDuration'), style: theme.textTheme.titleLarge),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(isDark),
            const SizedBox(height: 12),
            _buildPresetChips(isDark),
            const SizedBox(height: 14),
            if (isInvalid)
              _buildWarningBox()
            else
              _buildValidEquationInfo(),
          ],
        ),
      ),
      actions: _buildActions(isInvalid),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildInputField(bool isDark) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      onChanged: _onMinutesChanged,
      decoration: InputDecoration(
        labelText: AppStrings.get('focusDurationMinutes'),
        hintText: AppStrings.get('min25Notice'),
        suffixText: AppStrings.get('minutes'),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPresetChips(bool isDark) {
    final presets = [15, 20, 25, 30, 45, 50, 60];
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: presets.map((min) {
        final isSelected = _selectedMinutes == min;
        final isBelowMin = min < AppConstants.minWorkDurationMinutes;

        return ChoiceChip(
          label: Text('$min ${AppStrings.get('minutes')}'),
          selected: isSelected,
          selectedColor: isBelowMin ? AppColors.violationRed.withValues(alpha: 0.3) : AppColors.burgundy,
          labelStyle: TextStyle(
            color: isSelected
                ? AppColors.white
                : (isBelowMin ? AppColors.violationRed : (isDark ? AppColors.white : AppColors.darkAnthracite)),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (_) => _selectPreset(min),
        );
      }).toList(),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.violationRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.violationRed, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.violationRed, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppStrings.get('durationMinWarning'),
              style: const TextStyle(
                color: AppColors.violationRed,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidEquationInfo() {
    final breakMin = AppConstants.calculateBreakDuration(_selectedMinutes);
    return Text(
      AppStrings.getValidDurationNotice(_selectedMinutes, breakMin),
      style: const TextStyle(
        color: AppColors.roseDust,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  List<Widget> _buildActions(bool isInvalid) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(AppStrings.get('cancel')),
      ),
      ElevatedButton(
        onPressed: isInvalid ? null : _handleConfirm,
        child: Text(AppStrings.get('save')),
      ),
    ];
  }
}
