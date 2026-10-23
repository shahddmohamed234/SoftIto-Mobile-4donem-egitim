import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_state.dart';
import '../../navigation/app_navigation_scaffold.dart';
import 'mascot_selection_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isRegisterMode = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildForm(context),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                    const SizedBox(height: 12),
                    _buildSwitchModeButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF2C2E38) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 40 : 20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/icons/app_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Go On',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          _isRegisterMode
              ? AppStrings.tr('register_subtitle')
              : AppStrings.tr('welcome_subtitle'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    if (_isRegisterMode) {
      return Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppStrings.tr('name'),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _surnameController,
            decoration: InputDecoration(
              labelText: AppStrings.tr('surname'),
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _birthDateController,
            decoration: InputDecoration(
              labelText: AppStrings.tr('birth_date'),
              prefixIcon: const Icon(Icons.cake_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppStrings.tr('email'),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppStrings.tr('password'),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppStrings.tr('password_again'),
              prefixIcon: const Icon(Icons.lock_reset),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppStrings.tr('email'),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppStrings.tr('password'),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    final String buttonLabel = _isRegisterMode
        ? AppStrings.tr('register_btn')
        : AppStrings.tr('login_btn');

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        child: Text(buttonLabel),
      ),
    );
  }

  Widget _buildSwitchModeButton(BuildContext context) {
    final String switchText = _isRegisterMode
        ? AppStrings.tr('have_account')
        : AppStrings.tr('no_account');

    return TextButton(
      onPressed: () {
        setState(() {
          _isRegisterMode = !_isRegisterMode;
        });
      },
      child: Text(
        switchText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isRegisterMode) {
      final name = _nameController.text.trim();
      final surname = _surnameController.text.trim();
      final birthDate = _birthDateController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _showErrorSnackBar(AppStrings.tr('fill_all_fields'));
        return;
      }
      if (password != confirmPassword) {
        _showErrorSnackBar(AppStrings.tr('passwords_dont_match'));
        return;
      }

      await AppState.instance.register(
        name: name,
        surname: surname.isEmpty ? 'Kullanıcı' : surname,
        birthDate: birthDate.isEmpty ? '2000-01-01' : birthDate,
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MascotSelectionView(isFromRegister: true),
          ),
        );
      }
    } else {
      if (email.isEmpty || password.isEmpty) {
        // Convenient demo fallback
        await AppState.instance.login('pati@goon.com', '123456');
      } else {
        await AppState.instance.login(email, password);
      }
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const AppNavigationScaffold(),
          ),
          (route) => false,
        );
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
