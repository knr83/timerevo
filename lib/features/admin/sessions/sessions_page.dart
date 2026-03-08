import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/sessions_providers.dart';
import '../../../app/usecase_providers.dart';
import '../../../common/utils/date_time_picker.dart';
import '../../../common/utils/date_utils.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/utils/time_format.dart';
import '../../../common/utils/utc_clock.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/date_filter_chip.dart';
import '../../../core/domain_errors.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/session_with_employee_info.dart';

enum _JournalStatusFilter { all, open, closed }

final _journalFiltersProvider =
    StateProvider<_JournalFilters>((ref) => _JournalFilters.initial());

final _journalProvider = StreamProvider<List<SessionWithEmployeeInfo>>((ref) {
  final filters = ref.watch(_journalFiltersProvider);
  return ref.watch(watchSessionsUseCaseProvider).streamSessionsWithEmployee(
        employeeId: filters.employeeId,
        fromUtcMs: filters.fromUtcMs,
        toUtcMs: filters.toUtcMs,
      );
});

class SessionsPage extends ConsumerWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final employeesAsync = ref.watch(watchAllEmployeesProvider);
    final sessionsAsync = ref.watch(_journalProvider);
    final filters = ref.watch(_journalFiltersProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.journalTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DateFilterChip(
                      label: l10n.journalFilterFrom,
                      valueUtcMs: filters.fromUtcMs,
                      anyLabel: l10n.journalFilterAny,
                      onPickedUtcMs: (v) => ref
                          .read(_journalFiltersProvider.notifier)
                          .state = filters.copyWith(fromUtcMs: v),
                      onCleared: () => ref
                          .read(_journalFiltersProvider.notifier)
                          .state = filters.copyWith(fromUtcMs: null),
                      useEndOfDay: false,
                    ),
                    DateFilterChip(
                      label: l10n.journalFilterTo,
                      valueUtcMs: filters.toUtcMs,
                      anyLabel: l10n.journalFilterAny,
                      onPickedUtcMs: (v) => ref
                          .read(_journalFiltersProvider.notifier)
                          .state = filters.copyWith(toUtcMs: v),
                      onCleared: () => ref
                          .read(_journalFiltersProvider.notifier)
                          .state = filters.copyWith(toUtcMs: null),
                      useEndOfDay: true,
                    ),
                    _PresetChips(
                      onPreset: (fromUtcMs, toUtcMs) => ref
                          .read(_journalFiltersProvider.notifier)
                          .state = filters.copyWith(
                              fromUtcMs: fromUtcMs, toUtcMs: toUtcMs),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DropdownMenu<_JournalStatusFilter>(
                      label: Text(l10n.sessionsTableStatus),
                      initialSelection: filters.statusFilter,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                            value: _JournalStatusFilter.all,
                            label: l10n.journalFilterStatusAll),
                        DropdownMenuEntry(
                            value: _JournalStatusFilter.open,
                            label: l10n.journalFilterStatusOpen),
                        DropdownMenuEntry(
                            value: _JournalStatusFilter.closed,
                            label: l10n.journalFilterStatusClosed),
                      ],
                      onSelected: (v) => ref
                          .read(_journalFiltersProvider.notifier)
                          .state = filters.copyWith(
                              statusFilter: v ?? filters.statusFilter),
                    ),
                    employeesAsync.when(
                      data: (employees) {
                        return DropdownMenu<int?>(
                          label: Text(l10n.sessionsEmployeeFilter),
                          initialSelection: filters.employeeId,
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                                value: null, label: l10n.sessionsEmployeeAll),
                            ...employees.map(
                              (e) => DropdownMenuEntry(
                                value: e.id,
                                label: EmployeeDisplayName.of(
                                    EmployeeDisplay(
                                        firstName: e.firstName,
                                        lastName: e.lastName)),
                              ),
                            ),
                          ],
                          onSelected: (v) => ref
                              .read(_journalFiltersProvider.notifier)
                              .state = filters.copyWith(employeeId: v),
                        );
                      },
                      loading: () => const SizedBox(
                        width: 240,
                        height: 56,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text(l10n.sessionsFailedLoadEmployees(
                          errorMessageForUser(e, l10n.commonErrorOccurred))),
                    ),
                    SizedBox(
                      width: 180,
                      child: _JournalSearchField(
                        initialQuery: filters.searchQuery,
                        onChanged: (v) => ref
                            .read(_journalFiltersProvider.notifier)
                            .state = filters.copyWith(searchQuery: v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: sessionsAsync.when(
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
                  child: Text(l10n.sessionsFailedLoadSessions(
                      errorMessageForUser(e, l10n.commonErrorOccurred))),
                ),
              ),
            ),
          ],
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
        labelText: l10n.journalFilterSearch,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (v) => widget.onChanged(v.trim()),
    );
  }
}

