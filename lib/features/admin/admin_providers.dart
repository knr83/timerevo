import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected employee ID in Employees page. Shared with Dashboard for navigation.
final selectedEmployeeIdProvider = StateProvider<int?>((ref) => null);

/// Whether the "add new" form is shown in Employees page.
final isAddingNewProvider = StateProvider<bool>((ref) => false);
