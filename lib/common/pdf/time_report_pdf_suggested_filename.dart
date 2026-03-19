import '../utils/date_utils.dart';

/// Suggested save name for Time Report PDF exports.
///
/// Pattern: `timerevo_time_report_<from>_to_<to>_<yyyy-mm-dd>_<hhmm>.pdf`
/// (local calendar dates for report range; last segment is export timestamp.)
String timeReportPdfSuggestedFileName({
  required int fromUtcMs,
  required int toUtcMs,
  DateTime? generatedAt,
}) {
  final gen = (generatedAt ?? DateTime.now()).toLocal();
  final fromLocal = DateTime.fromMillisecondsSinceEpoch(
    fromUtcMs,
    isUtc: true,
  ).toLocal();
  final toLocal = DateTime.fromMillisecondsSinceEpoch(
    toUtcMs,
    isUtc: true,
  ).toLocal();
  final from = dateToYmd(fromLocal);
  final to = dateToYmd(toLocal);
  final stampDate = dateToYmd(gen);
  final hhmm =
      '${gen.hour.toString().padLeft(2, '0')}${gen.minute.toString().padLeft(2, '0')}';
  return 'timerevo_time_report_${from}_to_${to}_${stampDate}_$hhmm.pdf';
}
