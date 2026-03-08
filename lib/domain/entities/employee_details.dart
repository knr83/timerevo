/// Full employee data for admin editing. Data layer maps from Drift Employee.
class EmployeeDetails {
  const EmployeeDetails({
    required this.id,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    this.usePin = false,
    this.useNfc = false,
    this.accessToken,
    this.accessNote,
    this.employmentType,
    this.weeklyHours,
    this.email,
    this.phone,
    this.department,
    this.jobTitle,
    this.internalComment,
    this.policyAcknowledged = false,
    this.policyAcknowledgedAt,
    this.hireDate,
    this.employeeRole = 'employee',
    this.templateId,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String code;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool usePin;
  final bool useNfc;
  final String? accessToken;
  final String? accessNote;
  final String? employmentType;
  final double? weeklyHours;
  final String? email;
  final String? phone;
  final String? department;
  final String? jobTitle;
  final String? internalComment;
  final bool policyAcknowledged;
  final int? policyAcknowledgedAt;
  final int? hireDate;
  final String employeeRole;
  final int? templateId;
  final int createdAt;
  final int? updatedAt;
}
