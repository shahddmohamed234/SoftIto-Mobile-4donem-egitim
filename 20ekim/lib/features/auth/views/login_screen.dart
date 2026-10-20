import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;

  const LoginScreen({super.key, required this.authController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedRoleIndex = 0; // 0: Girişimci, 1: Yatırımcı

  final _nameController = TextEditingController(text: 'Ahmet Yılmaz');
  final _emailController = TextEditingController(text: 'ahmet@future-entrepreneur.com');
  final _extraController = TextEditingController(text: 'TechVision AI Çözümleri');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _extraController.dispose();
    super.dispose();
  }

  void _onRoleChanged(int index) {
    setState(() {
      _selectedRoleIndex = index;
      if (index == 0) {
        _nameController.text = 'Ahmet Yılmaz';
        _emailController.text = 'ahmet@future-entrepreneur.com';
        _extraController.text = 'TechVision AI Çözümleri';
      } else {
        _nameController.text = 'Mehmet Vural';
        _emailController.text = 'mehmet@angelinvest.com';
        _extraController.text = 'İstanbul Melek Yatırım Fonu';
      }
    });
  }

  void _handleLogin() {
    if (_selectedRoleIndex == 0) {
      widget.authController.loginAsEntrepreneur(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        startupName: _extraController.text.trim(),
      );
    } else {
      widget.authController.loginAsInvestor(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        fundName: _extraController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoHeader(),
                const SizedBox(height: 24),
                _buildRoleSelector(),
                const SizedBox(height: 20),
                _buildFormFields(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/logo.png',
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Future Entrepreneur',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'Girişimci & Yatırımcı Ekosistemine Hoş Geldiniz',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRoleTab('Girişimci Girişi', Icons.rocket_launch, 0),
          ),
          Expanded(
            child: _buildRoleTab('Yatırımcı Girişi', Icons.monetization_on, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTab(String title, IconData icon, int index) {
    final isSelected = _selectedRoleIndex == index;
    return GestureDetector(
      onTap: () => _onRoleChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withAlpha(140),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    final isEntrepreneur = _selectedRoleIndex == 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-posta Adresi',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _extraController,
              decoration: InputDecoration(
                labelText: isEntrepreneur
                    ? 'Girişim / Proje Adı'
                    : 'Yatırım Fonu / Melek Ağı Adı',
                prefixIcon: Icon(isEntrepreneur
                    ? Icons.lightbulb_outline
                    : Icons.business_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isEntrepreneur = _selectedRoleIndex == 0;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEntrepreneur
              ? AppColors.lightPrimary
              : AppColors.success,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.login),
        label: Text(
          isEntrepreneur
              ? 'Girişimci Olarak Giriş Yap'
              : 'Yatırımcı Olarak Giriş Yap',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
