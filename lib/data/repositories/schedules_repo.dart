import 'package:drift/drift.dart';

import '../../core/domain_errors.dart';
import '../../domain/entities/schedule_entities.dart';
import '../../domain/ports/schedules_repo_port.dart';
import '../db/app_db.dart';
import '../../common/utils/utc_clock.dart';
import 'repo_guard.dart';

class SchedulesRepo implements ISchedulesRepo {
  SchedulesRepo(this._db);

  final AppDb _db;

  void _validateIntervals({
    required bool isDayOff,
    required List<ScheduleInterval> intervals,
  }) {
    if (isDayOff) {
      if (intervals.isNotEmpty) {
        throw const DomainValidationException('Day off cannot have intervals.');
      }
      return;
    }

    if (intervals.isEmpty) {
      throw const DomainValidationException(
        'Please set at least one interval or mark the day as day off.',
      );
    }

    for (final it in intervals) {
      if (it.startMin < 0 || it.startMin > 1439) {
        throw const DomainValidationException('Start time is out of range.');
      }
      if (it.endMin < 0 || it.endMin > 1439) {
        throw const DomainValidationException('End time is out of range.');
      }
      if (it.endMin <= it.startMin) {
        throw const DomainValidationException('Start must be before end.');
      }
    }
  }

  /// Stream of schedule templates as domain types (id, name, weekly totals).
  ///
  /// Watches templates, days, and intervals so weekly minutes refresh when
  /// intervals change (not only when template metadata changes).
  @override
  Stream<List<ScheduleTemplateInfo>> streamTemplateInfos({
    bool onlyActive = true,
  }) {
    final activeFilter = onlyActive ? 'AND t.is_active = 1' : '';
    return _db
        .customSelect(
          '''
SELECT
  t.id AS template_id,
  t.name AS template_name,
  t.is_active AS is_active,
  COALESCE(SUM(
    CASE
      WHEN d.is_day_off = 0 AND i.end_min > i.start_min
      THEN (i.end_min - i.start_min)
      ELSE 0
    END
  ), 0) AS weekly_total_work_minutes
FROM shift_schedule_templates t
LEFT JOIN shift_schedule_template_days d ON d.template_id = t.id
LEFT JOIN shift_schedule_template_intervals i
  ON i.template_day_id = d.id AND i.end_min > i.start_min
WHERE 1 = 1 $activeFilter
GROUP BY t.id, t.name, t.is_active
ORDER BY t.name ASC
''',
          readsFrom: {
            _db.shiftScheduleTemplates,
            _db.shiftScheduleTemplateDays,
            _db.shiftScheduleTemplateIntervals,
          },
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => ScheduleTemplateInfo(
                  id: r.read<int>('template_id'),
                  name: r.read<String>('template_name'),
                  isActive: r.read<int>('is_active') == 1,
                  weeklyTotalWorkMinutes: r.read<int>(
                    'weekly_total_work_minutes',
                  ),
                ),
              )
              .toList(),
        );
  }

  /// One-shot: get assigned template ID for employee, or null.
  @override
  Future<int?> getAssignmentTemplateId(int employeeId) async {
    final a =
        await (_db.select(_db.employeeScheduleAssignments)
              ..where((x) => x.employeeId.equals(employeeId))
              ..limit(1))
            .getSingleOrNull();
    return a?.templateId;
  }

  @override
  Future<int> createTemplate(String name) async {
    return guardRepoCall(() async {
      return _db.transaction(() async {
        final now = UtcClock.nowMs();
        final id = await _db
            .into(_db.shiftScheduleTemplates)
            .insert(
              ShiftScheduleTemplatesCompanion.insert(
                name: name.trim(),
                createdAt: now,
              ),
            );

        // Create 7 day rows (Mon..Sun, 1..7).
        await _db.batch((b) {
          b.insertAll(_db.shiftScheduleTemplateDays, [
            for (var wd = 1; wd <= 7; wd++)
              ShiftScheduleTemplateDaysCompanion.insert(
                templateId: id,
                weekday: wd,
                isDayOff: const Value(0),
              ),
          ]);
        });

        return id;
      });
    });
  }

  @override
  Future<void> updateTemplateName({
    required int id,
    required String name,
  }) async {
    return guardRepoCall(() async {
      await (_db.update(_db.shiftScheduleTemplates)
            ..where((t) => t.id.equals(id)))
          .write(ShiftScheduleTemplatesCompanion(name: Value(name.trim())));
    });
  }

  @override
  Future<void> setTemplateActive({
    required int id,
    required bool isActive,
  }) async {
    return guardRepoCall(() async {
      await (_db.update(
        _db.shiftScheduleTemplates,
      )..where((t) => t.id.equals(id))).write(
        ShiftScheduleTemplatesCompanion(isActive: Value(isActive ? 1 : 0)),
      );
    });
  }

  /// Returns true if any employee is assigned to this template.
  @override
  Future<bool> hasAssignments(int templateId) async {
    final row =
        await (_db.select(_db.employeeScheduleAssignments)
              ..where((a) => a.templateId.equals(templateId))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  static const _assignedCode = 'schedulesTemplateAssigned';

  @override
  Future<void> deleteTemplate(int templateId) async {
    return guardRepoCall(() async {
      final assigned = await hasAssignments(templateId);
      if (assigned) {
        throw const DomainConstraintException(_assignedCode);
      }
      await _db.transaction(() async {
        await (_db.delete(
          _db.employeeScheduleAssignments,
        )..where((a) => a.templateId.equals(templateId))).go();

        final days = await (_db.select(
          _db.shiftScheduleTemplateDays,
        )..where((d) => d.templateId.equals(templateId))).get();

        for (final day in days) {
          await (_db.delete(
            _db.shiftScheduleTemplateIntervals,
          )..where((i) => i.templateDayId.equals(day.id))).go();
        }

        await (_db.delete(
          _db.shiftScheduleTemplateDays,
        )..where((d) => d.templateId.equals(templateId))).go();

        await (_db.delete(
          _db.shiftScheduleTemplates,
        )..where((t) => t.id.equals(templateId))).go();
      });
    });
  }

  @override
  Future<Map<int, DaySchedule>> getTemplateWeek(int templateId) async {
    return watchTemplateWeek(templateId).first;
  }

  @override
  Stream<Map<int, DaySchedule>> watchTemplateWeek(int templateId) {
    final d = _db.shiftScheduleTemplateDays;
    final i = _db.shiftScheduleTemplateIntervals;

    final join =
        _db.select(d).join([leftOuterJoin(i, i.templateDayId.equalsExp(d.id))])
          ..where(d.templateId.equals(templateId))
          ..orderBy([
            OrderingTerm.asc(d.weekday),
            OrderingTerm.asc(i.startMin),
          ]);

    return join.watch().map((rows) {
      final byDay = <int, DaySchedule>{};
      final intervals = <int, List<ScheduleInterval>>{};
      final isDayOff = <int, bool>{};

      for (final r in rows) {
        final day = r.readTable(d);
        isDayOff[day.weekday] = day.isDayOff == 1;
        final intervalRow = r.readTableOrNull(i);
        if (intervalRow != null && intervalRow.endMin > intervalRow.startMin) {
          (intervals[day.weekday] ??= []).add(
            ScheduleInterval(
              startMin: intervalRow.startMin,
              endMin: intervalRow.endMin,
            ),
          );
        }
      }

      for (var wd = 1; wd <= 7; wd++) {
        byDay[wd] = DaySchedule(
          isDayOff: isDayOff[wd] ?? false,
          intervals: intervals[wd] ?? const [],
        );
      }

      return byDay;
    });
  }

  @override
  Future<void> saveTemplateDay({
    required int templateId,
    required int weekday,
    required bool isDayOff,
    required List<ScheduleInterval> intervals,
  }) async {
    return guardRepoCall(() async {
      _validateIntervals(isDayOff: isDayOff, intervals: intervals);

      // Ensure day row exists.
      final day =
          await (_db.select(_db.shiftScheduleTemplateDays)
                ..where(
                  (d) =>
                      d.templateId.equals(templateId) &
                      d.weekday.equals(weekday),
                )
                ..limit(1))
              .getSingleOrNull();
      if (day == null) return;

      await _db.transaction(() async {
        await (_db.update(
          _db.shiftScheduleTemplateDays,
        )..where((d) => d.id.equals(day.id))).write(
          ShiftScheduleTemplateDaysCompanion(isDayOff: Value(isDayOff ? 1 : 0)),
        );

        await (_db.delete(
          _db.shiftScheduleTemplateIntervals,
        )..where((i) => i.templateDayId.equals(day.id))).go();

        if (!isDayOff) {
          await _db.batch((b) {
            b.insertAll(_db.shiftScheduleTemplateIntervals, [
              for (final it in intervals)
                ShiftScheduleTemplateIntervalsCompanion.insert(
                  templateDayId: day.id,
                  startMin: it.startMin,
                  endMin: it.endMin,
                  crossesMidnight: const Value(0),
                ),
            ]);
          });
        }
      });
    });
  }

  /// Saves the entire week in one transaction. On failure, no partial updates.
  @override
  Future<void> saveTemplateWeek({
    required int templateId,
    required Map<int, DaySchedule> days,
  }) async {
    return guardRepoCall(() async {
      for (var wd = 1; wd <= 7; wd++) {
        final day =
            days[wd] ?? const DaySchedule(isDayOff: true, intervals: []);
        _validateIntervals(isDayOff: day.isDayOff, intervals: day.intervals);
      }

      await _db.transaction(() async {
        final dayRows = await (_db.select(
          _db.shiftScheduleTemplateDays,
        )..where((d) => d.templateId.equals(templateId))).get();

        for (final dayRow in dayRows) {
          final wd = dayRow.weekday;
          final schedule =
              days[wd] ?? const DaySchedule(isDayOff: true, intervals: []);

          await (_db.update(
            _db.shiftScheduleTemplateDays,
          )..where((d) => d.id.equals(dayRow.id))).write(
            ShiftScheduleTemplateDaysCompanion(
              isDayOff: Value(schedule.isDayOff ? 1 : 0),
            ),
          );

          await (_db.delete(
            _db.shiftScheduleTemplateIntervals,
          )..where((i) => i.templateDayId.equals(dayRow.id))).go();

          if (!schedule.isDayOff) {
            await _db.batch((b) {
              b.insertAll(_db.shiftScheduleTemplateIntervals, [
                for (final it in schedule.intervals)
                  ShiftScheduleTemplateIntervalsCompanion.insert(
                    templateDayId: dayRow.id,
                    startMin: it.startMin,
                    endMin: it.endMin,
                    crossesMidnight: const Value(0),
                  ),
              ]);
            });
          }
        }
      });
    });
  }

  /// Creates a new template with the given week in one transaction.
  @override
  Future<int> createTemplateWithWeek({
    required String name,
    required Map<int, DaySchedule> days,
  }) async {
    return guardRepoCall(() async {
      for (var wd = 1; wd <= 7; wd++) {
        final day =
            days[wd] ?? const DaySchedule(isDayOff: true, intervals: []);
        _validateIntervals(isDayOff: day.isDayOff, intervals: day.intervals);
      }

      return _db.transaction(() async {
        final now = UtcClock.nowMs();
        final id = await _db
            .into(_db.shiftScheduleTemplates)
            .insert(
              ShiftScheduleTemplatesCompanion.insert(
                name: name.trim(),
                createdAt: now,
              ),
            );

        await _db.batch((b) {
          b.insertAll(_db.shiftScheduleTemplateDays, [
            for (var wd = 1; wd <= 7; wd++)
              ShiftScheduleTemplateDaysCompanion.insert(
                templateId: id,
                weekday: wd,
                isDayOff: const Value(1),
              ),
          ]);
        });

        final insertedDays = await (_db.select(
          _db.shiftScheduleTemplateDays,
        )..where((d) => d.templateId.equals(id))).get();

        for (final dayRow in insertedDays) {
          final wd = dayRow.weekday;
          final schedule =
              days[wd] ?? const DaySchedule(isDayOff: true, intervals: []);

          await (_db.update(
            _db.shiftScheduleTemplateDays,
          )..where((d) => d.id.equals(dayRow.id))).write(
            ShiftScheduleTemplateDaysCompanion(
              isDayOff: Value(schedule.isDayOff ? 1 : 0),
            ),
          );

          if (!schedule.isDayOff) {
            await _db.batch((b) {
              b.insertAll(_db.shiftScheduleTemplateIntervals, [
                for (final it in schedule.intervals)
                  ShiftScheduleTemplateIntervalsCompanion.insert(
                    templateDayId: dayRow.id,
                    startMin: it.startMin,
                    endMin: it.endMin,
                    crossesMidnight: const Value(0),
                  ),
              ]);
            });
          }
        }

        return id;
      });
    });
  }

  @override
  Future<void> setEmployeeTemplateAssignment({
    required int employeeId,
    required int? templateId,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      if (templateId == null) {
        await (_db.delete(
          _db.employeeScheduleAssignments,
        )..where((a) => a.employeeId.equals(employeeId))).go();
        return;
      }

      await _db
          .into(_db.employeeScheduleAssignments)
          .insert(
            EmployeeScheduleAssignmentsCompanion(
              employeeId: Value(employeeId),
              templateId: Value(templateId),
              createdAt: Value(now),
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
  }

  Stream<EmployeeScheduleAssignment?> watchAssignment(int employeeId) {
    return (_db.select(_db.employeeScheduleAssignments)
          ..where((a) => a.employeeId.equals(employeeId))
          ..limit(1))
        .watchSingleOrNull();
  }

  @override
  Future<ResolvedSchedule> resolveSchedule({
    required int employeeId,
    required DateTime dateLocal,
  }) async {
    final assignment =
        await (_db.select(_db.employeeScheduleAssignments)
              ..where((a) => a.employeeId.equals(employeeId))
              ..limit(1))
            .getSingleOrNull();
    if (assignment == null) {
      return const ResolvedSchedule(
        source: 'none',
        isDayOff: false,
        intervals: [],
      );
    }

    final weekday = dateLocal.weekday; // 1..7
    final day =
        await (_db.select(_db.shiftScheduleTemplateDays)
              ..where(
                (d) =>
                    d.templateId.equals(assignment.templateId) &
                    d.weekday.equals(weekday),
              )
              ..limit(1))
            .getSingleOrNull();
    if (day == null) {
      return const ResolvedSchedule(
        source: 'none',
        isDayOff: false,
        intervals: [],
      );
    }

    final intervals =
        await (_db.select(_db.shiftScheduleTemplateIntervals)
              ..where((i) => i.templateDayId.equals(day.id))
              ..orderBy([(i) => OrderingTerm.asc(i.startMin)]))
            .get();

    return ResolvedSchedule(
      source: 'template',
      isDayOff: day.isDayOff == 1,
      intervals: intervals
          .where((i) => i.endMin > i.startMin)
          .map((i) => ScheduleInterval(startMin: i.startMin, endMin: i.endMin))
          .toList(growable: false),
    );
  }
}
