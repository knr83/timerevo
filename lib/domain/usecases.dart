import 'dart:async';

import '../core/attendance_mode.dart';
import '../core/debug_session_log.dart';
import '../core/domain_errors.dart';
import '../core/journal_interval_projection.dart';
import '../core/employee_pin_status.dart';
import '../core/pin_validation.dart';
import '../common/utils/date_utils.dart';
import 'attendance_interval_resolver.dart';
import 'entities/absence_with_employee_info.dart';
import 'entities/employee_day_report_row.dart';
import 'entities/employee_details.dart';
import 'entities/employee_info.dart';
import 'entities/employee_status.dart';
import 'entities/employee_report_row_info.dart';
import 'entities/journal_day_overview_row.dart';
import 'entities/journal_day_state.dart';
import 'entities/schedule_entities.dart';
import 'entities/session_info.dart';
import 'entities/session_with_employee_info.dart';
import 'report_norm_calculator.dart';
import 'ports/absences_repo_port.dart';
import 'ports/auth_repo_port.dart';
import 'ports/employees_repo_port.dart';
import 'ports/schedules_repo_port.dart';
import 'ports/sessions_repo_port.dart';

sealed class ClockActionResult {
  const ClockActionResult();
}

class ClockSaved extends ClockActionResult {
  const ClockSaved();
}

enum ClockErrorKind {
  sessionAlreadyOpen,
  noOpenSession,
  employeeInactive,
  hasApprovedAbsence,
  noScheduleForDay,
}

enum ClockNeedsNoteKind { lateCheckIn, earlyCheckOut, lateCheckOut }

class ClockNeedsNote extends ClockActionResult {
  const ClockNeedsNote(this.kind);
  final ClockNeedsNoteKind kind;
}

class ClockError extends ClockActionResult {
  const ClockError(this.kind);
  final ClockErrorKind kind;
}

class ClockInUseCase {
  ClockInUseCase(
    this._sessionsRepo,
    this._employeesRepo,
    this._absencesRepo,
    this._schedulesRepo,
  );
  final ISessionsRepo _sessionsRepo;
  final IEmployeesRepo _employeesRepo;
  final IAbsencesRepo _absencesRepo;
  final ISchedulesRepo _schedulesRepo;

  Future<ClockActionResult> call(
    int employeeId, {
    String? note,
    required AttendanceMode attendanceMode,
    required int toleranceMinutes,
  }) async {
    final employee = await _employeesRepo.getEmployee(employeeId);
    if (employee == null) {
      return const ClockError(ClockErrorKind.employeeInactive);
    }
    if (employee.status != EmployeeStatus.active) {
      return const ClockError(ClockErrorKind.employeeInactive);
    }
    final open = await _sessionsRepo.getOpenSessionForEmployee(employeeId);
    if (open != null) {
      return const ClockError(ClockErrorKind.sessionAlreadyOpen);
    }
    final today = todayYmd();
    final hasAbsence = await _absencesRepo.hasApprovedAbsenceOnDate(
      employeeId,
      today,
    );
    if (hasAbsence) {
      return const ClockError(ClockErrorKind.hasApprovedAbsence);
    }

    if (attendanceMode == AttendanceMode.fixed) {
      final now = DateTime.now();
      final todayLocal = DateTime(now.year, now.month, now.day);
      final schedule = await _schedulesRepo.resolveSchedule(
        employeeId: employeeId,
        dateLocal: todayLocal,
      );
      if (schedule.isDayOff || schedule.intervals.isEmpty) {
        return const ClockError(ClockErrorKind.noScheduleForDay);
      }
      final nowMin = now.hour * 60 + now.minute;
      final interval = resolveIntervalForTime(nowMin, schedule.intervals);
      if (interval == null) {
        return const ClockError(ClockErrorKind.noScheduleForDay);
      }
      if (nowMin > interval.startMin + toleranceMinutes) {
        if (note == null || note.trim().isEmpty) {
          return const ClockNeedsNote(ClockNeedsNoteKind.lateCheckIn);
        }
      }
    }

    await _sessionsRepo.createOpenSession(
      employeeId: employeeId,
      note: note?.trim().isNotEmpty == true ? note!.trim() : null,
    );
    return const ClockSaved();
  }
}

class ClockOutUseCase {
  ClockOutUseCase(this._sessionsRepo, this._schedulesRepo);
  final ISessionsRepo _sessionsRepo;
  final ISchedulesRepo _schedulesRepo;

