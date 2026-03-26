import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../app/absences_providers.dart';
import '../../app/sessions_providers.dart';
import '../../common/utils/absence_domain_messages.dart';
import '../../common/utils/date_utils.dart';
import '../../common/utils/employee_display_name.dart';
import '../../common/utils/terminal_session_duration_format.dart';
import '../../common/utils/time_format.dart';
import '../../common/widgets/app_snack.dart';
import '../../core/domain_errors.dart';
import '../../domain/entities/absence_info.dart';
import '../../domain/entities/absence_with_employee_info.dart';
import '../../domain/entities/employee_display.dart';
import '../../domain/entities/session_info.dart';
import '../../domain/entities/employee_info.dart';
import '../admin/absences/absence_request_dialog.dart';

const _absenceTypeKeys = {
  'vacation': 'absenceTypeVacation',
  'sick_leave': 'absenceTypeSickLeave',
  'unpaid_leave': 'absenceTypeUnpaidLeave',
  'parental_leave': 'absenceTypeParentalLeave',
  'study_leave': 'absenceTypeStudyLeave',
  'other': 'absenceTypeOther',
};

String _formatDateRange(BuildContext context, String dateFrom, String dateTo) {
  final locale = Localizations.localeOf(context).toString();
  final from = DateTime.parse(dateFrom);
  final to = DateTime.parse(dateTo);
  return '${DateFormat.yMd(locale).format(from)} – ${DateFormat.yMd(locale).format(to)}';
}

String _typeLabel(String type, AppLocalizations l10n) {
  return switch (_absenceTypeKeys[type]) {
    'absenceTypeVacation' => l10n.absenceTypeVacation,
    'absenceTypeSickLeave' => l10n.absenceTypeSickLeave,
    'absenceTypeUnpaidLeave' => l10n.absenceTypeUnpaidLeave,
    'absenceTypeParentalLeave' => l10n.absenceTypeParentalLeave,
    'absenceTypeStudyLeave' => l10n.absenceTypeStudyLeave,
    'absenceTypeOther' => l10n.absenceTypeOther,
    _ => type,
  };
}

const _statusKeys = {
  'PENDING': 'absenceStatusPending',
  'APPROVED': 'absenceStatusApproved',
  'REJECTED': 'absenceStatusRejected',
};

String _statusLabel(String status, AppLocalizations l10n) {
  return switch (_statusKeys[status]) {
    'absenceStatusPending' => l10n.absenceStatusPending,
    'absenceStatusApproved' => l10n.absenceStatusApproved,
    'absenceStatusRejected' => l10n.absenceStatusRejected,
    _ => status,
  };
}

