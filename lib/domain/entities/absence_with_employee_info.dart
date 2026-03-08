import 'absence_info.dart';
import 'employee_info.dart';

/// Absence with employee display info for list rendering.
class AbsenceWithEmployeeInfo {
  const AbsenceWithEmployeeInfo({
    required this.absence,
    required this.employee,
  });

  final AbsenceInfo absence;
  final EmployeeInfo employee;
}
