import 'package:flutter/foundation.dart';

@immutable
class DashboardStats {
  final int totalPlans;
  final int approvedPlans;
  final int activeLegalRequests;
  final int totalGrantsAvailable;
  final int bookedSessions;

  const DashboardStats({
    required this.totalPlans,
    required this.approvedPlans,
    required this.activeLegalRequests,
    required this.totalGrantsAvailable,
    required this.bookedSessions,
  });

  factory DashboardStats.initial() {
    return const DashboardStats(
      totalPlans: 2,
      approvedPlans: 1,
      activeLegalRequests: 1,
      totalGrantsAvailable: 3,
      bookedSessions: 0,
    );
  }

  DashboardStats copyWith({
    int? totalPlans,
    int? approvedPlans,
    int? activeLegalRequests,
    int? totalGrantsAvailable,
    int? bookedSessions,
  }) {
    return DashboardStats(
      totalPlans: totalPlans ?? this.totalPlans,
      approvedPlans: approvedPlans ?? this.approvedPlans,
      activeLegalRequests: activeLegalRequests ?? this.activeLegalRequests,
      totalGrantsAvailable: totalGrantsAvailable ?? this.totalGrantsAvailable,
      bookedSessions: bookedSessions ?? this.bookedSessions,
    );
  }
}
