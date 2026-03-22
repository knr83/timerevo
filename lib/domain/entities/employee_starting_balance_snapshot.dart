/// Minimal employee starting-balance fields for report enrichment.
class EmployeeStartingBalanceSnapshot {
  const EmployeeStartingBalanceSnapshot({this.tenths, this.updatedAtUtcMs});

  /// Null when unset; 0 is explicit zero.
  final int? tenths;
  final int? updatedAtUtcMs;
}
