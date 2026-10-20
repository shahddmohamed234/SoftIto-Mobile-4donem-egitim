// Flutter malzeme tasarımı kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Profil kontrolcüsünü içeri aktarır
import '../controllers/profile_controller.dart';
// SSS ve kural maddeleri akordiyon kartını içeri aktarır
import '../widgets/faq_rules_expansion_card.dart';
// Kullanıcı bilgileri ve ehliyet rozet kartını içeri aktarır
import '../widgets/profile_user_card.dart';
// Açık/Koyu tema değiştirici anahtarını içeri aktarır
import '../widgets/theme_switch_tile.dart';

/// ProfileScreen: Kullanıcının profil bilgilerini, kiralama sözleşme kurallarını,
/// anlık tema geçiş ayarlarını ve oturum kapatma işlemlerini sunduğu ekrandır.
class ProfileScreen extends StatefulWidget {
  // Profil kontrolcüsü örneği
  final ProfileController controller;

  // Çıkış yapıldığında oturumu kapatıp Login ekranına yönlendiren fonksiyon
  final VoidCallback onLogout;

  // ProfileScreen sabit kurucu metodu
  const ProfileScreen({
    super.key,
    // Kontrolcü zorunludur
    required this.controller,
    // Çıkış geri çağırımı zorunludur
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // Üst sınıf initState metodunu çalıştırır
    super.initState();
    // Sayfa açıldığında kullanıcı profilini ve SSS kurallarını yükler
    widget.controller.init();
  }

  /// Güvenli çıkış yapma onay diyaloğunu açar
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // Çıkış başlığı
        title: const Text('Çıkış Yap'),
        // Onay metni
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz? Tekrar giriş yapmanız gerekecektir.'),
        // Dar ekranlarda butonların alt alta geçebilmesini sağlayan dikey boşluk
        actionsOverflowButtonSpacing: 8,
        actions: [
          // İşlemden vazgeçip pencereyi kapatan buton
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          // Kırmızı renkli oturumu kapatma onay butonu
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              // Onay penceresini kapatır
              Navigator.pop(ctx);
              // Kontrolcü üzerinden oturumu sıfırlar
              await widget.controller.logout();
              // Ana kabuktaki logout callback'ini tetikler
              widget.onLogout();
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfa üst çubuğu başlığı
      appBar: AppBar(title: const Text('Profil & Ayarlar')),
      // Kontrolcünün yükleme durumunu dinleyen reaktif yapı
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, loading, _) {
          // Yükleniyorsa dönen animasyon göster
          if (loading) return const Center(child: CircularProgressIndicator());
          // Yüklendiğinde kaydırılabilir liste görünümü
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Bölüm: Kullanıcı Profil Kartı
              ValueListenableBuilder(
                valueListenable: widget.controller.user,
                builder: (context, user, _) => ProfileUserCard(user: user),
              ),
              const SizedBox(height: 12),
              // 2. Bölüm: Çift Tema Değiştirme Anahtarı
              const ThemeSwitchTile(),
              const SizedBox(height: 12),
              // 3. Bölüm: Kiralama Kuralları & Sıkça Sorulan Sorular Akordiyonu
              ValueListenableBuilder(
                valueListenable: widget.controller.faqs,
                builder: (context, faqs, _) => FaqRulesExpansionCard(faqs: faqs),
              ),
              const SizedBox(height: 16),
              // 4. Bölüm: Güvenli Çıkış Yap Butonu
              _buildLogoutButton(),
            ],
          );
        },
      ),
    );
  }

  /// Güvenli çıkış butonunu inşa eden yardımcı metot
  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      // Hata/uyarı rengi olan kırmızı arka plan ve beyaz metin
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Colors.white,
      ),
      // Tıklandığında onay diyaloğunu açar
      onPressed: _confirmLogout,
      // Çıkış ikonu
      icon: const Icon(Icons.logout),
      // Buton metni
      label: const Text('Güvenli Çıkış Yap'),
    );
  }
}
