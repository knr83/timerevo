import '../entities/employee_report_row_info.dart';
import '../entities/session_info.dart';
import '../entities/session_ref.dart';
import '../entities/session_with_employee_info.dart';

/// Port for session data access (clock in/out). Use cases depend on this; data layer implements.
abstract interface class ISessionsRepo {
  Future<SessionRef?> getOpenSessionForEmployee(int employeeId);
  Future<int> createOpenSession({required int employeeId});
  Future<bool> closeOpenSession({required int employeeId});

  /// Closes the open session for [employeeId] with the given [endUtcMs].
  /// Returns false if no open session or if endUtcMs <= session.startTs.
  Future<bool> closeOpenSessionWithEnd({
    required int employeeId,
    required int endUtcMs,
    String? note,
    String? updatedBy,
  });

  /// Stream of open session for employee (domain type).
  Stream<SessionInfo?> streamOpenSessionForEmployee(int employeeId);

  /// Stream of today's sessions for employee (domain type).
  Stream<List<SessionInfo>> streamSessionsForEmployeeToday(int employeeId);

  /// Stream of sessions for employee in the last [days] days.
  Stream<List<SessionInfo>> streamSessionsForEmployeeLastDays(
    int employeeId,
    int days,
  );

  /// Stream of sessions for employee in date range (for calendar).
  Stream<List<SessionInfo>> streamSessions({
    required int employeeId,
    required int fromUtcMs,
    required int toUtcMs,
  });

  /// Stream of sessions for employee on a single date (local calendar day).
  Stream<List<SessionInfo>> streamSessionsForEmployeeOnDate(
    int employeeId,
    DateTime date,
  );

  /// Stream of sessions with employee info, optionally filtered.
  Stream<List<SessionWithEmployeeInfo>> streamSessionsWithEmployee({
    int? employeeId,
    int? fromUtcMs,
    int? toUtcMs,
  });

  /// Stream of open sessions (status=open, endTs null) with employee info.
  Stream<List<SessionWithEmployeeInfo>> streamOpenSessionsWithEmployee();

  /// Stream of recent sessions with employee info, limited to [limit] rows.
  Stream<List<SessionWithEmployeeInfo>> streamRecentSessionsWithEmployee({
    int limit = 10,
  });

  /// Stream of employee report rows (total ms, closed count) for date range.
  Stream<List<EmployeeReportRowInfo>> streamEmployeeReport({
    int? fromUtcMs,
    int? toUtcMs,
  });

  /// Update session as admin (used by sessions page).
  Future<void> updateSessionAsAdmin({
    required int sessionId,
    required int startUtcMs,
    required int? endUtcMs,
    required String? note,
    required String updateReason,
    String? updatedBy,
  });
}
