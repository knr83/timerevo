import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timerevo/l10n/app_localizations.dart';

import '../../core/error_message_helper.dart';
import '../../domain/usecases.dart';
import 'employee_daily_pdf_builder.dart';
import 'time_report_pdf_suggested_filename.dart';

String _formatDate(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

String _formatDurationMs(int ms, AppLocalizations l10n) {
  final totalMinutes = (ms / 60000).floor();
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  return l10n.durationHm(h, m);
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
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fontData),
      bold: pw.Font.ttf(fontBoldData),
    );
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
    );
    final pdf = await buildEmployeeDailyPdf(
      theme: theme,
      labels: labels,
      dayRows: dayRows,
      formatDuration: (ms) => _formatDurationMs(ms, l10n),
    );
    final bytes = await pdf.save();
    await File(saveLocation.path).writeAsBytes(bytes);

    if (context.mounted) {
      showSnack(l10n.reportsExported);
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnack(
        l10n.reportsFailedLoad(
          errorMessageForUser(e, l10n.commonErrorOccurred),
        ),
        isError: true,
      );
    }
  }
}
