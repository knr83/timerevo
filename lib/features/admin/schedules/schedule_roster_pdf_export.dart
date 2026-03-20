import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../app/usecase_providers.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../core/error_message_helper.dart';
import '../../../core/pdf/schedule_roster_pdf_builder.dart';
import '../../../core/weekly_template_hours_display.dart';

String _scheduleRosterPdfSuggestedFileName() {
  final gen = DateTime.now().toLocal();
  final d =
      '${gen.year}-${gen.month.toString().padLeft(2, '0')}-${gen.day.toString().padLeft(2, '0')}';
  final hhmm =
      '${gen.hour.toString().padLeft(2, '0')}${gen.minute.toString().padLeft(2, '0')}';
  return 'timerevo_schedule_roster_${d}_$hhmm.pdf';
}

String _weekdayLabel(AppLocalizations l10n, int w) {
  return switch (w) {
    1 => l10n.weekdayMonday,
    2 => l10n.weekdayTuesday,
    3 => l10n.weekdayWednesday,
    4 => l10n.weekdayThursday,
    5 => l10n.weekdayFriday,
    6 => l10n.weekdaySaturday,
    _ => l10n.weekdaySunday,
  };
}

/// Admin: export work schedule roster PDF (all employees, weekly templates).
Future<void> exportScheduleRosterPdf(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context);
  final saveLocation = await getSaveLocation(
    suggestedName: _scheduleRosterPdfSuggestedFileName(),
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.reportsPdfFileType, extensions: const ['pdf']),
    ],
  );
  if (saveLocation == null) return;

  try {
    final data = await ref.read(scheduleRosterPdfDataUseCaseProvider).build();
    final tableRows = data.rows.map((r) {
      final wh = formatTemplateWeeklyHoursDisplay(r.weeklyTotalWorkMinutes);
      return ScheduleRosterPdfTableRow(
        employee: r.employeeDisplayName,
        weekdayCells: List<String>.from(r.weekdayCells),
        weeklyHours: wh,
      );
    }).toList();

    final labels = ScheduleRosterPdfLabels(
      title: l10n.schedulesRosterPdfTitle,
      columnEmployee: l10n.schedulesRosterPdfColumnEmployee,
      columnWeeklyHours: l10n.schedulesRosterPdfColumnWeeklyHours,
      weekdayHeader: (w) => _weekdayLabel(l10n, w),
      footerPage: l10n.reportsPdfFooterPage,
    );

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fontData),
      bold: pw.Font.ttf(fontBoldData),
    );

    final pdf = await buildScheduleRosterPdf(
      theme: theme,
      labels: labels,
      rows: tableRows,
      visibleWeekdays: data.visibleWeekdays,
    );
    final bytes = await pdf.save();
    await File(saveLocation.path).writeAsBytes(bytes);

    if (context.mounted) {
      showAppSnack(context, l10n.schedulesRosterPdfExported);
    }
  } catch (e) {
    if (context.mounted) {
      showAppSnack(
        context,
        l10n.schedulesRosterPdfFailed(
          errorMessageForUser(e, l10n.commonErrorOccurred),
        ),
        isError: true,
      );
    }
  }
}