List<SessionWithEmployeeInfo> _applyClientFilters(
  List<SessionWithEmployeeInfo> rows,
  _JournalFilters filters,
) {
  var result = rows;
  final statusFilter = filters.statusFilter;
  if (statusFilter == _JournalStatusFilter.open) {
    result = result.where((r) => r.session.status == 'OPEN').toList();
  } else if (statusFilter == _JournalStatusFilter.closed) {
    result = result.where((r) => r.session.status == 'CLOSED').toList();
  }
  final query = filters.searchQuery;
  if (query.isNotEmpty) {
    final lower = query.toLowerCase();
    result = result.where((r) {
      final name = EmployeeDisplayName.of(EmployeeDisplay(
              firstName: r.employee.firstName, lastName: r.employee.lastName))
          .toLowerCase();
      final note = (r.session.note ?? '').toLowerCase();
      return name.contains(lower) || note.contains(lower);
    }).toList();
  }
  return result;
}

class _PresetChips extends StatelessWidget {
  const _PresetChips({required this.onPreset});

  final void Function(int fromUtcMs, int toUtcMs) onPreset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 4,
      children: [
        FilterChip(
          label: Text(l10n.journalPresetToday),
          onSelected: (_) {
            final r = reportPeriodToday();
            onPreset(r.fromUtcMs, r.toUtcMs);
          },
        ),
        FilterChip(
          label: Text(l10n.journalPresetWeek),
          onSelected: (_) {
            final r = reportPeriodWeek();
            onPreset(r.fromUtcMs, r.toUtcMs);
          },
        ),
        FilterChip(
          label: Text(l10n.journalPresetMonth),
          onSelected: (_) {
            final r = reportPeriodMonth();
            onPreset(r.fromUtcMs, r.toUtcMs);
          },
        ),
        FilterChip(
          label: Text(l10n.journalPresetLastMonth),
          onSelected: (_) {
            final r = reportPeriodLastMonth();
            onPreset(r.fromUtcMs, r.toUtcMs);
          },
        ),
      ],
    );
  }
}

class _JournalFilters {
  const _JournalFilters({
    required this.employeeId,
    required this.fromUtcMs,
    required this.toUtcMs,
    required this.statusFilter,
    required this.searchQuery,
  });

  final int? employeeId;
  final int? fromUtcMs;
  final int? toUtcMs;
  final _JournalStatusFilter statusFilter;
  final String searchQuery;

  factory _JournalFilters.initial() => const _JournalFilters(
        employeeId: null,
        fromUtcMs: null,
        toUtcMs: null,
        statusFilter: _JournalStatusFilter.all,
        searchQuery: '',
      );

