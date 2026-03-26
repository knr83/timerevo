import '../../domain/entities/session_info.dart';

/// True when [now] is past the end of the working day for the session (next
/// calendar day, or same day but current time >= [endMin] minutes from midnight).
///
/// When [now] is omitted, uses [DateTime.now].
bool isPastWorkingDayEnd(SessionInfo open, int endMin, {DateTime? now}) {
  final effectiveNow = now ?? DateTime.now();
  final sessionStartLocal = DateTime.fromMillisecondsSinceEpoch(
    open.startTs,
    isUtc: true,
  ).toLocal();
  final sessionDate = DateTime(
    sessionStartLocal.year,
    sessionStartLocal.month,
    sessionStartLocal.day,
  );
  final today = DateTime(
    effectiveNow.year,
    effectiveNow.month,
    effectiveNow.day,
  );
  final nowMin = effectiveNow.hour * 60 + effectiveNow.minute;
  final isNextDay = today.isAfter(sessionDate);
  final isSameDayPastEnd =
      today.year == sessionDate.year &&
      today.month == sessionDate.month &&
      today.day == sessionDate.day &&
      nowMin >= endMin;
  return isNextDay || isSameDayPastEnd;
}
