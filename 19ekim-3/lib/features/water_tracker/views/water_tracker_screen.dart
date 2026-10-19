import 'package:flutter/material.dart';
import '../../workout/controllers/workout_controller.dart';
import '../../workout/models/workout_model.dart';
import '../../workout/widgets/add_workout_dialog.dart';
import '../../workout/widgets/workout_card.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/logo_header.dart';
import '../widgets/quick_add_bar.dart';
import '../widgets/water_history_card.dart';
import '../widgets/water_progress_card.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();

    // Antrenman eklenince su hedefine bonus ekle
    _workoutController.workouts.addListener(_onWorkoutsChanged);
  }

  void _onWorkoutsChanged() {
    _waterController.updateWorkoutBonus(_workoutController.totalRecommendedWaterMl);
  }

  @override
  void dispose() {
    _workoutController.workouts.removeListener(_onWorkoutsChanged);
    _waterController.dispose();
    _workoutController.dispose();
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
              LogoHeader(onReset: _handleFullReset),
              const SizedBox(height: 16),
              _buildProgressSection(),
              const SizedBox(height: 16),
              QuickAddBar(onAddWater: _waterController.addWater),
              const SizedBox(height: 16),
              _buildWorkoutSection(),
              const SizedBox(height: 16),
              _buildHistorySection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return ValueListenableBuilder<WaterTrackerState>(
      valueListenable: _waterController.state,
      builder: (context, state, _) {
        return WaterProgressCard(state: state);
      },
    );
  }

  Widget _buildWorkoutSection() {
    return ValueListenableBuilder<List<WorkoutItem>>(
      valueListenable: _workoutController.workouts,
      builder: (context, workouts, _) {
        return WorkoutCard(
          workouts: workouts,
          onAddWorkout: _openAddWorkoutModal,
          onRemoveWorkout: _workoutController.removeWorkout,
        );
      },
    );
  }

  Widget _buildHistorySection() {
    return ValueListenableBuilder<WaterTrackerState>(
      valueListenable: _waterController.state,
      builder: (context, state, _) {
        return WaterHistoryCard(
          history: state.history,
          onDeleteEntry: _waterController.removeEntry,
        );
      },
    );
  }

  Future<void> _openAddWorkoutModal() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddWorkoutDialog(),
    );

    if (result != null) {
      _workoutController.addWorkout(
        name: result['name'] as String,
        durationMinutes: result['duration'] as int,
        burnedCalories: result['calories'] as int,
      );
    }
  }

  void _handleFullReset() {
    _waterController.resetWater();
    _workoutController.resetWorkouts();
  }
}
