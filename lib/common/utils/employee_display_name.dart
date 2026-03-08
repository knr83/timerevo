import '../../domain/entities/employee_display.dart';

class EmployeeDisplayName {
  static String of(EmployeeDisplay e) {
    final first = e.firstName.trim();
    final last = e.lastName.trim();
    if (first.isEmpty && last.isEmpty) return '(No name)';
    if (last.isEmpty) return first;
    if (first.isEmpty) return last;
    return '$last $first';
  }
}

