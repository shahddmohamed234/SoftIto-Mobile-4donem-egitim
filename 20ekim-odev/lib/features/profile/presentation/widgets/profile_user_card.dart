// Flutter malzeme tasarım sınıflarını içeri aktarır
import 'package:flutter/material.dart';
// Kullanıcı veri modelini içeri aktarır
import 'package:easy_rent/features/auth/data/models/user_model.dart';

/// ProfileUserCard: Giriş yapmış kullanıcının profil bilgilerini,
/// onaylı sürücü rozetini ve ehliyet detaylarını gösteren kart bileşenidir.
class ProfileUserCard extends StatelessWidget {
  // Görüntülenecek kullanıcı modeli (Giriş yapılmamışsa null olabilir)
  final UserModel? user;

  // ProfileUserCard sabit kurucu metodu
  const ProfileUserCard({super.key, required this.user});

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    // Profil bilgilerini çevreleyen Card bileşeni
    return Card(
      child: Padding(
        // Kartın tüm kenarlarına 16px iç boşluk verir
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kullanıcı profil avatar dairesi
            CircleAvatar(
              radius: 36,
              // Tema renginin şeffaf tonuyla yumuşak arka plan
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              // Profil kişi ikonu
              child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 12),
            // Kullanıcının adı ve soyadı
            Text(
              user?.fullName ?? 'Misafir Kullanıcı',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            // Onaylı sürücü rozeti
            _buildVerifiedBadge(context),
            // Ayraç çizgisi
            const Divider(height: 24),
            // TCKN bilgi satırı
            _infoRow(context, Icons.badge_outlined, 'TCKN', user?.tckn ?? '-'),
            // Ehliyet No bilgi satırı
            _infoRow(context, Icons.drive_eta_outlined, 'Ehliyet No', user?.licenseNumber ?? '-'),
            // Doğum Tarihi bilgi satırı
            _infoRow(context, Icons.calendar_today_outlined, 'Doğum Tarihi', user?.birthDate ?? '-'),
            // Telefon Numarası bilgi satırı
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
        // Mavi/kırmızı tema renginde onay ikonu
        Icon(Icons.verified, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        // Onaylı profil rozet metni
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

  /// Bilgi satırı yardımcısı (İkon, etiket ve sağa dayalı taşmayan değer)
  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      // Satırlar arası dikey 4px boşluk
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Sol başlık ikonu
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          // Alan etiketi
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 8),
          // Değer metni (Taşmayı önlemek için Expanded ve ellipsis ile sarılı)
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
