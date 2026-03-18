import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/utils/date_utils.dart';
import '../data/repositories/repo_providers.dart';
import '../domain/entities/employee_info.dart';
import '../domain/usecases.dart';
import 'sessions_providers.dart';
import 'usecase_providers.dart';

/// Re-export session providers for terminal (domain types, no drift).
export 'sessions_providers.dart'
    show
        watchOpenSessionForEmployeeProvider,
        watchSessionsForEmployeeTodayProvider;

/// Alias for terminal; same as watchSessionsForEmployeeTodayProvider.
final todaySessionsForEmployeeProvider = watchSessionsForEmployeeTodayProvider;

/// Active employees visible in the Terminal: today must fall within
/// [hireDate, terminationDate]. Hides employees outside their employment window.
final terminalEmployeesProvider = StreamProvider<List<EmployeeInfo>>((ref) {
  final today = todayYmd();
  return ref
      .watch(watchEmployeesUseCaseProvider)
      .streamActiveEmployees()
      .map(
        (list) => list
            .where(
              (e) =>
                  isDateWithinEmployment(e.hireDate, e.terminationDate, today),
            )
            .toList(),
      );
});

/// App-layer use case for terminal employee PIN/auth. Use from UI instead of repo.
final terminalEmployeeAuthUseCaseProvider =
    Provider<TerminalEmployeeAuthUseCase>((ref) {
      return TerminalEmployeeAuthUseCase(ref.watch(employeesRepoProvider));
    });

/// App-layer use case for closing open session with end time. Use from UI instead of repo.
final closeOpenSessionWithEndUseCaseProvider =
    Provider<CloseOpenSessionWithEndUseCase>((ref) {
      return CloseOpenSessionWithEndUseCase(ref.watch(sessionsRepoProvider));
    });
