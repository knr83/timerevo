/// Employee status for terminal visibility and admin display.
enum EmployeeStatus {
  active,
  inactive,
  archived,
}

/// Parses DB status string to [EmployeeStatus]. Defaults to inactive if unknown.
EmployeeStatus employeeStatusFromString(String s) => switch (s) {
      'active' => EmployeeStatus.active,
      'inactive' => EmployeeStatus.inactive,
      'archived' => EmployeeStatus.archived,
      _ => EmployeeStatus.inactive,
    };
