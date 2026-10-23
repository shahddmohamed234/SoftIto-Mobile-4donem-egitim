import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';
import '../../auth/presentation/login_view.dart';
import '../../auth/presentation/mascot_selection_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.user;
        final mascot = AppState.instance.selectedMascot;
        final currentLang = AppState.instance.language;
        final isDark = AppState.instance.themeMode == ThemeMode.dark;
        final currentThemeLabel = isDark
            ? (currentLang == 'EN' ? 'Calm Night (Dark)' : 'Sakin Gece (Koyu)')
            : (currentLang == 'EN' ? 'Light Pastel' : 'Açık Pastel');

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          catLottieAsset: mascot.lottieAssetPath,
          message: '${mascot.name}: ${AppStrings.tr('cat_purr')}',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 18),
                  _buildUserInfoCard(context, user, mascot),
                  const SizedBox(height: 20),
                  _buildSettingsSection(context, currentLang, currentThemeLabel, isDark),
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
          AppStrings.tr('profile_title'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.tr('profile_subtitle'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(BuildContext context, Map<String, dynamic> user, CatMascot mascot) {
    final name = user['name'] ?? 'Kullanıcı';
    final surname = user['surname'] ?? '';
    final email = user['email'] ?? 'goon@example.com';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6),
        ),
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
                  style: Theme.of(context).textTheme.bodySmall,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? const Color(0xFF2C2E38) : const Color(0xFFF9F6F0),
      ),
      child: ClipOval(
        child: Lottie.asset(
          mascot.lottieAssetPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(mascot.assetPath, fit: BoxFit.cover),
        ),
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
            '${AppStrings.tr('mascot_label')}: $mascotName (${AppStrings.tr('change_mascot')})',
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

  Widget _buildSettingsSection(
    BuildContext context,
    String currentLang,
    String currentThemeLabel,
    bool isDark,
  ) {
    final themeOptions = currentLang == 'EN'
        ? const ['Light Pastel', 'Calm Night (Dark)']
        : const ['Açık Pastel', 'Sakin Gece (Koyu)'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tr('preferences_title'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 10),
        Material(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6),
            ),
          ),
          child: Column(
            children: [
              _buildDropdownTile(
                title: AppStrings.tr('app_language'),
                icon: Icons.language,
                value: currentLang,
                items: const ['TR', 'EN'],
                onChanged: (val) {
                  if (val != null) {
                    AppState.instance.setLanguage(val);
                  }
                },
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6),
              ),
              _buildDropdownTile(
                title: AppStrings.tr('theme_selection'),
                icon: Icons.palette_outlined,
                value: themeOptions.contains(currentThemeLabel) ? currentThemeLabel : themeOptions.first,
                items: themeOptions,
                onChanged: (val) {
                  if (val != null) {
                    AppState.instance.setTheme(val);
                  }
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
          AppStrings.tr('faq_title'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 10),
        _buildFaqItem(context, AppStrings.tr('faq_q1'), AppStrings.tr('faq_a1')),
        const SizedBox(height: 8),
        _buildFaqItem(context, AppStrings.tr('faq_q2'), AppStrings.tr('faq_a2')),
        const SizedBox(height: 8),
        _buildFaqItem(context, AppStrings.tr('faq_q3'), AppStrings.tr('faq_a3')),
      ],
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6),
        ),
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
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
        label: Text(
          AppStrings.tr('logout_btn'),
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
        title: Text(AppStrings.tr('logout_dialog_title')),
        content: Text(AppStrings.tr('logout_dialog_content')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStrings.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AppState.instance.logout();
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              }
            },
            child: Text(AppStrings.tr('confirm_logout')),
          ),
        ],
      ),
    );
  }
}
