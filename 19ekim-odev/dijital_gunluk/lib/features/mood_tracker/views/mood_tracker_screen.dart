import 'package:flutter/material.dart';
import '../controllers/mood_tracker_controller.dart';
import '../models/mood_entry_model.dart';
import '../widgets/mood_card.dart';
import '../widgets/mood_selector_card.dart';
import '../widgets/mood_stats_card.dart';

class MoodTrackerScreen extends StatelessWidget {
  final MoodTrackerController controller;

  const MoodTrackerScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duygu Takibi'),
      ),
      body: ValueListenableBuilder<List<MoodEntry>>(
        valueListenable: controller.moods,
        builder: (context, moods, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MoodSelectorCard(
                  onMoodSelected: (mood, note) => controller.addMood(mood, note),
                ),
              ),
              SliverToBoxAdapter(
                child: MoodStatsCard(counts: controller.getMoodCounts()),
              ),
              _buildSectionHeader(context, moods.length),
              _buildMoodList(moods),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, int count) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Text(
          'Geçmiş Kayıtlar ($count)',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMoodList(List<MoodEntry> moods) {
    if (moods.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('Henüz bir duygu durumu kaydetmediniz.')),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final entry = moods[index];
          return MoodCard(
            entry: entry,
            onDelete: () => controller.deleteMood(entry.id),
          );
        },
        childCount: moods.length,
      ),
    );
  }
}
