/// Minimal employee data for display (e.g. "LastName FirstName").
/// Use this instead of Drift Employee in UI/common.
class EmployeeDisplay {
  const EmployeeDisplay({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;
}
