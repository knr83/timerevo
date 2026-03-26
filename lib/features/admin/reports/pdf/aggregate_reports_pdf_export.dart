import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timerevo/core/pdf/pdf_print_form_frame.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../../common/pdf/time_report_pdf_suggested_filename.dart';
import '../../../../common/utils/date_utils.dart';
import '../../../../common/utils/duration_hm_format.dart';
import '../../../../common/widgets/app_snack.dart';
import '../../../../core/pdf/pdf_print_theme.dart';
import '../../../../domain/entities/employee_report_row_info.dart';

/// Localized header label for the column used as the PDF sort key (matches on-screen table).
String aggregateReportSortColumnName(
  AppLocalizations l10n,
  int? sortColumnIndex,
) {
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

/// Saves the aggregate employee report (worked / planned / balance) as a PDF print form.
Future<void> exportAggregateReportsPdf(
  BuildContext context, {
  required int fromUtcMs,
  required int toUtcMs,
  required int? employeeId,
  required List<EmployeeReportRowInfo> rows,
  int? sortColumnIndex,
  bool sortAscending = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final generatedAt = DateTime.now().toLocal();
  final saveLocation = await getSaveLocation(
    suggestedName: timeReportPdfSuggestedFileName(
      fromUtcMs: fromUtcMs,
      toUtcMs: toUtcMs,
      generatedAt: generatedAt,
    ),
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.reportsPdfFileType, extensions: const ['pdf']),
    ],
  );
  if (saveLocation == null) return;

  try {
    final theme = await loadPdfPrintTheme();
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

    final employeeName = employeeId == null
        ? l10n.sessionsEmployeeAll
        : (rows.isEmpty ? l10n.sessionsEmployeeAll : rows.first.employeeName);

    final fromStr = dateToYmd(
      DateTime.fromMillisecondsSinceEpoch(fromUtcMs, isUtc: true).toLocal(),
    );
    final toStr = dateToYmd(
      DateTime.fromMillisecondsSinceEpoch(toUtcMs, isUtc: true).toLocal(),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pdfPrintFormPageMargin,
        header: (pw.Context ctx) => pdfPrintFormRunningHeader(),
        footer: pdfPrintFormFooterBuilder(
          generatedAtLocal: generatedAt,
          footerPage: l10n.reportsPdfFooterPage,
        ),
        build: (pw.Context ctx) {
          final tableHeaderStyle = pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: pdfPrintFormTableFontSize,
          );
          final tableCellStyle = const pw.TextStyle(
            fontSize: pdfPrintFormTableFontSize,
          );

          final header = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.SizedBox(height: pdfPrintFormHeaderToTitleGap),
              pw.Text(
                l10n.reportsPdfTitle,
                style: pdfPrintFormDocumentTitleStyle,
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                l10n.reportsPdfPeriod(fromStr, toStr),
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                l10n.reportsPdfEmployee(employeeName),
                style: const pw.TextStyle(fontSize: 11),
              ),
              if (sortColumnIndex != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  l10n.reportsPdfSort(
                    aggregateReportSortColumnName(l10n, sortColumnIndex),
                  ),
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
              pw.SizedBox(height: 8),
            ],
          );

          final table = pw.Table(
            border: pdfPrintFormTableBorderHorizontal(),
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
                    child: pw.Text(
                      l10n.reportsTableEmployee,
                      style: tableHeaderStyle,
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        l10n.reportsTableWorked,
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        l10n.reportsTablePlanned,
                        style: tableHeaderStyle,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        l10n.reportsTableBalance,
                        style: tableHeaderStyle,
                      ),
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
                        style: tableCellStyle,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          formatDurationHmFromMs(sorted[i].totalMs, l10n),
                          style: tableCellStyle,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          sorted[i].anyDayHasSchedule
                              ? formatDurationHmFromMs(sorted[i].normMs, l10n)
                              : l10n.reportsPlannedNoSchedule,
                          style: tableCellStyle,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pdfPrintFormBalanceText(
                          ms: sorted[i].deltaMs,
                          absHmDuration: formatDurationHmFromMs(
                            sorted[i].deltaMs.abs(),
                            l10n,
                          ),
                          baseStyle: tableCellStyle,
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
        l10n.reportsFailedLoad(l10n.commonErrorOccurred),
        isError: true,
      );
    }
  }
}
