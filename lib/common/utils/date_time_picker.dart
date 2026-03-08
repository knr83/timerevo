import 'package:flutter/material.dart';

/// Picks only the time, combining with [date] to return a full DateTime.
/// Use when date is already known (e.g. to re-pick time after validation error).
Future<DateTime?> pickTimeForDate(
  BuildContext context, {
  required DateTime date,
  TimeOfDay? initialTime,
}) async {
  final now = DateTime.now();
  final time = await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.fromDateTime(now),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Picks a local date and time. If [firstDate] and [lastDate] are set, the date
/// picker is restricted to that range (e.g. both equal to session date for
/// single-day selection). [initialTime] can hint the default time (e.g. end of
/// working day).
Future<DateTime?> pickLocalDateTime(
  BuildContext context, {
  DateTime? firstDate,
  DateTime? lastDate,
  TimeOfDay? initialTime,
}) async {
  final now = DateTime.now();
  final minDate = firstDate ?? DateTime(now.year - 2);
  final maxDate = lastDate ?? DateTime(now.year + 2);
  final date = await showDatePicker(
    context: context,
    firstDate: minDate,
    lastDate: maxDate,
    initialDate: now.isBefore(maxDate)
        ? (now.isBefore(minDate) ? minDate : now)
        : maxDate,
  );
  if (date == null) return null;
  if (!context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.fromDateTime(now),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// Picks a local date only (no time). Returns start of that day in local time.
/// Use with date_utils helpers to get UTC range.
Future<DateTime?> pickLocalDateOnly(
  BuildContext context, {
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? initialDate,
}) async {
  final now = DateTime.now();
  final minDate = firstDate ?? DateTime(now.year - 2);
  final maxDate = lastDate ?? DateTime(now.year + 2);
  final initial = initialDate ?? now;
  final date = await showDatePicker(
    context: context,
    firstDate: minDate,
    lastDate: maxDate,
    initialDate: initial.isBefore(maxDate)
        ? (initial.isBefore(minDate) ? minDate : initial)
        : maxDate,
  );
  if (date == null) return null;
  if (!context.mounted) return null;
  return DateTime(date.year, date.month, date.day);
}

/// Picks a local date range. Returns (fromUtcMs, toUtcMs) for start-of-from and end-of-to (inclusive).
/// Returns null if user cancels.
Future<({int fromUtcMs, int toUtcMs})?> pickDateRange(
  BuildContext context, {
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? initialStartDate,
  DateTime? initialEndDate,
}) async {
  final now = DateTime.now();
  final minDate = firstDate ?? DateTime(now.year - 2, 1, 1);
  final maxDate = lastDate ?? DateTime(now.year + 2, 12, 31);
  final initialStart = initialStartDate ?? now;
  final initialEnd = initialEndDate ?? now;

  final range = await showDateRangePicker(
    context: context,
    firstDate: minDate,
    lastDate: maxDate,
    initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
  );
  if (range == null) return null;
  if (!context.mounted) return null;

  final fromDate = DateTime(range.start.year, range.start.month, range.start.day);
  final toDate = DateTime(range.end.year, range.end.month, range.end.day);
  final fromUtcMs = fromDate.toUtc().millisecondsSinceEpoch;
  final toEndOfDay = DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59, 999);
  final toUtcMs = toEndOfDay.toUtc().millisecondsSinceEpoch;

  return (fromUtcMs: fromUtcMs, toUtcMs: toUtcMs);
}