Widget _statusChip(String status, AppLocalizations l10n, BuildContext context) {
  final color = switch (status) {
    'PENDING' => Theme.of(context).colorScheme.tertiary,
    'APPROVED' => Theme.of(context).colorScheme.primary,
    'REJECTED' => Theme.of(context).colorScheme.error,
    _ => Theme.of(context).colorScheme.surfaceContainerHighest,
  };
  return Chip(
    label: Text(_statusLabel(status, l10n)),
    backgroundColor: color.withValues(alpha: 0.3),
    side: BorderSide(color: color),
    padding: EdgeInsets.zero,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

final _calendarRangeAbsencesProvider =
    StreamProvider.family<List<AbsenceWithEmployeeInfo>, (int, int, int)>((
      ref,
      args,
    ) {
      final (employeeId, year, month) = args;
      final firstYmd = dateToYmd(DateTime(year, month - 1, 1));
      final lastYmd = dateToYmd(DateTime(year, month + 2, 0));
      return ref
          .watch(watchAbsencesUseCaseProvider)
          .streamAbsences(
            employeeId: employeeId,
            fromDate: firstYmd,
            toDate: lastYmd,
          );
    });

final _calendarDayAbsencesProvider =
    StreamProvider.family<List<AbsenceWithEmployeeInfo>, (int, String)>((
      ref,
      args,
    ) {
      final (employeeId, ymd) = args;
      return ref
          .watch(watchAbsencesUseCaseProvider)
          .streamAbsences(employeeId: employeeId, fromDate: ymd, toDate: ymd);
    });

/// Expands absence date range to all days with status (for calendar markers).
/// REJECTED absences are excluded — they are not shown on the calendar.
Map<DateTime, Set<String>> _absenceDaysByStatus(
  List<AbsenceWithEmployeeInfo> absences,
) {
  final map = <DateTime, Set<String>>{};
  for (final row in absences) {
    final a = row.absence;
    if (a.status == 'REJECTED') continue;
    final fromParts = a.dateFrom.split('-');
    final toParts = a.dateTo.split('-');
    if (fromParts.length != 3 || toParts.length != 3) continue;
    final from = DateTime(
      int.parse(fromParts[0]),
      int.parse(fromParts[1]),
      int.parse(fromParts[2]),
    );
    final to = DateTime(
      int.parse(toParts[0]),
      int.parse(toParts[1]),
      int.parse(toParts[2]),
    );
    var d = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    while (!d.isAfter(end)) {
      map.putIfAbsent(d, () => {}).add(a.status);
      d = d.add(const Duration(days: 1));
    }
  }
  return map;
}

/// Session start date in local time (for calendar markers).
Set<DateTime> _sessionDays(List<SessionInfo> sessions) {
  final set = <DateTime>{};
  for (final s in sessions) {
    final local = DateTime.fromMillisecondsSinceEpoch(
      s.startTs,
      isUtc: true,
    ).toLocal();
    set.add(DateTime(local.year, local.month, local.day));
  }
  return set;
}

class EmployeeCalendarPage extends ConsumerStatefulWidget {
  const EmployeeCalendarPage({
    super.key,
    required this.employeeId,
    required this.employee,
  });

  final int employeeId;
  final EmployeeInfo employee;

  @override
  ConsumerState<EmployeeCalendarPage> createState() =>
      _EmployeeCalendarPageState();
}

class _EmployeeCalendarPageState extends ConsumerState<EmployeeCalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final sessionsAsync = ref.watch(
      watchSessionsForCalendarRangeProvider((
        widget.employeeId,
        _focusedDay.year,
        _focusedDay.month,
      )),
    );
    final absencesAsync = ref.watch(
      _calendarRangeAbsencesProvider((
        widget.employeeId,
        _focusedDay.year,
        _focusedDay.month,
      )),
    );

    final sessionDays = <DateTime>{};
    final absenceDaysByStatus = <DateTime, Set<String>>{};
    final sessions = sessionsAsync.value;
    if (sessions != null) sessionDays.addAll(_sessionDays(sessions));
    final absences = absencesAsync.value;
    if (absences != null) {
      absenceDaysByStatus.addAll(_absenceDaysByStatus(absences));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.terminalCalendarPageTitle(
            EmployeeDisplayName.of(
              EmployeeDisplay(
                firstName: widget.employee.firstName,
                lastName: widget.employee.lastName,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          tooltip: l10n.commonBack,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sideBySide = constraints.maxWidth >= 900;
          final calendarPart = Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      setState(() {
                        _selectedDay = today;
                        _focusedDay = today;
                      });
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      minimumSize: const Size(0, 48),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Symbols.today, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n.terminalSessionsToday),
                      ],
                    ),
                  ),
                  SegmentedButton<CalendarFormat>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment<CalendarFormat>(
                        value: CalendarFormat.month,
                        label: Text(l10n.terminalCalendarFormatMonth),
                      ),
                      ButtonSegment<CalendarFormat>(
                        value: CalendarFormat.week,
                        label: Text(l10n.terminalCalendarFormatWeek),
                      ),
                      ButtonSegment<CalendarFormat>(
                        value: CalendarFormat.twoWeeks,
                        label: Text(l10n.terminalCalendarFormatTwoWeeks),
                      ),
                    ],
                    selected: {_calendarFormat},
                    onSelectionChanged: (Set<CalendarFormat> s) =>
                        setState(() => _calendarFormat = s.first),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat.yMMMd(locale).format(_selectedDay),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: TableCalendar<String>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) {
                      final hasSession = sessionDays.any(
                        (d) => isSameDay(d, day),
                      );
                      Set<String>? statuses;
                      for (final e in absenceDaysByStatus.entries) {
                        if (isSameDay(e.key, day)) {
                          statuses = e.value;
                          break;
                        }
                      }
                      final list = <String>[];
                      if (hasSession) list.add('session');
                      if (statuses != null) {
                        for (final s in statuses) {
                          list.add('absence_$s');
                        }
                      }
                      return list;
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) =>
                        setState(() => _calendarFormat = format),
                    onPageChanged: (focusedDay) =>
                        setState(() => _focusedDay = focusedDay),
                    locale: locale,
                    headerStyle: const HeaderStyle(formatButtonVisible: false),
                    calendarBuilders: CalendarBuilders<String>(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return null;
                        final cs = Theme.of(context).colorScheme;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (events.contains('session'))
                              Container(
                                height: 3,
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            if (events.contains('absence_PENDING'))
                              Container(
                                height: 3,
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: cs.tertiary,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            if (events.contains('absence_APPROVED'))
                              Container(
                                height: 3,
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.terminalCalendarSessions,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.terminalCalendarAbsences,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (!sideBySide) ...[
                const SizedBox(height: 12),
                _DayDetailBlock(
                  employeeId: widget.employeeId,
                  employee: widget.employee,
                  selectedDay: _selectedDay,
                  l10n: l10n,
                ),
              ],
            ],
          );
          final detailBlock = _DayDetailBlock(
            employeeId: widget.employeeId,
            employee: widget.employee,
            selectedDay: _selectedDay,
            l10n: l10n,
          );
          Widget content;
          if (sideBySide) {
            content = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: calendarPart,
                ),
                const SizedBox(width: 16),
                SizedBox(width: 320, child: detailBlock),
              ],
            );
          } else {
            content = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: calendarPart,
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: content,
          );
        },
      ),
    );
  }
}

class _DayDetailBlock extends ConsumerWidget {
  const _DayDetailBlock({
    required this.employeeId,
    required this.employee,
    required this.selectedDay,
    required this.l10n,
  });

