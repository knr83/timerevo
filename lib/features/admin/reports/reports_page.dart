import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../app/tracking_start/tracking_start_settings_controller.dart'
    show trackingStartSettingsProvider, trackingStartYmdFromWatch;
import '../../../app/usecase_providers.dart';
import '../../../core/tracking_start_range_clamp.dart';
import '../../../common/pdf/employee_daily_pdf_export.dart';
import '../../../common/utils/duration_hm_format.dart';
import '../../../common/widgets/date_range_filter_bar.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../core/starting_balance_period.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_report_row_info.dart';
import 'pdf/aggregate_reports_pdf_export.dart';

String formatBalanceMs(int ms, AppLocalizations l10n) {
  final s = formatDurationHmFromMs(ms.abs(), l10n);
  return ms >= 0 ? '+$s' : '-$s';
}

/// Balance text with semantic color: positive = green, negative = red.
Widget balanceText(int ms, AppLocalizations l10n, BuildContext context) {
  final color = ms > 0
      ? Colors.green.shade700
      : ms < 0
      ? Theme.of(context).colorScheme.error
      : Theme.of(context).colorScheme.onSurface;
  return Text(formatBalanceMs(ms, l10n), style: TextStyle(color: color));
}

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  int? _sortColumnIndex = 3;
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(reportFiltersProvider);
    final rowsAsync = ref.watch(watchReportWithNormProvider);
    final selectedId = ref.watch(selectedEmployeeForDetailsProvider);

    ref.listen(reportFiltersProvider, (prev, next) {
      if (next.employeeId != null &&
          next.employeeId != ref.read(selectedEmployeeForDetailsProvider)) {
        ref.read(selectedEmployeeForDetailsProvider.notifier).state = null;
      }
    });

    ref.listen(trackingStartSettingsProvider, (prev, next) {
      final ymd = trackingStartYmdFromWatch(next);
      final f = ref.read(reportFiltersProvider);
      final base = reportEffectiveRange(f);
      final c = maybeClampUtcRangeIfUpdateNeeded(
        resolvedFromUtcMs: base.fromUtcMs,
        resolvedToUtcMs: base.toUtcMs,
        storedFromUtcMs: f.fromUtcMs,
        storedToUtcMs: f.toUtcMs,
        trackingStartYmd: ymd,
      );
      if (c != null) {
        ref.read(reportFiltersProvider.notifier).state = (
          scope: f.scope,
          fromUtcMs: c.fromUtcMs,
          toUtcMs: c.toUtcMs,
          employeeId: f.employeeId,
        );
      }
    });

    var rows = rowsAsync.value ?? [];
    if (filters.employeeId != null) {
      rows = rows.where((r) => r.employeeId == filters.employeeId).toList();
    }

    final ymdWatch = trackingStartYmdFromWatch(
      ref.watch(trackingStartSettingsProvider),
    );
    final r = reportClampedRange(filters, ymdWatch);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.reportsTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () async {
                    if (rows.isEmpty) return;
                    final range = reportClampedRange(
                      filters,
                      trackingStartYmdFromWatch(
                        ref.read(trackingStartSettingsProvider),
                      ),
                    );
                    await exportAggregateReportsPdf(
                      context,
                      fromUtcMs: range.fromUtcMs,
                      toUtcMs: range.toUtcMs,
                      employeeId: filters.employeeId,
                      rows: rows,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                    );
                  },
                  icon: const Icon(Symbols.download),
                  label: Text(l10n.reportsExportPdf),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DateRangeFilterBar(
                  scope: filters.scope,
                  fromUtcMs: r.fromUtcMs,
                  toUtcMs: r.toUtcMs,
                  availableScopes: const [
                    DateRangeScope.day,
                    DateRangeScope.week,
                    DateRangeScope.month,
                    DateRangeScope.interval,
                  ],
                  onChanged: (scope, from, to) {
                    final ymd = trackingStartYmdFromWatch(
                      ref.read(trackingStartSettingsProvider),
                    );
                    final c = clampUtcRangeToTrackingStart(
                      fromUtcMs: from,
                      toUtcMs: to,
                      trackingStartYmd: ymd,
                    );
                    ref.read(reportFiltersProvider.notifier).state = (
                      scope: scope,
                      fromUtcMs: c.fromUtcMs,
                      toUtcMs: c.toUtcMs,
                      employeeId: filters.employeeId,
                    );
                  },
                ),
                _EmployeeFilterDropdown(filters: filters),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: rowsAsync.when(
                      data: (_) {
                        if (rows.isEmpty) {
                          return Center(child: Text(l10n.reportsNoData));
                        }
                        return _ReportTable(
                          rows: rows,
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                        child: Text(
                          l10n.reportsFailedLoad(l10n.commonErrorOccurred),
                        ),
                      ),
                    ),
                  ),
                  if (selectedId != null)
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 380),
                      child: IntrinsicWidth(
                        child: _ReportsDetailsDrawer(
                          selectedId: selectedId,
                          rows: rows,
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reportsOnlyClosedHint,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppLocalizations get l10n => AppLocalizations.of(context);
}

class _EmployeeFilterDropdown extends ConsumerWidget {
  const _EmployeeFilterDropdown({required this.filters});

  final ({DateRangeScope scope, int? fromUtcMs, int? toUtcMs, int? employeeId})
  filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final employeesAsync = ref.watch(watchActiveEmployeesProvider);

    return employeesAsync.when(
      data: (employees) {
        return DropdownMenu<int?>(
          label: Text(l10n.reportsEmployeeFilter),
          initialSelection: filters.employeeId,
          dropdownMenuEntries: [
            DropdownMenuEntry(value: null, label: l10n.sessionsEmployeeAll),
            ...employees.map(
              (e) => DropdownMenuEntry(
                value: e.id,
                label: EmployeeDisplayName.of(
                  EmployeeDisplay(firstName: e.firstName, lastName: e.lastName),
                ),
              ),
            ),
          ],
          onSelected: (v) {
            ref.read(reportFiltersProvider.notifier).state = (
              scope: filters.scope,
              fromUtcMs: filters.fromUtcMs,
              toUtcMs: filters.toUtcMs,
              employeeId: v,
            );
          },
        );
      },
      loading: () => const SizedBox(
        width: 200,
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text(l10n.reportsFailedLoad(l10n.commonErrorOccurred)),
    );
  }
}

class _ReportTable extends ConsumerWidget {
  const _ReportTable({
    required this.rows,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onSort,
  });

  final List<EmployeeReportRowInfo> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending) onSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    var sorted = List<EmployeeReportRowInfo>.from(rows);
    if (sortColumnIndex != null) {
      sorted.sort((a, b) {
        int cmp;
        switch (sortColumnIndex!) {
          case 0:
            cmp = a.employeeName.compareTo(b.employeeName);
            break;
          case 1:
            cmp = a.totalMs.compareTo(b.totalMs);
            break;
          case 2:
            cmp = a.normMs.compareTo(b.normMs);
            break;
          case 3:
            cmp = a.deltaMs.compareTo(b.deltaMs);
            break;
          default:
            cmp = 0;
        }
        return sortAscending ? cmp : -cmp;
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        columns: [
          DataColumn(
            label: Text(l10n.reportsTableEmployee),
            onSort: (_, _) =>
                onSort(0, sortColumnIndex == 0 ? !sortAscending : true),
          ),
          DataColumn(
            label: Text(l10n.reportsTableWorked),
            onSort: (_, _) =>
                onSort(1, sortColumnIndex == 1 ? !sortAscending : true),
          ),
          DataColumn(
            label: Text(l10n.reportsTablePlanned),
            onSort: (_, _) =>
                onSort(2, sortColumnIndex == 2 ? !sortAscending : true),
          ),
          DataColumn(
            label: Text(l10n.reportsTableBalance),
            onSort: (_, _) =>
                onSort(3, sortColumnIndex == 3 ? !sortAscending : true),
          ),
        ],
        rows: sorted
            .map((r) {
              final plannedText = r.anyDayHasSchedule
                  ? formatDurationHmFromMs(r.normMs, l10n)
                  : l10n.reportsPlannedNoSchedule;
              return DataRow(
                selected:
                    ref.watch(selectedEmployeeForDetailsProvider) ==
                    r.employeeId,
                onSelectChanged: (selected) {
                  ref.read(selectedEmployeeForDetailsProvider.notifier).state =
                      selected == true ? r.employeeId : null;
                },
                cells: [
                  DataCell(Text(r.employeeName)),
                  DataCell(Text(formatDurationHmFromMs(r.totalMs, l10n))),
                  DataCell(Text(plannedText)),
                  DataCell(balanceText(r.deltaMs, l10n, context)),
                ],
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _ReportsDetailsDrawer extends ConsumerWidget {
  const _ReportsDetailsDrawer({
    required this.selectedId,
    required this.rows,
    required this.sortColumnIndex,
    required this.sortAscending,
  });

  final int selectedId;
  final List<EmployeeReportRowInfo> rows;
  final int? sortColumnIndex;
  final bool sortAscending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dayRowsAsync = ref.watch(watchEmployeeDayReportProvider);
    final employeeName =
        rows
            .where((r) => r.employeeId == selectedId)
            .firstOrNull
            ?.employeeName ??
        '';

    return Container(
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    employeeName,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final filters = ref.read(reportFiltersProvider);
                    final r = reportClampedRange(
                      filters,
                      trackingStartYmdFromWatch(
                        ref.read(trackingStartSettingsProvider),
                      ),
                    );
                    final details = await ref
                        .read(employeesAdminUseCaseProvider)
                        .getEmployeeDetails(selectedId);
                    final trackYmd = trackingStartYmdFromWatch(
                      ref.read(trackingStartSettingsProvider),
                    );
                    final sbMs = startingBalanceMsForPeriod(
                      tenths: details?.startingBalanceTenths,
                      trackingStartYmd: trackYmd,
                      balanceUpdatedAtUtcMs: details?.startingBalanceUpdatedAt,
                      fromUtcMs: r.fromUtcMs,
                      toUtcMs: r.toUtcMs,
                    );
                    if (!context.mounted) return;
                    await exportEmployeeDailyPdf(
                      context,
                      dayReportUseCase: ref.read(
                        employeeDayReportUseCaseProvider,
                      ),
                      employeeId: selectedId,
                      employeeName: employeeName,
                      fromUtcMs: r.fromUtcMs,
                      toUtcMs: r.toUtcMs,
                      sortColumnName: sortColumnIndex != null
                          ? aggregateReportSortColumnName(l10n, sortColumnIndex)
                          : null,
                      periodStartingBalanceMs: sbMs,
                      showSnack: (msg) => showAppSnack(context, msg),
                      showErrorSnack: (msg, {bool isError = false}) =>
                          showAppSnack(context, msg, isError: isError),
                    );
                  },
                  child: Text(l10n.reportsExportEmployeePdf),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: dayRowsAsync.when(
              data: (dayRows) {
                if (dayRows.isEmpty) {
                  return Center(child: Text(l10n.reportsNoData));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(l10n.reportsTableDate),
                          columnWidth: const IntrinsicColumnWidth(),
                        ),
                        DataColumn(
                          label: Text(l10n.reportsTableWorked),
                          columnWidth: const IntrinsicColumnWidth(),
                        ),
                        DataColumn(
                          label: Text(l10n.reportsTablePlanned),
                          columnWidth: const IntrinsicColumnWidth(),
                        ),
                        DataColumn(
                          label: Text(l10n.reportsTableBalance),
                          columnWidth: const IntrinsicColumnWidth(),
                        ),
                      ],
                      rows: dayRows
                          .map((dr) {
                            final plannedText = dr.hasSchedule
                                ? formatDurationHmFromMs(dr.normMs, l10n)
                                : l10n.reportsPlannedNoSchedule;
                            return DataRow(
                              cells: [
                                DataCell(Text(dr.dateYmd)),
                                DataCell(
                                  Text(
                                    formatDurationHmFromMs(dr.workedMs, l10n),
                                  ),
                                ),
                                DataCell(Text(plannedText)),
                                DataCell(
                                  balanceText(dr.deltaMs, l10n, context),
                                ),
                              ],
                            );
                          })
                          .toList(growable: false),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.commonErrorOccurred)),
            ),
          ),
        ],
      ),
    );
  }
}
