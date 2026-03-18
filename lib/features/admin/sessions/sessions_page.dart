import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../app/sessions_providers.dart';
import '../../../app/usecase_providers.dart';
import '../../../app/working_hours/working_hours_settings_controller.dart';
import '../../../common/utils/date_time_picker.dart';
import '../../../common/utils/date_utils.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/utils/time_format.dart';
import '../../../common/utils/utc_clock.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/date_range_filter_bar.dart';
import '../../../core/domain_errors.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../core/journal_interval_projection.dart';
import '../../../domain/entities/journal_day_overview_row.dart';
import '../../../domain/entities/session_info.dart';
import '../../../domain/entities/session_with_employee_info.dart';
import 'journal_timeline_grid.dart';

enum _JournalStatusFilter { all, open, notClosed, closed }

enum _DetailedScope { day, week }

/// Scope for Table mode period controls.
enum _TableScope { day, week, month, interval }

/// Scope for Timeline mode period controls. Interval only if custom range is valid.
enum _TimelineScope { week, month, interval }

enum JournalViewMode { table, timeline, timelineDetailed }

DateRangeScope _tableScopeToDateRangeScope(_TableScope s) {
  return switch (s) {
    _TableScope.day => DateRangeScope.day,
    _TableScope.week => DateRangeScope.week,
    _TableScope.month => DateRangeScope.month,
    _TableScope.interval => DateRangeScope.interval,
  };
}

_TableScope _dateRangeScopeToTableScope(DateRangeScope s) {
  return switch (s) {
    DateRangeScope.day => _TableScope.day,
    DateRangeScope.week => _TableScope.week,
    DateRangeScope.month => _TableScope.month,
    DateRangeScope.interval => _TableScope.interval,
  };
}

DateRangeScope _timelineScopeToDateRangeScope(_TimelineScope s) {
  return switch (s) {
    _TimelineScope.week => DateRangeScope.week,
    _TimelineScope.month => DateRangeScope.month,
    _TimelineScope.interval => DateRangeScope.interval,
  };
}

_TimelineScope _dateRangeScopeToTimelineScope(DateRangeScope s) {
  return switch (s) {
    DateRangeScope.day => _TimelineScope.week,
    DateRangeScope.week => _TimelineScope.week,
    DateRangeScope.month => _TimelineScope.month,
    DateRangeScope.interval => _TimelineScope.interval,
  };
}

DateRangeScope _detailedScopeToDateRangeScope(_DetailedScope s) {
  return switch (s) {
    _DetailedScope.day => DateRangeScope.day,
    _DetailedScope.week => DateRangeScope.week,
  };
}

_DetailedScope _dateRangeScopeToDetailedScope(DateRangeScope s) {
  return switch (s) {
    DateRangeScope.day => _DetailedScope.day,
    DateRangeScope.week => _DetailedScope.week,
    DateRangeScope.month => _DetailedScope.week,
    DateRangeScope.interval => _DetailedScope.week,
  };
}

(int, int) _detailedEffectiveRange(_JournalFilters f) {
  if (f.fromUtcMs != null && f.toUtcMs != null) {
    return (f.fromUtcMs!, f.toUtcMs!);
  }
  return switch (f.detailedScope) {
    _DetailedScope.day => (
      reportPeriodToday().fromUtcMs,
      reportPeriodToday().toUtcMs,
    ),
    _DetailedScope.week => (
      reportPeriodWeek().fromUtcMs,
      reportPeriodWeek().toUtcMs,
    ),
  };
}

(int, int) _tableEffectiveRange(_JournalFilters f) {
  if (f.fromUtcMs != null && f.toUtcMs != null) {
    return (f.fromUtcMs!, f.toUtcMs!);
  }
  return switch (f.tableScope) {
    _TableScope.day => (
      reportPeriodToday().fromUtcMs,
      reportPeriodToday().toUtcMs,
    ),
    _TableScope.week => (
      reportPeriodWeek().fromUtcMs,
      reportPeriodWeek().toUtcMs,
    ),
    _TableScope.month => (
      reportPeriodMonth().fromUtcMs,
      reportPeriodMonth().toUtcMs,
    ),
    _TableScope.interval => (
      reportPeriodMonth().fromUtcMs,
      reportPeriodMonth().toUtcMs,
    ),
  };
}

