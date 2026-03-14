import 'package:drift/drift.dart';

import '../../domain/entities/employee_info.dart';
import '../../domain/entities/employee_status.dart';
import '../../domain/entities/employee_report_row_info.dart';
import '../../core/debug_session_log.dart';
import '../../domain/entities/session_info.dart';
import '../../domain/entities/session_ref.dart';
import '../../domain/entities/session_with_employee_info.dart';
import '../../domain/ports/sessions_repo_port.dart';
import '../db/app_db.dart';
import '../../common/utils/date_utils.dart';
import '../../core/domain_errors.dart';
import '../../common/utils/utc_clock.dart';
import '../db/work_session_db_values.dart';
import 'repo_guard.dart';

class SessionWithEmployee {
  const SessionWithEmployee({required this.session, required this.employee});

  final WorkSession session;
  final Employee employee;
}

class EmployeeReportRow {
  const EmployeeReportRow({
    required this.employeeId,
    required this.employeeName,
    required this.totalMs,
    required this.closedSessionsCount,
  });

  final int employeeId;
  final String employeeName;
  final int totalMs;
  final int closedSessionsCount;
}

class SessionsRepo implements ISessionsRepo {
  SessionsRepo(this._db);

  final AppDb _db;

  SimpleSelectStatement<$WorkSessionsTable, WorkSession> _openSessionQuery(
    int employeeId,
  ) {
    return (_db.select(_db.workSessions)
      ..where(
        (s) =>
            s.employeeId.equals(employeeId) &
            s.endTs.isNull() &
            s.status.equals(WorkSessionStatusDb.open),
      )
      ..orderBy([(s) => OrderingTerm.desc(s.startTs)])
      ..limit(1));
  }

  Stream<WorkSession?> watchOpenSessionForEmployee(int employeeId) {
    return _openSessionQuery(employeeId).watchSingleOrNull();
  }

  @override
  Future<SessionRef?> getOpenSessionForEmployee(int employeeId) async {
    final row = await _openSessionQuery(employeeId).getSingleOrNull();
    return row != null ? SessionRef(id: row.id) : null;
  }

  @override
  Future<SessionInfo?> getOpenSessionInfoForEmployee(int employeeId) async {
    final row = await _openSessionQuery(employeeId).getSingleOrNull();
    // #region agent log
    debugLog(
      location: 'SessionsRepo:getOpenSessionInfoForEmployee',
      message: 'Query result',
      data: {
        'employeeId': employeeId,
        'found': row != null,
        if (row != null) 'startTs': row.startTs,
      },
      hypothesisId: 'H2',
    );
    // #endregion
    return row != null ? _toSessionInfo(row) : null;
  }

  Future<WorkSession?> getOpenSessionForEmployeeRaw(int employeeId) {
    return _openSessionQuery(employeeId).getSingleOrNull();
  }

  static SessionInfo _toSessionInfo(WorkSession w) => SessionInfo(
    id: w.id,
    startTs: w.startTs,
    endTs: w.endTs,
    status: w.status,
    note: w.note,
  );

  static EmployeeInfo _toEmployeeInfo(Employee e) => EmployeeInfo(
    id: e.id,
    firstName: e.firstName,
    lastName: e.lastName,
    status: employeeStatusFromString(e.status),
    usePin: e.usePin == 1,
    policyAcknowledged: e.policyAcknowledged == 1,
  );

  static SessionWithEmployeeInfo _toSessionWithEmployeeInfo(
    SessionWithEmployee sw,
  ) => SessionWithEmployeeInfo(
    session: _toSessionInfo(sw.session),
    employee: _toEmployeeInfo(sw.employee),
  );

  @override
  Stream<SessionInfo?> streamOpenSessionForEmployee(int employeeId) {
    return watchOpenSessionForEmployee(
      employeeId,
    ).map((w) => w != null ? _toSessionInfo(w) : null);
  }

  @override
  Stream<List<SessionInfo>> streamSessionsForEmployeeToday(int employeeId) {
    return watchSessionsForEmployeeToday(
      employeeId,
    ).map((list) => list.map(_toSessionInfo).toList());
  }

