import '../widgets/date_range_filter_bar.dart' show DateRangeScope;

import 'date_utils.dart';

/// Effective UTC range for a [DateRangeScope] when [fromUtcMs]/[toUtcMs] are
/// not both set explicitly (then those are used as-is).
///
/// [DateRangeScope.interval] falls back to [reportPeriodMonth], matching Reports
/// and Absences. Lives here (not in [date_utils]) to avoid a circular import
/// with [DateRangeFilterBar], which imports [date_utils].
({int fromUtcMs, int toUtcMs}) effectiveUtcRangeForDateScope({
  required DateRangeScope scope,
  int? fromUtcMs,
  int? toUtcMs,
}) {
  if (fromUtcMs != null && toUtcMs != null) {
    return (fromUtcMs: fromUtcMs, toUtcMs: toUtcMs);
  }
  return switch (scope) {
    DateRangeScope.day => reportPeriodToday(),
    DateRangeScope.week => reportPeriodWeek(),
    DateRangeScope.month => reportPeriodMonth(),
    DateRangeScope.interval => reportPeriodMonth(),
  };
}
