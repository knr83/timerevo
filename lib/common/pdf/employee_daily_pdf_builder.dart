import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/employee_day_report_row.dart';

/// Labels for the employee daily PDF. Caller provides all localized strings.
class EmployeeDailyPdfLabels {
  const EmployeeDailyPdfLabels({
    required this.title,
    required this.periodLine,
    required this.generatedLine,
    required this.employeeLine,
    this.sortLine,
    required this.dateColumn,
    required this.workedColumn,
    required this.plannedColumn,
    required this.balanceColumn,
    required this.totalLabel,
    required this.noSchedule,
    required this.footerBrand,
    required this.footerPage,
  });

  final String title;
  final String periodLine;
  final String generatedLine;
  final String employeeLine;
  final String? sortLine;
  final String dateColumn;
  final String workedColumn;
  final String plannedColumn;
  final String balanceColumn;
  final String totalLabel;
  final String noSchedule;
  final String footerBrand;
  final String Function(int current, int total) footerPage;
}

/// Builds a single-employee daily breakdown PDF. Summary and totals computed from dayRows.
Future<pw.Document> buildEmployeeDailyPdf({
  required pw.ThemeData theme,
  required EmployeeDailyPdfLabels labels,
  required List<EmployeeDayReportRow> dayRows,
  required String Function(int ms) formatDuration,
  required String Function(int ms) formatBalance,
}) async {
  final totalMs = dayRows.fold<int>(0, (s, r) => s + r.workedMs);
  final normMs = dayRows.fold<int>(0, (s, r) => s + r.normMs);
  final deltaMs = dayRows.fold<int>(0, (s, r) => s + r.deltaMs);
  final anyDayHasSchedule = dayRows.any((r) => r.hasSchedule);

  final pdf = pw.Document(theme: theme);
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      footer: (pw.Context ctx) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(labels.footerBrand,
                style: const pw.TextStyle(fontSize: 10)),
            pw.Text(
              labels.footerPage(ctx.pageNumber, ctx.pagesCount),
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
            pw.Text(labels.title,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 18,
                )),
            pw.SizedBox(height: 6),
            pw.Text(labels.periodLine, style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 2),
            pw.Text(labels.generatedLine,
                style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 6),
            pw.Text(labels.employeeLine,
                style: const pw.TextStyle(fontSize: 11)),
            if (labels.sortLine != null) ...[
              pw.SizedBox(height: 2),
              pw.Text(labels.sortLine!,
                  style: const pw.TextStyle(fontSize: 11)),
            ],
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                border: pw.Border.all(color: PdfColors.grey400),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(labels.workedColumn,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 16),
                  pw.Text(formatDuration(totalMs)),
                  pw.SizedBox(width: 24),
                  pw.Text(labels.plannedColumn,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 16),
                  pw.Text(anyDayHasSchedule
                      ? formatDuration(normMs)
                      : labels.noSchedule),
                  pw.SizedBox(width: 24),
                  pw.Text(labels.balanceColumn,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 16),
                  pw.Text(formatBalance(deltaMs)),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
          ],
        );

        final table = pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
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
                  child: pw.Text(labels.dateColumn,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(labels.workedColumn,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(labels.plannedColumn,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(labels.balanceColumn,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                    child: pw.Text(dayRows[i].dateYmd),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                          formatDuration(dayRows[i].workedMs)),
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
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                          formatBalance(dayRows[i].deltaMs)),
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
                  child: pw.Text(labels.totalLabel,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(formatDuration(totalMs),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(formatBalance(deltaMs),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        );

        return [header, table];
      },
    ),
  );
  return pdf;
}
