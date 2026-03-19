import '../entities/schedule_entities.dart';

/// Port for schedule resolution. Use cases depend on this; data layer implements.
abstract interface class ISchedulesRepo {
  Future<ResolvedSchedule> resolveSchedule({
    required int employeeId,
    required DateTime dateLocal,
  });

  /// Assigned template id for [employeeId], or null if none.
  Future<int?> getAssignmentTemplateId(int employeeId);

  /// Weekday 1..Mon .. 7..Sun → template day definition.
  Future<Map<int, DaySchedule>> getTemplateWeek(int templateId);
}