(int, int) _timelineEffectiveRange(_JournalFilters f) {
  if (f.fromUtcMs != null && f.toUtcMs != null) {
    return (f.fromUtcMs!, f.toUtcMs!);
  }
  return switch (f.timelineScope) {
    _TimelineScope.week => (
      reportPeriodWeek().fromUtcMs,
      reportPeriodWeek().toUtcMs,
    ),
    _TimelineScope.month => (
      reportPeriodMonth().fromUtcMs,
      reportPeriodMonth().toUtcMs,
    ),
    _TimelineScope.interval => (
      reportPeriodMonth().fromUtcMs,
      reportPeriodMonth().toUtcMs,
    ),
  };
}

final journalViewModeProvider = StateProvider<JournalViewMode>(
  (ref) => JournalViewMode.table,
);

final _journalDayOverviewProvider = StreamProvider<List<JournalDayOverviewRow>>(
  (ref) {
    final filters = ref.watch(_journalFiltersProvider);
    final (from, to) = _timelineEffectiveRange(filters);
    return ref
        .watch(journalDayOverviewUseCaseProvider)
        .streamDayOverview(employeeId: null, fromUtcMs: from, toUtcMs: to);
  },
);

final _journalFiltersProvider = StateProvider<_JournalFilters>(
  (ref) => _JournalFilters.initial(),
);

final _journalProvider = StreamProvider<List<SessionWithEmployeeInfo>>((ref) {
  final filters = ref.watch(_journalFiltersProvider);
  final (from, to) = _tableEffectiveRange(filters);
  return ref
      .watch(watchSessionsUseCaseProvider)
      .streamSessionsWithEmployee(
        employeeId: null,
        fromUtcMs: from,
        toUtcMs: to,
      );
});

