import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';
import '../../auth/presentation/mascot_selection_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _selectedLanguage = 'TR';
  String _selectedTheme = 'Açık Pastel';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.user;
        final mascot = AppState.instance.selectedMascot;

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          message: '${mascot.name}: Profilin burada!',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 18),
                  _buildUserInfoCard(context, user, mascot),
                  const SizedBox(height: 20),
                  _buildSettingsSection(context),
                  const SizedBox(height: 20),
                  _buildFaqSection(context),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil ve Ayarlar ⚙️',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hesap bilgilerini ve uygulama tercihlerini yönet.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(BuildContext context, Map<String, dynamic> user, CatMascot mascot) {
    final name = user['name'] ?? 'Kullanıcı';
    final surname = user['surname'] ?? '';
    final email = user['email'] ?? 'goon@example.com';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4DFD6)),
      ),
      child: Row(
        children: [
          _buildMascotAvatar(context, mascot),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name $surname',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 6),
                _buildChangeMascotButton(context, mascot.name),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotAvatar(BuildContext context, CatMascot mascot) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF9F6F0),
      ),
      child: ClipOval(
        child: Image.asset(mascot.assetPath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildChangeMascotButton(BuildContext context, String mascotName) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const MascotSelectionView(isFromRegister: false),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            'Maskot: $mascotName (Değiştir)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uygulama Tercihleri',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 10),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE4DFD6)),
          ),
          child: Column(
            children: [
              _buildDropdownTile(
                title: 'Uygulama Dili',
                icon: Icons.language,
                value: _selectedLanguage,
                items: const ['TR', 'EN'],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLanguage = val);
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildDropdownTile(
                title: 'Tema Seçimi',
                icon: Icons.palette_outlined,
                value: _selectedTheme,
                items: const ['Açık Pastel', 'Sakin Gece'],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTheme = val);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9DB2A1)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sıkça Sorulan Sorular (SSS)',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 10),
        _buildFaqItem('Streak (Seri) nasıl çalışır?',
            'Her gün en az bir alışkanlığını tamamladığında serin 1 gün artar. Gün atlanırsa seri sıfırlanır.'),
        const SizedBox(height: 8),
        _buildFaqItem('Kuponları nasıl kazanırım?',
            'Bir takvim ayını hiç gün atlamadan tamamladığında o aya özel indirim kuponun otomatik olarak açılır.'),
        const SizedBox(height: 8),
        _buildFaqItem('Kedimin pozları neden değişiyor?',
            'Seçtiğin kedi maskotu her sayfada sana özel animasyonlarla moral verir ve serilerini kutlar.'),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE4DFD6)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: const Text(
          'Çıkış Yap',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yapılsın mı?'),
        content: const Text('Oturumunu kapatmak istediğinden emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AppState.instance.logout();
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}
