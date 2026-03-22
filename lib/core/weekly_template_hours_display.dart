/// Display for template-derived weekly work totals (planned minutes Mon–Sun).
///
/// Rules: always one decimal place of hours, half-up (0.1 h = 6 min), ASCII `.`
/// only, then [unitSuffix] (e.g. localized `" h"` or `" ч"`). [null] → em dash
/// (U+2014), same placeholder as roster PDF cells when no template.
String formatTemplateWeeklyHoursDisplay(
  int? totalMinutes, {
  required String unitSuffix,
}) {
  if (totalMinutes == null) {
    return '\u2014';
  }
  if (totalMinutes < 0) {
    throw ArgumentError.value(totalMinutes, 'totalMinutes', 'must be >= 0');
  }
  final tenths = (totalMinutes * 10 + 30) ~/ 60;
  final w = tenths ~/ 10;
  final f = tenths % 10;
  return '$w.$f$unitSuffix';
}