  Future<ClockActionResult> call(
    int employeeId, {
    String? note,
    required AttendanceMode attendanceMode,
    required int toleranceMinutes,
  }) async {
    // #region agent log
    debugLog(
      location: 'ClockOutUseCase:entry',
      message: 'ClockOut call',
      data: {'employeeId': employeeId, 'attendanceMode': attendanceMode.name},
      hypothesisId: 'H2',
    );
    // #endregion
    final open = await _sessionsRepo.getOpenSessionInfoForEmployee(employeeId);
    if (open == null) {
      // #region agent log
      debugLog(
        location: 'ClockOutUseCase:openNull',
        message: 'getOpenSessionInfoForEmployee returned null',
        data: {'employeeId': employeeId},
        hypothesisId: 'H2',
      );
      // #endregion
      return const ClockError(ClockErrorKind.noOpenSession);
    }

    if (attendanceMode == AttendanceMode.fixed) {
      final sessionStartLocal = DateTime.fromMillisecondsSinceEpoch(
        open.startTs,
        isUtc: true,
      ).toLocal();
      final sessionDate = DateTime(
        sessionStartLocal.year,
        sessionStartLocal.month,
        sessionStartLocal.day,
      );
      final schedule = await _schedulesRepo.resolveSchedule(
        employeeId: employeeId,
        dateLocal: sessionDate,
      );
      if (schedule.isDayOff || schedule.intervals.isEmpty) {
        // #region agent log
        debugLog(
          location: 'ClockOutUseCase:scheduleEmpty',
          message: 'Schedule empty or day off',
          data: {'employeeId': employeeId, 'sessionStartTs': open.startTs},
          hypothesisId: 'H1',
        );
        // #endregion
        return const ClockError(ClockErrorKind.noOpenSession);
      }
      final startMin = sessionStartLocal.hour * 60 + sessionStartLocal.minute;
      final interval = resolveIntervalForTime(startMin, schedule.intervals);
      if (interval == null) {
        // Session started outside schedule intervals (e.g. in Flexible mode).
        // Allow clock-out without tolerance check; cannot enforce schedule rules.
        // #region agent log
        debugLog(
          location: 'ClockOutUseCase:intervalNullAllowed',
          message:
              'Session start outside intervals - allowing clock-out without tolerance',
          data: {'employeeId': employeeId, 'startMin': startMin},
          hypothesisId: 'H1',
        );
        // #endregion
      } else {
        final now = DateTime.now();
        final nowMin = now.hour * 60 + now.minute;
        if (nowMin < interval.endMin - toleranceMinutes ||
            nowMin > interval.endMin + toleranceMinutes) {
          if (note == null || note.trim().isEmpty) {
            return nowMin < interval.endMin - toleranceMinutes
                ? const ClockNeedsNote(ClockNeedsNoteKind.earlyCheckOut)
                : const ClockNeedsNote(ClockNeedsNoteKind.lateCheckOut);
          }
        }
      }
    }

    final ok = await _sessionsRepo.closeOpenSession(
      employeeId: employeeId,
      note: note?.trim().isNotEmpty == true ? note!.trim() : null,
    );
    if (!ok) return const ClockError(ClockErrorKind.noOpenSession);
    return const ClockSaved();
  }
}

/// Read-only use case for watching employee lists. Exposes streams via domain port.
class WatchEmployeesUseCase {
  WatchEmployeesUseCase(this._repo);
  final IEmployeesRepo _repo;

  Stream<List<EmployeeInfo>> streamActiveEmployees() =>
      _repo.streamActiveEmployees();

  Stream<List<EmployeeInfo>> streamAllEmployees() => _repo.streamAllEmployees();
}

/// Read-only use case for watching session lists. Exposes streams via domain port.
class WatchSessionsUseCase {
  WatchSessionsUseCase(this._repo);
  final ISessionsRepo _repo;

  Stream<SessionInfo?> streamOpenSessionForEmployee(int employeeId) =>
      _repo.streamOpenSessionForEmployee(employeeId);

  Stream<List<SessionInfo>> streamSessionsForEmployeeToday(int employeeId) =>
      _repo.streamSessionsForEmployeeToday(employeeId);

  Stream<List<SessionInfo>> streamSessionsForEmployeeLastDays(
    int employeeId,
    int days,
  ) => _repo.streamSessionsForEmployeeLastDays(employeeId, days);

  Stream<List<SessionInfo>> streamSessions({
    required int employeeId,
    required int fromUtcMs,
    required int toUtcMs,
  }) => _repo.streamSessions(
    employeeId: employeeId,
    fromUtcMs: fromUtcMs,
    toUtcMs: toUtcMs,
  );

  Stream<List<SessionInfo>> streamSessionsForEmployeeOnDate(
    int employeeId,
    DateTime date,
  ) => _repo.streamSessionsForEmployeeOnDate(employeeId, date);

  Stream<List<SessionWithEmployeeInfo>> streamSessionsWithEmployee({
    int? employeeId,
    int? fromUtcMs,
    int? toUtcMs,
  }) => _repo.streamSessionsWithEmployee(
    employeeId: employeeId,
    fromUtcMs: fromUtcMs,
    toUtcMs: toUtcMs,
  );

  Stream<List<SessionWithEmployeeInfo>> streamOpenSessionsWithEmployee() =>
      _repo.streamOpenSessionsWithEmployee();

  Stream<List<SessionWithEmployeeInfo>> streamRecentSessionsWithEmployee({
    int limit = 10,
  }) => _repo.streamRecentSessionsWithEmployee(limit: limit);

  Stream<List<EmployeeReportRowInfo>> streamEmployeeReport({
    int? fromUtcMs,
    int? toUtcMs,
  }) => _repo.streamEmployeeReport(fromUtcMs: fromUtcMs, toUtcMs: toUtcMs);
}

