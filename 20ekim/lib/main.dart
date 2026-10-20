import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/profile_screen.dart';
import 'features/business_plan/controllers/business_plan_controller.dart';
import 'features/business_plan/views/business_plan_screen.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/dashboard/views/dashboard_screen.dart';
import 'features/funding/controllers/funding_controller.dart';
import 'features/funding/views/funding_screen.dart';
import 'features/legal_support/controllers/legal_support_controller.dart';
import 'features/legal_support/views/legal_support_screen.dart';
import 'features/mentorship/controllers/mentorship_controller.dart';
import 'features/mentorship/views/mentorship_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FutureEntrepreneurApp());
}

class FutureEntrepreneurApp extends StatefulWidget {
  const FutureEntrepreneurApp({super.key});

  @override
  State<FutureEntrepreneurApp> createState() => _FutureEntrepreneurAppState();
}

class _FutureEntrepreneurAppState extends State<FutureEntrepreneurApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Future Entrepreneur',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: ValueListenableBuilder<bool>(
            valueListenable: _authController.isLoggedIn,
            builder: (context, isLoggedIn, _) {
              if (!isLoggedIn) {
                return LoginScreen(authController: _authController);
              }
              return MainNavigationShell(authController: _authController);
            },
          ),
        );
      },
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final AuthController authController;

  const MainNavigationShell({super.key, required this.authController});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  late final DashboardController _dashboardController;
  late final BusinessPlanController _businessPlanController;
  late final LegalSupportController _legalSupportController;
  late final FundingController _fundingController;
  late final MentorshipController _mentorshipController;

  @override
  void initState() {
    super.initState();
    _dashboardController = DashboardController();
    _businessPlanController = BusinessPlanController();
    _legalSupportController = LegalSupportController();
    _fundingController = FundingController();
    _mentorshipController = MentorshipController();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _dashboardController.dispose();
    _businessPlanController.dispose();
    _legalSupportController.dispose();
    _fundingController.dispose();
    _mentorshipController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    _currentIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          appBar: _buildAppBar(index),
          body: _buildPageBody(index),
          bottomNavigationBar: _buildBottomNav(index),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(int index) {
    if (index == 0) return null; // Dashboard has its own custom branding header
    final titles = [
      'Dashboard',
      'İş Planı & Onay Takibi',
      'Hukuki Destek',
      'Hibe & Fon Fırsatları',
      'Mentorluk & Danışmanlık',
      'Kullanıcı Profili',
    ];
    return AppBar(
      title: Text(titles[index]),
    );
  }

  Widget _buildPageBody(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(
          controller: _dashboardController,
          onNavigateTab: _onTabSelected,
        );
      case 1:
        return BusinessPlanScreen(controller: _businessPlanController);
      case 2:
        return LegalSupportScreen(controller: _legalSupportController);
      case 3:
        return FundingScreen(controller: _fundingController);
      case 4:
        return MentorshipScreen(controller: _mentorshipController);
      case 5:
        return ProfileScreen(controller: widget.authController);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNav(int currentIndex) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: _onTabSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Özet',
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment),
          label: 'İş Planı',
        ),
        NavigationDestination(
          icon: Icon(Icons.balance_outlined),
          selectedIcon: Icon(Icons.balance),
          label: 'Hukuk',
        ),
        NavigationDestination(
          icon: Icon(Icons.monetization_on_outlined),
          selectedIcon: Icon(Icons.monetization_on),
          label: 'Fonlama',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: 'Mentorluk',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
