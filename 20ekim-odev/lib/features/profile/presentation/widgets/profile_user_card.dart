import 'package:flutter/material.dart';
import 'package:easy_rent/features/auth/data/models/user_model.dart';

/// ProfileUserCard: Giriş yapmış kullanıcının profil bilgilerini,
/// onaylı sürücü rozetini ve ehliyet detaylarını gösteren karttır.
class ProfileUserCard extends StatelessWidget {
  final UserModel? user;

  const ProfileUserCard({super.key, required this.user});

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              user?.fullName ?? 'Misafir Kullanıcı',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            _buildVerifiedBadge(context),
            const Divider(height: 24),
            _infoRow(context, Icons.badge_outlined, 'TCKN', user?.tckn ?? '-'),
            _infoRow(context, Icons.drive_eta_outlined, 'Ehliyet No', user?.licenseNumber ?? '-'),
            _infoRow(context, Icons.calendar_today_outlined, 'Doğum Tarihi', user?.birthDate ?? '-'),
            _infoRow(context, Icons.phone_android_outlined, 'Telefon', user?.phoneNumber ?? '-'),
          ],
        ),
      ),
    );
  }

  /// Onaylı sürücü rozeti
  Widget _buildVerifiedBadge(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          'Onaylı Sürücü Profili',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Bilgi satırı yardımcısı
  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
