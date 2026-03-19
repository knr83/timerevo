import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// ~15 mm margins per [PDF_PRINT_FORMS_GUIDE.md] §3.1.
pw.EdgeInsets get pdfPrintFormPageMargin =>
    const pw.EdgeInsets.all(15 * PdfPageFormat.mm);

/// Subtle page-frame typography (running header + footer row).
final pw.TextStyle pdfPrintFormFrameChromeStyle = pw.TextStyle(
  fontSize: 8,
  color: PdfColors.grey600,
  fontWeight: pw.FontWeight.normal,
);

/// Space below running header rule before document title (clear separation from frame).
const double pdfPrintFormHeaderToTitleGap = 12;

/// Primary document title in the content area (not the running header).
final pw.TextStyle pdfPrintFormDocumentTitleStyle = pw.TextStyle(
  fontWeight: pw.FontWeight.bold,
  fontSize: 17,
);

/// Footer-left timestamp per guide §5.1 / §2.5: `YYYY-MM-DD HH:mm`, no label.
String pdfPrintFormFooterTimestamp(DateTime local) {
  final y = local.year;
  final mo = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  final h = local.hour.toString().padLeft(2, '0');
  final mi = local.minute.toString().padLeft(2, '0');
  return '$y-$mo-$d $h:$mi';
}

/// Running header: subtle brand + thin rule (guide §2.1).
pw.Widget pdfPrintFormRunningHeader() {
  return pw.Column(
    mainAxisSize: pw.MainAxisSize.min,
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Text('Timerevo', style: pdfPrintFormFrameChromeStyle),
      pw.SizedBox(height: 3),
      pw.Container(height: 0.35, color: PdfColors.grey400),
    ],
  );
}

/// Default footer: rule + timestamp (left) + page X/Y (right). Guide §2.5.
pw.Widget Function(pw.Context) pdfPrintFormFooterBuilder({
  required DateTime generatedAtLocal,
  required String Function(int current, int total) footerPage,
}) {
  return (pw.Context ctx) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(height: 0.35, color: PdfColors.grey400),
        pw.SizedBox(height: 3),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              pdfPrintFormFooterTimestamp(generatedAtLocal),
              style: pdfPrintFormFrameChromeStyle,
            ),
            pw.Text(
              footerPage(ctx.pageNumber, ctx.pagesCount),
              style: pdfPrintFormFrameChromeStyle,
            ),
          ],
        ),
      ],
    );
  };
}

/// Table / summary body text default size.
const double pdfPrintFormTableFontSize = 9;

/// Balance / delta per guide §5.3: no `+` for positive; minus + red for negative.
pw.Widget pdfPrintFormBalanceText({
  required int ms,
  required String absHmDuration,
  pw.TextStyle? baseStyle,
}) {
  final base =
      baseStyle ?? const pw.TextStyle(fontSize: pdfPrintFormTableFontSize);
  if (ms == 0) {
    return pw.Text(absHmDuration, style: base);
  }
  if (ms < 0) {
    return pw.Text(
      '-$absHmDuration',
      style: base.copyWith(color: PdfColors.red),
    );
  }
  return pw.Text(absHmDuration, style: base);
}

/// Horizontal-first table border (guide §4.1): outline + horizontal rules only.
pw.TableBorder pdfPrintFormTableBorderHorizontal() {
  const side = pw.BorderSide(color: PdfColors.grey400, width: 0.5);
  return pw.TableBorder(
    top: side,
    bottom: side,
    left: side,
    right: side,
    horizontalInside: side,
  );
}
