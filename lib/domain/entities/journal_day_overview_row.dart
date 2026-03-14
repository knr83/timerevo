import 'journal_day_state.dart';

/// One row in the Journal timeline overview: employee info + one cell per day.
class JournalDayOverviewRow {
  const JournalDayOverviewRow({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.cells,
  });

  final int employeeId;
  final String firstName;
  final String lastName;

  /// One state per day in the selected range, ordered by date.
  final List<JournalDayState> cells;
}
