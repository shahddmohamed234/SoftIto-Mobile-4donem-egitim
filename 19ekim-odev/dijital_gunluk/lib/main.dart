import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/diary/controllers/diary_controller.dart';
import 'features/diary/views/diary_screen.dart';
import 'features/mood_tracker/controllers/mood_tracker_controller.dart';
import 'features/mood_tracker/views/mood_tracker_screen.dart';
import 'features/settings/controllers/settings_controller.dart';
import 'features/settings/views/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DijitalGunlukApp());
}

class DijitalGunlukApp extends StatefulWidget {
  const DijitalGunlukApp({super.key});

  @override
  State<DijitalGunlukApp> createState() => _DijitalGunlukAppState();
}

class _DijitalGunlukAppState extends State<DijitalGunlukApp> {
  late final DiaryController _diaryController;
  late final MoodTrackerController _moodController;
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _diaryController = DiaryController();
    _moodController = MoodTrackerController();
    _settingsController = SettingsController();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    _moodController.dispose();
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _settingsController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Anı Defteri',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MainNavigationShell(
            diaryController: _diaryController,
            moodController: _moodController,
            settingsController: _settingsController,
          ),
        );
      },
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final DiaryController diaryController;
  final MoodTrackerController moodController;
  final SettingsController settingsController;

  const MainNavigationShell({
    super.key,
    required this.diaryController,
    required this.moodController,
    required this.settingsController,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DiaryScreen(controller: widget.diaryController),
      MoodTrackerScreen(controller: widget.moodController),
      SettingsScreen(controller: widget.settingsController),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Günlük',
          ),
          NavigationDestination(
            icon: Icon(Icons.mood_outlined),
            selectedIcon: Icon(Icons.mood_rounded),
            label: 'Duygular',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
