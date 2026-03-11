import 'package:flutter_riverpod/flutter_riverpod.dart';

class TerminalState {
  const TerminalState({required this.selectedEmployeeId});

  final int? selectedEmployeeId;

  TerminalState copyWith({int? selectedEmployeeId}) {
    return TerminalState(selectedEmployeeId: selectedEmployeeId);
  }

  static const initial = TerminalState(selectedEmployeeId: null);
}

class TerminalController extends Notifier<TerminalState> {
  @override
  TerminalState build() => TerminalState.initial;

  void selectEmployee(int employeeId) {
    state = state.copyWith(selectedEmployeeId: employeeId);
  }

  void clearSelection() {
    state = state.copyWith(selectedEmployeeId: null);
  }
}

final terminalControllerProvider =
    NotifierProvider<TerminalController, TerminalState>(TerminalController.new);