/// Use case for report with norm and delta (planned time, worked - norm).
class EmployeeReportWithNormUseCase {
  EmployeeReportWithNormUseCase(
    this._sessionsRepo,
    this._schedulesRepo,
    this._absencesRepo,
  );
  final ISessionsRepo _sessionsRepo;
  final ISchedulesRepo _schedulesRepo;
  final IAbsencesRepo _absencesRepo;

  Stream<List<EmployeeReportRowInfo>> streamEmployeeReportWithNorm({
    int? fromUtcMs,
    int? toUtcMs,
  }) async* {
    await for (final rows in _sessionsRepo.streamEmployeeReport(
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
    )) {
      if (fromUtcMs == null || toUtcMs == null) {
        yield rows;
        continue;
      }
      final enriched = await _enrichWithNorm(rows, fromUtcMs, toUtcMs);
      yield enriched;
    }
  }

  Future<List<EmployeeReportRowInfo>> _enrichWithNorm(
    List<EmployeeReportRowInfo> rows,
    int fromUtcMs,
    int toUtcMs,
  ) async {
    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final fromDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
    final toDate = DateTime(toLocal.year, toLocal.month, toLocal.day);

    // Batched absences: one call per employee
    final absenceCoveredYmd = <int, Set<String>>{};
    for (final r in rows) {
      final ranges = await _absencesRepo
          .getApprovedAbsenceRangesForEmployeeInPeriod(
            r.employeeId,
            dateToYmd(fromDate),
            dateToYmd(toDate),
          );
      final set = <String>{};
      for (final range in ranges) {
        var d = DateTime(
          range.dateFrom.year,
          range.dateFrom.month,
          range.dateFrom.day,
        );
        final end = DateTime(
          range.dateTo.year,
          range.dateTo.month,
          range.dateTo.day,
        );
        while (!d.isAfter(end)) {
          set.add(dateToYmd(d));
          d = d.add(const Duration(days: 1));
        }
      }
      absenceCoveredYmd[r.employeeId] = set;
    }

    // Schedule cache: (employeeId, dateYmd) -> ResolvedSchedule
    final scheduleCache = <String, ResolvedSchedule>{};

    Future<ResolvedSchedule> getSchedule(int employeeId, DateTime date) async {
      final ymd = dateToYmd(date);
      final key = '$employeeId:$ymd';
      final cached = scheduleCache[key];
      if (cached != null) return cached;
      final s = await _schedulesRepo.resolveSchedule(
        employeeId: employeeId,
        dateLocal: date,
      );
      scheduleCache[key] = s;
      return s;
    }

    final result = <EmployeeReportRowInfo>[];
    for (final r in rows) {
      var normMs = 0;
      var anyDayHasSchedule = false;
      var d = fromDate;
      while (!d.isAfter(toDate)) {
        final ymd = dateToYmd(d);
        final hasAbsence =
            absenceCoveredYmd[r.employeeId]?.contains(ymd) ?? false;
        final schedule = await getSchedule(r.employeeId, d);
        if (schedule.source != 'none') anyDayHasSchedule = true;
        final dayMin = ReportNormCalculator.dayNormMinutes(
          schedule,
          hasAbsence,
        );
        normMs += dayMin * 60 * 1000; // minutes to ms
        d = d.add(const Duration(days: 1));
      }
      final deltaMs = r.totalMs - normMs;
      result.add(
        EmployeeReportRowInfo(
          employeeId: r.employeeId,
          employeeName: r.employeeName,
          totalMs: r.totalMs,
          closedSessionsCount: r.closedSessionsCount,
          normMs: normMs,
          deltaMs: deltaMs,
          anyDayHasSchedule: anyDayHasSchedule,
        ),
      );
    }
    return result;
  }
}

/// Use case for per-day report (worked, planned, balance) for one employee.
class EmployeeDayReportUseCase {
  EmployeeDayReportUseCase(
    this._sessionsRepo,
    this._schedulesRepo,
    this._absencesRepo,
  );
  final ISessionsRepo _sessionsRepo;
  final ISchedulesRepo _schedulesRepo;
  final IAbsencesRepo _absencesRepo;

