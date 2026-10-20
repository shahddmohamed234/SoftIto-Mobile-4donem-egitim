import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/data/repositories/mock_auth_repository.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/home/presentation/controllers/home_controller.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/profile/presentation/controllers/profile_controller.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/reservations/presentation/controllers/reservations_controller.dart';
import 'features/reservations/presentation/pages/reservations_screen.dart';

/// main: Uygulamanın başlangıç noktasıdır.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EasyRentApp());
}

/// EasyRentApp: Kök uygulama widget'ı.
/// ThemeController'ı dinleyerek anlık tema değişimini sağlar.
class EasyRentApp extends StatelessWidget {
  const EasyRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'EasyRent',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const AppRootView(),
        );
      },
    );
  }
}

/// AppRootView: Kimlik doğrulama kapısı (Auth Gate) ve ana navigasyon kabuğunu yönetir.
/// Kullanıcı oturum açmadığı sürece LoginScreen dışında hiçbir ekrana geçit vermez.
class AppRootView extends StatefulWidget {
  const AppRootView({super.key});

  @override
  State<AppRootView> createState() => _AppRootViewState();
}

class _AppRootViewState extends State<AppRootView> {
  // Modül kontrolcüleri
  final AuthController _authController = AuthController();
  final HomeController _homeController = HomeController();
  final ReservationsController _reservationsController = ReservationsController();
  final ProfileController _profileController = ProfileController();

  // Aktif sekme indeksi ve giriş durumu
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  // Başlangıçta oturum kapalıdır (Zorunlu Login Ekranı)
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(MockAuthRepository.instance.isLoggedIn);

  @override
  void dispose() {
    _authController.dispose();
    _homeController.dispose();
    _reservationsController.dispose();
    _profileController.dispose();
    _currentIndex.dispose();
    _isLoggedIn.dispose();
    super.dispose();
  }

  /// Giriş başarılı olduğunda ana kabuğa yönlendir
  void _onLoginSuccess() {
    _isLoggedIn.value = true;
    _profileController.init();
  }

  /// Çıkış yapıldığında oturumu kapatıp doğrudan LoginScreen'e döndür
  void _onLogout() {
    _isLoggedIn.value = false;
    _currentIndex.value = 0;
  }

  // 40 satır kuralına uygun ana build metodu (Auth Gate)
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoggedIn,
      builder: (context, loggedIn, _) {
        // Kullanıcı giriş yapmamışsa ZORUNLU olarak LoginScreen gösterilir
        if (!loggedIn) {
          return LoginScreen(
            authController: _authController,
            onLoginSuccess: _onLoginSuccess,
          );
        }
        // Giriş yapılmışsa ana navigasyon kabuğu açılır
        return _buildShellScaffold();
      },
    );
  }

  /// 3 sekmeli ana navigasyon kabuğu (Araçlar, Rezervasyonlarım, Profilim)
  Widget _buildShellScaffold() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          body: IndexedStack(
            index: index,
            children: [
              HomeScreen(
                controller: _homeController,
                onNavigateToReservations: () => _currentIndex.value = 1,
              ),
              ReservationsScreen(controller: _reservationsController),
              ProfileScreen(
                controller: _profileController,
                onLogout: _onLogout,
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (newIndex) => _currentIndex.value = newIndex,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.directions_car_outlined), selectedIcon: Icon(Icons.directions_car), label: 'Araçlar'),
              NavigationDestination(icon: Icon(Icons.bookmark_outline), selectedIcon: Icon(Icons.bookmark), label: 'Rezervasyonlarım'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profilim'),
            ],
          ),
        );
      },
    );
  }
}
