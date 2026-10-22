import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/presentation/layouts/base_layout_with_cat.dart';
import '../../../core/state/app_state.dart';

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
          message: '${mascot.name}: Harika gidiyorsun!',
          catAlignment: Alignment.bottomRight,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, currentStreak, mascot),
                  const SizedBox(height: 18),
                  _buildAddHabitCard(context),
                  const SizedBox(height: 18),
                  _buildSuggestionsSection(context),
                  const SizedBox(height: 20),
                  _buildHabitsSection(context, habits),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, int streak, CatMascot mascot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bugün Neler Yaptın? ✨',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Her gün düzenli ol, serini bozma!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ],
        ),
        _buildStreakHeartBadge(context, streak),
      ],
    );
  }

  Widget _buildStreakHeartBadge(BuildContext context, int streak) {
    final heartColor = Theme.of(context).colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: heartColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: heartColor.withAlpha(50),
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
            '$streak Gün',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4DFD6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yeni Alışkanlık Ekle',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Alışkanlık Başlığı',
              hintText: 'Örn: Kitap Okuma, Yürüyüş...',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Açıklama / Hedef',
              hintText: 'Örn: Günde 20 sayfa okumak',
              prefixIcon: Icon(Icons.notes_outlined),
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
              label: const Text('Alışkanlığı Kaydet'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = ['✨', '🏃‍♂️', '🚶‍♀️', '📚', '✍️', '🎨', '🧶', '🧘', '💧', '🌅', '🎸'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: emojis.map((emoji) {
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
                color: isSelected ? const Color(0xFF9DB2A1).withAlpha(50) : const Color(0xFFF1EDE6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF9DB2A1) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSuggestionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hazır Öneriler',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.habitSuggestions.map((item) {
              return GestureDetector(
                onTap: () => _addPresetHabit(item),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE4DFD6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['emoji']!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        item['name']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.add, size: 16, color: Color(0xFF9DB2A1)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context, List<Map<String, dynamic>> habits) {
    if (habits.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('Henüz eklenmiş alışkanlık yok. Yukarıdan ekleyebilirsin!'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bugünün Alışkanlıkları (${habits.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 10),
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
    final String name = habit['name'] ?? '';
    final String category = habit['category'] ?? 'Genel';
    final int totalCount = habit['totalCount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? const Color(0xFF9DB2A1) : const Color(0xFFE4DFD6),
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
                  ? const Color(0xFF9DB2A1).withAlpha(40)
                  : const Color(0xFFF1EDE6),
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
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$category • Toplam $totalCount kez yapıldı',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => AppState.instance.toggleHabitCompletion(habit['id']),
            icon: Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? const Color(0xFF9DB2A1) : Colors.black26,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  void _saveCustomHabit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir alışkanlık başlığı yazın.')),
      );
      return;
    }

    await AppState.instance.addHabit(
      name: title,
      emoji: _selectedEmoji,
      category: 'Kişisel',
    );
    _titleController.clear();
    _descController.clear();
  }

  void _addPresetHabit(Map<String, String> item) async {
    await AppState.instance.addHabit(
      name: item['name']!,
      emoji: item['emoji']!,
      category: item['category']!,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} başarıyla eklendi!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