  _JournalFilters copyWith({
    Object? employeeId = _sentinel,
    Object? fromUtcMs = _sentinel,
    Object? toUtcMs = _sentinel,
    Object? statusFilter = _sentinel,
    Object? searchQuery = _sentinel,
  }) {
    return _JournalFilters(
      employeeId:
          identical(employeeId, _sentinel) ? this.employeeId : employeeId as int?,
      fromUtcMs:
          identical(fromUtcMs, _sentinel) ? this.fromUtcMs : fromUtcMs as int?,
      toUtcMs: identical(toUtcMs, _sentinel) ? this.toUtcMs : toUtcMs as int?,
      statusFilter: identical(statusFilter, _sentinel)
          ? this.statusFilter
          : statusFilter as _JournalStatusFilter,
      searchQuery: identical(searchQuery, _sentinel)
          ? this.searchQuery
          : searchQuery as String,
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
                DataColumn(
                    label: Center(child: Text(l10n.sessionsTableStatus))),
                DataColumn(
                    label: Center(child: Text(l10n.sessionsTableActions))),
              ],
              rows: rows.map((row) {
                final s = row.session;
                final employeeName = EmployeeDisplayName.of(EmployeeDisplay(
                    firstName: row.employee.firstName,
                    lastName: row.employee.lastName));
                final start =
                    TimeFormat.formatLocalDateTimeNoSeconds(s.startTs);
                final end = s.endTs == null
                    ? l10n.journalEndEmpty
                    : TimeFormat.formatLocalDateTimeNoSeconds(s.endTs!);
                final duration = s.endTs == null
                    ? l10n.commonOngoing
                    : (() {
                        final minutes =
                            ((s.endTs! - s.startTs) / 60000).floor();
                        final h = minutes ~/ 60;
                        final m = minutes % 60;
                        return l10n.durationHm(h, m);
                      })();
                final isOpen = s.status == 'OPEN';

                return DataRow(
                  cells: [
                    DataCell(Text(employeeName)),
                    DataCell(Center(child: Text(start))),
                    DataCell(Center(child: Text(end))),
                    DataCell(Center(child: Text(duration))),
                    DataCell(
                      Center(
                        child: Icon(
                          isOpen
                              ? Icons.schedule
                              : Icons.check_circle_outline,
                          size: 20,
                          color: isOpen
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: l10n.sessionsEdit,
                          onPressed: () => _openEditDialog(
                              context, ref, row, closeNowPreFill: false),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(growable: false),
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

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return StatefulBuilder(
          builder: (context, setState) {
            final startText =
                TimeFormat.formatLocalDateTimeNoSeconds(startUtcMs);
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

            return AlertDialog(
              title: Text(l10n.journalEditDialogTitle),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.sessionsEmployeePrefix(
                          EmployeeDisplayName.of(EmployeeDisplay(
                              firstName: row.employee.firstName,
                              lastName: row.employee.lastName)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked =
                                  await pickLocalDateTime(context);
                              if (picked == null) return;
                              setState(() {
                                startUtcMs =
                                    picked.toUtc().millisecondsSinceEpoch;
                              });
                            },
                            child: Text(l10n.sessionsStartPrefix(startText)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked =
                                  await pickLocalDateTime(context);
                              if (picked == null) return;
                              setState(() {
                                endUtcMs =
                                    picked.toUtc().millisecondsSinceEpoch;
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
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
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
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.sessionsEmployeeCannotChangeHint,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
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
                  onPressed: (reasonRequired &&
                          reasonCtrl.text.trim().isEmpty)
                      ? null
                      : () => Navigator.of(context).pop(true),
                  child: Text(l10n.commonSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;

    final startOrEndChanged =
        startUtcMs != initialStartUtcMs || endUtcMs != initialEndUtcMs;
    final reason = reasonCtrl.text.trim();
    if (startOrEndChanged && reason.isEmpty) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        showAppSnack(context, l10n.sessionsUpdateReasonRequired, isError: true);
      }
      return;
    }

    if (endUtcMs != null) {
      final endMs = endUtcMs!;
      if (endMs <= startUtcMs) {
        if (context.mounted) {
          showAppSnack(
            context,
            AppLocalizations.of(context).journalErrorEndBeforeStart,
            isError: true,
          );
        }
        return;
      }
      if (!isSameLocalCalendarDay(startUtcMs, endMs)) {
        if (context.mounted) {
          showAppSnack(
            context,
            AppLocalizations.of(context).journalErrorCrossDay,
            isError: true,
          );
        }
        return;
      }
    }

    try {
      final useCase = ref.read(updateSessionAsAdminUseCaseProvider);
      await useCase(
        sessionId: s.id,
        startUtcMs: startUtcMs,
        endUtcMs: endUtcMs,
        note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
        updateReason: startOrEndChanged ? reason : '',
        updatedBy: 'admin',
      );
    } on DomainValidationException catch (e) {
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context);
      final msg = e.message == 'sessionsErrorSameDayRequired'
          ? l10n.journalErrorCrossDay
          : errorMessageForUser(e, l10n.commonErrorOccurred);
      showAppSnack(context, msg, isError: true);
      return;
    }

    if (context.mounted) {
      showAppSnack(context, AppLocalizations.of(context).journalSaved);
    }
  }
}
