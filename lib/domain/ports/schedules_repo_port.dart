import '../entities/schedule_entities.dart';

/// Port for schedule resolution. Use cases depend on this; data layer implements.
abstract interface class ISchedulesRepo {
  Future<ResolvedSchedule> resolveSchedule({
    required int employeeId,
    required DateTime dateLocal,
  });
}
