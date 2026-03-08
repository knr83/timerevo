import 'entities/schedule_entities.dart';

/// Pure calculation helpers for report norm (planned time).
/// No dependencies on data layer. Testable.
class ReportNormCalculator {
  ReportNormCalculator._();

  /// Duration of a schedule interval in minutes.
  /// Rule: endMin > startMin → endMin - startMin; else 0.
  static int intervalDurationMinutes(ScheduleInterval i) {
    if (i.endMin > i.startMin) {
      return i.endMin - i.startMin;
    }
    return 0;
  }

  /// Norm minutes for a single day from resolved schedule.
  /// Returns 0 if hasApprovedAbsence, isDayOff, or intervals empty.
  static int dayNormMinutes(
    ResolvedSchedule schedule,
    bool hasApprovedAbsence,
  ) {
    if (hasApprovedAbsence) return 0;
    if (schedule.isDayOff || schedule.intervals.isEmpty) return 0;
    var total = 0;
    for (final it in schedule.intervals) {
      total += intervalDurationMinutes(it);
    }
    return total;
  }
}
