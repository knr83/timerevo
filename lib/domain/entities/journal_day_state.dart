/// Display state for a single day in the Journal timeline overview.
///
/// See docs/ and the Journal Timeline plan for semantics.
enum JournalDayState {
  /// Open session started on this (local) calendar day.
  ongoing,

  /// At least one closed session with worked time on this day.
  present,

  /// Approved absence covers this day.
  approvedAbsence,

  /// Had schedule (source != 'none'), no work, no approved absence.
  expectedNoShow,

  /// No schedule, no work, no approved absence.
  noData,
}
