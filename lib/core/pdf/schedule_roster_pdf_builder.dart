import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_print_form_frame.dart';

/// Fully formatted row for the roster table (including localized weekly hours text).
class ScheduleRosterPdfTableRow {
  const ScheduleRosterPdfTableRow({
    required this.employee,
    required this.weekdayCells,
    required this.weeklyHours,
  });

  final String employee;

  /// Length 7: index 0 = Monday … 6 = Sunday.
  final List<String> weekdayCells;

  final String weeklyHours;
}

/// Localized labels for the schedule roster PDF.
class ScheduleRosterPdfLabels {
  const ScheduleRosterPdfLabels({
    required this.title,
    required this.columnEmployee,
    required this.columnWeeklyHours,
    required this.weekdayHeader,
    required this.footerPage,
  });

  final String title;
  final String columnEmployee;
  final String columnWeeklyHours;
  final String Function(int weekday1to7) weekdayHeader;
  final String Function(int current, int total) footerPage;
}

const double _employeeColWidthPt = 118;

/// Wide enough for localized header (e.g. EN/DE/RU) on one line at table font size.
const double _weeklyColWidthPt = 86;

final pw.TextStyle _headerStyle = pw.TextStyle(
  fontWeight: pw.FontWeight.bold,
  fontSize: pdfPrintFormTableFontSize,
);

final pw.TextStyle _cellStyle = const pw.TextStyle(
  fontSize: pdfPrintFormTableFontSize,
);

Future<pw.Document> buildScheduleRosterPdf({
  required pw.ThemeData theme,
  required ScheduleRosterPdfLabels labels,
  required List<ScheduleRosterPdfTableRow> rows,
  required List<int> visibleWeekdays,
}) async {
  final generatedAt = DateTime.now().toLocal();
  final pdf = pw.Document(theme: theme);

  final colCount = 1 + visibleWeekdays.length + 1;
  final columnWidths = <int, pw.TableColumnWidth>{
    0: const pw.FixedColumnWidth(_employeeColWidthPt),
    for (var i = 0; i < visibleWeekdays.length; i++)
      i + 1: const pw.FlexColumnWidth(1),
    colCount - 1: const pw.FixedColumnWidth(_weeklyColWidthPt),
  };

  pw.TableRow headerRow() {
    return pw.TableRow(
      repeat: true,
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(labels.columnEmployee, style: _headerStyle),
        ),
        for (final w in visibleWeekdays)
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(labels.weekdayHeader(w), style: _headerStyle),
          ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(labels.columnWeeklyHours, style: _headerStyle),
        ),
      ],
    );
  }

  pw.TableRow dataRow(ScheduleRosterPdfTableRow r) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            r.employee,
            style: _cellStyle,
            maxLines: 2,
            overflow: pw.TextOverflow.clip,
          ),
        ),
        for (final w in visibleWeekdays)
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(r.weekdayCells[w - 1], style: _cellStyle),
          ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(r.weeklyHours, style: _cellStyle),
        ),
      ],
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: pdfPrintFormPageMargin,
      header: (pw.Context ctx) => pdfPrintFormRunningHeader(),
      footer: pdfPrintFormFooterBuilder(
        generatedAtLocal: generatedAt,
        footerPage: labels.footerPage,
      ),
      build: (pw.Context ctx) => [
        pw.SizedBox(height: pdfPrintFormHeaderToTitleGap),
        pw.Text(labels.title, style: pdfPrintFormDocumentTitleStyle),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pdfPrintFormTableBorderHorizontal(),
          columnWidths: columnWidths,
          children: [headerRow(), for (final r in rows) dataRow(r)],
        ),
      ],
    ),
  );

  return pdf;
}
