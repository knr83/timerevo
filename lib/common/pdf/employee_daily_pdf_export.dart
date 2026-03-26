import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../core/pdf/pdf_print_theme.dart';
import '../utils/duration_hm_format.dart';
import '../../domain/usecases.dart';
import 'employee_daily_pdf_builder.dart';
import 'time_report_pdf_suggested_filename.dart';

String _formatDate(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

/// Exports single-employee daily breakdown PDF. Call from admin drawer or terminal.
Future<void> exportEmployeeDailyPdf(
  BuildContext context, {
  required EmployeeDayReportUseCase dayReportUseCase,
  required int employeeId,
  required String employeeName,
  required int fromUtcMs,
  required int toUtcMs,
  String? sortColumnName,
  int periodStartingBalanceMs = 0,
  required void Function(String message) showSnack,
  required void Function(String message, {bool isError}) showErrorSnack,
}) async {
  final l10n = AppLocalizations.of(context);
  final saveLocation = await getSaveLocation(
    suggestedName: timeReportPdfSuggestedFileName(
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
    ),
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.reportsPdfFileType, extensions: const ['pdf']),
    ],
  );
  if (saveLocation == null) return;

  try {
    final dayRows = await dayReportUseCase.getEmployeeDayReport(
      employeeId: employeeId,
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
    );
    final theme = await loadPdfPrintTheme();
    final fromStr = _formatDate(
      DateTime.fromMillisecondsSinceEpoch(fromUtcMs, isUtc: true).toLocal(),
    );
    final toStr = _formatDate(
      DateTime.fromMillisecondsSinceEpoch(toUtcMs, isUtc: true).toLocal(),
    );
    final labels = EmployeeDailyPdfLabels(
      title: l10n.reportsPdfTitle,
      periodLine: l10n.reportsPdfPeriod(fromStr, toStr),
      employeeLine: l10n.reportsPdfEmployee(employeeName),
      sortLine: sortColumnName != null
          ? l10n.reportsPdfSort(sortColumnName)
          : null,
      dateColumn: l10n.reportsTableDate,
      workedColumn: l10n.reportsTableWorked,
      plannedColumn: l10n.reportsTablePlanned,
      balanceColumn: l10n.reportsTableBalance,
      totalLabel: l10n.reportsTableTotal,
      noSchedule: l10n.reportsPlannedNoSchedule,
      footerPage: l10n.reportsPdfFooterPage,
      startingBalanceRowLabel: periodStartingBalanceMs != 0
          ? l10n.reportsPdfStartingBalance
          : null,
    );
    final pdf = await buildEmployeeDailyPdf(
      theme: theme,
      labels: labels,
      dayRows: dayRows,
      formatDuration: (ms) => formatDurationHmFromMs(ms, l10n),
      periodStartingBalanceMs: periodStartingBalanceMs,
    );
    final bytes = await pdf.save();
    await File(saveLocation.path).writeAsBytes(bytes);

    if (context.mounted) {
      showSnack(l10n.reportsExported);
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnack(
        l10n.reportsFailedLoad(l10n.commonErrorOccurred),
        isError: true,
      );
    }
  }
}
