// Flutter malzeme tasarım sınıflarını içeri aktarır
import 'package:flutter/material.dart';
// Kullanıcı veri modelini içeri aktarır
import '../../data/models/user_model.dart';
// Kimlik doğrulama kontrolcüsünü içeri aktarır
import '../controllers/auth_controller.dart';
// Özel form metin kutusu bileşenini içeri aktarır
import '../widgets/auth_text_field.dart';
// SMS doğrulama açılır penceresini içeri aktarır
import '../widgets/sms_verification_dialog.dart';

/// LoginScreen: Uygulama ilk açıldığında zorunlu olarak karşılanan
/// ehliyet ve kimlik bilgileri doğrulama ekranıdır.
class LoginScreen extends StatefulWidget {
  // Kimlik doğrulama durum kontrolcüsü
  final AuthController authController;

  // Giriş ve SMS onayı başarıyla tamamlandığında ana kabuğa yönlendiren fonksiyon
  final VoidCallback onLoginSuccess;

  // LoginScreen sabit kurucu metodu
  const LoginScreen({
    super.key,
    // Kontrolcü parametresi zorunludur
    required this.authController,
    // Başarı geri çağırımı zorunludur
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form doğrulama anahtarı: Tüm alanların kurallara uyup uymadığını denetler
  final _formKey = GlobalKey<FormState>();

  // T.C. Kimlik No girdi denetleyicisi (Örnek test verisi ile hazır)
  final _tcknController = TextEditingController(text: '12345678901');

  // Ad Soyad girdi denetleyicisi
  final _fullNameController = TextEditingController(text: 'Ahmet Yılmaz');

  // Doğum Tarihi girdi denetleyicisi
  final _birthDateController = TextEditingController(text: '15.05.1995');

  // Ehliyet Belge No girdi denetleyicisi
  final _licenseController = TextEditingController(text: 'B129845');

  // Telefon Numarası girdi denetleyicisi
  final _phoneController = TextEditingController(text: '05551234567');

  @override
  void dispose() {
    // TCKN denetleyicisini bellekten temizler
    _tcknController.dispose();
    // Ad soyad denetleyicisini bellekten temizler
    _fullNameController.dispose();
    // Doğum tarihi denetleyicisini bellekten temizler
    _birthDateController.dispose();
    // Ehliyet no denetleyicisini bellekten temizler
    _licenseController.dispose();
    // Telefon denetleyicisini bellekten temizler
    _phoneController.dispose();
    // Üst sınıf dispose metodunu çağırır
    super.dispose();
  }

  /// Form alanları geçerliyse kullanıcıya SMS kodu gönderir ve doğrulama diyaloğunu açar
  void _onFormSubmit() async {
    // Form alanları geçerli değilse işlemi durdurur
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Girdilerden UserModel nesnesi oluşturur
    final user = UserModel(
      tckn: _tcknController.text.trim(),
      fullName: _fullNameController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    // Kontrolcü aracılığıyla SMS kod gönderim isteğini başlatır
    final sent = await widget.authController.requestSmsVerification(user.phoneNumber);
    // Widget ağaçtan ayrılmışsa devam etme
    if (!mounted) return;

    // SMS başarıyla gönderildiyse
    if (sent) {
      // Kullanıcıya bilgi bildirim çubuğu (SnackBar) gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.phoneNumber} numarasına doğrulama kodu gönderildi!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      // 4 haneli SMS kodu giriş penceresini açar
      _showSmsDialog(user);
    }
  }

  /// 4 haneli SMS doğrulama penceresini gösterir (Test Kodu: 1234)
  void _showSmsDialog(UserModel user) {
    // Ekranda açılır pencere oluşturur
    showDialog(
      context: context,
      // Dışarı tıklayarak kapatılmasını engeller (Zorunlu doğrulama)
      barrierDismissible: false,
      // Diyalog penceresi widget'ını inşa eder
      builder: (ctx) => SmsVerificationDialog(
        phoneNumber: user.phoneNumber,
        onVerify: (code) async {
          // Diyalog penceresini kapatır
          Navigator.of(ctx).pop();
          // Girilen kod ile oturum açmayı dener
          final success = await widget.authController.verifyAndLogin(user, code);
          // Widget hala ekranda mı kontrolü
          if (!mounted) return;
          // Doğrulama başarılı ise
          if (success) {
            // Başarı mesajı gösterir
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kimlik ve ehliyet doğrulaması başarılı! İyi yolculuklar.'),
                backgroundColor: Colors.green,
              ),
            );
            // Ana kabuğa geçiş fonksiyonunu tetikler
            widget.onLoginSuccess();
          } else {
            // Hata mesajı gösterir
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
      // Giriş ekranı üst başlığı
      appBar: AppBar(title: const Text('EasyRent Giriş')),
      // Cihazın çentik ve alt çubuk alanlarını koruyan güvenli alan
      body: SafeArea(
        // Klavye açıldığında sayfanın taşmasını önleyen dikey kaydırma alanı
        child: SingleChildScrollView(
          // Çevresel 20px iç boşluk
          padding: const EdgeInsets.all(20),
          // Doğrulama kurallarını denetleyen Form widget'ı
          child: Form(
            key: _formKey,
            child: Column(
              // Çocukları yatayda tam genişliğe yayar
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo ve karşılama başlığı
                _buildHeader(context),
                const SizedBox(height: 20),
                // Form alanları (TCKN, Ad, Doğum tarihi, Ehliyet, Telefon)
                _buildFormFields(),
                const SizedBox(height: 16),
                // SMS gönderim ve giriş onay butonu
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
        // Uygulama ikonu
        Image.asset('assets/images/app_icon.png', height: 80, width: 80),
        const SizedBox(height: 10),
        // Ekran ana başlığı
        Text(
          'Ehliyet ve Kimlik Doğrulama',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Açıklayıcı alt metin
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
        // 1. Alan: T.C. Kimlik Numarası
        AuthTextField(
          controller: _tcknController,
          label: 'TCKN / Pasaport No',
          hintText: '11 haneli TCKN giriniz',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          validator: (val) => (val == null || val.length != 11) ? 'Geçerli 11 haneli TCKN giriniz' : null,
        ),
        // 2. Alan: Ad Soyad
        AuthTextField(
          controller: _fullNameController,
          label: 'Ad Soyad',
          hintText: 'Adınızı ve soyadınızı giriniz',
          prefixIcon: Icons.person_outline,
          validator: (val) => (val == null || val.trim().isEmpty) ? 'Ad soyad zorunludur' : null,
        ),
        // 3. Alan: Doğum Tarihi
        AuthTextField(
          controller: _birthDateController,
          label: 'Doğum Tarihi',
          hintText: 'GG.AA.YYYY',
          prefixIcon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.datetime,
          validator: (val) => (val == null || val.trim().isEmpty) ? 'Doğum tarihi zorunludur' : null,
        ),
        // 4. Alan: Ehliyet Belge No
        AuthTextField(
          controller: _licenseController,
          label: 'Ehliyet Belge No',
          hintText: 'Örn: B129845',
          prefixIcon: Icons.drive_eta_outlined,
          validator: (val) => (val == null || val.trim().isEmpty) ? 'Ehliyet no zorunludur' : null,
        ),
        // 5. Alan: Telefon Numarası
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
    // Kontrolcünün yükleniyor durumunu dinler
    return ValueListenableBuilder<bool>(
      valueListenable: widget.authController.isLoading,
      builder: (context, loading, _) {
        // Yükleniyorsa dönen ilerleme göstergesi koyar
        if (loading) return const Center(child: CircularProgressIndicator());
        // Normal durumda SMS gönderim butonunu çizer
        return ElevatedButton.icon(
          onPressed: _onFormSubmit,
          icon: const Icon(Icons.sms_outlined),
          label: const Text('SMS Kodu Al ve Giriş Yap'),
        );
      },
    );
  }
}