  Stream<List<EmployeeDayReportRow>> streamEmployeeDayReport({
    required int employeeId,
    required int fromUtcMs,
    required int toUtcMs,
  }) async* {
    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final fromDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
    final toDate = DateTime(toLocal.year, toLocal.month, toLocal.day);
    final fromYmd = dateToYmd(fromDate);
    final toYmd = dateToYmd(toDate);

    final ranges = await _absencesRepo
        .getApprovedAbsenceRangesForEmployeeInPeriod(
          employeeId,
          fromYmd,
          toYmd,
        );
    final absenceYmd = <String>{};
    for (final range in ranges) {
      var d = DateTime(
        range.dateFrom.year,
        range.dateFrom.month,
        range.dateFrom.day,
      );
      final end = DateTime(
        range.dateTo.year,
        range.dateTo.month,
        range.dateTo.day,
      );
      while (!d.isAfter(end)) {
        absenceYmd.add(dateToYmd(d));
        d = d.add(const Duration(days: 1));
      }
    }

    final scheduleCache = <String, ResolvedSchedule>{};

    await for (final sessions in _sessionsRepo.streamSessions(
      employeeId: employeeId,
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
    )) {
      final workedByYmd = <String, int>{};
      for (
        var d = fromDate;
        !d.isAfter(toDate);
        d = d.add(const Duration(days: 1))
      ) {
        workedByYmd[dateToYmd(d)] = 0;
      }
      for (final s in sessions) {
        if (s.endTs == null) continue;
        final startLocal = DateTime.fromMillisecondsSinceEpoch(
          s.startTs,
          isUtc: true,
        ).toLocal();
        final ymd = dateToYmd(startLocal);
        if (workedByYmd.containsKey(ymd)) {
          workedByYmd[ymd] = workedByYmd[ymd]! + (s.endTs! - s.startTs);
        }
      }

      final rows = <EmployeeDayReportRow>[];
      var d = fromDate;
      while (!d.isAfter(toDate)) {
        final ymd = dateToYmd(d);
        ResolvedSchedule schedule;
        if (scheduleCache.containsKey(ymd)) {
          schedule = scheduleCache[ymd]!;
        } else {
          schedule = await _schedulesRepo.resolveSchedule(
            employeeId: employeeId,
            dateLocal: d,
          );
          scheduleCache[ymd] = schedule;
        }
        final hasAbsence = absenceYmd.contains(ymd);
        final dayMin = ReportNormCalculator.dayNormMinutes(
          schedule,
          hasAbsence,
        );
        final normMs = dayMin * 60 * 1000;
        final workedMs = workedByYmd[ymd] ?? 0;
        final deltaMs = workedMs - normMs;
        final hasSchedule = schedule.source != 'none';
        rows.add(
          EmployeeDayReportRow(
            dateYmd: ymd,
            workedMs: workedMs,
            normMs: normMs,
            deltaMs: deltaMs,
            hasSchedule: hasSchedule,
          ),
        );
        d = d.add(const Duration(days: 1));
      }
      rows.sort((a, b) => a.dateYmd.compareTo(b.dateYmd));
      yield rows;
    }
  }

  /// One-shot fetch of per-day report rows for export.
  Future<List<EmployeeDayReportRow>> getEmployeeDayReport({
    required int employeeId,
    required int fromUtcMs,
    required int toUtcMs,
  }) => streamEmployeeDayReport(
    employeeId: employeeId,
    fromUtcMs: fromUtcMs,
    toUtcMs: toUtcMs,
  ).first;
}

/// Use case for Journal timeline overview: per-day, per-employee states.
/// Batch-oriented: fetches sessions and employees via streams, then aggregates in memory.
class JournalDayOverviewUseCase {
  JournalDayOverviewUseCase(
    this._sessionsRepo,
    this._absencesRepo,
    this._schedulesRepo,
    this._employeesRepo,
  );
  final ISessionsRepo _sessionsRepo;
  final IAbsencesRepo _absencesRepo;
  final ISchedulesRepo _schedulesRepo;
  final IEmployeesRepo _employeesRepo;

  Stream<List<JournalDayOverviewRow>> streamDayOverview({
    int? employeeId,
    required int fromUtcMs,
    required int toUtcMs,
  }) {
    final controller =
        StreamController<List<JournalDayOverviewRow>>.broadcast();
    List<EmployeeInfo>? latestEmployees;
    List<SessionWithEmployeeInfo>? latestSessions;

    late StreamSubscription<void> subEmp;
    late StreamSubscription<void> subSess;

    void maybeEmit() async {
      if (latestEmployees == null || latestSessions == null) return;
      final rows = await _computeRows(
        employees: latestEmployees!,
        sessions: latestSessions!,
        fromUtcMs: fromUtcMs,
        toUtcMs: toUtcMs,
        employeeIdFilter: employeeId,
      );
      if (!controller.isClosed) controller.add(rows);
    }

    subEmp = _employeesRepo.streamActiveEmployees().listen((e) {
      latestEmployees = employeeId != null
          ? e.where((x) => x.id == employeeId).toList()
          : List<EmployeeInfo>.from(e);
      maybeEmit();
    });

    subSess = _sessionsRepo
        .streamSessionsWithEmployee(
          employeeId: employeeId,
          fromUtcMs: fromUtcMs,
          toUtcMs: toUtcMs,
        )
        .listen((s) {
          latestSessions = s;
          maybeEmit();
        });

    controller.onCancel = () {
      subEmp.cancel();
      subSess.cancel();
    };

    return controller.stream;
  }

