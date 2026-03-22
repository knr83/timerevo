import '../common/utils/date_utils.dart';
import 'tracking_start_range_clamp.dart';

/// Effective calendar date (YYYY-MM-DD) for when a starting balance begins to apply.
/// Tracking start wins when set; otherwise local calendar date of [balanceUpdatedAtUtcMs].
String? effectiveStartingBalanceYmd({
  required String? trackingStartYmd,
  required int? balanceUpdatedAtUtcMs,
}) {
  if (trackingStartYmd != null && trackingStartYmd.isNotEmpty) {
    return trackingStartYmd;
  }
  if (balanceUpdatedAtUtcMs == null) return null;
  final local = DateTime.fromMillisecondsSinceEpoch(
    balanceUpdatedAtUtcMs,
    isUtc: true,
  ).toLocal();
  return dateToYmd(DateTime(local.year, local.month, local.day));
}

/// Converts signed tenths of an hour to milliseconds (0.1 h = 360_000 ms).
int startingBalanceTenthsToMs(int tenths) => tenths * 360000;

/// True when [fromUtcMs]/[toUtcMs] period overlaps the effective starting-balance day onward.
bool periodIntersectsEffectiveStartingBalance({
  required int fromUtcMs,
  required int toUtcMs,
  required String? effectiveYmd,
}) {
  if (effectiveYmd == null) return false;
  final effectiveStartMs = trackingStartLocalDayStartUtcMsFromYmd(effectiveYmd);
  return toUtcMs >= effectiveStartMs;
}

/// Milliseconds to add to period balance (0 if unset, no overlap, or explicit zero).
int startingBalanceMsForPeriod({
  required int? tenths,
  required String? trackingStartYmd,
  required int? balanceUpdatedAtUtcMs,
  required int fromUtcMs,
  required int toUtcMs,
}) {
  if (tenths == null) return 0;
  final ymd = effectiveStartingBalanceYmd(
    trackingStartYmd: trackingStartYmd,
    balanceUpdatedAtUtcMs: balanceUpdatedAtUtcMs,
  );
  if (!periodIntersectsEffectiveStartingBalance(
    fromUtcMs: fromUtcMs,
    toUtcMs: toUtcMs,
    effectiveYmd: ymd,
  )) {
    return 0;
  }
  return startingBalanceTenthsToMs(tenths);
}