  @override
  Stream<List<SessionInfo>> streamSessions({
    required int employeeId,
    required int fromUtcMs,
    required int toUtcMs,
  }) {
    return watchSessions(
      employeeId: employeeId,
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
    ).map((list) => list.map(_toSessionInfo).toList());
  }

  @override
  Stream<List<SessionInfo>> streamSessionsForEmployeeOnDate(
    int employeeId,
    DateTime date,
  ) {
    return watchSessionsForEmployeeOnDate(
      employeeId,
      date,
    ).map((list) => list.map(_toSessionInfo).toList());
  }

  @override
  Stream<List<SessionInfo>> streamSessionsForEmployeeLastDays(
    int employeeId,
    int days,
  ) {
    return watchSessionsForEmployeeLastDays(
      employeeId,
      days,
    ).map((list) => list.map(_toSessionInfo).toList());
  }

  @override
  Stream<List<SessionWithEmployeeInfo>> streamSessionsWithEmployee({
    int? employeeId,
    int? fromUtcMs,
    int? toUtcMs,
  }) {
    return watchSessionsWithEmployee(
      employeeId: employeeId,
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
    ).map((list) => list.map(_toSessionWithEmployeeInfo).toList());
  }

  @override
  Stream<List<SessionWithEmployeeInfo>> streamOpenSessionsWithEmployee() {
    return watchOpenSessionsWithEmployee().map(
      (list) => list.map(_toSessionWithEmployeeInfo).toList(),
    );
  }

  @override
  Stream<List<SessionWithEmployeeInfo>> streamRecentSessionsWithEmployee({
    int limit = 10,
  }) {
    return watchRecentSessionsWithEmployee(
      limit: limit,
    ).map((list) => list.map(_toSessionWithEmployeeInfo).toList());
  }

