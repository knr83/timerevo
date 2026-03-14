import 'package:flutter_riverpod/legacy.dart';

/// Selected employee ID in Employees page. Shared with Dashboard for navigation.
final selectedEmployeeIdProvider = StateProvider<int?>((ref) => null);

/// Whether the "add new" form is shown in Employees page.
final isAddingNewProvider = StateProvider<bool>((ref) => false);

/// Guard state for unsaved changes in the embedded Employee Card form.
/// The form registers itself here; the list checks before switching selection.
class EmployeeCardGuardState {
  const EmployeeCardGuardState({
    required this.isDirty,
    this.performSave,
  });

  final bool isDirty;
  final Future<bool> Function()? performSave;
}

class EmployeeCardGuardNotifier extends StateNotifier<EmployeeCardGuardState> {
  EmployeeCardGuardNotifier()
      : super(const EmployeeCardGuardState(isDirty: false, performSave: null));

  void setFormState(bool isDirty, Future<bool> Function()? performSave) {
    state = EmployeeCardGuardState(isDirty: isDirty, performSave: performSave);
  }

  void clear() {
    state = const EmployeeCardGuardState(isDirty: false, performSave: null);
  }
}

final employeeCardGuardProvider =
    StateNotifierProvider<EmployeeCardGuardNotifier, EmployeeCardGuardState>(
  (ref) => EmployeeCardGuardNotifier(),
);
