import 'package:flutter/material.dart';
import '../../data/models/car_model.dart';

class RateToggleBar extends StatelessWidget {
  final PricingType selectedType;
  final ValueChanged<PricingType> onTypeChanged;

  const RateToggleBar({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PricingType>(
      segments: const [
        ButtonSegment(value: PricingType.daily, label: Text('Günlük')),
        ButtonSegment(value: PricingType.weekly, label: Text('Haftalık')),
        ButtonSegment(value: PricingType.monthly, label: Text('Aylık')),
      ],
      selected: {selectedType},
      onSelectionChanged: (set) => onTypeChanged(set.first),
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
