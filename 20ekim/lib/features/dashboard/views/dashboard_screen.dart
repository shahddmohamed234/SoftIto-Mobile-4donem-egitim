import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_stats_model.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/stat_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller;
  final Function(int) onNavigateTab;

  const DashboardScreen({
    super.key,
    required this.controller,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: 8),
              _buildStatsSection(),
              const SizedBox(height: 16),
              _buildBanner(context),
              const SizedBox(height: 16),
              _buildQuickActionsHeader(context),
              const SizedBox(height: 8),
              _buildQuickActionsList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return ValueListenableBuilder<DashboardStats>(
      valueListenable: controller.stats,
      builder: (context, stats, _) {
        return Column(
          children: [
            Row(
              children: [
                StatSummaryCard(
                  title: 'İş Planı',
                  value: '${stats.totalPlans} Plan',
                  icon: Icons.assignment_turned_in,
                  color: AppColors.lightPrimary,
                ),
                const SizedBox(width: 8),
                StatSummaryCard(
                  title: 'Hukuk Desteği',
                  value: '${stats.activeLegalRequests} Aktif',
                  icon: Icons.gavel,
                  color: AppColors.lightSecondary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                StatSummaryCard(
                  title: 'Açık Fonlar',
                  value: '${stats.totalGrantsAvailable} Hibe',
                  icon: Icons.monetization_on,
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                StatSummaryCard(
                  title: 'Mentorluk',
                  value: '3 Mentor',
                  icon: Icons.people_alt,
                  color: AppColors.warning,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fikrini Başarıya Dönüştür!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'İş planını oluştur, hukuki riskleri çöz, hibe ve yatırımlarla büyü.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsHeader(BuildContext context) {
    return Text(
      'Hızlı İşlemler',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildQuickActionsList() {
    return Column(
      children: [
        QuickActionCard(
          title: 'İş Planı Oluştur & Takip Et',
          description: 'İş modelini hazırla ve onay aşamalarını izle',
          icon: Icons.description_outlined,
          onTap: () => onNavigateTab(1),
        ),
        QuickActionCard(
          title: 'Hukuki Danışmanlık Talebi',
          description: 'Sözleşme, KVKK ve şirket kuruluşu desteği al',
          icon: Icons.balance,
          onTap: () => onNavigateTab(2),
        ),
        QuickActionCard(
          title: 'Hibe ve Fon Fırsatları',
          description: 'TÜBİTAK, KOSGEB ve yatırımcı fonlarına başvur',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () => onNavigateTab(3),
        ),
        QuickActionCard(
          title: 'Mentor ile Görüşme Ayarla',
          description: 'Sektör lideri uzmanlardan birebir tavsiye al',
          icon: Icons.school_outlined,
          onTap: () => onNavigateTab(4),
        ),
      ],
    );
  }
}
