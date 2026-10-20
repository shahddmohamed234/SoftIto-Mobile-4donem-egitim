import 'package:flutter/foundation.dart';
import '../models/dashboard_stats_model.dart';

class DashboardController {
  final ValueNotifier<DashboardStats> _stats =
      ValueNotifier<DashboardStats>(DashboardStats.initial());

  ValueNotifier<DashboardStats> get stats => _stats;

  void updateStats({
    int? totalPlans,
    int? approvedPlans,
    int? activeLegalRequests,
    int? totalGrantsAvailable,
    int? bookedSessions,
  }) {
    _stats.value = _stats.value.copyWith(
      totalPlans: totalPlans,
      approvedPlans: approvedPlans,
      activeLegalRequests: activeLegalRequests,
      totalGrantsAvailable: totalGrantsAvailable,
      bookedSessions: bookedSessions,
    );
  }

  void dispose() {
    _stats.dispose();
  }
}
