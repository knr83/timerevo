import '../entities/schedule_entities.dart';
import '../entities/schedule_roster_pdf_row.dart';
import '../ports/employees_repo_port.dart';
import '../ports/schedules_repo_port.dart';
import '../schedule_weekly_work_minutes.dart';

String _formatMinutes(int min) {
  final h = (min ~/ 60).toString().padLeft(2, '0');
  final m = (min % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

String _dayScheduleToCell(DaySchedule day) {
  if (day.isDayOff || day.intervals.isEmpty) {
    return scheduleRosterPdfEmptyCell;
  }
  return day.intervals
      .map((i) {
        final a = _formatMinutes(i.startMin);
        final b = _formatMinutes(i.endMin);
        return '$a\u2013$b';
      })
      .join('\n');
}

List<int> _computeVisibleWeekdays(List<ScheduleRosterPdfRow> rows) {
  final vis = <int>[];
  for (var w = 1; w <= 7; w++) {
    final idx = w - 1;
    if (rows.any((r) => r.weekdayCells[idx] != scheduleRosterPdfEmptyCell)) {
      vis.add(w);
    }
  }
  return vis;
}

/// Builds schedule roster rows for the PDF (all employees, template weeks).
class ScheduleRosterPdfDataUseCase {
  ScheduleRosterPdfDataUseCase(this._employeesRepo, this._schedulesRepo);

  final IEmployeesRepo _employeesRepo;
  final ISchedulesRepo _schedulesRepo;

  Future<ScheduleRosterPdfData> build() async {
    final employees = await _employeesRepo.streamAllEmployees().first;
    final templateCache = <int, Map<int, DaySchedule>>{};
    final rows = <ScheduleRosterPdfRow>[];

    for (final e in employees) {
      final tid = await _schedulesRepo.getAssignmentTemplateId(e.id);
      Map<int, DaySchedule>? week;
      if (tid != null) {
        week = templateCache[tid];
        week ??= await _schedulesRepo.getTemplateWeek(tid);
        templateCache[tid] = week;
      }

      final cells = <String>[];
      int? weeklyTotal;

      if (week == null) {
        for (var i = 0; i < 7; i++) {
          cells.add(scheduleRosterPdfEmptyCell);
        }
        weeklyTotal = null;
      } else {
        for (var wd = 1; wd <= 7; wd++) {
          final day =
              week[wd] ?? const DaySchedule(isDayOff: true, intervals: []);
          final cell = _dayScheduleToCell(day);
          cells.add(cell);
        }
        weeklyTotal = scheduleTemplateWeekTotalWorkMinutes(week);
      }

      rows.add(
        ScheduleRosterPdfRow(
          employeeDisplayName: scheduleRosterEmployeeDisplayName(e),
          weekdayCells: cells,
          weeklyTotalWorkMinutes: weeklyTotal,
        ),
      );
    }

    return ScheduleRosterPdfData(
      rows: rows,
      visibleWeekdays: _computeVisibleWeekdays(rows),
    );
  }
}