  @override
  Future<int> createOpenSession({
    required int employeeId,
    int? deviceId,
    String source = WorkSessionSourceDb.terminal,
    String? note,
    String? createdBy,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      return _db
          .into(_db.workSessions)
          .insert(
            WorkSessionsCompanion.insert(
              employeeId: employeeId,
              deviceId: Value(deviceId),
              startTs: now,
              endTs: const Value(null),
              status: WorkSessionStatusDb.open,
              source: source,
              note: Value(note),
              createdAt: now,
              createdBy: Value(createdBy),
              updatedAt: const Value(null),
              updatedBy: const Value(null),
              updateReason: const Value(null),
            ),
          );
    });
  }

  @override
  Future<bool> closeOpenSession({
    required int employeeId,
    String? note,
    String source = WorkSessionSourceDb.terminal,
    String? updatedBy,
  }) async {
    return guardRepoCall(() async {
      return _db.transaction(() async {
        final open = await getOpenSessionForEmployee(employeeId);
        if (open == null) return false;

        final now = UtcClock.nowMs();
        final rows =
            await (_db.update(
              _db.workSessions,
            )..where((s) => s.id.equals(open.id))).write(
              WorkSessionsCompanion(
                endTs: Value(now),
                status: const Value(WorkSessionStatusDb.closed),
                note: Value(note),
                source: Value(source),
                updatedAt: Value(now),
                updatedBy: Value(updatedBy),
              ),
            );
        return rows > 0;
      });
    });
  }

  /// Closes the open session for [employeeId] with the given [endUtcMs].
  /// Returns false if no open session or if endUtcMs <= session.startTs.
  @override
  Future<bool> closeOpenSessionWithEnd({
    required int employeeId,
    required int endUtcMs,
    String? note,
    String source = WorkSessionSourceDb.terminal,
    String? updatedBy,
  }) async {
    return guardRepoCall(() async {
      return _db.transaction(() async {
        final open = await getOpenSessionForEmployeeRaw(employeeId);
        if (open == null) return false;
        if (endUtcMs <= open.startTs) return false;
        if (!isSameLocalCalendarDay(open.startTs, endUtcMs)) {
          throw const DomainValidationException('sessionsErrorSameDayRequired');
        }

        final now = UtcClock.nowMs();
        final rows =
            await (_db.update(
              _db.workSessions,
            )..where((s) => s.id.equals(open.id))).write(
              WorkSessionsCompanion(
                endTs: Value(endUtcMs),
                status: const Value(WorkSessionStatusDb.closed),
                note: Value(note),
                source: Value(source),
                updatedAt: Value(now),
                updatedBy: Value(updatedBy),
              ),
            );
        return rows > 0;
      });
    });
  }

  /// Sessions for [employeeId] that started on [date] (local date).
  Stream<List<WorkSession>> watchSessionsForEmployeeOnDate(
    int employeeId,
    DateTime date,
  ) {
    final range = localDayRangeUtcMs(date);
    return watchSessions(
      employeeId: employeeId,
      fromUtcMs: range.fromUtcMs,
      toUtcMs: range.toUtcMs,
    );
  }

  /// Sessions for [employeeId] that started today (local date).
  Stream<List<WorkSession>> watchSessionsForEmployeeToday(int employeeId) {
    final range = localDayRangeUtcMs(DateTime.now());
    return watchSessions(
      employeeId: employeeId,
      fromUtcMs: range.fromUtcMs,
      toUtcMs: range.toUtcMs,
    );
  }

  /// Sessions for [employeeId] in the last [days] days (inclusive of today).
  Stream<List<WorkSession>> watchSessionsForEmployeeLastDays(
    int employeeId,
    int days,
  ) {
    final now = DateTime.now();
    final todayRange = localDayRangeUtcMs(now);
    final startDate = now.subtract(Duration(days: days - 1));
    final startRange = localDayRangeUtcMs(
      DateTime(startDate.year, startDate.month, startDate.day),
    );
    return watchSessions(
      employeeId: employeeId,
      fromUtcMs: startRange.fromUtcMs,
      toUtcMs: todayRange.toUtcMs,
    );
  }

  Stream<List<WorkSession>> watchSessions({
    int? employeeId,
    int? fromUtcMs,
    int? toUtcMs,
  }) {
    final q = _db.select(_db.workSessions);
    if (employeeId != null) {
      q.where((s) => s.employeeId.equals(employeeId));
    }
    if (fromUtcMs != null) {
      q.where((s) => s.startTs.isBiggerOrEqualValue(fromUtcMs));
    }
    if (toUtcMs != null) {
      q.where((s) => s.startTs.isSmallerOrEqualValue(toUtcMs));
    }
    q.orderBy([(s) => OrderingTerm.desc(s.startTs)]);
    return q.watch();
  }

  Stream<List<SessionWithEmployee>> watchSessionsWithEmployee({
    int? employeeId,
    int? fromUtcMs,
    int? toUtcMs,
  }) {
    final ws = _db.workSessions;
    final e = _db.employees;

    final join = _db.select(ws).join([
      innerJoin(e, e.id.equalsExp(ws.employeeId)),
    ]);

    if (employeeId != null) {
      join.where(ws.employeeId.equals(employeeId));
    }
    if (fromUtcMs != null) {
      join.where(ws.startTs.isBiggerOrEqualValue(fromUtcMs));
    }
    if (toUtcMs != null) {
      join.where(ws.startTs.isSmallerOrEqualValue(toUtcMs));
    }

    join.orderBy([OrderingTerm.desc(ws.startTs)]);

    return join.watch().map(
      (rows) => rows
          .map(
            (r) => SessionWithEmployee(
              session: r.readTable(ws),
              employee: r.readTable(e),
            ),
          )
          .toList(growable: false),
    );
  }

  /// All open sessions (status=OPEN, endTs IS NULL) with employee data.
  Stream<List<SessionWithEmployee>> watchOpenSessionsWithEmployee() {
    final ws = _db.workSessions;
    final e = _db.employees;

    final join = _db.select(ws).join([
      innerJoin(e, e.id.equalsExp(ws.employeeId)),
    ]);

    join.where(ws.status.equals(WorkSessionStatusDb.open));
    join.where(ws.endTs.isNull());
    join.orderBy([OrderingTerm.desc(ws.startTs)]);

    return join.watch().map(
      (rows) => rows
          .map(
            (r) => SessionWithEmployee(
              session: r.readTable(ws),
              employee: r.readTable(e),
            ),
          )
          .toList(growable: false),
    );
  }

  /// Recent sessions with employee data, limited to [limit] rows.
  Stream<List<SessionWithEmployee>> watchRecentSessionsWithEmployee({
    int limit = 10,
  }) {
    final ws = _db.workSessions;
    final e = _db.employees;

    final join = _db.select(ws).join([
      innerJoin(e, e.id.equalsExp(ws.employeeId)),
    ]);

    join.orderBy([OrderingTerm.desc(ws.startTs)]);
    join.limit(limit);

    return join.watch().map(
      (rows) => rows
          .map(
            (r) => SessionWithEmployee(
              session: r.readTable(ws),
              employee: r.readTable(e),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> updateSessionAsAdmin({
    required int sessionId,
    required int startUtcMs,
    required int? endUtcMs,
    required String? note,
    required String updateReason,
    String? updatedBy,
  }) async {
    return guardRepoCall(() async {
      if (endUtcMs != null) {
        if (endUtcMs <= startUtcMs) {
          throw const DomainValidationException(
            'End time must be after start time.',
          );
        }
        if (!isSameLocalCalendarDay(startUtcMs, endUtcMs)) {
          throw const DomainValidationException('sessionsErrorSameDayRequired');
        }
      }
      final now = UtcClock.nowMs();
      final status = endUtcMs == null
          ? WorkSessionStatusDb.open
          : WorkSessionStatusDb.closed;
      await (_db.update(
        _db.workSessions,
      )..where((s) => s.id.equals(sessionId))).write(
        WorkSessionsCompanion(
          startTs: Value(startUtcMs),
          endTs: Value(endUtcMs),
          status: Value(status),
          note: Value(note),
          source: const Value(WorkSessionSourceDb.admin),
          updatedAt: Value(now),
          updatedBy: Value(updatedBy),
          updateReason: Value(
            updateReason.trim().isEmpty ? null : updateReason.trim(),
          ),
        ),
      );
    });
  }

  @override
  Stream<List<EmployeeReportRowInfo>> streamEmployeeReport({
    int? fromUtcMs,
    int? toUtcMs,
  }) {
    return watchEmployeeReport(fromUtcMs: fromUtcMs, toUtcMs: toUtcMs).map(
      (list) => list
          .map(
            (r) => EmployeeReportRowInfo(
              employeeId: r.employeeId,
              employeeName: r.employeeName,
              totalMs: r.totalMs,
              closedSessionsCount: r.closedSessionsCount,
              normMs: 0,
              deltaMs: r.totalMs,
              anyDayHasSchedule: false,
            ),
          )
          .toList(),
    );
  }

  Stream<List<EmployeeReportRow>> watchEmployeeReport({
    int? fromUtcMs,
    int? toUtcMs,
  }) {
    // Sum only CLOSED sessions (end_ts IS NOT NULL).
    // Keep filters in the JOIN condition to preserve employees with zero sessions.
    final from = fromUtcMs;
    final to = toUtcMs;

    final conditions = <String>[];
    final vars = <Variable<Object>>[];
    if (from != null) {
      conditions.add('ws.start_ts >= ?');
      vars.add(Variable<int>(from));
    }
    if (to != null) {
      conditions.add('ws.start_ts <= ?');
      vars.add(Variable<int>(to));
    }
    final onExtra = conditions.isEmpty
        ? ''
        : ' AND ${conditions.join(' AND ')}';

    final sql =
        '''
SELECT
  e.id AS employee_id,
  (e.last_name || ' ' || e.first_name) AS employee_name,
  COALESCE(SUM(CASE WHEN ws.end_ts IS NOT NULL THEN (ws.end_ts - ws.start_ts) ELSE 0 END), 0) AS total_ms,
  COALESCE(SUM(CASE WHEN ws.end_ts IS NOT NULL THEN 1 ELSE 0 END), 0) AS closed_count
FROM employees e
LEFT JOIN work_sessions ws
  ON ws.employee_id = e.id $onExtra
GROUP BY e.id, e.first_name, e.last_name
ORDER BY e.last_name ASC, e.first_name ASC;
''';

    return _db
        .customSelect(
          sql,
          variables: vars,
          readsFrom: {_db.employees, _db.workSessions},
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => EmployeeReportRow(
                  employeeId: r.read<int>('employee_id'),
                  employeeName: r.read<String>('employee_name'),
                  totalMs: r.read<int>('total_ms'),
                  closedSessionsCount: r.read<int>('closed_count'),
                ),
              )
              .toList(growable: false),
        );
  }
}
