import '../../core/employee_pin_status.dart';
import '../entities/employee_details.dart';
import '../entities/employee_info.dart';

/// Port for employee data access. Use cases depend on this; data layer implements.
abstract interface class IEmployeesRepo {
  Future<EmployeeInfo?> getEmployee(int id);
  Future<EmployeeDetails?> getEmployeeDetails(int id);

  /// Stream of active employees (isActive=true), sorted by lastName, firstName.
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
    bool isActive = true,
    int? hireDate,
    String employeeRole = 'employee',
    bool usePin = false,
    bool useNfc = false,
    String? accessToken,
    String? accessNote,
    String? employmentType,
    double? weeklyHours,
    String? email,
    String? phone,
    String? department,
    String? jobTitle,
    String? internalComment,
    bool policyAcknowledged = false,
    int? policyAcknowledgedAt,
    required int? templateId,
    String? createdBy,
  });

  Future<void> updateEmployeeFull({
    required int id,
    required String code,
    required String firstName,
    required String lastName,
    bool isActive = true,
    int? hireDate,
    String employeeRole = 'employee',
    bool usePin = false,
    bool useNfc = false,
    String? accessToken,
    String? accessNote,
    String? employmentType,
    double? weeklyHours,
    String? email,
    String? phone,
    String? department,
    String? jobTitle,
    String? internalComment,
    bool policyAcknowledged = false,
    int? policyAcknowledgedAt,
    int? templateId,
    String? updatedBy,
  });

  Future<void> setEmployeePin({required int employeeId, required String pin});
  Future<void> resetEmployeePin(int employeeId);
}
