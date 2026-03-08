import 'employee_info.dart';
import 'session_info.dart';

/// Session with employee display info for list rendering.
class SessionWithEmployeeInfo {
  const SessionWithEmployeeInfo({
    required this.session,
    required this.employee,
  });

  final SessionInfo session;
  final EmployeeInfo employee;
}
