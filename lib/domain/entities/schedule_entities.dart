/// Domain value objects for schedule intervals and day schedules.
class ScheduleInterval {
  const ScheduleInterval({required this.startMin, required this.endMin});

  final int startMin;
  final int endMin;
}

class DaySchedule {
  const DaySchedule({required this.isDayOff, required this.intervals});

  final bool isDayOff;
  final List<ScheduleInterval> intervals;
}

class ResolvedSchedule {
  const ResolvedSchedule({
    required this.source,
    required this.isDayOff,
    required this.intervals,
  });

  /// Source: template | none
  final String source;
  final bool isDayOff;
  final List<ScheduleInterval> intervals;
}

/// Minimal schedule template for dropdowns and lists (id, name, isActive).
class ScheduleTemplateInfo {
  const ScheduleTemplateInfo({
    required this.id,
    required this.name,
    this.isActive = true,
  });
  final int id;
  final String name;
  final bool isActive;
}
