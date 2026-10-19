#!/usr/bin/env bash
# ==============================================================================
# Feature Scaffold Generator Script for Susadım Flutter Project
# Standartlar: project.md ve SKILL.md kurallarına %100 uyumludur.
# Mimari: Feature-Based (Controllers, Models, Views, Widgets)
# State: ValueNotifier + ValueListenableBuilder (0 Ağır Paket, 0 Dev setState)
# UI: Material 3, Çift Tema Uyumlu, 40 Satır Altı Build Metotları, const Zorunlu
# ==============================================================================

set -euo pipefail

# Renkler
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Yardım Mesajı
show_help() {
  echo -e "${BLUE}Kullanım:${NC}"
  echo "  $0 <ozellik_adi> [hedef_dizin]"
  echo ""
  echo -e "${BLUE}Örnekler:${NC}"
  echo "  $0 calorie_tracker"
  echo "  $0 step_counter ./lib/features"
  echo ""
  echo -e "${YELLOW}Not: Özellik adı snake_case (örn: sleep_tracker, calorie_counter) formatında olmalıdır.${NC}"
  exit 0
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  show_help
fi

FEATURE_NAME="$1"
BASE_DIR="${2:-lib/features}"

# snake_case kontrolü ve düzeltme (tireleri alt çizgiye çevir)
FEATURE_NAME="$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')"

# PascalCase ve camelCase dönüşümleri
to_pascal_case() {
  echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1)) substr($i,2); print ""}'
}

to_camel_case() {
  local pascal
  pascal=$(to_pascal_case "$1")
  echo "$(tr '[:upper:]' '[:lower:]' <<< "${pascal:0:1}")${pascal:1}"
}

PASCAL_NAME=$(to_pascal_case "$FEATURE_NAME")
CAMEL_NAME=$(to_camel_case "$FEATURE_NAME")
TARGET_DIR="${BASE_DIR}/${FEATURE_NAME}"

echo -e "${BLUE}==> [Scaffold] '${FEATURE_NAME}' özelliği oluşturuluyor...${NC}"
echo -e "    Hedef Dizin : ${TARGET_DIR}"
echo -e "    Pascal Case : ${PASCAL_NAME}"

# Klasörleri oluştur
mkdir -p "${TARGET_DIR}/controllers"
mkdir -p "${TARGET_DIR}/models"
mkdir -p "${TARGET_DIR}/views"
mkdir -p "${TARGET_DIR}/widgets"

# ------------------------------------------------------------------------------
# 1. MODEL DOSYASI (models/<feature_name>_model.dart)
# ------------------------------------------------------------------------------
MODEL_FILE="${TARGET_DIR}/models/${FEATURE_NAME}_model.dart"
cat <<EOF > "$MODEL_FILE"
/// ${PASCAL_NAME} için Immutable Veri Modeli
/// Standartlar: const constructor, copyWith, toJson, fromJson
class ${PASCAL_NAME}Item {
  final String id;
  final String title;
  final int value;
  final DateTime createdAt;

  const ${PASCAL_NAME}Item({
    required this.id,
    required this.title,
    required this.value,
    required this.createdAt,
  });

