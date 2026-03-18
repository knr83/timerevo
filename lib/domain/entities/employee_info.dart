import 'employee_status.dart';

/// Minimal employee info for domain use cases. Data layer maps from Drift Employee.
class EmployeeInfo {
  const EmployeeInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.usePin = false,
    this.policyAcknowledged = false,
    this.hireDate,
    this.terminationDate,
  });

  final int id;
  final String firstName;
  final String lastName;
  final EmployeeStatus status;
  final bool usePin;
  final bool policyAcknowledged;

  /// UTC milliseconds; null = no lower employment boundary.
  final int? hireDate;

  /// UTC milliseconds; null = no upper employment boundary.
  final int? terminationDate;
}
