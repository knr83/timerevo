import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/employee_day_report_row.dart';
import 'package:timerevo/core/pdf/pdf_print_form_frame.dart';

/// Labels for the employee daily PDF. Caller provides all localized strings.
class EmployeeDailyPdfLabels {
  const EmployeeDailyPdfLabels({
    required this.title,
    required this.periodLine,
    required this.employeeLine,
    this.sortLine,
    required this.dateColumn,
    required this.workedColumn,
    required this.plannedColumn,
    required this.balanceColumn,
    required this.totalLabel,
    required this.noSchedule,
    required this.footerPage,
  });

  final String title;
  final String periodLine;
  final String employeeLine;
  final String? sortLine;
  final String dateColumn;
  final String workedColumn;
  final String plannedColumn;
  final String balanceColumn;
  final String totalLabel;
  final String noSchedule;
  final String Function(int current, int total) footerPage;
}

const pw.TextStyle _contextLineStyle = pw.TextStyle(
  fontSize: 11,
  color: PdfColors.black,
);
const pw.TextStyle _periodLineStyle = pw.TextStyle(
  fontSize: 12,
  color: PdfColors.black,
);

final pw.TextStyle _tableHeaderStyle = pw.TextStyle(
  fontWeight: pw.FontWeight.bold,
  fontSize: pdfPrintFormTableFontSize,
);

final pw.TextStyle _tableCellStyle = const pw.TextStyle(
  fontSize: pdfPrintFormTableFontSize,
);

/// Builds a single-employee daily breakdown PDF. Summary and totals computed from dayRows.
Future<pw.Document> buildEmployeeDailyPdf({
  required pw.ThemeData theme,
  required EmployeeDailyPdfLabels labels,
  required List<EmployeeDayReportRow> dayRows,
  required String Function(int ms) formatDuration,
}) async {
  final totalMs = dayRows.fold<int>(0, (s, r) => s + r.workedMs);
  final normMs = dayRows.fold<int>(0, (s, r) => s + r.normMs);
  final deltaMs = dayRows.fold<int>(0, (s, r) => s + r.deltaMs);
  final anyDayHasSchedule = dayRows.any((r) => r.hasSchedule);

  final generatedAt = DateTime.now().toLocal();

  final pdf = pw.Document(theme: theme);
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pdfPrintFormPageMargin,
      header: (pw.Context ctx) => pdfPrintFormRunningHeader(),
      footer: pdfPrintFormFooterBuilder(
        generatedAtLocal: generatedAt,
        footerPage: labels.footerPage,
      ),
      build: (pw.Context ctx) {
        final titleAndContext = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.SizedBox(height: pdfPrintFormHeaderToTitleGap),
            pw.Text(labels.title, style: pdfPrintFormDocumentTitleStyle),
            pw.SizedBox(height: 6),
            pw.Text(labels.periodLine, style: _periodLineStyle),
            pw.SizedBox(height: 4),
            pw.Text(labels.employeeLine, style: _contextLineStyle),
            if (labels.sortLine != null) ...[
              pw.SizedBox(height: 2),
              pw.Text(labels.sortLine!, style: _contextLineStyle),
            ],
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(labels.workedColumn, style: _tableHeaderStyle),
                  pw.SizedBox(width: 16),
                  pw.Text(formatDuration(totalMs), style: _tableCellStyle),
                  pw.SizedBox(width: 24),
                  pw.Text(labels.plannedColumn, style: _tableHeaderStyle),
                  pw.SizedBox(width: 16),
                  pw.Text(
                    anyDayHasSchedule
                        ? formatDuration(normMs)
                        : labels.noSchedule,
                    style: _tableCellStyle,
                  ),
                  pw.SizedBox(width: 24),
                  pw.Text(labels.balanceColumn, style: _tableHeaderStyle),
                  pw.SizedBox(width: 16),
                  pdfPrintFormBalanceText(
                    ms: deltaMs,
                    absHmDuration: formatDuration(deltaMs.abs()),
                    baseStyle: _tableCellStyle,
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
          ],
        );

        final table = pw.Table(
          border: pdfPrintFormTableBorderHorizontal(),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
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
                  child: pw.Text(labels.dateColumn, style: _tableHeaderStyle),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      labels.workedColumn,
                      style: _tableHeaderStyle,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      labels.plannedColumn,
                      style: _tableHeaderStyle,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      labels.balanceColumn,
                      style: _tableHeaderStyle,
                    ),
                  ),
                ),
              ],
            ),
            for (var i = 0; i < dayRows.length; i++) ...[
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: i.isOdd ? PdfColors.grey100 : PdfColors.white,
                ),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(dayRows[i].dateYmd, style: _tableCellStyle),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        formatDuration(dayRows[i].workedMs),
                        style: _tableCellStyle,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        dayRows[i].hasSchedule
                            ? formatDuration(dayRows[i].normMs)
                            : labels.noSchedule,
                        style: _tableCellStyle,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pdfPrintFormBalanceText(
                        ms: dayRows[i].deltaMs,
                        absHmDuration: formatDuration(dayRows[i].deltaMs.abs()),
                        baseStyle: _tableCellStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(labels.totalLabel, style: _tableHeaderStyle),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      formatDuration(totalMs),
                      style: _tableHeaderStyle,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      anyDayHasSchedule
                          ? formatDuration(normMs)
                          : labels.noSchedule,
                      style: _tableHeaderStyle,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pdfPrintFormBalanceText(
                      ms: deltaMs,
                      absHmDuration: formatDuration(deltaMs.abs()),
                      baseStyle: _tableHeaderStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

        return [titleAndContext, table];
      },
    ),
  );
  return pdf;
}
