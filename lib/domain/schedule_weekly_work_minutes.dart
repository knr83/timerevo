import 'entities/schedule_entities.dart';

/// Planned work minutes for one template day (sum of interval lengths).
int scheduleDayWorkMinutes(DaySchedule day) {
  if (day.isDayOff) return 0;
  var t = 0;
  for (final i in day.intervals) {
    t += i.endMin - i.startMin;
  }
  return t;
}

/// Total planned minutes Mon–Sun from a template week map (weekday keys 1..7).
///
/// Same basis as [ScheduleRosterPdfDataUseCase] “Weekly hours” column.
int scheduleTemplateWeekTotalWorkMinutes(Map<int, DaySchedule> week) {
  var sum = 0;
  for (var wd = 1; wd <= 7; wd++) {
    final day = week[wd] ?? const DaySchedule(isDayOff: true, intervals: []);
    sum += scheduleDayWorkMinutes(day);
  }
  return sum;
}
