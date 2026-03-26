import '../common/utils/date_utils.dart';

/// Expands approved absence ranges (local calendar dates) into Ymd strings.
///
/// Inclusive on both [dateFrom] and [dateTo]. Matches the date-walking
/// semantics previously inlined in report and journal use cases.
Set<String> ymdSetFromApprovedAbsenceRanges(
  List<({DateTime dateFrom, DateTime dateTo})> ranges,
) {
  final set = <String>{};
  for (final range in ranges) {
    var d = DateTime(
      range.dateFrom.year,
      range.dateFrom.month,
      range.dateFrom.day,
    );
    final end = DateTime(
      range.dateTo.year,
      range.dateTo.month,
      range.dateTo.day,
    );
    while (!d.isAfter(end)) {
      set.add(dateToYmd(d));
      d = d.add(const Duration(days: 1));
    }
  }
  return set;
}
