/// Display type for employee report rows (total time, closed sessions count, norm, delta).
class EmployeeReportRowInfo {
  const EmployeeReportRowInfo({
    required this.employeeId,
    required this.employeeName,
    required this.totalMs,
    required this.closedSessionsCount,
    required this.normMs,
    required this.deltaMs,
    required this.anyDayHasSchedule,
  });

  final int employeeId;
  final String employeeName;
  final int totalMs;
  final int closedSessionsCount;
  final int normMs;
  final int deltaMs;

  /// True if at least one day in the period had ResolvedSchedule.source != 'none'.
  final bool anyDayHasSchedule;
}