class SessionsPage extends ConsumerWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessionsAsync = ref.watch(_journalProvider);
    final filters = ref.watch(_journalFiltersProvider);
    final viewMode = ref.watch(journalViewModeProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.journalTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 16),
                SegmentedButton<JournalViewMode>(
                  showSelectedIcon: true,
                  segments: [
                    ButtonSegment(
                      value: JournalViewMode.table,
                      label: Text(l10n.journalViewTable),
                      icon: const Icon(Symbols.table_chart, size: 18),
                    ),
                    ButtonSegment(
                      value: JournalViewMode.timeline,
                      label: Text(l10n.journalViewTimeline),
                      icon: const Icon(Symbols.timeline, size: 18),
                    ),
                    ButtonSegment(
                      value: JournalViewMode.timelineDetailed,
                      label: Text(l10n.journalViewDetailed),
                      icon: const Icon(Symbols.schedule, size: 18),
                    ),
                  ],
                  selected: {viewMode},
                  onSelectionChanged: (s) {
                    final newMode = s.first;
                    if (newMode == JournalViewMode.timelineDetailed) {
                      final today = reportPeriodToday();
                      ref.read(_journalFiltersProvider.notifier).state = ref
                          .read(_journalFiltersProvider)
                          .copyWith(
                            fromUtcMs: today.fromUtcMs,
                            toUtcMs: today.toUtcMs,
                            detailedScope: _DetailedScope.day,
                          );
                    }
                    ref.read(journalViewModeProvider.notifier).state = newMode;
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (viewMode == JournalViewMode.timelineDetailed)
                  DateRangeFilterBar(
                    scope: _detailedScopeToDateRangeScope(filters.detailedScope),
                    fromUtcMs: _detailedEffectiveRange(filters).$1,
                    toUtcMs: _detailedEffectiveRange(filters).$2,
                    availableScopes: const [
                      DateRangeScope.day,
                      DateRangeScope.week,
                    ],
                    onChanged: (scope, from, to) =>
                        ref.read(_journalFiltersProvider.notifier).state =
                            filters.copyWith(
                          detailedScope: _dateRangeScopeToDetailedScope(scope),
                          fromUtcMs: from,
                          toUtcMs: to,
                        ),
                  )
                else if (viewMode == JournalViewMode.table)
                  DateRangeFilterBar(
                    scope: _tableScopeToDateRangeScope(filters.tableScope),
                    fromUtcMs: _tableEffectiveRange(filters).$1,
                    toUtcMs: _tableEffectiveRange(filters).$2,
                    availableScopes: const [
                      DateRangeScope.day,
                      DateRangeScope.week,
                      DateRangeScope.month,
                      DateRangeScope.interval,
                    ],
                    onChanged: (scope, from, to) =>
                        ref.read(_journalFiltersProvider.notifier).state =
                            filters.copyWith(
                          tableScope: _dateRangeScopeToTableScope(scope),
                          fromUtcMs: from,
                          toUtcMs: to,
                        ),
                  )
                else
                  DateRangeFilterBar(
                    scope: _timelineScopeToDateRangeScope(filters.timelineScope),
                    fromUtcMs: _timelineEffectiveRange(filters).$1,
                    toUtcMs: _timelineEffectiveRange(filters).$2,
                    availableScopes: const [
                      DateRangeScope.week,
                      DateRangeScope.month,
                      DateRangeScope.interval,
                    ],
                    onChanged: (scope, from, to) =>
                        ref.read(_journalFiltersProvider.notifier).state =
                            filters.copyWith(
                          timelineScope: _dateRangeScopeToTimelineScope(scope),
                          fromUtcMs: from,
                          toUtcMs: to,
                        ),
                  ),
                if (viewMode == JournalViewMode.table)
                  DropdownMenu<_JournalStatusFilter>(
                    label: Text(l10n.sessionsTableStatus),
                    initialSelection: filters.statusFilter,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: _JournalStatusFilter.all,
                        label: l10n.journalFilterStatusAll,
                      ),
                      DropdownMenuEntry(
                        value: _JournalStatusFilter.open,
                        label: l10n.journalFilterStatusOpen,
                      ),
                      DropdownMenuEntry(
                        value: _JournalStatusFilter.notClosed,
                        label: l10n.journalFilterStatusNotClosed,
                      ),
                      DropdownMenuEntry(
                        value: _JournalStatusFilter.closed,
                        label: l10n.journalFilterStatusClosed,
                      ),
                    ],
                    onSelected: (v) =>
                        ref
                            .read(_journalFiltersProvider.notifier)
                            .state = filters.copyWith(
                          statusFilter: v ?? filters.statusFilter,
                        ),
                  ),
                SizedBox(
                  width: 260,
                  child: _JournalSearchField(
                    initialQuery: filters.searchQuery,
                    onChanged: (v) =>
                        ref.read(_journalFiltersProvider.notifier).state =
                            filters.copyWith(searchQuery: v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: viewMode == JournalViewMode.timelineDetailed
                  ? _JournalDetailedTimelineContent(l10n: l10n)
                  : viewMode == JournalViewMode.timeline
                  ? _JournalTimelineContent(l10n: l10n)
                  : sessionsAsync.when(
                      data: (rows) {
                        final filtered = _applyClientFilters(rows, filters);
                        if (filtered.isEmpty) {
                          return Center(child: Text(l10n.sessionsNoSessions));
                        }
                        return _JournalTable(rows: filtered);
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                        child: Text(
                          l10n.sessionsFailedLoadSessions(
                            errorMessageForUser(e, l10n.commonErrorOccurred),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

final _journalIntervalOverviewProvider =
    StreamProvider<List<JournalIntervalRow>>((ref) {
      final filters = ref.watch(_journalFiltersProvider);
      final viewMode = ref.watch(journalViewModeProvider);
      final workingHoursAsync = ref.watch(workingHoursSettingsProvider);

      final (
        fromUtcMs,
        toUtcMs,
      ) = (filters.fromUtcMs != null && filters.toUtcMs != null)
          ? (filters.fromUtcMs!, filters.toUtcMs!)
          : (() {
              if (viewMode == JournalViewMode.timelineDetailed) {
                final t = reportPeriodToday();
                return (t.fromUtcMs, t.toUtcMs);
              }
              final m = reportPeriodMonth();
              return (m.fromUtcMs, m.toUtcMs);
            })();

      final workingHours = workingHoursAsync.value;
      if (workingHours == null) return Stream.value([]);

      return ref
          .watch(journalIntervalOverviewUseCaseProvider)
          .streamIntervalOverview(
            employeeId: null,
            fromUtcMs: fromUtcMs,
            toUtcMs: toUtcMs,
            startMin: workingHours.startMin,
            endMin: workingHours.endMin,
          );
    });

List<JournalDayOverviewRow> _filterDayOverviewBySearch(
  List<JournalDayOverviewRow> rows,
  String searchQuery,
) {
  if (searchQuery.isEmpty) return rows;
  final lower = searchQuery.toLowerCase().trim();
  return rows.where((r) {
    final name = EmployeeDisplayName.of(
      EmployeeDisplay(firstName: r.firstName, lastName: r.lastName),
    ).toLowerCase();
    return name.contains(lower);
  }).toList();
}

List<JournalIntervalRow> _filterIntervalOverviewBySearch(
  List<JournalIntervalRow> rows,
  String searchQuery,
) {
  if (searchQuery.isEmpty) return rows;
  final lower = searchQuery.toLowerCase().trim();
  return rows.where((r) {
    final name = EmployeeDisplayName.of(
      EmployeeDisplay(firstName: r.firstName, lastName: r.lastName),
    ).toLowerCase();
    return name.contains(lower);
  }).toList();
}

class _JournalDetailedTimelineContent extends ConsumerWidget {
  const _JournalDetailedTimelineContent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(_journalFiltersProvider);
    final (
      fromUtcMs,
      toUtcMs,
    ) = (filters.fromUtcMs != null && filters.toUtcMs != null)
        ? (filters.fromUtcMs!, filters.toUtcMs!)
        : (() {
            final t = reportPeriodToday();
            return (t.fromUtcMs, t.toUtcMs);
          })();
    final workingHoursAsync = ref.watch(workingHoursSettingsProvider);
    final intervalAsync = ref.watch(_journalIntervalOverviewProvider);

    return workingHoursAsync.when(
      data: (wh) {
        return intervalAsync.when(
          data: (rows) {
            final filtered = _filterIntervalOverviewBySearch(
              rows,
              filters.searchQuery,
            );
            if (filtered.isEmpty) {
              return Center(child: Text(l10n.journalTimelinePickRangeHint));
            }
            return JournalDetailedTimelineGrid(
              rows: filtered,
              fromUtcMs: fromUtcMs,
              toUtcMs: toUtcMs,
              startMin: wh.startMin,
              endMin: wh.endMin,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              l10n.sessionsFailedLoadSessions(
                errorMessageForUser(e, l10n.commonErrorOccurred),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l10n.journalTimelinePickRangeHint)),
    );
  }
}

class _JournalTimelineContent extends ConsumerWidget {
  const _JournalTimelineContent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(_journalFiltersProvider);
    final (fromUtcMs, toUtcMs) = _timelineEffectiveRange(filters);
    final overviewAsync = ref.watch(_journalDayOverviewProvider);
    return overviewAsync.when(
      data: (rows) {
        final filtered = _filterDayOverviewBySearch(rows, filters.searchQuery);
        if (filtered.isEmpty) {
          return Center(child: Text(l10n.journalTimelinePickRangeHint));
        }
        return JournalTimelineGrid(
          rows: filtered,
          fromUtcMs: fromUtcMs,
          toUtcMs: toUtcMs,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          l10n.sessionsFailedLoadSessions(
            errorMessageForUser(e, l10n.commonErrorOccurred),
          ),
        ),
      ),
    );
  }
}

class _JournalSearchField extends StatefulWidget {
  const _JournalSearchField({
    required this.initialQuery,
    required this.onChanged,
  });

  final String initialQuery;
  final ValueChanged<String> onChanged;

  @override
  State<_JournalSearchField> createState() => _JournalSearchFieldState();
}

class _JournalSearchFieldState extends State<_JournalSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(_JournalSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        _controller.text != widget.initialQuery) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: l10n.journalFilterEmployee,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (v) => widget.onChanged(v.trim()),
    );
  }
}

bool _isNotClosed(SessionInfo s) {
  if (s.status != 'OPEN' || s.endTs != null) return false;
  final startLocal = DateTime.fromMillisecondsSinceEpoch(
    s.startTs,
    isUtc: true,
  ).toLocal();
  final startYmd = dateToYmd(
    DateTime(startLocal.year, startLocal.month, startLocal.day),
  );
  return startYmd.compareTo(todayYmd()) < 0;
}

List<SessionWithEmployeeInfo> _applyClientFilters(
  List<SessionWithEmployeeInfo> rows,
  _JournalFilters filters,
) {
  var result = rows;
  final statusFilter = filters.statusFilter;
  if (statusFilter == _JournalStatusFilter.open) {
    result = result.where((r) => r.session.status == 'OPEN').toList();
  } else if (statusFilter == _JournalStatusFilter.notClosed) {
    result = result.where((r) => _isNotClosed(r.session)).toList();
  } else if (statusFilter == _JournalStatusFilter.closed) {
    result = result.where((r) => r.session.status == 'CLOSED').toList();
  }
  final query = filters.searchQuery;
  if (query.isNotEmpty) {
    final lower = query.toLowerCase();
    result = result.where((r) {
      final name = EmployeeDisplayName.of(
        EmployeeDisplay(
          firstName: r.employee.firstName,
          lastName: r.employee.lastName,
        ),
      ).toLowerCase();
      final note = (r.session.note ?? '').toLowerCase();
      return name.contains(lower) || note.contains(lower);
    }).toList();
  }
  return result;
}

class _JournalFilters {
  const _JournalFilters({
    required this.employeeId,
    required this.fromUtcMs,
    required this.toUtcMs,
    required this.statusFilter,
    required this.searchQuery,
    required this.detailedScope,
    required this.tableScope,
    required this.timelineScope,
  });

  final int? employeeId;
  final int? fromUtcMs;
  final int? toUtcMs;
  final _JournalStatusFilter statusFilter;
  final String searchQuery;

  /// Only used when viewMode is timelineDetailed.
  final _DetailedScope detailedScope;

  /// Only used when viewMode is table.
  final _TableScope tableScope;

  /// Only used when viewMode is timeline.
  final _TimelineScope timelineScope;

  factory _JournalFilters.initial() => const _JournalFilters(
    employeeId: null,
    fromUtcMs: null,
    toUtcMs: null,
    statusFilter: _JournalStatusFilter.all,
    searchQuery: '',
    detailedScope: _DetailedScope.day,
    tableScope: _TableScope.month,
    timelineScope: _TimelineScope.month,
  );

  _JournalFilters copyWith({
    Object? employeeId = _sentinel,
    Object? fromUtcMs = _sentinel,
    Object? toUtcMs = _sentinel,
    Object? statusFilter = _sentinel,
    Object? searchQuery = _sentinel,
    Object? detailedScope = _sentinel,
    Object? tableScope = _sentinel,
    Object? timelineScope = _sentinel,
  }) {
    return _JournalFilters(
      employeeId: identical(employeeId, _sentinel)
          ? this.employeeId
          : employeeId as int?,
      fromUtcMs: identical(fromUtcMs, _sentinel)
          ? this.fromUtcMs
          : fromUtcMs as int?,
      toUtcMs: identical(toUtcMs, _sentinel) ? this.toUtcMs : toUtcMs as int?,
      statusFilter: identical(statusFilter, _sentinel)
          ? this.statusFilter
          : statusFilter as _JournalStatusFilter,
      searchQuery: identical(searchQuery, _sentinel)
          ? this.searchQuery
          : searchQuery as String,
      detailedScope: identical(detailedScope, _sentinel)
          ? this.detailedScope
          : detailedScope as _DetailedScope,
      tableScope: identical(tableScope, _sentinel)
          ? this.tableScope
          : tableScope as _TableScope,
      timelineScope: identical(timelineScope, _sentinel)
          ? this.timelineScope
          : timelineScope as _TimelineScope,
    );
  }
}

const _sentinel = Object();

class _JournalTable extends ConsumerWidget {
  const _JournalTable({required this.rows});

  final List<SessionWithEmployeeInfo> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: 1,
          sortAscending: false,
          columnSpacing: 24,
          columns: [
            DataColumn(label: Text(l10n.sessionsTableEmployee)),
            DataColumn(
              label: Center(child: Text(l10n.sessionsTableStart)),
              numeric: true,
            ),
            DataColumn(
              label: Center(child: Text(l10n.sessionsTableEnd)),
              numeric: true,
            ),
            DataColumn(
              label: Center(child: Text(l10n.sessionsTableDuration)),
              numeric: true,
            ),
            DataColumn(label: Center(child: Text(l10n.sessionsTableStatus))),
            DataColumn(label: Center(child: Text(l10n.sessionsTableActions))),
          ],
          rows: rows
              .map((row) {
                final s = row.session;
                final employeeName = EmployeeDisplayName.of(
                  EmployeeDisplay(
                    firstName: row.employee.firstName,
                    lastName: row.employee.lastName,
                  ),
                );
                final start = TimeFormat.formatLocalDateTimeNoSeconds(
                  s.startTs,
                );
                final end = s.endTs == null
                    ? l10n.journalEndEmpty
                    : TimeFormat.formatLocalDateTimeNoSeconds(s.endTs!);
                final duration = s.endTs == null
                    ? l10n.commonOngoing
                    : (() {
                        final minutes = ((s.endTs! - s.startTs) / 60000)
                            .floor();
                        final h = minutes ~/ 60;
                        final m = minutes % 60;
                        return l10n.durationHm(h, m);
                      })();
                final isOpen = s.status == 'OPEN';
                final isNotClosed = isOpen && _isNotClosed(s);

                return DataRow(
                  cells: [
                    DataCell(Text(employeeName)),
                    DataCell(Center(child: Text(start))),
                    DataCell(Center(child: Text(end))),
                    DataCell(Center(child: Text(duration))),
                    DataCell(
                      Center(
                        child: Tooltip(
                          message: isNotClosed
                              ? l10n.journalFilterStatusNotClosed
                              : isOpen
                              ? l10n.commonOngoing
                              : l10n.journalFilterStatusClosed,
                          child: Icon(
                            isNotClosed
                                ? Symbols.warning_amber_rounded
                                : isOpen
                                ? Symbols.schedule
                                : Symbols.check_circle,
                            size: 20,
                            color: isNotClosed
                                ? Theme.of(context).colorScheme.error
                                : isOpen
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: IconButton(
                          icon: const Icon(Symbols.edit),
                          tooltip: l10n.sessionsEdit,
                          onPressed: () => _openEditDialog(
                            context,
                            ref,
                            row,
                            closeNowPreFill: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    SessionWithEmployeeInfo row, {
    required bool closeNowPreFill,
  }) async {
    final s = row.session;
    var startUtcMs = s.startTs;
    int? endUtcMs = closeNowPreFill ? UtcClock.nowMs() : s.endTs;
    final noteCtrl = TextEditingController(text: s.note ?? '');
    final reasonCtrl = TextEditingController();
    final initialStartUtcMs = s.startTs;
    final initialEndUtcMs = s.endTs;

    String? validationError;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return StatefulBuilder(
          builder: (context, setState) {
            final startText = TimeFormat.formatLocalDateTimeNoSeconds(
              startUtcMs,
            );
            final endText = endUtcMs == null
                ? l10n.commonOngoing
                : TimeFormat.formatLocalDateTimeNoSeconds(endUtcMs!);
            final durationText = endUtcMs == null
                ? l10n.commonOngoing
                : l10n.durationHm(
                    ((endUtcMs! - startUtcMs) / 60000).floor() ~/ 60,
                    ((endUtcMs! - startUtcMs) / 60000).floor() % 60,
                  );
            final startOrEndChanged =
                startUtcMs != initialStartUtcMs || endUtcMs != initialEndUtcMs;
            final reasonRequired = startOrEndChanged;
            final reasonEmpty = reasonCtrl.text.trim().isEmpty;

            return AlertDialog(
              title: Text(l10n.journalEditDialogTitle),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (validationError != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .errorContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Symbols.error,
                              size: 20,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                validationError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.sessionsEmployeePrefix(
                          EmployeeDisplayName.of(
                            EmployeeDisplay(
                              firstName: row.employee.firstName,
                              lastName: row.employee.lastName,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await pickLocalDateTime(context);
                              if (picked == null) return;
                              setState(() {
                                startUtcMs = picked
                                    .toUtc()
                                    .millisecondsSinceEpoch;
                              });
                            },
                            child: Text(l10n.sessionsStartPrefix(startText)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await pickLocalDateTime(context);
                              if (picked == null) return;
                              setState(() {
                                endUtcMs = picked
                                    .toUtc()
                                    .millisecondsSinceEpoch;
                              });
                            },
                            child: Text(l10n.sessionsEndPrefix(endText)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.sessionsDurationWithValue(durationText),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () =>
                              setState(() => endUtcMs = UtcClock.nowMs()),
                          child: Text(l10n.sessionsSetEndNow),
                        ),
                        TextButton(
                          onPressed: () => setState(() => endUtcMs = null),
                          child: Text(l10n.sessionsClearEnd),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.sessionsTableNote,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.sessionsUpdateReason,
                        hintText: reasonRequired
                            ? null
                            : l10n.journalUpdateReasonHint,
                        errorText: reasonRequired && reasonEmpty
                            ? l10n.sessionsUpdateReasonRequired
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.sessionsEmployeeCannotChangeHint,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: (reasonRequired && reasonEmpty) ? null : () async {
                    validationError = null;
                    setState(() {});

                    if (reasonRequired && reasonCtrl.text.trim().isEmpty) {
                      validationError = l10n.sessionsUpdateReasonRequired;
                      setState(() {});
                      return;
                    }
                    if (endUtcMs != null) {
                      if (endUtcMs! <= startUtcMs) {
                        validationError = l10n.journalErrorEndBeforeStart;
                        setState(() {});
                        return;
                      }
                      if (!isSameLocalCalendarDay(startUtcMs, endUtcMs!)) {
                        validationError = l10n.journalErrorCrossDay;
                        setState(() {});
                        return;
                      }
                    }
                    final emp = row.employee;
                    final startLocal = DateTime.fromMillisecondsSinceEpoch(
                      startUtcMs,
                      isUtc: true,
                    ).toLocal();
                    final startYmd = dateToYmd(
                      DateTime(startLocal.year, startLocal.month, startLocal.day),
                    );
                    if (!isDateWithinEmployment(
                      emp.hireDate,
                      emp.terminationDate,
                      startYmd,
                    )) {
                      validationError = l10n.journalErrorOutsideEmployment;
                      setState(() {});
                      return;
                    }
                    if (endUtcMs != null) {
                      final endLocal = DateTime.fromMillisecondsSinceEpoch(
                        endUtcMs!,
                        isUtc: true,
                      ).toLocal();
                      final endYmd = dateToYmd(
                        DateTime(
                          endLocal.year,
                          endLocal.month,
                          endLocal.day,
                        ),
                      );
                      if (!isDateWithinEmployment(
                        emp.hireDate,
                        emp.terminationDate,
                        endYmd,
                      )) {
                        validationError = l10n.journalErrorOutsideEmployment;
                        setState(() {});
                        return;
                      }
                    }
                    try {
                      final useCase = ref.read(
                        updateSessionAsAdminUseCaseProvider,
                      );
                      await useCase(
                        sessionId: s.id,
                        startUtcMs: startUtcMs,
                        endUtcMs: endUtcMs,
                        note: noteCtrl.text.trim().isEmpty
                            ? null
                            : noteCtrl.text.trim(),
                        updateReason: startOrEndChanged
                            ? reasonCtrl.text.trim()
                            : '',
                        updatedBy: 'admin',
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } on DomainValidationException catch (e) {
                      if (!context.mounted) return;
                      validationError = switch (e.message) {
                        'sessionsErrorSameDayRequired' =>
                          l10n.journalErrorCrossDay,
                        'journalErrorOutsideEmployment' =>
                          l10n.journalErrorOutsideEmployment,
                        _ => errorMessageForUser(e, l10n.commonErrorOccurred),
                      };
                      setState(() {});
                    }
                  },
                  child: Text(l10n.commonSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true && context.mounted) {
      showAppSnack(context, AppLocalizations.of(context).journalSaved);
    }
  }
}