  Future<List<JournalDayOverviewRow>> _computeRows({
    required List<EmployeeInfo> employees,
    required List<SessionWithEmployeeInfo> sessions,
    required int fromUtcMs,
    required int toUtcMs,
    int? employeeIdFilter,
  }) async {
    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final fromDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
    final toDate = DateTime(toLocal.year, toLocal.month, toLocal.day);
    final fromYmd = dateToYmd(fromDate);
    final toYmd = dateToYmd(toDate);

    final employeeIds = employees.map((e) => e.id).toSet();
    if (employeeIdFilter != null && !employeeIds.contains(employeeIdFilter)) {
      return [];
    }

    final workedByEmpYmd = <int, Map<String, int>>{};
    final ongoingByEmpYmd = <int, Set<String>>{};
    for (final empId in employeeIds) {
      workedByEmpYmd[empId] = <String, int>{};
      ongoingByEmpYmd[empId] = <String>{};
    }

    for (
      var d = fromDate;
      !d.isAfter(toDate);
      d = d.add(const Duration(days: 1))
    ) {
      final ymd = dateToYmd(d);
      for (final empId in employeeIds) {
        workedByEmpYmd[empId]![ymd] = 0;
      }
    }

    for (final sw in sessions) {
      final empId = sw.employee.id;
      if (!employeeIds.contains(empId)) continue;
      final s = sw.session;
      final startLocal = DateTime.fromMillisecondsSinceEpoch(
        s.startTs,
        isUtc: true,
      ).toLocal();
      final ymd = dateToYmd(startLocal);
      if (!workedByEmpYmd[empId]!.containsKey(ymd)) continue;
      if (s.endTs == null) {
        ongoingByEmpYmd[empId]!.add(ymd);
      } else {
        workedByEmpYmd[empId]![ymd] =
            workedByEmpYmd[empId]![ymd]! + (s.endTs! - s.startTs);
      }
    }

    final absenceByEmpYmd = <int, Set<String>>{};
    final absenceFutures = employees.map(
      (e) => _absencesRepo.getApprovedAbsenceRangesForEmployeeInPeriod(
        e.id,
        fromYmd,
        toYmd,
      ),
    );
    final absenceRangesList = await Future.wait(absenceFutures);
    for (var i = 0; i < employees.length; i++) {
      final empId = employees[i].id;
      final set = <String>{};
      for (final range in absenceRangesList[i]) {
        var d = DateTime(
          range.dateFrom.year,
          range.dateFrom.month,
          range.dateFrom.day,
        );
        final end = DateTime(
          range.dateTo.year,
          range.dateTo.month,
          range.dateTo.day,
        );
        while (!d.isAfter(end)) {
          set.add(dateToYmd(d));
          d = d.add(const Duration(days: 1));
        }
      }
      absenceByEmpYmd[empId] = set;
    }

    final scheduleCache = <String, ResolvedSchedule>{};

    Future<ResolvedSchedule> getSchedule(int empId, DateTime date) async {
      final ymd = dateToYmd(date);
      final key = '$empId:$ymd';
      final cached = scheduleCache[key];
      if (cached != null) return cached;
      final s = await _schedulesRepo.resolveSchedule(
        employeeId: empId,
        dateLocal: date,
      );
      scheduleCache[key] = s;
      return s;
    }

    final result = <JournalDayOverviewRow>[];
    for (final emp in employees) {
      final cells = <JournalDayState>[];
      var d = fromDate;
      while (!d.isAfter(toDate)) {
        final ymd = dateToYmd(d);
        final hasOngoing = ongoingByEmpYmd[emp.id]?.contains(ymd) ?? false;
        final workedMs = workedByEmpYmd[emp.id]?[ymd] ?? 0;
        final hasWorked = workedMs > 0;
        final hasAbsence = absenceByEmpYmd[emp.id]?.contains(ymd) ?? false;
        final schedule = await getSchedule(emp.id, d);
        final hasSchedule = schedule.source != 'none';

        final state = _resolveState(
          hasOngoing: hasOngoing,
          hasWorked: hasWorked,
          hasAbsence: hasAbsence,
          hasSchedule: hasSchedule,
        );
        cells.add(state);
        d = d.add(const Duration(days: 1));
      }
      result.add(
        JournalDayOverviewRow(
          employeeId: emp.id,
          firstName: emp.firstName,
          lastName: emp.lastName,
          cells: cells,
        ),
      );
    }
    return result;
  }

  JournalDayState _resolveState({
    required bool hasOngoing,
    required bool hasWorked,
    required bool hasAbsence,
    required bool hasSchedule,
  }) {
    if (hasOngoing) return JournalDayState.ongoing;
    if (hasWorked) return JournalDayState.present;
    if (hasAbsence) return JournalDayState.approvedAbsence;
    if (hasSchedule) return JournalDayState.expectedNoShow;
    return JournalDayState.noData;
  }
}

/// Use case for Journal detailed timeline: interval-level data per day per employee.
/// Clips intervals to the allowed working window. Returns display-oriented projections.
class JournalIntervalOverviewUseCase {
  JournalIntervalOverviewUseCase(
    this._sessionsRepo,
    this._absencesRepo,
    this._employeesRepo,
  );
  final ISessionsRepo _sessionsRepo;
  final IAbsencesRepo _absencesRepo;
  final IEmployeesRepo _employeesRepo;

  Stream<List<JournalIntervalRow>> streamIntervalOverview({
    int? employeeId,
    required int fromUtcMs,
    required int toUtcMs,
    required int startMin,
    required int endMin,
  }) {
    final controller = StreamController<List<JournalIntervalRow>>.broadcast();
    List<EmployeeInfo>? latestEmployees;
    List<SessionWithEmployeeInfo>? latestSessions;

    late StreamSubscription<void> subEmp;
    late StreamSubscription<void> subSess;

    void maybeEmit() async {
      if (latestEmployees == null || latestSessions == null) return;
      final rows = await _computeRows(
        employees: latestEmployees!,
        sessions: latestSessions!,
        fromUtcMs: fromUtcMs,
        toUtcMs: toUtcMs,
        startMin: startMin,
        endMin: endMin,
        employeeIdFilter: employeeId,
      );
      if (!controller.isClosed) controller.add(rows);
    }

    subEmp = _employeesRepo.streamActiveEmployees().listen((e) {
      latestEmployees = employeeId != null
          ? e.where((x) => x.id == employeeId).toList()
          : List<EmployeeInfo>.from(e);
      maybeEmit();
    });

    subSess = _sessionsRepo
        .streamSessionsWithEmployee(
          employeeId: employeeId,
          fromUtcMs: fromUtcMs,
          toUtcMs: toUtcMs,
        )
        .listen((s) {
          latestSessions = s;
          maybeEmit();
        });

    controller.onCancel = () {
      subEmp.cancel();
      subSess.cancel();
    };

    return controller.stream;
  }

