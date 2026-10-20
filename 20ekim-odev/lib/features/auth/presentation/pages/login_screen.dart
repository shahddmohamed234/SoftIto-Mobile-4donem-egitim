import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/sms_verification_dialog.dart';

/// LoginScreen: Uygulama ilk açıldığında zorunlu olarak karşılanan
/// ehliyet ve kimlik bilgileri doğrulama ekranıdır.
class LoginScreen extends StatefulWidget {
  final AuthController authController;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.authController,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form doğrulama anahtarı
  final _formKey = GlobalKey<FormState>();

  // Girdi denetleyicileri
  final _tcknController = TextEditingController(text: '12345678901');
  final _fullNameController = TextEditingController(text: 'Ahmet Yılmaz');
  final _birthDateController = TextEditingController(text: '15.05.1995');
  final _licenseController = TextEditingController(text: 'B129845');
  final _phoneController = TextEditingController(text: '05551234567');

  @override
  void dispose() {
    _tcknController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Form alanları geçerliyse kullanıcıya SMS kodu gönderir ve diyalog açar
  void _onFormSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = UserModel(
      tckn: _tcknController.text.trim(),
      fullName: _fullNameController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    final sent = await widget.authController.requestSmsVerification(user.phoneNumber);
    if (!mounted) return;

    if (sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.phoneNumber} numarasına doğrulama kodu gönderildi!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      _showSmsDialog(user);
    }
  }

  /// 4 haneli SMS doğrulama penceresini gösterir (Test: 1234)
  void _showSmsDialog(UserModel user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SmsVerificationDialog(
        phoneNumber: user.phoneNumber,
        onVerify: (code) async {
          Navigator.of(ctx).pop();
          final success = await widget.authController.verifyAndLogin(user, code);
          if (!mounted) return;
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kimlik ve ehliyet doğrulaması başarılı! İyi yolculuklar.'),
                backgroundColor: Colors.green,
              ),
            );
            widget.onLoginSuccess();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.authController.errorMessage.value ?? 'Doğrulama başarısız!'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      ),
    );
  }

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EasyRent Giriş')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildFormFields(),
                const SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Ekran başlığı ve logo bölümü
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/app_icon.png', height: 80, width: 80),
        const SizedBox(height: 10),
        Text(
          'Ehliyet ve Kimlik Doğrulama',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Araç kiralayabilmek için bilgilerinizi eksiksiz doldurunuz.',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Doğrulamalı form alanları
  Widget _buildFormFields() {
    return Column(
      children: [
        AuthTextField(
          controller: _tcknController,
          label: 'TCKN / Pasaport No',
          hintText: '11 haneli TCKN giriniz',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          validator: (val) => (val == null || val.length != 11) ? 'Geçerli 11 haneli TCKN giriniz' : null,
        ),
        AuthTextField(
          controller: _fullNameController,
          label: 'Ad Soyad',
          hintText: 'Adınızı ve soyadınızı giriniz',
          prefixIcon: Icons.person_outline,
          validator: (val) => (val == null || val.trim().isEmpty) ? 'Ad soyad zorunludur' : null,
        ),
        AuthTextField(
          controller: _birthDateController,
          label: 'Doğum Tarihi',
          hintText: 'GG.AA.YYYY',
          prefixIcon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.datetime,
          validator: (val) => (val == null || val.trim().isEmpty) ? 'Doğum tarihi zorunludur' : null,
        ),
        AuthTextField(
          controller: _licenseController,
          label: 'Ehliyet Belge No',
          hintText: 'Örn: B129845',
          prefixIcon: Icons.drive_eta_outlined,
          validator: (val) => (val == null || val.trim().isEmpty) ? 'Ehliyet no zorunludur' : null,
        ),
        AuthTextField(
          controller: _phoneController,
          label: 'Telefon Numarası',
          hintText: '05XXXXXXXXX',
          prefixIcon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
          validator: (val) => (val == null || val.length < 10) ? 'Geçerli telefon no giriniz' : null,
        ),
      ],
    );
  }

  /// SMS gönderme ve doğrulama butonu
  Widget _buildSubmitButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.authController.isLoading,
      builder: (context, loading, _) {
        if (loading) return const Center(child: CircularProgressIndicator());
        return ElevatedButton.icon(
          onPressed: _onFormSubmit,
          icon: const Icon(Icons.sms_outlined),
          label: const Text('SMS Kodu Al ve Giriş Yap'),
        );
      },
    );
  }
}
