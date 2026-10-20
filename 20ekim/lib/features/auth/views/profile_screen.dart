import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../models/user_profile_model.dart';
import '../widgets/user_profile_card.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController controller;

  const ProfileScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<UserProfile>(
        valueListenable: controller.currentUser,
        builder: (context, profile, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                UserProfileCard(profile: profile),
                const SizedBox(height: 16),
                _buildSettingsList(context, profile),
                const SizedBox(height: 16),
                _buildLogoutButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, UserProfile profile) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.business_center_outlined),
            title: const Text('Şirket Bilgilerini Görüntüle'),
            subtitle: Text(profile.startupName),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => _showCompanyInfoCard(context, profile),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Güvenlik ve İki Adımlı Doğrulama'),
            subtitle: const Text('SMS Doğrulaması Aktif'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => _showSecurityCard(context, profile),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Bildirim ve SMS Tercihleri'),
            subtitle: const Text('Tüm kanallar açık'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => _showNotificationPreferences(context, profile),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Destek ve Yardım Merkezi'),
            subtitle: const Text('7/24 Girişimci Danışma'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => _showSupportCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => controller.logout(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightSecondary,
          side: const BorderSide(color: AppColors.lightSecondary),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        icon: const Icon(Icons.logout),
        label: const Text('Oturumu Kapat / Rol Değiştir'),
      ),
    );
  }

  void _showCompanyInfoCard(BuildContext context, UserProfile profile) {
    _showModalInfoCard(
      context,
      title: 'Şirket ve Girişim Detayları',
      icon: Icons.business,
      content: [
        _buildInfoRow('Kuruluş / Girişim:', profile.startupName),
        _buildInfoRow('Hesap Tipi:', profile.accountType),
        _buildInfoRow('Unvan / Rol:', profile.role),
        _buildInfoRow('Kayıtlı E-posta:', profile.email),
        _buildInfoRow('İletişim Numarası:', profile.phone),
        _buildInfoRow('Durum:', profile.isVerified ? 'Resmi Onaylı' : 'Doğrulama Bekliyor'),
      ],
    );
  }

  void _showSecurityCard(BuildContext context, UserProfile profile) {
    _showModalInfoCard(
      context,
      title: 'Güvenlik ve Doğrulama Kartı',
      icon: Icons.shield,
      content: [
        _buildInfoRow('İki Adımlı SMS Doğrulama:', 'AKTİF (${profile.phone})'),
        _buildInfoRow('Biyometrik Giriş (FaceID):', 'Açık'),
        _buildInfoRow('Şifre Güvenlik Seviyesi:', 'Yüksek (Son güncelleme 14 gün önce)'),
        _buildInfoRow('Oturum Konumu:', 'İstanbul, Türkiye (iOS Simulator)'),
      ],
    );
  }

  void _showNotificationPreferences(BuildContext context, UserProfile profile) {
    _showModalInfoCard(
      context,
      title: 'Bildirim & İletişim Tercihleri',
      icon: Icons.notifications_active,
      content: [
        _buildInfoRow('SMS ile Randevu Hatırlatıcı:', 'Açık (Her seans öncesi)'),
        _buildInfoRow('Fon ve Hibe Sonuçları:', 'Anlık SMS & E-posta'),
        _buildInfoRow('Hukuki Destek Güncellemeleri:', 'Aktif'),
        _buildInfoRow('Yatırımcı Bülteni:', 'Haftalık Özet'),
      ],
    );
  }

  void _showSupportCard(BuildContext context) {
    _showModalInfoCard(
      context,
      title: 'Destek ve Yardım Merkezi',
      icon: Icons.headset_mic,
      content: [
        _buildInfoRow('Danışma Hattı:', '+90 (212) 555 00 00'),
        _buildInfoRow('Destek E-postası:', 'destek@future-entrepreneur.com'),
        _buildInfoRow('Çalışma Saatleri:', 'Hafta içi 09:00 - 18:00 (7/24 Acil Talep)'),
        _buildInfoRow('Mevcut Talep Durumu:', 'Aktif bekleyen açık çağrı yok'),
      ],
    );
  }

  void _showModalInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> content,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(ctx).colorScheme.primary.withAlpha(25),
                  child: Icon(icon, color: Theme.of(ctx).colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...content,
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Kapat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