  Future<List<JournalIntervalRow>> _computeRows({
    required List<EmployeeInfo> employees,
    required List<SessionWithEmployeeInfo> sessions,
    required int fromUtcMs,
    required int toUtcMs,
    required int startMin,
    required int endMin,
    int? employeeIdFilter,
  }) async {
    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final fromDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
    final toDate = DateTime(toLocal.year, toLocal.month, toLocal.day);
    final fromYmd = dateToYmd(fromDate);
    final toYmd = dateToYmd(toDate);
    final nowUtcMs = DateTime.now().toUtc().millisecondsSinceEpoch;

    final employeeIds = employees.map((e) => e.id).toSet();
    if (employeeIdFilter != null && !employeeIds.contains(employeeIdFilter)) {
      return [];
    }

    final absenceByEmpYmd = <int, Set<String>>{};
    final absenceFutures = employees.map(
      (e) => _absencesRepo.getApprovedAbsenceRangesForEmployeeInPeriod(
        e.id,
        fromYmd,
        toYmd,
      ),
    );
    final absenceRangesList = await Future.wait(absenceFutures);
    for (var i = 0; i < employees.length; i++) {
      final empId = employees[i].id;
      final set = <String>{};
      for (final range in absenceRangesList[i]) {
        var d = DateTime(
          range.dateFrom.year,
          range.dateFrom.month,
          range.dateFrom.day,
        );
        final end = DateTime(
          range.dateTo.year,
          range.dateTo.month,
          range.dateTo.day,
        );
        while (!d.isAfter(end)) {
          set.add(dateToYmd(d));
          d = d.add(const Duration(days: 1));
        }
      }
      absenceByEmpYmd[empId] = set;
    }

    final result = <JournalIntervalRow>[];
    for (final emp in employees) {
      final cells = <List<JournalIntervalItem>>[];
      var d = fromDate;
      while (!d.isAfter(toDate)) {
        final ymd = dateToYmd(d);
        final dayStart = DateTime(d.year, d.month, d.day);
        final windowStart = dayStart
            .add(Duration(minutes: startMin))
            .toUtc()
            .millisecondsSinceEpoch;
        final windowEnd = dayStart
            .add(Duration(minutes: endMin))
            .toUtc()
            .millisecondsSinceEpoch;

        final intervals = <JournalIntervalItem>[];

        for (final sw in sessions) {
          if (sw.employee.id != emp.id) continue;
          final s = sw.session;
          final startLocal = DateTime.fromMillisecondsSinceEpoch(
            s.startTs,
            isUtc: true,
          ).toLocal();
          if (dateToYmd(startLocal) != ymd) continue;

          final effectiveEnd = s.endTs ?? nowUtcMs;
          if (!isSameLocalCalendarDay(s.startTs, effectiveEnd)) continue;

          var clipStart = s.startTs;
          var clipEnd = effectiveEnd;
          if (s.endTs == null) {
            clipEnd = effectiveEnd < windowEnd ? effectiveEnd : windowEnd;
          }
          if (clipStart < windowStart) clipStart = windowStart;
          if (clipEnd > windowEnd) clipEnd = windowEnd;
          if (clipStart >= clipEnd) continue;

          final kind = s.endTs == null
              ? JournalIntervalKind.ongoing
              : JournalIntervalKind.work;
          intervals.add(
            JournalIntervalItem(
              kind: kind,
              startUtcMs: clipStart,
              endUtcMs: clipEnd,
            ),
          );
        }

        final hasAbsence = absenceByEmpYmd[emp.id]?.contains(ymd) ?? false;
        if (hasAbsence) {
          intervals.add(
            JournalIntervalItem(
              kind: JournalIntervalKind.absence,
              startUtcMs: windowStart,
              endUtcMs: windowEnd,
            ),
          );
        }

        intervals.sort((a, b) => a.startUtcMs.compareTo(b.startUtcMs));
        cells.add(intervals);
        d = d.add(const Duration(days: 1));
      }

      result.add(
        JournalIntervalRow(
          employeeId: emp.id,
          firstName: emp.firstName,
          lastName: emp.lastName,
          cells: cells,
        ),
      );
    }
    return result;
  }
}

/// Terminal use case for employee PIN verification and policy acknowledgment.
class TerminalEmployeeAuthUseCase {
  TerminalEmployeeAuthUseCase(this._repo);
  final IEmployeesRepo _repo;

  Future<EmployeePinStatus> getPinStatus(int employeeId) =>
      _repo.getPinStatus(employeeId);

