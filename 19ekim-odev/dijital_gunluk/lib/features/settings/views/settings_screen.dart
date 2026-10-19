import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../widgets/about_card.dart';
import '../widgets/theme_switch_card.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController controller;

  const SettingsScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ThemeSwitchCard(controller: controller),
          const SizedBox(height: 8),
          const AboutCard(),
        ],
      ),
    );
  }
}
