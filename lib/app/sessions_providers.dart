import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/utils/date_utils.dart';
import '../core/tracking_start_range_clamp.dart';
import '../data/repositories/repo_providers.dart';
import '../domain/entities/session_info.dart';
import '../domain/entities/session_with_employee_info.dart';
import '../domain/usecases.dart';
import 'tracking_start/tracking_start_settings_controller.dart'
    show trackingStartSettingsProvider, trackingStartYmdFromWatch;

final watchSessionsUseCaseProvider = Provider<WatchSessionsUseCase>((ref) {
  return WatchSessionsUseCase(ref.watch(sessionsRepoProvider));
});

/// Open session for a single employee (domain type). Used by terminal.
final watchOpenSessionForEmployeeProvider =
    StreamProvider.family<SessionInfo?, int>((ref, employeeId) {
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamOpenSessionForEmployee(employeeId);
    });

/// Open sessions (status=open) with employee info. Used by dashboard "Now at Work".
final watchOpenSessionsProvider = StreamProvider<List<SessionWithEmployeeInfo>>(
  (ref) {
    return ref
        .watch(watchSessionsUseCaseProvider)
        .streamOpenSessionsWithEmployee();
  },
);

/// Recent sessions (last 10) with employee info. Used by dashboard "Recent Activity".
final watchRecentSessionsProvider =
    StreamProvider<List<SessionWithEmployeeInfo>>((ref) {
      final ymd = trackingStartYmdFromWatch(
        ref.watch(trackingStartSettingsProvider),
      );
      final int? fromUtcMs = (ymd != null && ymd.isNotEmpty)
          ? trackingStartLocalDayStartUtcMsFromYmd(ymd)
          : null;
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamRecentSessionsWithEmployee(limit: 10, fromUtcMs: fromUtcMs);
    });

({int fromUtcMs, int toUtcMs}) _todayRange() =>
    localDayRangeUtcMs(DateTime.now());

/// Today's sessions with employee info. Used by dashboard "Today".
final watchTodaySessionsProvider =
    StreamProvider<List<SessionWithEmployeeInfo>>((ref) {
      final range = _todayRange();
      final ymd = trackingStartYmdFromWatch(
        ref.watch(trackingStartSettingsProvider),
      );
      final clamped = clampUtcRangeToTrackingStart(
        fromUtcMs: range.fromUtcMs,
        toUtcMs: range.toUtcMs,
        trackingStartYmd: ymd,
      );
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamSessionsWithEmployee(
            fromUtcMs: clamped.fromUtcMs,
            toUtcMs: clamped.toUtcMs,
          );
    });

/// Sessions for employee today (domain type). Used by dashboard expand blocks.
final watchSessionsForEmployeeTodayProvider =
    StreamProvider.family<List<SessionInfo>, int>((ref, employeeId) {
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamSessionsForEmployeeToday(employeeId);
    });

/// Sessions for employee in last N days. Used by dashboard "Recent Activity" expand.
final watchSessionsForEmployeeLastDaysProvider =
    StreamProvider.family<List<SessionInfo>, (int, int)>((ref, args) {
      final (employeeId, days) = args;
      final ymd = trackingStartYmdFromWatch(
        ref.watch(trackingStartSettingsProvider),
      );
      final int? minStartUtcMs = (ymd != null && ymd.isNotEmpty)
          ? trackingStartLocalDayStartUtcMsFromYmd(ymd)
          : null;
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamSessionsForEmployeeLastDays(
            employeeId,
            days,
            minStartUtcMs: minStartUtcMs,
          );
    });

/// Sessions for calendar range (3 months around focused month). Used by employee calendar markers.
final watchSessionsForCalendarRangeProvider =
    StreamProvider.family<List<SessionInfo>, (int, int, int)>((ref, args) {
      final (employeeId, year, month) = args;
      final start = DateTime(year, month - 1, 1);
      final lastDay = DateTime(year, month + 2, 0);
      final endRange = localDayRangeUtcMs(lastDay);
      final ymd = trackingStartYmdFromWatch(
        ref.watch(trackingStartSettingsProvider),
      );
      final clamped = clampUtcRangeToTrackingStart(
        fromUtcMs: start.toUtc().millisecondsSinceEpoch,
        toUtcMs: endRange.toUtcMs,
        trackingStartYmd: ymd,
      );
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamSessions(
            employeeId: employeeId,
            fromUtcMs: clamped.fromUtcMs,
            toUtcMs: clamped.toUtcMs,
          );
    });

/// Sessions for employee on a single date. Used by employee calendar day detail.
final watchSessionsForEmployeeOnDateProvider =
    StreamProvider.family<List<SessionInfo>, (int, DateTime)>((ref, args) {
      final (employeeId, date) = args;
      return ref
          .watch(watchSessionsUseCaseProvider)
          .streamSessionsForEmployeeOnDate(employeeId, date);
    });

/// App-layer use case for admin session updates. Use from UI instead of repo.
final updateSessionAsAdminUseCaseProvider =
    Provider<UpdateSessionAsAdminUseCase>((ref) {
      return UpdateSessionAsAdminUseCase(
        ref.watch(sessionsRepoProvider),
        ref.watch(employeesRepoProvider),
      );
    });
