import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_date_folder_widget.dart';
import '../widgets/add_task_dialog.dart';
import 'package:full_concentrate/core/localization/app_strings.dart';

/// Görev Listesi Ekranı (Sayfa 2 - Altta Tek Görev Ekleme Butonlu)
class TaskListScreen extends StatelessWidget {
  final TaskController controller;
  final VoidCallback onNavigateToPomodoro;

  const TaskListScreen({
    super.key,
    required this.controller,
    required this.onNavigateToPomodoro,
  });

  void _showAddDialog(BuildContext context, {String? initialDate}) {
    showDialog(
      context: context,
      builder: (ctx) => AddTaskDialog(
        initialDate: initialDate,
        onAdd: (title, date) {
          controller.addTask(title, date);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('tasksTab')),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return _buildBody(context, theme);
        },
      ),
      bottomNavigationBar: _buildBottomBar(context, theme),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final groupedTasks = controller.tasksGroupedByDate;
    if (groupedTasks.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    final dateKeys = groupedTasks.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      itemCount: dateKeys.length,
      itemBuilder: (context, index) {
        final date = dateKeys[index];
        final tasksForDate = groupedTasks[date] ?? [];

        return TaskDateFolderWidget(
          date: date,
          tasks: tasksForDate,
          selectedTask: controller.selectedTask,
          onSelect: (task) => controller.selectTask(task),
          onToggleComplete: (task) => controller.toggleTaskCompletion(task),
          onDelete: (id) => controller.deleteTask(id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open_rounded, size: 72, color: Color(0xFFB56576)),
            const SizedBox(height: 16),
            Text(
              'Henüz görev klasörü yok',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Aşağıdaki "Yeni Görev Ekle" butonuna basarak tarihli görevinizi oluşturabilirsiniz.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 22),
              label: Text(AppStrings.get('addNewTask')),
              onPressed: () => _showAddDialog(context),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.timer_outlined),
              label: Text(AppStrings.get('saveAndGoToPomodoro')),
              onPressed: onNavigateToPomodoro,
            ),
          ),
        ],
      ),
    );
  }
}
