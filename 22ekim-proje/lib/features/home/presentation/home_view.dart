import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';
import '../../../core/utils/translation_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedEmoji = '✨';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final lang = AppState.instance.language;

    if (lang == 'EN') {
      const weekdays = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${weekdays[now.weekday]}, ${now.day} ${months[now.month]}';
    } else {
      const weekdays = ['', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
      const months = ['', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
      return '${now.day} ${months[now.month]} ${weekdays[now.weekday]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final mascot = AppState.instance.selectedMascot;
        final habits = AppState.instance.habits;
        final currentStreak = AppState.instance.currentStreak;

        return BaseLayoutWithCat(
          catAsset: mascot.assetPath,
          catLottieAsset: mascot.lottieAssetPath,
          message: '${mascot.name}: ${AppStrings.tr('cat_great_job')}',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, currentStreak),
                  const SizedBox(height: 18),
                  _buildAddHabitCard(context),
                  const SizedBox(height: 22),
                  _buildHabitsSection(context, habits),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, int streak) {
    final dateStr = _getFormattedDate();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Badge (Tarih Gösterimi)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(isDark ? 40 : 25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                AppStrings.tr('home_title'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.tr('home_subtitle'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildStreakHeartBadge(context, streak),
      ],
    );
  }

  Widget _buildStreakHeartBadge(BuildContext context, int streak) {
    final heartColor = Theme.of(context).colorScheme.tertiary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: heartColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: heartColor.withAlpha(isDark ? 40 : 30),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: heartColor, size: 22),
          const SizedBox(width: 6),
          Text(
            '$streak ${AppStrings.tr('streak_day')}',
            style: TextStyle(
              color: heartColor,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddHabitCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF373A47)
              : const Color(0xFFE4DFD6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.tr('add_habit_title'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              // Preset suggestions modal trigger
              TextButton.icon(
                onPressed: () => _openPresetSuggestionsModal(context),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(
                  AppStrings.tr('browse_presets_btn'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: AppStrings.tr('habit_title_label'),
              hintText: AppStrings.tr('habit_title_hint'),
              prefixIcon: const Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: AppStrings.tr('habit_desc_label'),
              hintText: AppStrings.tr('habit_desc_hint'),
              prefixIcon: const Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 12),
          _buildEmojiPicker(),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveCustomHabit,
              icon: const Icon(Icons.add_task),
              label: Text(AppStrings.tr('save_habit_btn')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    final defaultEmojis = ['✨', '🏃‍♂️', '🚶‍♀️', '📚', '✍️', '🎨', '🧶', '🧘', '💧', '🌅', '🎸', '🥗', '💻'];
    final displayEmojis = [
      if (!defaultEmojis.contains(_selectedEmoji)) _selectedEmoji,
      ...defaultEmojis,
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayEmojis.map((emoji) {
            final isSelected = _selectedEmoji == emoji;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedEmoji = emoji;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withAlpha(isDark ? 80 : 50)
                      : (isDark ? const Color(0xFF2C2E38) : const Color(0xFFF1EDE6)),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 18)),
              ),
            );
          }),
          // More Emojis / Custom Emoji button
          GestureDetector(
            onTap: () => _openCustomEmojiSelectorModal(context),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2E38) : const Color(0xFFF1EDE6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: !defaultEmojis.contains(_selectedEmoji)
                      ? Theme.of(context).colorScheme.primary
                      : (isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6)),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_reaction_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppStrings.tr('more_emojis_btn'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCustomEmojiSelectorModal(BuildContext context) {
    final customEmojiController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final emojiCategories = {
      AppStrings.tr('emoji_cat_sports'): [
        '⚽', '🏀', '🎾', '🏊', '🚴', '🏋️', '🧗', '🧘', '🛹', '🥊',
        '🥋', '🏸', '🏹', '⛷️', '⛳', '🏄', '🚣', '🤸', '🏐', '⛸️'
      ],
      AppStrings.tr('emoji_cat_mind'): [
        '📖', '✍️', '💻', '🧠', '🔬', '🔭', '📝', '🎓', '💡', '📐',
        '💼', '📈', '🗂️', '🔍', '📱', '⏰', '📅', '🎯', '⚙️', '📊'
      ],
      AppStrings.tr('emoji_cat_health'): [
        '💧', '🥗', '🍎', '🥑', '🍵', '🛌', '☀️', '💊', '🦷', '🧘‍♀️',
        '🚿', '🚶', '🍏', '🍌', '🥕', '🍉', '🥥', '🥦', '🥛', '☕'
      ],
      AppStrings.tr('emoji_cat_art'): [
        '🎸', '🎹', '🎨', '🧶', '📷', '🎮', '🎤', '🎬', '🪴', '🧩',
        '🎧', '🎻', '🧵', '🎲', '🖌️', '🎺', '🥁', '🎭', '🪡', '📻'
      ],
      AppStrings.tr('emoji_cat_soul'): [
        '✨', '💖', '🕊️', '🌅', '🕯️', '🪄', '🌟', '🍀', '🌻', '🌈',
        '🧸', '🌙', '🐱', '🐶', '🌿', '🌷', '🦋', '🎈', '❤️', '🔥'
      ],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tr('choose_emoji_title'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.tr('choose_emoji_subtitle'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      // Custom emoji text input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: customEmojiController,
                              decoration: InputDecoration(
                                hintText: AppStrings.tr('custom_emoji_hint'),
                                prefixIcon: const Icon(Icons.keyboard_outlined, size: 20),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onPressed: () {
                              final text = customEmojiController.text.trim();
                              if (text.isNotEmpty) {
                                final firstRune = text.characters.first;
                                setState(() {
                                  _selectedEmoji = firstRune;
                                });
                                Navigator.of(ctx).pop();
                              }
                            },
                            child: Text(AppStrings.tr('select_emoji_btn')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: emojiCategories.entries.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.key,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: cat.value.map((emoji) {
                                final isSel = _selectedEmoji == emoji;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedEmoji = emoji;
                                    });
                                    Navigator.of(ctx).pop();
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? Theme.of(context).colorScheme.primary.withAlpha(isDark ? 80 : 50)
                                          : (isDark ? const Color(0xFF2C2E38) : const Color(0xFFF1EDE6)),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSel
                                            ? Theme.of(context).colorScheme.primary
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openPresetSuggestionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tr('preset_modal_title'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.tr('preset_modal_subtitle'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final suggestions = AppConstants.getHabitSuggestions(AppState.instance.language);
                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: suggestions.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = suggestions[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF2C2E38)
                                  : const Color(0xFFFAF7F2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF373A47)
                                    : const Color(0xFFE4DFD6),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary.withAlpha(30),
                                ),
                                child: Center(
                                  child: Text(item['emoji']!, style: const TextStyle(fontSize: 22)),
                                ),
                              ),
                              title: Text(
                                item['name']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              subtitle: Text(
                                item['category']!,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _addPresetHabit(item);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(AppStrings.tr('add'), style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHabitsSection(BuildContext context, List<Map<String, dynamic>> habits) {
    if (habits.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        alignment: Alignment.center,
        child: Text(
          AppStrings.tr('no_habits'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.tr('today_habits_title')} (${habits.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return _buildHabitItem(context, habit);
          },
        ),
      ],
    );
  }

  Widget _buildHabitItem(BuildContext context, Map<String, dynamic> habit) {
    final bool isDone = habit['isDoneToday'] ?? false;
    final String emoji = habit['emoji'] ?? '✨';
    final String name = AppStrings.getLocalizedHabitName(habit);
    final String category = AppStrings.getLocalizedCategory(habit);
    final int totalCount = habit['totalCount'] ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(habit['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 26),
            const SizedBox(width: 8),
            Text(
              AppStrings.tr('delete'),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmDialog(context, habit);
      },
      onDismissed: (direction) {
        AppState.instance.deleteHabit(habit['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.tr('habit_deleted_snack')),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone
                ? Theme.of(context).colorScheme.primary
                : (isDark ? const Color(0xFF373A47) : const Color(0xFFE4DFD6)),
            width: isDone ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? Theme.of(context).colorScheme.primary.withAlpha(isDark ? 60 : 40)
                    : (isDark ? const Color(0xFF2C2E38) : const Color(0xFFF1EDE6)),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$category • $totalCount ${AppStrings.tr('completed_count')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 22,
                color: isDark ? Colors.red.shade300.withAlpha(200) : Colors.red.shade400,
              ),
              tooltip: AppStrings.tr('delete'),
              onPressed: () async {
                final confirmed = await _showDeleteConfirmDialog(context, habit);
                if (confirmed == true) {
                  await AppState.instance.deleteHabit(habit['id']);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppStrings.tr('habit_deleted_snack')),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
            ),
            IconButton(
              onPressed: () => AppState.instance.toggleHabitCompletion(habit['id']),
              icon: Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? Theme.of(context).colorScheme.primary : Colors.grey,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, Map<String, dynamic> habit) {
    final name = AppStrings.getLocalizedHabitName(habit);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.tr('delete_habit_title')),
        content: Text(
          AppStrings.tr('delete_habit_confirm').replaceAll('{name}', name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppStrings.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppStrings.tr('delete')),
          ),
        ],
      ),
    );
  }

  void _saveCustomHabit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.tr('enter_title_warning'))),
      );
      return;
    }

    final isEn = AppState.instance.language == 'EN';
    final translatedTitle = await TranslationService.translateTrToEn(title);

    await AppState.instance.addHabit(
      name: isEn ? translatedTitle : title,
      nameEn: isEn ? title : translatedTitle,
      emoji: _selectedEmoji,
      category: 'Kişisel',
      categoryEn: 'Personal',
    );
    _titleController.clear();
    _descController.clear();
  }

  void _addPresetHabit(Map<String, String> item) async {
    final nameTr = item['nameTr'] ?? item['name']!;
    final nameEn = item['nameEn'] ?? item['name']!;
    final catTr = item['categoryTr'] ?? item['category']!;
    final catEn = item['categoryEn'] ?? item['category']!;

    await AppState.instance.addHabit(
      name: nameTr,
      nameEn: nameEn,
      emoji: item['emoji']!,
      category: catTr,
      categoryEn: catEn,
    );
    if (mounted) {
      final displayName = AppStrings.getLocalizedHabitName(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$displayName ${AppStrings.tr('habit_added_snack')}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