  final int employeeId;
  final EmployeeInfo employee;
  final DateTime selectedDay;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ymd = dateToYmd(selectedDay);
    final sessionsAsync = ref.watch(
      watchSessionsForEmployeeOnDateProvider((employeeId, selectedDay)),
    );
    final absencesAsync = ref.watch(
      _calendarDayAbsencesProvider((employeeId, ymd)),
    );

    return sessionsAsync.when(
      data: (sessions) {
        return absencesAsync.when(
          data: (absences) {
            final hasSessions = sessions.isNotEmpty;
            final hasAbsences = absences.isNotEmpty;
            if (!hasSessions && !hasAbsences) {
              return Card(
                elevation: 1,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.calendar_today,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.terminalCalendarNoData,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _openCreateDialog(context, ref),
                        icon: const Icon(Symbols.add),
                        label: Text(l10n.absenceCreateTitle),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasSessions) ...[
                      Text(
                        l10n.terminalCalendarSessions,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...sessions.map(
                        (s) => _SessionRow(
                          session: s,
                          openSessionId: null,
                          l10n: l10n,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (hasAbsences) ...[
                      Text(
                        l10n.terminalCalendarAbsences,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...absences.map(
                        (row) => _AbsenceCard(
                          row: row,
                          l10n: l10n,
                          onEdit: () =>
                              _openEditDialog(context, ref, row.absence),
                          onDelete: () =>
                              _deleteAbsence(context, ref, row.absence.id),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    FilledButton.icon(
                      onPressed: () => _openCreateDialog(context, ref),
                      icon: const Icon(Symbols.add),
                      label: Text(l10n.absenceCreateTitle),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.terminalFailedLoadEmployees(l10n.commonErrorOccurred),
              ),
            ),
          ),
        );
      },
      loading: () => Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.terminalFailedLoadEmployees(l10n.commonErrorOccurred),
          ),
        ),
      ),
    );
  }

  Future<void> _openCreateDialog(BuildContext context, WidgetRef ref) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AbsenceRequestDialog(
        employeeId: employeeId,
        isAdminContext: false,
        employees: [employee],
        onSaved: () {},
      ),
    );
    if (saved == true && context.mounted) {
      showAppSnack(context, l10n.absenceCreated);
    }
  }

  Future<void> _openEditDialog(
    BuildContext context,
    WidgetRef ref,
    AbsenceInfo a,
  ) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AbsenceRequestDialog(
        existing: a,
        employeeId: employeeId,
        isAdminContext: false,
        employees: [employee],
        onSaved: () {},
      ),
    );
    if (saved == true && context.mounted) {
      showAppSnack(context, l10n.absenceUpdated);
    }
  }

  Future<void> _deleteAbsence(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.absenceDelete),
        content: Text(l10n.absenceDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonRemove),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      await ref.read(absencesAdminUseCaseProvider).deleteAbsence(id);
      if (context.mounted) {
        showAppSnack(context, l10n.absenceDeleted);
      }
    } on DomainException catch (e) {
      if (context.mounted) {
        showAppSnack(
          context,
          absenceDomainMessageForKey(e.message, l10n),
          isError: true,
        );
      }
    }
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.openSessionId,
    required this.l10n,
  });

  final SessionInfo session;
  final int? openSessionId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final isOpen = session.id == openSessionId;
    final start = TimeFormat.formatTimeOnly(session.startTs);
    final String trailing;
    if (isOpen) {
      trailing = formatTerminalSessionDuration(
        l10n,
        minutesBetweenUtcMsClamp(session.startTs, nowMs),
      );
    } else if (session.endTs != null) {
      trailing = formatTerminalSessionDuration(
        l10n,
        minutesBetweenUtcMsClamp(session.startTs, session.endTs!),
      );
    } else {
      trailing = l10n.commonOngoing;
    }
    final endStr = session.endTs != null
        ? TimeFormat.formatTimeOnly(session.endTs!)
        : '…';
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Material(
      color: isOpen ? cs.primaryContainer.withValues(alpha: 0.5) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              isOpen ? Symbols.schedule : Symbols.check_circle,
              size: 20,
              color: isOpen ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 95,
              child: Text(
                '$start – $endStr',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Expanded(
              child: Text(
                trailing,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOpen ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: isOpen ? FontWeight.w600 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AbsenceCard extends StatelessWidget {
  const _AbsenceCard({
    required this.row,
    required this.l10n,
    required this.onEdit,
    required this.onDelete,
  });

  final AbsenceWithEmployeeInfo row;
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final a = row.absence;
    final isPending = a.status == 'PENDING';

    return Card(
      child: ListTile(
        title: Text(_typeLabel(a.type, l10n)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_formatDateRange(context, a.dateFrom, a.dateTo)),
            const SizedBox(height: 4),
            _statusChip(a.status, l10n, context),
          ],
        ),
        trailing: isPending
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Symbols.edit),
                    tooltip: l10n.absenceEdit,
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Symbols.delete),
                    tooltip: l10n.absenceDelete,
                    onPressed: onDelete,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
