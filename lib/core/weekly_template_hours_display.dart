/// Display for template-derived weekly work totals (planned minutes Mon–Sun).
///
/// Rules: one decimal place of hours, half-up (0.1 h = 6 min), ASCII `.` only,
/// no unit suffix. [null] → em dash (U+2014), same placeholder as roster PDF cells.
String formatTemplateWeeklyHoursDisplay(int? totalMinutes) {
  if (totalMinutes == null) {
    return '\u2014';
  }
  if (totalMinutes < 0) {
    throw ArgumentError.value(totalMinutes, 'totalMinutes', 'must be >= 0');
  }
  final tenths = (totalMinutes * 10 + 30) ~/ 60;
  final w = tenths ~/ 10;
  final f = tenths % 10;
  if (f == 0) {
    return '$w';
  }
  return '$w.$f';
}