  Future<bool> verifyEmployeePin({
    required int employeeId,
    required String pin,
  }) => _repo.verifyEmployeePin(employeeId: employeeId, pin: pin);

  Future<void> updateEmployeePolicyAcknowledged(
    int employeeId, {
    required bool acknowledged,
    required int? acknowledgedAt,
  }) => _repo.updateEmployeePolicyAcknowledged(
    employeeId,
    acknowledged: acknowledged,
    acknowledgedAt: acknowledgedAt,
  );
}

/// Terminal use case for closing an open session with explicit end time.
class CloseOpenSessionWithEndUseCase {
  CloseOpenSessionWithEndUseCase(this._repo);
  final ISessionsRepo _repo;

  Future<bool> call({
    required int employeeId,
    required int endUtcMs,
    String? note,
    String? updatedBy,
  }) => _repo.closeOpenSessionWithEnd(
    employeeId: employeeId,
    endUtcMs: endUtcMs,
    note: note,
    updatedBy: updatedBy,
  );
}

/// Admin use case for updating sessions (edit end time, note, etc.).
class UpdateSessionAsAdminUseCase {
  UpdateSessionAsAdminUseCase(this._repo);
  final ISessionsRepo _repo;

  Future<void> call({
    required int sessionId,
    required int startUtcMs,
    required int? endUtcMs,
    required String? note,
    required String updateReason,
    String? updatedBy,
  }) => _repo.updateSessionAsAdmin(
    sessionId: sessionId,
    startUtcMs: startUtcMs,
    endUtcMs: endUtcMs,
    note: note,
    updateReason: updateReason,
    updatedBy: updatedBy,
  );
}

/// Admin use case for absence CRUD and status updates. Use from UI instead of repo.
class AbsencesAdminUseCase {
  AbsencesAdminUseCase(this._repo);
  final IAbsencesRepo _repo;

  void validateEmployeeDateRestriction(
    String type,
    String dateFrom,
    String dateTo,
  ) => _repo.validateEmployeeDateRestriction(type, dateFrom, dateTo);

  Future<int> insertAbsence({
    required int employeeId,
    required String dateFrom,
    required String dateTo,
    required String type,
    String? note,
    int? createdByEmployeeId,
  }) => _repo.insertAbsence(
    employeeId: employeeId,
    dateFrom: dateFrom,
    dateTo: dateTo,
    type: type,
    note: note,
    createdByEmployeeId: createdByEmployeeId,
  );

  Future<void> updateAbsence({
    required int id,
    String? dateFrom,
    String? dateTo,
    String? type,
    String? note,
  }) => _repo.updateAbsence(
    id: id,
    dateFrom: dateFrom,
    dateTo: dateTo,
    type: type,
    note: note,
  );

  Future<void> deleteAbsence(int id) => _repo.deleteAbsence(id);

  Future<void> updateAbsenceStatus({
    required int id,
    required String status,
    String? approvedBy,
    String? rejectReason,
  }) => _repo.updateAbsenceStatus(
    id: id,
    status: status,
    approvedBy: approvedBy,
    rejectReason: rejectReason,
  );
}

/// Read-only use case for watching absence lists. Exposes streams via domain port.
class WatchAbsencesUseCase {
  WatchAbsencesUseCase(this._repo);
  final IAbsencesRepo _repo;

  Stream<List<AbsenceWithEmployeeInfo>> streamAbsences({
    int? employeeId,
    String? fromDate,
    String? toDate,
    String? status,
  }) => _repo.streamAbsences(
    employeeId: employeeId,
    fromDate: fromDate,
    toDate: toDate,
    status: status,
  );
}

/// Admin use case for employee CRUD, pin, and assignment lookup.
class EmployeesAdminUseCase {
  EmployeesAdminUseCase(this._employeesRepo, this._schedulesRepo);
  final IEmployeesRepo _employeesRepo;
  final dynamic _schedulesRepo; // SchedulesRepo (no port yet)

  Future<EmployeeDetails?> getEmployeeDetails(int id) =>
      _employeesRepo.getEmployeeDetails(id);

  Future<String> getSuggestedEmployeeCode() =>
      _employeesRepo.getSuggestedEmployeeCode();

  Future<bool> checkCodeUnique(String code, {int? excludeEmployeeId}) =>
      _employeesRepo.checkCodeUnique(
        code,
        excludeEmployeeId: excludeEmployeeId,
      );

  Future<int> createEmployeeFull({
    required String code,
    required String firstName,
    required String lastName,
    EmployeeStatus status = EmployeeStatus.active,
    int? hireDate,
    int? terminationDate,
    int? vacationDaysPerYear,
    String employeeRole = 'employee',
    bool usePin = false,
    bool useNfc = false,
    String? accessToken,
    String? accessNote,
    String? employmentType,
    double? weeklyHours,
    String? email,
    String? phone,
    String? secondaryPhone,
    String? department,
    String? jobTitle,
    String? internalComment,
    bool policyAcknowledged = false,
    int? policyAcknowledgedAt,
    required int? templateId,
    String? createdBy,
  }) => _employeesRepo.createEmployeeFull(
    code: code,
    firstName: firstName,
    lastName: lastName,
    status: status,
    hireDate: hireDate,
    terminationDate: terminationDate,
    vacationDaysPerYear: vacationDaysPerYear,
    employeeRole: employeeRole,
    usePin: usePin,
    useNfc: useNfc,
    accessToken: accessToken,
    accessNote: accessNote,
    employmentType: employmentType,
    weeklyHours: weeklyHours,
    email: email,
    phone: phone,
    secondaryPhone: secondaryPhone,
    department: department,
    jobTitle: jobTitle,
    internalComment: internalComment,
    policyAcknowledged: policyAcknowledged,
    policyAcknowledgedAt: policyAcknowledgedAt,
    templateId: templateId,
    createdBy: createdBy,
  );

