import 'package:flutter/material.dart';

// ============================================================================
// SUSADIM FITNESS UYGULAMASI - ÖRNEK EKRAN UYGULAMASI (SAMPLE SCREEN)
// Standartlar: project.md ve SKILL.md kurallarına tam uyumludur.
// - State: ValueNotifier ve ValueListenableBuilder (0 ağır paket, 0 dev setState)
// - Build Metodu: 40 satır altı kuralına uygun, modüler atomik widget yapısı
// - Tema: Material 3, Çift Tema Uyumlu (Dark Obsidian / Arctic White)
// - Performans: Statik widget'larda zorunlu const kullanımı
// ============================================================================

// ----------------------------------------------------------------------------
// 1. IMMUTABLE MODEL KATMANI
// ----------------------------------------------------------------------------

/// Aktivite / Egzersiz Veri Modeli
@immutable
class SampleActivity {
  final String id;
  final String name;
  final int burnedCalories;
  final int bonusWaterMl;
  final DateTime timestamp;

  const SampleActivity({
    required this.id,
    required this.name,
    required this.burnedCalories,
    required this.bonusWaterMl,
    required this.timestamp,
  });

  SampleActivity copyWith({
    String? id,
    String? name,
    int? burnedCalories,
    int? bonusWaterMl,
    DateTime? timestamp,
  }) {
    return SampleActivity(
      id: id ?? this.id,
      name: name ?? this.name,
      burnedCalories: burnedCalories ?? this.burnedCalories,
      bonusWaterMl: bonusWaterMl ?? this.bonusWaterMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'burnedCalories': burnedCalories,
      'bonusWaterMl': bonusWaterMl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SampleActivity.fromJson(Map<String, dynamic> json) {
    return SampleActivity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      burnedCalories: json['burnedCalories'] as int? ?? 0,
      bonusWaterMl: json['bonusWaterMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Ekranın Genel Reaktif Durumu
@immutable
class SampleFitnessState {
  final int targetCalories;
  final int baseWaterGoalMl;
  final int consumedWaterMl;
  final List<SampleActivity> activities;

  const SampleFitnessState({
    this.targetCalories = 500,
    this.baseWaterGoalMl = 2000,
    this.consumedWaterMl = 0,
    this.activities = const [],
  });

  /// Egzersizlerden gelen toplam yakılan kalori
  int get totalBurnedCalories {
    return activities.fold(0, (sum, item) => sum + item.burnedCalories);
  }

  /// Egzersiz kaynaklı ek su ihtiyacı (Her 100 kalori için ~150 ml su bonusu)
  int get workoutBonusWaterMl {
    return activities.fold(0, (sum, item) => sum + item.bonusWaterMl);
  }

  /// Güncel toplam su hedefi
  int get dynamicWaterTargetMl => baseWaterGoalMl + workoutBonusWaterMl;

  /// Kalori tamamlanma oranı (0.0 - 1.0)
  double get calorieProgress {
    if (targetCalories <= 0) return 0.0;
    return (totalBurnedCalories / targetCalories).clamp(0.0, 1.0);
  }

  /// Su tamamlanma oranı (0.0 - 1.0)
  double get waterProgress {
    if (dynamicWaterTargetMl <= 0) return 0.0;
    return (consumedWaterMl / dynamicWaterTargetMl).clamp(0.0, 1.0);
  }

  SampleFitnessState copyWith({
    int? targetCalories,
    int? baseWaterGoalMl,
    int? consumedWaterMl,
    List<SampleActivity>? activities,
  }) {
    return SampleFitnessState(
      targetCalories: targetCalories ?? this.targetCalories,
      baseWaterGoalMl: baseWaterGoalMl ?? this.baseWaterGoalMl,
      consumedWaterMl: consumedWaterMl ?? this.consumedWaterMl,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetCalories': targetCalories,
      'baseWaterGoalMl': baseWaterGoalMl,
      'consumedWaterMl': consumedWaterMl,
      'activities': activities.map((e) => e.toJson()).toList(),
    };
  }

  factory SampleFitnessState.fromJson(Map<String, dynamic> json) {
    final rawList = json['activities'] as List<dynamic>? ?? [];
    return SampleFitnessState(
      targetCalories: json['targetCalories'] as int? ?? 500,
      baseWaterGoalMl: json['baseWaterGoalMl'] as int? ?? 2000,
      consumedWaterMl: json['consumedWaterMl'] as int? ?? 0,
      activities: rawList
          .map((e) => SampleActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ----------------------------------------------------------------------------
// 2. REAKTİF CONTROLLER KATMANI
// ----------------------------------------------------------------------------

class SampleFitnessController {
  final ValueNotifier<SampleFitnessState> state = ValueNotifier<SampleFitnessState>(
    const SampleFitnessState(),
  );

  /// Su tüketimi ekle
  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    final current = state.value;
    state.value = current.copyWith(
      consumedWaterMl: current.consumedWaterMl + amountMl,
    );
  }

  /// Yeni egzersiz kaydı ekle
  void addActivity({
    required String name,
    required int calories,
  }) {
    if (calories <= 0 || name.trim().isEmpty) return;

    final bonusWater = (calories * 1.5).round(); // 1 kalori = 1.5 ml su bonusu
    final newActivity = SampleActivity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      burnedCalories: calories,
      bonusWaterMl: bonusWater,
      timestamp: DateTime.now(),
    );

    final current = state.value;
    state.value = current.copyWith(
      activities: [newActivity, ...current.activities],
    );
  }

  /// Egzersiz kaydını sil
  void removeActivity(String id) {
    final current = state.value;
    final updatedList = current.activities.where((a) => a.id != id).toList();
    state.value = current.copyWith(activities: updatedList);
  }

  /// Sıfırla
  void resetAll() {
    final current = state.value;
    state.value = current.copyWith(
      consumedWaterMl: 0,
      activities: const [],
    );
  }

  /// Bellek sızıntısını önleme (Zorunlu)
  void dispose() {
    state.dispose();
  }
}

// ----------------------------------------------------------------------------
// 3. VIEW KATMANI (SCREEN)
// ----------------------------------------------------------------------------

/// Standartlara uygun ana sayfa
/// Kural: Sayfa düzeyinde setState YOKTUR. Sadece Controller yaşam döngüsü yönetilir.
/// Kural: build metodu 40 satırın altındadır.
class SampleFitnessScreen extends StatefulWidget {
  const SampleFitnessScreen({super.key});

  @override
  State<SampleFitnessScreen> createState() => _SampleFitnessScreenState();
}

class _SampleFitnessScreenState extends State<SampleFitnessScreen> {
  late final SampleFitnessController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SampleFitnessController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SampleHeaderWidget(onReset: _controller.resetAll),
              const SizedBox(height: 16),
              _buildReactiveProgressCard(),
              const SizedBox(height: 16),
              _SampleQuickActionButtons(
                onAddWater: _controller.addWater,
                onAddWorkout: () => _openAddWorkoutDialog(context),
              ),
              const SizedBox(height: 16),
              _buildReactiveActivityList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactiveProgressCard() {
    return ValueListenableBuilder<SampleFitnessState>(
      valueListenable: _controller.state,
      builder: (context, state, _) {
        return _SampleProgressCard(state: state);
      },
    );
  }

  Widget _buildReactiveActivityList() {
    return ValueListenableBuilder<SampleFitnessState>(
      valueListenable: _controller.state,
      builder: (context, state, _) {
        return _SampleActivityHistoryCard(
          activities: state.activities,
          onDelete: _controller.removeActivity,
        );
      },
    );
  }

  Future<void> _openAddWorkoutDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final calController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Antrenman Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Antrenman Adı'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: calController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Yakılan Kalori (kcal)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result == true) {
      final cal = int.tryParse(calController.text) ?? 0;
      if (cal > 0 && nameController.text.isNotEmpty) {
        _controller.addActivity(
          name: nameController.text,
          calories: cal,
        );
      }
    }
    nameController.dispose();
    calController.dispose();
  }
}

// ----------------------------------------------------------------------------
// 4. ATOMİK ÖZEL WIDGET'LAR (WIDGETS KATMANI)
// ----------------------------------------------------------------------------

/// Üst Başlık ve Sıfırlama Butonu
class _SampleHeaderWidget extends StatelessWidget {
  final VoidCallback onReset;

  const _SampleHeaderWidget({required this.onReset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Susadım Fit Tracker',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Günlük Kalori ve Su Dengesi',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        IconButton(
          tooltip: 'Verileri Sıfırla',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onReset,
        ),
      ],
    );
  }
}

/// İlerleme Kartı (Çift Metrik: Kalori + Su)
class _SampleProgressCard extends StatelessWidget {
  final SampleFitnessState state;

  const _SampleProgressCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161A23) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3245) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricRing(
                title: 'Su Tüketimi',
                valueText: '${state.consumedWaterMl} ml',
                subText: 'Hedef: ${state.dynamicWaterTargetMl} ml',
                progress: state.waterProgress,
                activeColor: const Color(0xFF00F0FF),
                trackColor: isDark ? const Color(0xFF1E2330) : const Color(0xFFE2E8F0),
                theme: theme,
              ),
              _buildMetricRing(
                title: 'Yakılan Kalori',
                valueText: '${state.totalBurnedCalories} kcal',
                subText: 'Hedef: ${state.targetCalories} kcal',
                progress: state.calorieProgress,
                activeColor: const Color(0xFFFF6D00),
                trackColor: isDark ? const Color(0xFF1E2330) : const Color(0xFFE2E8F0),
                theme: theme,
              ),
            ],
          ),
          if (state.workoutBonusWaterMl > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF00F0FF)),
                  const SizedBox(width: 6),
                  Text(
                    'Antrenman Bonusu: +${state.workoutBonusWaterMl} ml su eklendi',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark ? const Color(0xFF00F0FF) : const Color(0xFF0284C7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricRing({
    required String title,
    required String valueText,
    required String subText,
    required double progress,
    required Color activeColor,
    required Color trackColor,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: trackColor,
                valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              '%${(progress * 100).toInt()}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(title, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        Text(valueText, style: theme.textTheme.titleSmall?.copyWith(color: activeColor)),
        Text(subText, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

/// Hızlı Aksiyon Butonları Barı
class _SampleQuickActionButtons extends StatelessWidget {
  final ValueChanged<int> onAddWater;
  final VoidCallback onAddWorkout;

  const _SampleQuickActionButtons({
    required this.onAddWater,
    required this.onAddWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () => onAddWater(250),
            icon: const Icon(Icons.local_drink_rounded),
            label: const Text('+250 ml Su'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: onAddWorkout,
            icon: const Icon(Icons.fitness_center_rounded),
            label: const Text('+ Antrenman'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF6D00),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

/// Aktivite Geçmişi Kartı
class _SampleActivityHistoryCard extends StatelessWidget {
  final List<SampleActivity> activities;
  final ValueChanged<String> onDelete;

  const _SampleActivityHistoryCard({
    required this.activities,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161A23) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A3245) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          'Bugün henüz antrenman kaydedilmedi.\nYukarıdaki butondan ilk antrenmanınızı ekleyin!',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161A23) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3245) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Günlük Aktiviteler',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = activities[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6D00).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.directions_run_rounded,
                      color: Color(0xFFFF6D00),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${item.burnedCalories} kcal • +${item.bonusWaterMl} ml su bonusu',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => onDelete(item.id),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
