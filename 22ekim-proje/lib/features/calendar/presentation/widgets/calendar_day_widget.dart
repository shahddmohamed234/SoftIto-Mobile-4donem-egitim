import 'package:flutter/material.dart';

class CalendarDayWidget extends StatelessWidget {
  final int dayNumber;
  final bool isStreakCompleted;

  const CalendarDayWidget({
    super.key,
    required this.dayNumber,
    required this.isStreakCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStreakCompleted
              ? Theme.of(context).colorScheme.tertiary.withAlpha(120)
              : (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF373A47)
                  : Colors.black12),
          width: 1,
        ),
      ),
      child: Center(
        child: _buildDayContent(context),
      ),
    );
  }

  Widget _buildDayContent(BuildContext context) {
    if (isStreakCompleted) {
      // Streak başarılıysa Pudra / Gül Kurusu rengi kalp gösterilir
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.tertiary,
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            dayNumber.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      // Tamamlanmayan gün için standart metin
      return Text(
        dayNumber.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
  }
}
