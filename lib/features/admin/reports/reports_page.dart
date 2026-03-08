import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../app/usecase_providers.dart';
import '../../../common/pdf/employee_daily_pdf_export.dart';
import '../../../common/utils/date_time_picker.dart';
import '../../../common/utils/date_utils.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_report_row_info.dart';

String formatDurationMs(int ms, AppLocalizations l10n) {
  final totalMinutes = (ms / 60000).floor();
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  return l10n.durationHm(h, m);
}

String formatBalanceMs(int ms, AppLocalizations l10n) {
  final s = formatDurationMs(ms.abs(), l10n);
  return ms >= 0 ? '+$s' : '-$s';
}

/// Balance text with semantic color: positive = green, negative = red.
Widget balanceText(int ms, AppLocalizations l10n, BuildContext context) {
  final color = ms > 0
      ? Colors.green.shade700
      : ms < 0
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.onSurface;
  return Text(
    formatBalanceMs(ms, l10n),
    style: TextStyle(color: color),
  );
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

    var rows = rowsAsync.valueOrNull ?? [];
    if (filters.employeeId != null) {
      rows = rows.where((r) => r.employeeId == filters.employeeId).toList();
    }

    final periodLabel = _periodLabel(filters);

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
                    await _exportPdf(
                      context,
                      filters: filters,
                      rows: rows,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: Text(l10n.reportsExportPdf),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                InputChip(
                  label: Text(periodLabel),
                  onPressed: () async {
                    final range = await pickDateRange(
                      context,
                      initialStartDate: filters.fromUtcMs != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              filters.fromUtcMs!,
                              isUtc: true,
                            ).toLocal()
                          : DateTime.now(),
                      initialEndDate: filters.toUtcMs != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              filters.toUtcMs!,
                              isUtc: true,
                            ).toLocal()
                          : DateTime.now(),
                    );
                    if (range == null) return;
                    ref.read(reportFiltersProvider.notifier).state = (
                      fromUtcMs: range.fromUtcMs,
                      toUtcMs: range.toUtcMs,
                      employeeId: filters.employeeId,
                    );
                  },
                ),
                InputChip(
                  label: Text(l10n.reportsPeriodPresetToday),
                  onPressed: () => _applyPreset(reportPeriodToday()),
                ),
                InputChip(
                  label: Text(l10n.reportsPeriodPresetWeek),
                  onPressed: () => _applyPreset(reportPeriodWeek()),
                ),
                InputChip(
                  label: Text(l10n.reportsPeriodPresetMonth),
                  onPressed: () => _applyPreset(reportPeriodMonth()),
                ),
                InputChip(
                  label: Text(l10n.reportsPeriodPresetLastMonth),
                  onPressed: () => _applyPreset(reportPeriodLastMonth()),
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
                        child: Text(l10n.reportsFailedLoad(
                            errorMessageForUser(
                                e, l10n.commonErrorOccurred))),
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

  void _applyPreset(({int fromUtcMs, int toUtcMs}) preset) {
    final filters = ref.read(reportFiltersProvider);
    ref.read(reportFiltersProvider.notifier).state = (
      fromUtcMs: preset.fromUtcMs,
      toUtcMs: preset.toUtcMs,
      employeeId: filters.employeeId,
    );
  }

  String _periodLabel(({int? fromUtcMs, int? toUtcMs, int? employeeId}) f) {
    if (f.fromUtcMs == null || f.toUtcMs == null) {
      return AppLocalizations.of(context).reportsPeriodLabel;
    }
    final fromDt =
        DateTime.fromMillisecondsSinceEpoch(f.fromUtcMs!, isUtc: true).toLocal();
    final toDt =
        DateTime.fromMillisecondsSinceEpoch(f.toUtcMs!, isUtc: true).toLocal();
    final from = '${fromDt.year}-${fromDt.month.toString().padLeft(2, '0')}-${fromDt.day.toString().padLeft(2, '0')}';
    final to = '${toDt.year}-${toDt.month.toString().padLeft(2, '0')}-${toDt.day.toString().padLeft(2, '0')}';
    return '$from – $to';
  }

  AppLocalizations get l10n => AppLocalizations.of(context);
}

