import 'employee_info.dart';

/// Placeholder for empty schedule cells (PDF guide §4.2).
const String scheduleRosterPdfEmptyCell = '\u2014';

/// One row of schedule roster PDF data (domain layer; no internal ids).
class ScheduleRosterPdfRow {
  const ScheduleRosterPdfRow({
    required this.employeeDisplayName,
    required this.weekdayCells,
    this.weeklyTotalWorkMinutes,
  });

  final String employeeDisplayName;

  /// Index 0 = Monday (weekday 1) … index 6 = Sunday (weekday 7).
  final List<String> weekdayCells;

  /// Total planned minutes Mon–Sun; `null` when the employee has no template.
  final int? weeklyTotalWorkMinutes;
}

/// Dataset for building the schedule roster PDF.
class ScheduleRosterPdfData {
  const ScheduleRosterPdfData({
    required this.rows,
    required this.visibleWeekdays,
  });

  final List<ScheduleRosterPdfRow> rows;

  /// Subset of 1..7 with at least one non-empty cell in [rows].
  final List<int> visibleWeekdays;
}

/// Display name aligned with admin list (`last first`).
String scheduleRosterEmployeeDisplayName(EmployeeInfo e) {
  final first = e.firstName.trim();
  final last = e.lastName.trim();
  if (first.isEmpty && last.isEmpty) return '(No name)';
  if (last.isEmpty) return first;
  if (first.isEmpty) return last;
  return '$last $first';
}
