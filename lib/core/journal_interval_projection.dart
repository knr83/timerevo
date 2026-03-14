// Display-oriented timeline projections for the Journal detailed grid.
// Not domain truth — used to drive interval-based rendering.

/// Kind of interval in the detailed timeline.
enum JournalIntervalKind { work, absence, ongoing }

/// One interval within a day, already clipped to the working window.
class JournalIntervalItem {
  const JournalIntervalItem({
    required this.kind,
    required this.startUtcMs,
    required this.endUtcMs,
  });

  final JournalIntervalKind kind;
  final int startUtcMs;
  final int endUtcMs;
}

/// One row in the Journal detailed timeline: employee info + intervals per day.
class JournalIntervalRow {
  const JournalIntervalRow({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.cells,
  });

  final int employeeId;
  final String firstName;
  final String lastName;

  /// One list of intervals per day in the selected range, ordered by date.
  final List<List<JournalIntervalItem>> cells;
}
