/// Converts [DateTime] to YYYY-MM-DD string.
String dateToYmd(DateTime d) {
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// Today as YYYY-MM-DD in local date.
String todayYmd() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

/// N days ago as YYYY-MM-DD.
String daysAgoYmd(int days) {
  final d = DateTime.now().subtract(Duration(days: days));
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// True if [utcMs1] and [utcMs2] fall on the same local calendar day.
bool isSameLocalCalendarDay(int utcMs1, int utcMs2) {
  final d1 = DateTime.fromMillisecondsSinceEpoch(utcMs1, isUtc: true).toLocal();
  final d2 = DateTime.fromMillisecondsSinceEpoch(utcMs2, isUtc: true).toLocal();
  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}

/// DST-safe local day range as UTC milliseconds.
/// Returns [startOfDay, endOfDay] inclusive for [date] (local calendar day).
({int fromUtcMs, int toUtcMs}) localDayRangeUtcMs(DateTime date) {
  final startOfDay = DateTime(date.year, date.month, date.day);
  final startOfNextDay = startOfDay.add(const Duration(days: 1));
  return (
    fromUtcMs: startOfDay.toUtc().millisecondsSinceEpoch,
    toUtcMs: startOfNextDay.toUtc().millisecondsSinceEpoch - 1,
  );
}

/// Inclusive date range [fromDate..toDate] as UTC milliseconds.
/// Composes localDayRangeUtcMs for DST-safe boundaries.
({int fromUtcMs, int toUtcMs}) localDateRangeUtcMs(
  DateTime fromDate,
  DateTime toDate,
) {
  final fromNormalized = DateTime(fromDate.year, fromDate.month, fromDate.day);
  final toNormalized = DateTime(toDate.year, toDate.month, toDate.day);
  final fromRange = localDayRangeUtcMs(fromNormalized);
  final toRange = localDayRangeUtcMs(toNormalized);
  return (
    fromUtcMs: fromRange.fromUtcMs,
    toUtcMs: toRange.toUtcMs,
  );
}

/// Report period preset: today only.
({int fromUtcMs, int toUtcMs}) reportPeriodToday() {
  final now = DateTime.now();
  return localDayRangeUtcMs(now);
}

/// Report period preset: current week (Monday..Sunday).
({int fromUtcMs, int toUtcMs}) reportPeriodWeek() {
  final now = DateTime.now();
  final weekday = now.weekday;
  final startOfWeek = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));
  return (
    fromUtcMs: startOfWeek.toUtc().millisecondsSinceEpoch,
    toUtcMs: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59, 999)
        .toUtc()
        .millisecondsSinceEpoch,
  );
}

/// Report period preset: current month.
({int fromUtcMs, int toUtcMs}) reportPeriodMonth() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
  return (
    fromUtcMs: start.toUtc().millisecondsSinceEpoch,
    toUtcMs: DateTime(end.year, end.month, end.day, 23, 59, 59, 999)
        .toUtc()
        .millisecondsSinceEpoch,
  );
}

/// Report period preset: last month.
({int fromUtcMs, int toUtcMs}) reportPeriodLastMonth() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month - 1, 1);
  final end = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
  return (
    fromUtcMs: start.toUtc().millisecondsSinceEpoch,
    toUtcMs: DateTime(end.year, end.month, end.day, 23, 59, 59, 999)
        .toUtc()
        .millisecondsSinceEpoch,
  );
}