  Future<void> updateEmployeeFull({
    required int id,
    required String code,
    required String firstName,
    required String lastName,
    EmployeeStatus status = EmployeeStatus.active,
    int? hireDate,
    int? terminationDate,
    int? vacationDaysPerYear,
    String employeeRole = 'employee',
    bool usePin = false,
    bool useNfc = false,
    String? accessToken,
    String? accessNote,
    String? employmentType,
    double? weeklyHours,
    String? email,
    String? phone,
    String? secondaryPhone,
    String? department,
    String? jobTitle,
    String? internalComment,
    bool policyAcknowledged = false,
    int? policyAcknowledgedAt,
    int? templateId,
    String? updatedBy,
  }) => _employeesRepo.updateEmployeeFull(
    id: id,
    code: code,
    firstName: firstName,
    lastName: lastName,
    status: status,
    hireDate: hireDate,
    terminationDate: terminationDate,
    vacationDaysPerYear: vacationDaysPerYear,
    employeeRole: employeeRole,
    usePin: usePin,
    useNfc: useNfc,
    accessToken: accessToken,
    accessNote: accessNote,
    employmentType: employmentType,
    weeklyHours: weeklyHours,
    email: email,
    phone: phone,
    secondaryPhone: secondaryPhone,
    department: department,
    jobTitle: jobTitle,
    internalComment: internalComment,
    policyAcknowledged: policyAcknowledged,
    policyAcknowledgedAt: policyAcknowledgedAt,
    templateId: templateId,
    updatedBy: updatedBy,
  );

  Future<EmployeePinStatus> getPinStatus(int employeeId) =>
      _employeesRepo.getPinStatus(employeeId);

  Future<void> setEmployeePin({required int employeeId, required String pin}) =>
      _employeesRepo.setEmployeePin(employeeId: employeeId, pin: pin);

  Future<void> resetEmployeePin(int employeeId) =>
      _employeesRepo.resetEmployeePin(employeeId);

  Future<int?> getAssignmentTemplateId(int employeeId) =>
      _schedulesRepo.getAssignmentTemplateId(employeeId);
}

/// Use case for schedule template CRUD and week editing.
class SchedulesTemplatesUseCase {
  SchedulesTemplatesUseCase(this._schedulesRepo);
  final dynamic _schedulesRepo; // SchedulesRepo

  Future<int> createTemplate(String name) =>
      _schedulesRepo.createTemplate(name);

  Future<void> updateTemplateName({required int id, required String name}) =>
      _schedulesRepo.updateTemplateName(id: id, name: name);

  Future<bool> hasAssignments(int templateId) =>
      _schedulesRepo.hasAssignments(templateId);

  Future<void> deleteTemplate(int templateId) =>
      _schedulesRepo.deleteTemplate(templateId);

  Future<void> setTemplateActive({required int id, required bool isActive}) =>
      _schedulesRepo.setTemplateActive(id: id, isActive: isActive);

  Future<void> saveTemplateDay({
    required int templateId,
    required int weekday,
    required bool isDayOff,
    required List<ScheduleInterval> intervals,
  }) => _schedulesRepo.saveTemplateDay(
    templateId: templateId,
    weekday: weekday,
    isDayOff: isDayOff,
    intervals: intervals,
  );

  Future<void> saveTemplateWeek({
    required int templateId,
    required Map<int, DaySchedule> days,
  }) => _schedulesRepo.saveTemplateWeek(templateId: templateId, days: days);

  Future<int> createTemplateWithWeek({
    required String name,
    required Map<int, DaySchedule> days,
  }) => _schedulesRepo.createTemplateWithWeek(name: name, days: days);

  Stream<Map<int, DaySchedule>> streamTemplateWeek(int templateId) =>
      _schedulesRepo.watchTemplateWeek(templateId);

  Future<Map<int, DaySchedule>> getTemplateWeek(int templateId) =>
      _schedulesRepo.getTemplateWeek(templateId);
}

/// Use case for changing admin PIN.
class ChangeAdminPinUseCase {
  ChangeAdminPinUseCase(this._authRepo);
  final IAuthRepo _authRepo;

  /// Returns true if successful, false if current PIN invalid.
  /// Throws [DomainValidationException] if PIN format invalid (digits only, min 4).
  Future<bool> changeAdminPin({
    required String currentPin,
    required String newPin,
  }) {
    if (!isValidAdminPinFormat(currentPin) || !isValidAdminPinFormat(newPin)) {
      throw const DomainValidationException('invalid_pin_format');
    }
    return _authRepo.changeAdminPin(currentPin: currentPin, newPin: newPin);
  }
}
