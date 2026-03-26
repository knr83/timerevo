import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Loads Roboto Regular/Bold from assets and builds the PDF widget theme for
/// Timerevo print forms (see docs/PDF_PRINT_FORMS_GUIDE.md).
Future<pw.ThemeData> loadPdfPrintTheme() async {
  final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
  return pw.ThemeData.withFont(
    base: pw.Font.ttf(fontData),
    bold: pw.Font.ttf(fontBoldData),
  );
}
