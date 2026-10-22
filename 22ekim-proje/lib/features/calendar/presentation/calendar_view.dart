import 'package:flutter/material.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';
import 'widgets/calendar_day_widget.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final mascot = AppState.instance.selectedMascot;
        final streakDates = AppState.instance.streakDates;
        final currentStreak = AppState.instance.currentStreak;

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          message: '${mascot.name}: Kalpleri toplamaya devam!',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildStreakSummary(context, currentStreak, streakDates.length),
                  const SizedBox(height: 18),
                  _buildMonthNavigation(context),
                  const SizedBox(height: 12),
                  _buildDaysOfWeekHeader(context),
                  const SizedBox(height: 8),
                  _buildCalendarGrid(context, streakDates),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aylık Takvim ve Seri 📅',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Alışkanlıklarını tamamladığın günlerde pembe kalpler parlar!',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget _buildStreakSummary(BuildContext context, int streak, int totalDays) {
    final heartColor = Theme.of(context).colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4DFD6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatSummaryColumn('Mevcut Seri', '$streak Gün', heartColor),
          Container(width: 1, height: 40, color: const Color(0xFFE4DFD6)),
          _buildStatSummaryColumn('Toplam Kalpli Gün', '$totalDays Gün', const Color(0xFF9DB2A1)),
        ],
      ),
    );
  }

  Widget _buildStatSummaryColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation(BuildContext context) {
    final monthNames = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final monthName = monthNames[_currentMonth.month - 1];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
            });
          },
        ),
        Text(
          '$monthName ${_currentMonth.year}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
            });
          },
        ),
      ],
    );
  }

  Widget _buildDaysOfWeekHeader(BuildContext context) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return Row(
      children: days.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, List<String> streakDates) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    final leadingBlanks = firstWeekday - 1;

    final totalGridItems = leadingBlanks + daysInMonth;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalGridItems,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        if (index < leadingBlanks) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - leadingBlanks + 1;
        final dayStr = dayNumber.toString().padLeft(2, '0');
        final monthStr = _currentMonth.month.toString().padLeft(2, '0');
        final dateKey = '${_currentMonth.year}-$monthStr-$dayStr';

        final isStreakCompleted = streakDates.contains(dateKey);

        return CalendarDayWidget(
          dayNumber: dayNumber,
          isStreakCompleted: isStreakCompleted,
        );
      },
    );
  }
}