class _EmployeeFilterDropdown extends ConsumerWidget {
  const _EmployeeFilterDropdown({
    required this.filters,
  });

  final ({int? fromUtcMs, int? toUtcMs, int? employeeId}) filters;

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
                    EmployeeDisplay(firstName: e.firstName, lastName: e.lastName)),
              ),
            ),
          ],
          onSelected: (v) {
            ref.read(reportFiltersProvider.notifier).state = (
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
      error: (e, _) => Text(l10n.reportsFailedLoad(
          errorMessageForUser(e, l10n.commonErrorOccurred))),
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
            onSort: (_, __) => onSort(0, sortColumnIndex == 0 ? !sortAscending : true),
          ),
          DataColumn(
            label: Text(l10n.reportsTableWorked),
            onSort: (_, __) => onSort(1, sortColumnIndex == 1 ? !sortAscending : true),
          ),
          DataColumn(
            label: Text(l10n.reportsTablePlanned),
            onSort: (_, __) => onSort(2, sortColumnIndex == 2 ? !sortAscending : true),
          ),
          DataColumn(
            label: Text(l10n.reportsTableBalance),
            onSort: (_, __) => onSort(3, sortColumnIndex == 3 ? !sortAscending : true),
          ),
        ],
        rows: sorted.map((r) {
          final plannedText = r.anyDayHasSchedule
              ? formatDurationMs(r.normMs, l10n)
              : l10n.reportsPlannedNoSchedule;
          return DataRow(
            selected: ref.watch(selectedEmployeeForDetailsProvider) == r.employeeId,
            onSelectChanged: (selected) {
              ref.read(selectedEmployeeForDetailsProvider.notifier).state =
                  selected == true ? r.employeeId : null;
            },
            cells: [
              DataCell(Text(r.employeeName)),
              DataCell(Text(formatDurationMs(r.totalMs, l10n))),
              DataCell(Text(plannedText)),
              DataCell(balanceText(r.deltaMs, l10n, context)),
            ],
          );
        }).toList(growable: false),
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
        rows.where((r) => r.employeeId == selectedId).firstOrNull?.employeeName ?? '';

    return Container(
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
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
                    if (filters.fromUtcMs == null || filters.toUtcMs == null) {
                      if (context.mounted) {
                        showAppSnack(context, l10n.reportsPeriodLabel);
                      }
                      return;
                    }
                    await exportEmployeeDailyPdf(
                      context,
                      dayReportUseCase: ref.read(employeeDayReportUseCaseProvider),
                      employeeId: selectedId,
                      employeeName: employeeName,
                      fromUtcMs: filters.fromUtcMs!,
                      toUtcMs: filters.toUtcMs!,
                      sortColumnName: sortColumnIndex != null
                          ? _sortColumnName(l10n, sortColumnIndex)
                          : null,
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
                    rows: dayRows.map((dr) {
                      final plannedText = dr.hasSchedule
                          ? formatDurationMs(dr.normMs, l10n)
                          : l10n.reportsPlannedNoSchedule;
                      return DataRow(
                        cells: [
                          DataCell(Text(dr.dateYmd)),
                          DataCell(Text(formatDurationMs(dr.workedMs, l10n))),
                          DataCell(Text(plannedText)),
                          DataCell(balanceText(dr.deltaMs, l10n, context)),
                        ],
                      );
                    }).toList(growable: false),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  errorMessageForUser(e, l10n.commonErrorOccurred),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _sortColumnName(AppLocalizations l10n, int? sortColumnIndex) {
  if (sortColumnIndex == null) return '';
  switch (sortColumnIndex) {
    case 0:
      return l10n.reportsTableEmployee;
    case 1:
      return l10n.reportsTableWorked;
    case 2:
      return l10n.reportsTablePlanned;
    case 3:
      return l10n.reportsTableBalance;
    default:
      return '';
  }
}

Future<void> _exportPdf(
  BuildContext context, {
  required ({int? fromUtcMs, int? toUtcMs, int? employeeId}) filters,
  required List<EmployeeReportRowInfo> rows,
  int? sortColumnIndex,
  bool sortAscending = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final saveLocation = await getSaveLocation(
    suggestedName: 'report.pdf',
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.reportsPdfFileType, extensions: const ['pdf']),
    ],
  );
  if (saveLocation == null) return;

  try {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fontData),
      bold: pw.Font.ttf(fontBoldData),
    );
    final pdf = pw.Document(theme: theme);

    var sorted = List<EmployeeReportRowInfo>.from(rows);
    if (sortColumnIndex != null) {
      sorted.sort((a, b) {
        int cmp;
        switch (sortColumnIndex) {
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

    final employeeName = filters.employeeId == null
        ? l10n.sessionsEmployeeAll
        : (rows.firstOrNull?.employeeName ?? l10n.sessionsEmployeeAll);

    final fromStr = filters.fromUtcMs != null
        ? dateToYmd(
            DateTime.fromMillisecondsSinceEpoch(filters.fromUtcMs!, isUtc: true)
                .toLocal())
        : '—';
    final toStr = filters.toUtcMs != null
        ? dateToYmd(
            DateTime.fromMillisecondsSinceEpoch(filters.toUtcMs!, isUtc: true)
                .toLocal())
        : '—';
    final generatedStr =
        DateFormat.yMMMd().add_Hm().format(DateTime.now().toLocal());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        footer: (pw.Context ctx) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(l10n.reportsPdfFooterBrand,
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text(
                l10n.reportsPdfFooterPage(ctx.pageNumber, ctx.pagesCount),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        build: (pw.Context ctx) {
          final header = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text('Timerevo',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  )),
              pw.SizedBox(height: 4),
              pw.Text(l10n.reportsPdfTitle,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                  )),
              pw.SizedBox(height: 6),
              pw.Text(
                l10n.reportsPdfPeriod(fromStr, toStr),
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                l10n.reportsPdfGenerated(generatedStr),
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                l10n.reportsPdfEmployee(employeeName),
                style: const pw.TextStyle(fontSize: 11),
              ),
              if (sortColumnIndex != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  l10n.reportsPdfSort(_sortColumnName(l10n, sortColumnIndex)),
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
              pw.SizedBox(height: 8),
            ],
          );

          final table = pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
            },
            children: [
              pw.TableRow(
                repeat: true,
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(l10n.reportsTableEmployee,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(l10n.reportsTableWorked,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(l10n.reportsTablePlanned,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(l10n.reportsTableBalance,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              for (var i = 0; i < sorted.length; i++) ...[
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: i.isOdd ? PdfColors.grey100 : PdfColors.white,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        sorted[i].employeeName,
                        maxLines: 2,
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          formatDurationMs(sorted[i].totalMs, l10n),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          sorted[i].anyDayHasSchedule
                              ? formatDurationMs(sorted[i].normMs, l10n)
                              : l10n.reportsPlannedNoSchedule,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          formatBalanceMs(sorted[i].deltaMs, l10n),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );

          return [header, table];
        },
      ),
    );

    final bytes = await pdf.save();
    await File(saveLocation.path).writeAsBytes(bytes);

    if (context.mounted) {
      showAppSnack(context, l10n.reportsExported);
    }
  } catch (e) {
    if (context.mounted) {
      showAppSnack(
        context,
        l10n.reportsFailedLoad(
            errorMessageForUser(e, l10n.commonErrorOccurred)),
        isError: true,
      );
    }
  }
}

