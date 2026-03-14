import 'entities/schedule_entities.dart';

/// Resolves which schedule interval a given time (minutes since midnight) belongs to
/// when multiple intervals exist on the same day.
///
/// Rules:
/// - T inside [start, end] → that interval
/// - T before first interval's start → first interval (early check-in)
/// - T in gap between intervals → next interval (early for next shift)
/// - T after last interval's end → null (outside working day)
///
/// [intervals] must be non-empty and ordered by startMin (ascending).
ScheduleInterval? resolveIntervalForTime(int timeMin, List<ScheduleInterval> intervals) {
  if (intervals.isEmpty) return null;

  for (var i = 0; i < intervals.length; i++) {
    final interval = intervals[i];
    if (timeMin >= interval.startMin && timeMin <= interval.endMin) {
      return interval;
    }
    if (timeMin < interval.startMin) {
      return interval;
    }
    if (i < intervals.length - 1) {
      final next = intervals[i + 1];
      if (timeMin > interval.endMin && timeMin < next.startMin) {
        return next;
      }
    }
  }

  final last = intervals.last;
  if (timeMin > last.endMin) return null;
  return last;
}
