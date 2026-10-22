import 'package:flutter/material.dart';
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Bugün',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'İstatistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Takvim',
          ),
          NavigationDestination(
            icon: Icon(Icons.military_tech_outlined),
            selectedIcon: Icon(Icons.military_tech),
            label: 'Ödüller',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa),
            label: 'İlham',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
