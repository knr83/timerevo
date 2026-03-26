import '../entities/schedule_entities.dart';

/// Port for schedule resolution and template administration.
/// Use cases depend on this; data layer implements.
abstract interface class ISchedulesRepo {
  Future<ResolvedSchedule> resolveSchedule({
    required int employeeId,
    required DateTime dateLocal,
  });

  /// Assigned template id for [employeeId], or null if none.
  Future<int?> getAssignmentTemplateId(int employeeId);

  /// Sets or clears the employee's assigned schedule template row.
  /// [templateId] null removes the assignment.
  Future<void> setEmployeeTemplateAssignment({
    required int employeeId,
    required int? templateId,
  });

  /// Weekday 1..Mon .. 7..Sun → template day definition.
  Future<Map<int, DaySchedule>> getTemplateWeek(int templateId);

  /// Stream of schedule templates as domain types (id, name, weekly totals).
  Stream<List<ScheduleTemplateInfo>> streamTemplateInfos({
    bool onlyActive = true,
  });

  Future<int> createTemplate(String name);

  Future<void> updateTemplateName({required int id, required String name});

  Future<void> setTemplateActive({required int id, required bool isActive});

  Future<bool> hasAssignments(int templateId);

  Future<void> deleteTemplate(int templateId);

  Stream<Map<int, DaySchedule>> watchTemplateWeek(int templateId);

  Future<void> saveTemplateDay({
    required int templateId,
    required int weekday,
    required bool isDayOff,
    required List<ScheduleInterval> intervals,
  });

  Future<void> saveTemplateWeek({
    required int templateId,
    required Map<int, DaySchedule> days,
  });

  Future<int> createTemplateWithWeek({
    required String name,
    required Map<int, DaySchedule> days,
  });
}
