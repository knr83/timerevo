import '../../domain/entities/employee_info.dart';
import '../../domain/entities/employee_status.dart';
import '../db/app_db.dart';

/// Maps a Drift [Employee] row to [EmployeeInfo] (full fields used in list/join streams).
EmployeeInfo employeeInfoFromDrift(Employee employee) => EmployeeInfo(
  id: employee.id,
  firstName: employee.firstName,
  lastName: employee.lastName,
  status: employeeStatusFromString(employee.status),
  usePin: employee.usePin == 1,
  policyAcknowledged: employee.policyAcknowledged == 1,
  hireDate: employee.hireDate,
  terminationDate: employee.terminationDate,
);
