import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:timerevo/l10n/app_localizations.dart';

import '../../core/error_message_helper.dart';
import '../../core/weekly_template_hours_display.dart';
import '../../domain/entities/employee_status.dart';
import '../../domain/entities/schedule_entities.dart';
import '../../domain/ports/schedules_repo_port.dart';
import '../../domain/schedule_weekly_work_minutes.dart';
import '../../domain/usecases.dart';
import 'employee_data_pdf_builder.dart';

String _formatDate(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

String _statusLabel(EmployeeStatus status, AppLocalizations l10n) =>
    switch (status) {
      EmployeeStatus.active => l10n.employeeStatusActive,
      EmployeeStatus.inactive => l10n.employeeStatusInactive,
      EmployeeStatus.archived => l10n.employeeStatusArchived,
    };

String _roleLabel(String role, AppLocalizations l10n) => switch (role) {
  'manager' => l10n.employeeRoleManager,
  _ => l10n.employeeRoleEmployee,
};

String _employmentTypeLabel(String? type, AppLocalizations l10n) {
  if (type == null) return l10n.commonNone;
  return switch (type) {
    'full_time' => l10n.employeeEmploymentTypeFullTime,
    'part_time' => l10n.employeeEmploymentTypePartTime,
    'minijob' => l10n.employeeEmploymentTypeMinijob,
    'custom' => l10n.employeeEmploymentTypeCustom,
    _ => type,
  };
}

/// Exports single-employee data PDF. Call from admin employee details screen.
/// Access enforcement: requires [isAdminContext] true; aborts if false.
Future<void> exportEmployeeDataPdf(
  BuildContext context, {
  required bool isAdminContext,
  required EmployeesAdminUseCase employeesAdminUseCase,
  required ISchedulesRepo schedulesRepo,
  required int employeeId,
  required List<ScheduleTemplateInfo> templates,
  required void Function(String message) showSnack,
  required void Function(String message, {bool isError}) showErrorSnack,
}) async {
  final l10n = AppLocalizations.of(context);
  if (!isAdminContext) {
    showErrorSnack(l10n.employeeDataPdfAdminOnly, isError: true);
    return;
  }

  final now = DateTime.now().toLocal();
  final suggestedName =
      'timerevo_employee_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.pdf';

  final saveLocation = await getSaveLocation(
    suggestedName: suggestedName,
    acceptedTypeGroups: [
      XTypeGroup(label: l10n.reportsPdfFileType, extensions: const ['pdf']),
    ],
  );
  if (saveLocation == null) return;

  try {
    final details = await employeesAdminUseCase.getEmployeeDetails(employeeId);
    if (details == null) {
      if (context.mounted) {
        showErrorSnack(
          l10n.employeeDataPdfFailed(l10n.commonErrorOccurred),
          isError: true,
        );
      }
      return;
    }

    final templateName = details.templateId != null
        ? templates
                  .where((t) => t.id == details.templateId)
                  .firstOrNull
                  ?.name ??
              l10n.commonNone
        : l10n.commonNone;

    String weeklyHoursDisplay = '\u2014';
    if (details.templateId != null) {
      final week = await schedulesRepo.getTemplateWeek(details.templateId!);
      final totalMin = scheduleTemplateWeekTotalWorkMinutes(week);
      weeklyHoursDisplay = formatTemplateWeeklyHoursDisplay(totalMin);
    }

    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(fontData),
      bold: pw.Font.ttf(fontBoldData),
    );

    final labels = EmployeeDataPdfLabels(
      title: l10n.employeeDataPdfTitle,
      sectionEmployeeInfo: l10n.employeeDataPdfSectionEmployeeInfo,
      sectionEmployment: l10n.employeeSectionEmployment,
      firstName: l10n.employeeFirstName,
      lastName: l10n.employeeLastName,
      status: l10n.employeeStatus,
      email: l10n.employeeEmail,
      phone: l10n.employeePhone,
      secondaryPhone: l10n.employeeSecondaryPhoneLabel,
      role: l10n.employeeRole,
      employmentType: l10n.employeeEmploymentType,
      hireDate: l10n.employeeHireDate,
      terminationDate: l10n.employeeTerminationDateLabel,
      weeklyHours: l10n.employeeWeeklyHours,
      vacationDaysPerYear: l10n.employeeVacationDaysPerYearLabel,
      department: l10n.employeeDepartment,
      jobTitle: l10n.employeeJobTitle,
      schedule: l10n.employeeSectionSchedule,
      footerPage: l10n.reportsPdfFooterPage,
    );

    final pdf = await buildEmployeeDataPdf(
      theme: theme,
      labels: labels,
      details: details,
      templateName: templateName == l10n.commonNone ? null : templateName,
      weeklyHoursDisplay: weeklyHoursDisplay,
      formatDate: _formatDate,
      statusLabel: _statusLabel(details.status, l10n),
      roleLabel: _roleLabel(details.employeeRole, l10n),
      employmentTypeLabel: _employmentTypeLabel(details.employmentType, l10n),
    );
    final bytes = await pdf.save();
    await File(saveLocation.path).writeAsBytes(bytes);

    if (context.mounted) {
      showSnack(l10n.employeeDataPdfExported);
    }
  } catch (e) {
    if (context.mounted) {
      showErrorSnack(
        l10n.employeeDataPdfFailed(
          errorMessageForUser(e, l10n.commonErrorOccurred),
        ),
        isError: true,
      );
    }
  }
}
