import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/state/app_state.dart';
import '../calendar/presentation/calendar_view.dart';
import '../home/presentation/home_view.dart';
import '../motivation/presentation/motivation_view.dart';
import '../profile/presentation/profile_view.dart';
import '../rewards/presentation/rewards_view.dart';
import '../statistics/presentation/statistics_view.dart';

class AppNavigationScaffold extends StatefulWidget {
  const AppNavigationScaffold({super.key});

  @override
  State<AppNavigationScaffold> createState() => _AppNavigationScaffoldState();
}

class _AppNavigationScaffoldState extends State<AppNavigationScaffold> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    HomeView(),
    StatisticsView(),
    CalendarView(),
    RewardsView(),
    MotivationView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _views,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: AppStrings.tr('nav_today'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: AppStrings.tr('nav_stats'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_outlined),
                selectedIcon: const Icon(Icons.calendar_month),
                label: AppStrings.tr('nav_calendar'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.military_tech_outlined),
                selectedIcon: const Icon(Icons.military_tech),
                label: AppStrings.tr('nav_rewards'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.spa_outlined),
                selectedIcon: const Icon(Icons.spa),
                label: AppStrings.tr('nav_inspiration'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: AppStrings.tr('nav_profile'),
              ),
            ],
          ),
        );
      },
    );
  }
}
