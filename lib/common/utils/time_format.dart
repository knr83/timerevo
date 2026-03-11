import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TimeFormat {
  static final _dt = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final _timeOnly = DateFormat('HH:mm');

  /// Short time for display (e.g. "09:00").
  static String formatTimeOnly(int utcMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      utcMs,
      isUtc: true,
    ).toLocal();
    return _timeOnly.format(dt);
  }

  /// Current local time as "HH:mm".
  static String formatNow() => _timeOnly.format(DateTime.now());

  static String formatLocalFromUtcMs(int utcMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      utcMs,
      isUtc: true,
    ).toLocal();
    return _dt.format(dt);
  }

  /// Date and time without seconds (e.g. "2025-01-15 09:00").
  static String formatLocalDateTimeNoSeconds(int utcMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      utcMs,
      isUtc: true,
    ).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  /// Parses [input] as local date-time, returns UTC milliseconds.
  static int? tryParseLocalToUtcMs(String input) {
    try {
      final parsed = _dt.parseStrict(input.trim(), false);
      return parsed.toUtc().millisecondsSinceEpoch;
    } catch (_) {
      // Intentional: tryParse returns null on invalid input.
      return null;
    }
  }

  static String formatMinutes(int min) {
    final h = (min ~/ 60).toString().padLeft(2, '0');
    final m = (min % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  static TimeOfDay timeOfDayFromMinutes(int min) {
    return TimeOfDay(hour: min ~/ 60, minute: min % 60);
  }
}
