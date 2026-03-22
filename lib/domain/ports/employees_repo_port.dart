import '../../core/employee_pin_status.dart';
import '../entities/employee_details.dart';
import '../entities/employee_info.dart';
import '../entities/employee_starting_balance_snapshot.dart';
import '../entities/employee_status.dart';

/// Port for employee data access. Use cases depend on this; data layer implements.
abstract interface class IEmployeesRepo {
  Future<EmployeeInfo?> getEmployee(int id);
  Future<EmployeeDetails?> getEmployeeDetails(int id);

  /// Starting-balance fields for report period enrichment (batched).
  Future<Map<int, EmployeeStartingBalanceSnapshot>> getStartingBalanceSnapshots(
    Iterable<int> employeeIds,
  );

  /// Stream of active employees (status == active), sorted by lastName, firstName.
  Stream<List<EmployeeInfo>> streamActiveEmployees();

  /// Stream of all employees, sorted by lastName, firstName.
  Stream<List<EmployeeInfo>> streamAllEmployees();

  Future<EmployeePinStatus> getPinStatus(int employeeId);
  Future<bool> verifyEmployeePin({
    required int employeeId,
    required String pin,
  });
  Future<void> updateEmployeePolicyAcknowledged(
    int employeeId, {
    required bool acknowledged,
    required int? acknowledgedAt,
  });

  Future<String> getSuggestedEmployeeCode();
  Future<bool> checkCodeUnique(String code, {int? excludeEmployeeId});

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
    int? startingBalanceTenths,
  });

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
    int? startingBalanceTenths,
  });

  Future<void> setEmployeePin({required int employeeId, required String pin});
  Future<void> resetEmployeePin(int employeeId);

  /// Soft-deletes the employee: sets deleted_at and status=archived in one transaction.
  Future<void> markEmployeeForDeletion(int id);
}
