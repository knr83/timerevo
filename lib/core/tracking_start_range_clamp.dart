/// Lower-bound clamp for reporting when a "tracking start" calendar date is set.
/// Only [fromUtcMs] may increase (tracking day start). The original [toUtcMs] is
/// never lowered; if the new lower bound would exceed [toUtcMs], [toUtcMs] is
/// raised to [newFrom] so the range stays valid for queries and UI labels.
({int fromUtcMs, int toUtcMs}) clampUtcRangeToTrackingStart({
  required int fromUtcMs,
  required int toUtcMs,
  String? trackingStartYmd,
}) {
  if (trackingStartYmd == null || trackingStartYmd.isEmpty) {
    return (fromUtcMs: fromUtcMs, toUtcMs: toUtcMs);
  }
  final boundFrom = trackingStartLocalDayStartUtcMsFromYmd(trackingStartYmd);
  final newFrom = fromUtcMs > boundFrom ? fromUtcMs : boundFrom;
  final newTo = toUtcMs < newFrom ? newFrom : toUtcMs;
  return (fromUtcMs: newFrom, toUtcMs: newTo);
}

/// After applying [clampUtcRangeToTrackingStart] to the resolved range, returns
/// the clamped pair only if it differs from [storedFromUtcMs] / [storedToUtcMs].
/// Returns null when filters do not need updating (same values after clamp).
///
/// Used when [trackingStartSettingsProvider] changes: callers pass the effective
/// UTC range ([resolvedFromUtcMs], [resolvedToUtcMs]) and current filter fields
/// as stored values (e.g. Reports may use [reportEffectiveRange] for resolved
/// and raw filter fields for stored).
({int fromUtcMs, int toUtcMs})? maybeClampUtcRangeIfUpdateNeeded({
  required int resolvedFromUtcMs,
  required int resolvedToUtcMs,
  required int? storedFromUtcMs,
  required int? storedToUtcMs,
  required String? trackingStartYmd,
}) {
  final c = clampUtcRangeToTrackingStart(
    fromUtcMs: resolvedFromUtcMs,
    toUtcMs: resolvedToUtcMs,
    trackingStartYmd: trackingStartYmd,
  );
  if (c.fromUtcMs == storedFromUtcMs && c.toUtcMs == storedToUtcMs) {
    return null;
  }
  return c;
}

/// When both [fromUtcMs] and [toUtcMs] are non-null (custom interval selected),
/// returns the clamped range if it differs from the inputs; otherwise null.
/// Returns null if either bound is null (preset scope — no sync in listener).
({int fromUtcMs, int toUtcMs})? maybeClampCustomUtcRange({
  required int? fromUtcMs,
  required int? toUtcMs,
  required String? trackingStartYmd,
}) {
  if (fromUtcMs == null || toUtcMs == null) return null;
  return maybeClampUtcRangeIfUpdateNeeded(
    resolvedFromUtcMs: fromUtcMs,
    resolvedToUtcMs: toUtcMs,
    storedFromUtcMs: fromUtcMs,
    storedToUtcMs: toUtcMs,
    trackingStartYmd: trackingStartYmd,
  );
}

/// Start of local calendar day for [ymd] (`YYYY-MM-DD`) as UTC epoch ms (DST-safe).
int trackingStartLocalDayStartUtcMsFromYmd(String ymd) {
  final parts = ymd.split('-');
  if (parts.length != 3) {
    throw FormatException('Expected YYYY-MM-DD', ymd);
  }
  final y = int.parse(parts[0]);
  final m = int.parse(parts[1]);
  final d = int.parse(parts[2]);
  final startOfDay = DateTime(y, m, d);
  return startOfDay.toUtc().millisecondsSinceEpoch;
}

/// ISO `YYYY-MM-DD` lower bound for absence queries: max(fromDate, tracking) when set.
String clampAbsenceFromDateYmd(String fromDate, String? trackingStartYmd) {
  if (trackingStartYmd == null || trackingStartYmd.isEmpty) {
    return fromDate;
  }
  return fromDate.compareTo(trackingStartYmd) >= 0
      ? fromDate
      : trackingStartYmd;
}
