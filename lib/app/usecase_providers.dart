import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../common/utils/date_utils.dart';
import '../common/widgets/date_range_filter_bar.dart';
import '../data/repositories/repo_providers.dart';
import '../domain/entities/employee_day_report_row.dart';
import '../domain/entities/employee_info.dart';
import '../domain/entities/employee_report_row_info.dart';
import '../domain/entities/schedule_entities.dart';
import '../domain/usecases.dart';

final clockInUseCaseProvider = Provider<ClockInUseCase>((ref) {
  return ClockInUseCase(
    ref.watch(sessionsRepoProvider),
    ref.watch(employeesRepoProvider),
    ref.watch(absencesRepoProvider),
    ref.watch(schedulesRepoProvider),
  );
});

final clockOutUseCaseProvider = Provider<ClockOutUseCase>((ref) {
  return ClockOutUseCase(
    ref.watch(sessionsRepoProvider),
    ref.watch(schedulesRepoProvider),
  );
});

final watchEmployeesUseCaseProvider = Provider<WatchEmployeesUseCase>((ref) {
  return WatchEmployeesUseCase(ref.watch(employeesRepoProvider));
});

final employeesAdminUseCaseProvider = Provider<EmployeesAdminUseCase>((ref) {
  return EmployeesAdminUseCase(
    ref.watch(employeesRepoProvider),
    ref.watch(schedulesRepoProvider),
  );
});

final schedulesTemplatesUseCaseProvider = Provider<SchedulesTemplatesUseCase>((
  ref,
) {
  return SchedulesTemplatesUseCase(ref.watch(schedulesRepoProvider));
});

final changeAdminPinUseCaseProvider = Provider<ChangeAdminPinUseCase>((ref) {
  return ChangeAdminPinUseCase(ref.watch(authRepoProvider));
});

final employeeReportWithNormUseCaseProvider =
    Provider<EmployeeReportWithNormUseCase>((ref) {
      return EmployeeReportWithNormUseCase(
        ref.watch(sessionsRepoProvider),
        ref.watch(schedulesRepoProvider),
        ref.watch(absencesRepoProvider),
      );
    });

final employeeDayReportUseCaseProvider = Provider<EmployeeDayReportUseCase>((
  ref,
) {
  return EmployeeDayReportUseCase(
    ref.watch(sessionsRepoProvider),
    ref.watch(schedulesRepoProvider),
    ref.watch(absencesRepoProvider),
  );
});

final journalDayOverviewUseCaseProvider = Provider<JournalDayOverviewUseCase>((
  ref,
) {
  return JournalDayOverviewUseCase(
    ref.watch(sessionsRepoProvider),
    ref.watch(absencesRepoProvider),
    ref.watch(schedulesRepoProvider),
    ref.watch(employeesRepoProvider),
  );
});

final journalIntervalOverviewUseCaseProvider =
    Provider<JournalIntervalOverviewUseCase>((ref) {
      return JournalIntervalOverviewUseCase(
        ref.watch(sessionsRepoProvider),
        ref.watch(absencesRepoProvider),
        ref.watch(employeesRepoProvider),
      );
    });

/// Report filters (scope, date range, employee). Used by Reports page and watchReportWithNormProvider.
/// Default period: current month.
final reportFiltersProvider =
    StateProvider<({DateRangeScope scope, int? fromUtcMs, int? toUtcMs, int? employeeId})>((ref) {
      final month = reportPeriodMonth();
      return (
        scope: DateRangeScope.month,
        fromUtcMs: month.fromUtcMs,
        toUtcMs: month.toUtcMs,
        employeeId: null,
      );
    });

({int fromUtcMs, int toUtcMs}) reportEffectiveRange(
  ({DateRangeScope scope, int? fromUtcMs, int? toUtcMs, int? employeeId}) f,
) {
  if (f.fromUtcMs != null && f.toUtcMs != null) {
    return (fromUtcMs: f.fromUtcMs!, toUtcMs: f.toUtcMs!);
  }
  return switch (f.scope) {
    DateRangeScope.day => reportPeriodToday(),
    DateRangeScope.week => reportPeriodWeek(),
    DateRangeScope.month => reportPeriodMonth(),
    DateRangeScope.interval => reportPeriodMonth(),
  };
}

/// Selected employee for details drawer. Null when drawer is closed.
final selectedEmployeeForDetailsProvider = StateProvider<int?>((ref) => null);

/// Stream of per-day report rows for the selected employee and period. Empty when drawer closed or period missing.
final watchEmployeeDayReportProvider =
    StreamProvider<List<EmployeeDayReportRow>>((ref) {
      final filters = ref.watch(reportFiltersProvider);
      final selectedId = ref.watch(selectedEmployeeForDetailsProvider);
      if (selectedId == null) return Stream.value([]);
      final r = reportEffectiveRange(filters);
      return ref
          .watch(employeeDayReportUseCaseProvider)
          .streamEmployeeDayReport(
            employeeId: selectedId,
            fromUtcMs: r.fromUtcMs,
            toUtcMs: r.toUtcMs,
          );
    });

/// Stream of employee report rows with norm and delta.
final watchReportWithNormProvider = StreamProvider<List<EmployeeReportRowInfo>>(
  (ref) {
    final filters = ref.watch(reportFiltersProvider);
    final r = reportEffectiveRange(filters);
    return ref
        .watch(employeeReportWithNormUseCaseProvider)
        .streamEmployeeReportWithNorm(
          fromUtcMs: r.fromUtcMs,
          toUtcMs: r.toUtcMs,
        );
  },
);

/// Stream of active employees (domain types). Use instead of direct repo access.
///
/// Example usage in a feature:
/// ```dart
/// final employeesAsync = ref.watch(watchActiveEmployeesProvider);
/// employeesAsync.when(
///   data: (list) => ListView.builder(
///     itemCount: list.length,
///     itemBuilder: (_, i) => ListTile(
///       title: Text('${list[i].firstName} ${list[i].lastName}'),
///     ),
///   ),
///   loading: () => const CircularProgressIndicator(),
///   error: (e, _) => Text(l10n.commonErrorOccurred),
/// );
/// ```
final watchActiveEmployeesProvider = StreamProvider<List<EmployeeInfo>>((ref) {
  return ref.watch(watchEmployeesUseCaseProvider).streamActiveEmployees();
});

final watchAllEmployeesProvider = StreamProvider<List<EmployeeInfo>>((ref) {
  return ref.watch(watchEmployeesUseCaseProvider).streamAllEmployees();
});

/// Stream of schedule templates as domain types (id, name, isActive).
/// Use onlyActive: true for dropdowns (e.g. employees), false for admin list.
final watchScheduleTemplatesProvider =
    StreamProvider.family<List<ScheduleTemplateInfo>, bool>((ref, onlyActive) {
      return ref
          .watch(schedulesRepoProvider)
          .streamTemplateInfos(onlyActive: onlyActive);
    });

/// Convenience: active templates only (for dropdowns).
final watchActiveScheduleTemplatesProvider =
    StreamProvider<List<ScheduleTemplateInfo>>((ref) {
      return ref
          .watch(schedulesRepoProvider)
          .streamTemplateInfos(onlyActive: true);
    });

/// Stream of template week (weekday -> DaySchedule).
final watchTemplateWeekProvider =
    StreamProvider.family<Map<int, DaySchedule>, int>((ref, templateId) {
      return ref
          .watch(schedulesTemplatesUseCaseProvider)
          .streamTemplateWeek(templateId);
    });
