import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/employee_details.dart';
import 'package:timerevo/core/pdf/pdf_print_form_frame.dart';

/// Labels for the Employee Data PDF. Caller provides all localized strings.
class EmployeeDataPdfLabels {
  const EmployeeDataPdfLabels({
    required this.title,
    required this.sectionEmployeeInfo,
    required this.sectionEmployment,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.email,
    required this.phone,
    required this.secondaryPhone,
    required this.role,
    required this.employmentType,
    required this.hireDate,
    required this.terminationDate,
    required this.weeklyHours,
    required this.vacationDaysPerYear,
    required this.department,
    required this.jobTitle,
    required this.footerPage,
  });

  final String title;
  final String sectionEmployeeInfo;
  final String sectionEmployment;
  final String firstName;
  final String lastName;
  final String status;
  final String email;
  final String phone;
  final String secondaryPhone;
  final String role;
  final String employmentType;
  final String hireDate;
  final String terminationDate;
  final String weeklyHours;
  final String vacationDaysPerYear;
  final String department;
  final String jobTitle;
  final String Function(int current, int total) footerPage;
}

const String _emptyPlaceholder = '—';

String _value(String? v) =>
    (v == null || v.trim().isEmpty) ? _emptyPlaceholder : v;

const double _titleFontSize = 17;
const double _sectionTitleFontSize = 10.5;
const double _bodyFontSize = 9;

/// Label vs value flex within each half-column (long labels like vacation days per year).
const int _labelFlexInCell = 13;
const int _valueFlexInCell = 11;
const double _labelValueGapInCell = 6;
const double _rowSpacing = 2.5;
const double _sectionGap = 8;
const double _titleBelowGap = 6;

/// Builds a single-employee data PDF.
Future<pw.Document> buildEmployeeDataPdf({
  required pw.ThemeData theme,
  required EmployeeDataPdfLabels labels,
  required EmployeeDetails details,

  /// Display for “Weekly hours”: template-based total with unit (same as schedule roster), or em dash if no template.
  required String weeklyHoursDisplay,
  required String Function(DateTime dt) formatDate,
  required String statusLabel,
  required String roleLabel,
  required String employmentTypeLabel,
}) async {
  final pdf = pw.Document(theme: theme);
  final generatedAt = DateTime.now().toLocal();

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
        final titleBlock = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text(
              labels.title,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: _titleFontSize,
              ),
            ),
            pw.SizedBox(height: _titleBelowGap),
          ],
        );

        final employeeInfoSection =
            _buildSectionDense(labels.sectionEmployeeInfo, [
              (labels.firstName, details.firstName),
              (labels.lastName, details.lastName),
              (labels.status, statusLabel),
              (labels.email, details.email ?? ''),
              (labels.phone, details.phone ?? ''),
              (labels.secondaryPhone, details.secondaryPhone ?? ''),
            ]);

        final employmentFields = <(String, String)>[
          (labels.role, roleLabel),
          (labels.employmentType, employmentTypeLabel),
          (
            labels.hireDate,
            details.hireDate != null
                ? formatDate(
                    DateTime.fromMillisecondsSinceEpoch(
                      details.hireDate!,
                      isUtc: true,
                    ),
                  )
                : _emptyPlaceholder,
          ),
          if (details.terminationDate != null)
            (
              labels.terminationDate,
              formatDate(
                DateTime.fromMillisecondsSinceEpoch(
                  details.terminationDate!,
                  isUtc: true,
                ),
              ),
            ),
          (labels.weeklyHours, weeklyHoursDisplay),
          (
            labels.vacationDaysPerYear,
            details.vacationDaysPerYear?.toString() ?? _emptyPlaceholder,
          ),
          (labels.department, details.department ?? ''),
          (labels.jobTitle, details.jobTitle ?? ''),
        ];
        final employmentSection = _buildSectionDense(
          labels.sectionEmployment,
          employmentFields,
        );

        return [
          pw.SizedBox(height: pdfPrintFormHeaderToTitleGap),
          titleBlock,
          employeeInfoSection,
          pw.SizedBox(height: _sectionGap),
          employmentSection,
        ];
      },
    ),
  );
  return pdf;
}

pw.Widget _labelValueCell((String, String) row) {
  final labelStyle = pw.TextStyle(
    fontSize: _bodyFontSize,
    color: PdfColors.grey700,
  );
  final valueStyle = const pw.TextStyle(fontSize: _bodyFontSize);
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        flex: _labelFlexInCell,
        child: pw.Text(row.$1, style: labelStyle),
      ),
      pw.SizedBox(width: _labelValueGapInCell),
      pw.Expanded(
        flex: _valueFlexInCell,
        child: pw.Text(_value(row.$2), style: valueStyle),
      ),
    ],
  );
}

List<pw.Widget> _buildPairedRowWidgets(List<(String, String)> rows) {
  final rowWidgets = <pw.Widget>[];
  for (var i = 0; i < rows.length; i += 2) {
    if (i + 1 < rows.length) {
      rowWidgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: _rowSpacing),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: _labelValueCell(rows[i])),
              pw.SizedBox(width: 10),
              pw.Expanded(child: _labelValueCell(rows[i + 1])),
            ],
          ),
        ),
      );
    } else {
      rowWidgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: _rowSpacing),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [pw.Expanded(flex: 1, child: _labelValueCell(rows[i]))],
          ),
        ),
      );
    }
  }
  return rowWidgets;
}

/// Two-column pairs; preserves list order (row 0–1, then 2–3, …).
pw.Widget _buildSectionDense(String sectionTitle, List<(String, String)> rows) {
  final rowWidgets = _buildPairedRowWidgets(rows);

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Text(
        sectionTitle,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: _sectionTitleFontSize,
        ),
      ),
      pw.SizedBox(height: 4),
      ...rowWidgets,
    ],
  );
}