  ${PASCAL_NAME}Item copyWith({
    String? id,
    String? title,
    int? value,
    DateTime? createdAt,
  }) {
    return ${PASCAL_NAME}Item(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ${PASCAL_NAME}Item.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Item(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ${PASCAL_NAME}State {
  final int totalGoal;
  final int currentProgress;
  final List<${PASCAL_NAME}Item> items;

  const ${PASCAL_NAME}State({
    this.totalGoal = 100,
    this.currentProgress = 0,
    this.items = const [],
  });

  double get progressRatio {
    if (totalGoal <= 0) return 0.0;
    return (currentProgress / totalGoal).clamp(0.0, 1.0);
  }

  ${PASCAL_NAME}State copyWith({
    int? totalGoal,
    int? currentProgress,
    List<${PASCAL_NAME}Item>? items,
  }) {
    return ${PASCAL_NAME}State(
      totalGoal: totalGoal ?? this.totalGoal,
      currentProgress: currentProgress ?? this.currentProgress,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGoal': totalGoal,
      'currentProgress': currentProgress,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  factory ${PASCAL_NAME}State.fromJson(Map<String, dynamic> json) {
    final rawList = json['items'] as List<dynamic>? ?? [];
    return ${PASCAL_NAME}State(
      totalGoal: json['totalGoal'] as int? ?? 100,
      currentProgress: json['currentProgress'] as int? ?? 0,
      items: rawList
          .map((e) => ${PASCAL_NAME}Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
EOF
echo -e "    ${GREEN}✓${NC} Model oluşturuldu       : ${MODEL_FILE}"

# ------------------------------------------------------------------------------
# 2. CONTROLLER DOSYASI (controllers/<feature_name>_controller.dart)
# ------------------------------------------------------------------------------
CONTROLLER_FILE="${TARGET_DIR}/controllers/${FEATURE_NAME}_controller.dart"
cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// ${PASCAL_NAME} reaktif durum kontrolcüsü
/// Standartlar: ValueNotifier mimarisi, izole mutasyon, dispose() zorunluluğu
class ${PASCAL_NAME}Controller {
  final ValueNotifier<${PASCAL_NAME}State> state = ValueNotifier<${PASCAL_NAME}State>(
    const ${PASCAL_NAME}State(),
  );

  void addItem({required String title, required int value}) {
    if (value <= 0 || title.trim().isEmpty) return;

    final newItem = ${PASCAL_NAME}Item(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      value: value,
      createdAt: DateTime.now(),
    );

    final current = state.value;
    state.value = current.copyWith(
      currentProgress: current.currentProgress + value,
      items: [newItem, ...current.items],
    );
  }

  void removeItem(String id) {
    final current = state.value;
    final item = current.items.firstWhere(
      (e) => e.id == id,
      orElse: () => ${PASCAL_NAME}Item(
        id: '',
        title: '',
        value: 0,
        createdAt: DateTime.now(),
      ),
    );

    if (item.id.isEmpty) return;

    final updatedItems = current.items.where((e) => e.id != id).toList();
    final updatedProgress = (current.currentProgress - item.value).clamp(0, 999999);

    state.value = current.copyWith(
      currentProgress: updatedProgress,
      items: updatedItems,
    );
  }

  void reset() {
    final current = state.value;
    state.value = current.copyWith(
      currentProgress: 0,
      items: [],
    );
  }

  void dispose() {
    state.dispose();
  }
}
EOF
echo -e "    ${GREEN}✓${NC} Controller oluşturuldu  : ${CONTROLLER_FILE}"

# ------------------------------------------------------------------------------
# 3. WIDGET DOSYASI (widgets/<feature_name>_card.dart)
# ------------------------------------------------------------------------------
WIDGET_FILE="${TARGET_DIR}/widgets/${FEATURE_NAME}_card.dart"
cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// Modüler, yeniden kullanılabilir ve tema duyarlı kart bileşeni
/// Standartlar: const constructor, Theme.of(context) entegrasyonu, 40 satır altı build
class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}State state;
  final VoidCallback onAddPressed;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.state,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3245) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 12),
          _buildProgressIndicator(theme),
          const SizedBox(height: 12),
          _buildActionButton(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${PASCAL_NAME} Durumu',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\${state.currentProgress} / \${state.totalGoal}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: state.progressRatio,
        minHeight: 10,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    return OutlinedButton.icon(
      onPressed: onAddPressed,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Yeni Kayıt Ekle'),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
EOF
echo -e "    ${GREEN}✓${NC} Widget oluşturuldu      : ${WIDGET_FILE}"

# ------------------------------------------------------------------------------
# 4. VIEW DOSYASI (views/<feature_name>_screen.dart)
# ------------------------------------------------------------------------------
VIEW_FILE="${TARGET_DIR}/views/${FEATURE_NAME}_screen.dart"
cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widgets/${FEATURE_NAME}_card.dart';

/// ${PASCAL_NAME} Ekranı
/// Standartlar: ValueListenableBuilder ile izole rebuild, 40 satır altı build, const zorunluluğu
class ${PASCAL_NAME}Screen extends StatefulWidget {
  const ${PASCAL_NAME}Screen({super.key});

  @override
  State<${PASCAL_NAME}Screen> createState() => _${PASCAL_NAME}ScreenState();
}

class _${PASCAL_NAME}ScreenState extends State<${PASCAL_NAME}Screen> {
  late final ${PASCAL_NAME}Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = ${PASCAL_NAME}Controller();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL_NAME}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReactiveProgressCard(),
              const SizedBox(height: 16),
              _buildReactiveHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactiveProgressCard() {
    return ValueListenableBuilder<${PASCAL_NAME}State>(
      valueListenable: _controller.state,
      builder: (context, state, _) {
        return ${PASCAL_NAME}Card(
          state: state,
          onAddPressed: () {
            _controller.addItem(title: 'Aktivite', value: 10);
          },
        );
      },
    );
  }

  Widget _buildReactiveHistoryList() {
    return ValueListenableBuilder<${PASCAL_NAME}State>(
      valueListenable: _controller.state,
      builder: (context, state, _) {
        if (state.items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Henüz kayıt bulunmuyor.'),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = state.items[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.createdAt.toString().split('.')[0]),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => _controller.removeItem(item.id),
              ),
            );
          },
        );
      },
    );
  }
}
EOF
echo -e "    ${GREEN}✓${NC} View oluşturuldu        : ${VIEW_FILE}"

echo -e "\n${GREEN}==> Başarılı! '${FEATURE_NAME}' iskeleti eksiksiz üretildi.${NC}"
echo -e "${YELLOW}Şimdi kodu kontrol etmek için: flutter analyze${NC}\n"
