import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../widgets/faq_rules_expansion_card.dart';
import '../widgets/profile_user_card.dart';
import '../widgets/theme_switch_tile.dart';

/// ProfileScreen: Kullanıcının profil bilgilerini, kiralama sözleşme kurallarını,
/// anlık tema geçiş ayarlarını ve oturum kapatma işlemlerini sunduğu ekrandır.
class ProfileScreen extends StatefulWidget {
  final ProfileController controller;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.controller,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Kullanıcı profil ve SSS kurallarını yükle
    widget.controller.init();
  }

  /// Güvenli çıkış yapma onay diyaloğu
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz? Tekrar giriş yapmanız gerekecektir.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.controller.logout();
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
      appBar: AppBar(title: const Text('Profil & Ayarlar')),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, loading, _) {
          if (loading) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ValueListenableBuilder(
                valueListenable: widget.controller.user,
                builder: (context, user, _) => ProfileUserCard(user: user),
              ),
              const SizedBox(height: 12),
              const ThemeSwitchTile(),
              const SizedBox(height: 12),
              ValueListenableBuilder(
                valueListenable: widget.controller.faqs,
                builder: (context, faqs, _) => FaqRulesExpansionCard(faqs: faqs),
              ),
              const SizedBox(height: 16),
              _buildLogoutButton(),
            ],
          );
        },
      ),
    );
  }

  /// Güvenli çıkış butonu
  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Colors.white,
      ),
      onPressed: _confirmLogout,
      icon: const Icon(Icons.logout),
      label: const Text('Güvenli Çıkış Yap'),
    );
  }
}
