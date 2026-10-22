import 'package:flutter/material.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_view.dart';
import 'features/navigation/app_navigation_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  runApp(const GoOnApp());
}

class GoOnApp extends StatelessWidget {
  const GoOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go On',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isLoggedIn = AppState.instance.isLoggedIn;
        if (isLoggedIn) {
          return const AppNavigationScaffold();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
