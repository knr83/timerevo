/// Display type for per-day report rows (worked, planned, balance).
class EmployeeDayReportRow {
  const EmployeeDayReportRow({
    required this.dateYmd,
    required this.workedMs,
    required this.normMs,
    required this.deltaMs,
    required this.hasSchedule,
  });

  final String dateYmd;
  final int workedMs;
  final int normMs;
  final int deltaMs;

  /// True when ResolvedSchedule.source != 'none' for that date.
  final bool hasSchedule;
}
