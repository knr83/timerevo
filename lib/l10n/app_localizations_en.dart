// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Time Tracker';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonOngoing => 'Ongoing';

  @override
  String get commonNotAvailable => 'N/A';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonActivate => 'Activate';

  @override
  String get commonDeactivate => 'Deactivate';

  @override
  String get commonActive => 'Active';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get commonNone => 'None';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonBack => 'Back';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonOk => 'OK';

  @override
  String get commonErrorOccurred => 'An error occurred.';

  @override
  String get commonRequiredFieldsLegend => '* Required fields';

  @override
  String commonFilterLabelWithValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String initFailed(String error) {
    return 'Initialization failed: $error';
  }

  @override
  String get initFailedGeneric =>
      'Initialization failed. Please try again or reinstall.';

  @override
  String get initDbErrorTitle => 'Database error';

  @override
  String get initDbErrorMessage =>
      'The database could not be opened. Restore from a backup or reinitialize to continue.';

  @override
  String get initDbErrorRestore => 'Restore from backup';

  @override
  String get initDbErrorReinitialize => 'Reinitialize (loses all local data)';

  @override
  String get initDbErrorRetry => 'Retry';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalAdmin => 'Administration';

  @override
  String get terminalNoActiveEmployees => 'No active employees.';

  @override
  String terminalFailedLoadEmployees(String error) {
    return 'Failed to load employees: $error';
  }

  @override
  String get terminalNoOpenSession => 'No open session.';

  @override
  String get terminalStatusOnShift => 'On shift';

  @override
  String terminalOnShiftSince(String time) {
    return 'since $time';
  }

  @override
  String get terminalStatusReady => 'Ready to clock in';

  @override
  String terminalCurrentTime(String time) {
    return 'Now $time';
  }

  @override
  String get terminalSwitchEmployee => 'Change employee';

  @override
  String get terminalSessionsToday => 'Today';

  @override
  String get terminalSessionInProgress => 'in progress';

  @override
  String terminalSessionRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get terminalNoSessionsToday => 'No sessions today';

  @override
  String get terminalDurationLessThanOneMin => '< 1 min';

  @override
  String terminalDurationMinutesOnly(int m) {
    return '$m min';
  }

  @override
  String terminalDurationHoursOnly(int h) {
    return '$h h';
  }

  @override
  String terminalShowMoreSessions(int count) {
    return 'Show $count more';
  }

  @override
  String get terminalTotalToday => 'Total today';

  @override
  String terminalTotalTodayWithValue(String value) {
    return 'Total today: $value';
  }

  @override
  String get terminalErrorSessionAlreadyOpen => 'Session is already open.';

  @override
  String get terminalErrorNoOpenSession => 'No open session.';

  @override
  String get terminalErrorClockInBeforeStart =>
      'Cannot clock in before working hours start.';

  @override
  String get terminalErrorClockInAfterEnd =>
      'Cannot clock in after working hours end.';

  @override
  String get terminalErrorHasApprovedAbsence =>
      'You have an approved absence today. Clock-in is not available.';

  @override
  String get terminalErrorNoScheduleForDay => 'No scheduled work today.';

  @override
  String get terminalErrorAttendanceUnavailable =>
      'Attendance settings could not be loaded.';

  @override
  String get terminalNoteRequiredTitle => 'Note required';

  @override
  String get terminalNoteRequiredMessage =>
      'A note is required for this attendance deviation.';

  @override
  String get terminalNoteReasonLateArrival => 'Reason: Late arrival';

  @override
  String get terminalNoteReasonEarlyDeparture => 'Reason: Early departure';

  @override
  String get terminalNoteReasonLateDeparture => 'Reason: Late departure';

  @override
  String get terminalNoteLabel => 'Note';

  @override
  String get terminalNoteConfirm => 'Confirm';

  @override
  String get terminalNoteCancel => 'Cancel';

  @override
  String terminalOpenSince(String time) {
    return 'OPEN session since $time';
  }

  @override
  String get terminalIn => 'IN';

  @override
  String get terminalOut => 'OUT';

  @override
  String get terminalSaved => 'Saved.';

  @override
  String get terminalSuccessClockIn => 'Have a good workday';

  @override
  String get terminalSuccessClockOut => 'Enjoy your rest';

  @override
  String get terminalPinPromptTitle => 'Enter PIN';

  @override
  String get terminalPinConfirm => 'OK';

  @override
  String get terminalPinNotSet =>
      'PIN is not set for this user. Contact the administrator.';

  @override
  String get terminalUnclosedSessionTitle => 'Unclosed session';

  @override
  String terminalUnclosedSessionMessage(String startTime) {
    return 'Session started at $startTime. Enter the end date and time.';
  }

  @override
  String get terminalUnclosedSessionEndLabel => 'End date and time';

  @override
  String get terminalUnclosedSessionSelectEnd => 'Select date and time';

  @override
  String get terminalUnclosedSessionConfirm => 'Close session';

  @override
  String get terminalUnclosedSessionErrorEndBeforeStart =>
      'End must be after start.';

  @override
  String get terminalUnclosedSessionErrorEndInFuture =>
      'End cannot be in the future.';

  @override
  String get terminalUnclosedSessionErrorEndAfterWorkingHours =>
      'End time cannot exceed working hours.';

  @override
  String get terminalPolicyRequiredTitle => 'Policy acknowledgment required';

  @override
  String get terminalPolicyRequiredMessage =>
      'To continue, you must read and acknowledge the Privacy Policy and Terms.';

  @override
  String get terminalPolicyCheckboxText =>
      'I have read and agree to the Privacy Policy and Terms';

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminNavEmployees => 'Employees';

  @override
  String get adminNavSchedules => 'Schedules';

  @override
  String get adminNavSessions => 'Sessions';

  @override
  String get adminNavJournal => 'Journal';

  @override
  String get adminNavReports => 'Reports';

  @override
  String get adminNavSettings => 'Settings';

  @override
  String get dashboardTitle => 'Home';

  @override
  String get dashboardNavOverview => 'Home';

  @override
  String get dashboardNowAtWork => 'Now at work';

  @override
  String get dashboardNoOneAtWork => 'No one at work yet';

  @override
  String get dashboardToday => 'All employees for today';

  @override
  String get dashboardRecentActivity => 'Recent activity';

  @override
  String get dashboardViewAllSessions => 'All sessions';

  @override
  String get dashboardNoRecentActivity => 'No recent activity';

  @override
  String get dashboardNoEmployeesToday => 'No employees today';

  @override
  String get adminEnterPinToContinue => 'Enter PIN to continue.';

  @override
  String get adminPinLabel => 'PIN';

  @override
  String get adminUnlock => 'Unlock';

  @override
  String get adminInvalidPin => 'Invalid PIN.';

  @override
  String get adminPinInvalidFormat =>
      'PIN must be digits only and at least 4 digits.';

  @override
  String get adminDefaultPinHint => 'Default PIN: 0000';

  @override
  String get adminChangePin => 'Change PIN';

  @override
  String get adminLock => 'Lock';

  @override
  String get adminPinUpdated => 'PIN updated.';

  @override
  String get changePinTitle => 'Change PIN';

  @override
  String get changePinCurrentPin => 'Current PIN';

  @override
  String get changePinNewPin => 'New PIN';

  @override
  String get changePinConfirmNewPin => 'Confirm new PIN';

  @override
  String get changePinNewPinRequired => 'New PIN is required.';

  @override
  String get changePinConfirmationMismatch =>
      'PIN confirmation does not match.';

  @override
  String get changePinCurrentInvalid => 'Current PIN is invalid.';

  @override
  String get changePinInvalidFormat =>
      'PIN must be digits only and at least 4 digits.';

  @override
  String get employeesTitle => 'Employees';

  @override
  String get employeesNoEmployeesYet => 'No employees yet.';

  @override
  String get employeesSelectFromList => 'Select an employee from the list.';

  @override
  String get employeesAddEmployee => 'Add';

  @override
  String get employeesInactiveHiddenHint =>
      'Inactive employees are hidden in the Terminal.';

  @override
  String get employeeDialogAddTitle => 'Add employee';

  @override
  String get employeeDialogEditTitle => 'Edit employee';

  @override
  String get employeeDialogNewTitle => 'New employee';

  @override
  String get employeeFirstName => 'First name';

  @override
  String get employeeLastName => 'Last name';

  @override
  String get employeeDefaultSchedule => 'Default schedule';

  @override
  String get employeeActiveLabel => 'Active';

  @override
  String get employeeStatusLabel => 'Status';

  @override
  String get employeeStatusActive => 'Active';

  @override
  String get employeeStatusInactive => 'Inactive';

  @override
  String get employeeStatusArchived => 'Archived';

  @override
  String get employeeTerminationDateLabel => 'Termination date';

  @override
  String get employeeVacationDaysPerYearLabel => 'Vacation days per year';

  @override
  String get employeeSecondaryPhoneLabel => 'Secondary phone';

  @override
  String get employeeStatusChangeConfirmTitle => 'Change status?';

  @override
  String get employeeStatusChangeConfirmMessage =>
      'Active employees are shown in the Terminal. Inactive and archived employees are not shown.';

  @override
  String get employeeStatusChangeConfirmConfirm => 'Change';

  @override
  String get employeeVacationDaysPerYearInvalid => 'Must be 0 or more';

  @override
  String get employeeTerminationDateBeforeHireError =>
      'Termination date must be on or after hire date.';

  @override
  String get employeeFirstLastRequired =>
      'First name and last name are required.';

  @override
  String employeeCreateFailed(String error) {
    return 'Failed to create employee: $error';
  }

  @override
  String employeeUpdateFailed(String error) {
    return 'Failed to update employee: $error';
  }

  @override
  String get employeeSaved => 'Saved.';

  @override
  String get employeeUnsavedChangesTitle => 'Unsaved changes';

  @override
  String get employeeUnsavedChangesMessage =>
      'You have unsaved changes. Save, discard, or cancel?';

  @override
  String get employeeDiscardChanges => 'Discard';

  @override
  String employeeDefaultScheduleSubtitle(String name) {
    return 'Default schedule: $name';
  }

  @override
  String employeeScheduleButtonLabel(String name) {
    return 'Schedule: $name';
  }

  @override
  String get employeeChangeScheduleTooltip => 'Change schedule';

  @override
  String get employeeId => 'Employee ID';

  @override
  String get employeeCode => 'Employee code';

  @override
  String get employeeCodeHint => 'E001';

  @override
  String get employeeCodeRequired => 'Employee code is required.';

  @override
  String get employeeFirstNameRequired => 'First name is required.';

  @override
  String get employeeLastNameRequired => 'Last name is required.';

  @override
  String get employeeHireDate => 'Hire date';

  @override
  String get employeeStatus => 'Status';

  @override
  String get employeeRole => 'Role';

  @override
  String get employeeRoleFieldLabel => 'Employee / Manager';

  @override
  String get employeeUsePin => 'Enable PIN';

  @override
  String get employeeUseNfc => 'Enable NFC';

  @override
  String get employeeAccessToken => 'Access token';

  @override
  String get employeePinStatus => 'PIN Status';

  @override
  String employeePinStatusWithValue(String value) {
    return 'PIN Status: $value';
  }

  @override
  String get employeeAccessNote => 'Access notes';

  @override
  String get employeeAccessTokenRequiredWhenNfc => 'Required when NFC enabled.';

  @override
  String get employeeEmploymentType => 'Employment type';

  @override
  String get employeeWeeklyHours => 'Weekly hours';

  @override
  String get employeeWeeklyHoursHint => '40';

  @override
  String get employeeEmail => 'Email';

  @override
  String get employeePhone => 'Phone';

  @override
  String get employeeDepartment => 'Department';

  @override
  String get employeeJobTitle => 'Job Title';

  @override
  String get employeeInternalComment => 'Internal Comment';

  @override
  String get employeePolicyAcknowledged => 'Policy Acknowledged';

  @override
  String get employeePolicyAcknowledgedAt => 'Acknowledged At';

  @override
  String employeePolicyAcknowledgedAtWithValue(String value) {
    return 'Acknowledged: $value';
  }

  @override
  String get employeeDataRetentionPolicy => 'Data Retention Policy';

  @override
  String get employeeCreatedAt => 'Created At';

  @override
  String employeeCreatedAtWithValue(String value) {
    return 'Created: $value';
  }

  @override
  String get employeeUpdatedAt => 'Updated At';

  @override
  String employeeUpdatedAtWithValue(String value) {
    return 'Updated: $value';
  }

  @override
  String get employeeCreatedBy => 'Created By';

  @override
  String get employeeUpdatedBy => 'Updated By';

  @override
  String get employeePinStatusSet => 'Set';

  @override
  String get employeePinStatusNotSet => 'Not set';

  @override
  String get employeeRoleEmployee => 'Employee';

  @override
  String get employeeRoleManager => 'Manager';

  @override
  String get employeeEmploymentTypeFullTime => 'Full time';

  @override
  String get employeeEmploymentTypePartTime => 'Part time';

  @override
  String get employeeEmploymentTypeMinijob => 'Minijob';

  @override
  String get employeeEmploymentTypeCustom => 'Custom';

  @override
  String get employeeTerminalAccessDisabled => 'Terminal access disabled';

  @override
  String get employeeInactive => 'Employee is inactive';

  @override
  String get employeeCodeAlreadyExists => 'Employee code already exists';

  @override
  String get employeePolicyText =>
      'Employee has acknowledged the Privacy Policy and Terms';

  @override
  String get employeePolicyPrefix => 'Employee has acknowledged the ';

  @override
  String get employeePolicyLinkPrivacy => 'Privacy Policy';

  @override
  String get employeePolicyMiddle => ' and ';

  @override
  String get employeePolicyLinkTerms => 'Terms';

  @override
  String get employeeSetPin => 'Set PIN';

  @override
  String get employeeResetPin => 'Reset PIN';

  @override
  String employeeFieldLabelWithRequired(String label) {
    return '$label *';
  }

  @override
  String get employeeSectionIdentity => 'Identity';

  @override
  String get employeeSectionBasicInfo => 'Basic information';

  @override
  String get employeeSectionEmployment => 'Employment';

  @override
  String get employeeSectionContact => 'Contact';

  @override
  String get employeeSectionAccess => 'Terminal Access';

  @override
  String get employeeSectionSchedule => 'Schedule';

  @override
  String get employeeScheduleRequired => 'Schedule is required.';

  @override
  String get employeeSectionPolicy => 'Policy & Compliance';

  @override
  String get employeeSectionAudit => 'Record';

  @override
  String get employeeTabGeneral => 'General';

  @override
  String get employeeTabContact => 'Contact';

  @override
  String get employeeTabTerminalAccess => 'Terminal Access';

  @override
  String get employeeTabAdditional => 'Additional';

  @override
  String get schedulesEmptyHint => 'Create a schedule template.';

  @override
  String schedulesFailedLoad(String error) {
    return 'Failed to load schedules: $error';
  }

  @override
  String get schedulesTitle => 'Schedules';

  @override
  String get schedulesAddTemplateTooltip => 'Add template';

  @override
  String get schedulesNoTemplates => 'No templates.';

  @override
  String get schedulesCreateTemplateTitle => 'Create template';

  @override
  String get schedulesRenameTemplateTitle => 'Rename template';

  @override
  String get schedulesTemplateNameLabel => 'Name';

  @override
  String get schedulesWeekEditorTitle => 'Week editor';

  @override
  String schedulesFailedLoadTemplate(String error) {
    return 'Failed to load template: $error';
  }

  @override
  String get schedulesDayOff => 'Day off';

  @override
  String get schedulesNoIntervals => 'No intervals.';

  @override
  String get schedulesAddInterval => 'Add interval';

  @override
  String get schedulesSaved => 'Saved.';

  @override
  String schedulesCopiedTo(String weekday) {
    return 'Copied to $weekday.';
  }

  @override
  String get schedulesInvalidInput => 'Invalid input.';

  @override
  String get schedulesBreadcrumb => 'Admin / Schedules';

  @override
  String get schedulesNewSchedule => 'New schedule';

  @override
  String get schedulesEditIntervalTitle => 'Edit interval';

  @override
  String get schedulesAddIntervalTitle => 'Add interval';

  @override
  String get schedulesStartTimeLabel => 'Start time';

  @override
  String get schedulesEndTimeLabel => 'End time';

  @override
  String get schedulesDiscardChanges => 'Discard';

  @override
  String get schedulesUnsavedChangesTitle => 'Unsaved changes';

  @override
  String get schedulesUnsavedChangesMessage =>
      'You have unsaved changes. Save, discard, or cancel?';

  @override
  String schedulesSaveFailed(String reason) {
    return 'Could not save: $reason';
  }

  @override
  String schedulesTotalHours(String hours) {
    return 'Total ${hours}h';
  }

  @override
  String get schedulesIntervalOverlapError =>
      'This interval overlaps with another.';

  @override
  String get schedulesIntervalEndBeforeStartError =>
      'End time must be after start time.';

  @override
  String get schedulesScheduleActiveSuffix => ' (Active)';

  @override
  String get schedulesScheduleInactiveSuffix => ' (Inactive)';

  @override
  String get schedulesRenameScheduleTooltip => 'Rename schedule';

  @override
  String get schedulesNameAlreadyExistsError => 'Name already exists.';

  @override
  String get schedulesNameRequiredError => 'Name is required.';

  @override
  String get schedulesDeleteScheduleTooltip => 'Delete schedule';

  @override
  String get schedulesDeleteScheduleTitle => 'Delete schedule?';

  @override
  String get schedulesDeleteScheduleMessage =>
      'This will remove the schedule template. Employees assigned to it will have no default schedule.';

  @override
  String get schedulesDeleteScheduleButton => 'Delete';

  @override
  String schedulesDeleteFailed(String reason) {
    return 'Could not delete: $reason';
  }

  @override
  String get schedulesDeleteBlockedAssignedTitle => 'Cannot delete';

  @override
  String get schedulesDeleteBlockedAssignedMessage =>
      'This schedule is assigned to employees. Unassign it before deleting.';

  @override
  String intervalStart(String time) {
    return 'Start: $time';
  }

  @override
  String intervalEnd(String time) {
    return 'End: $time';
  }

  @override
  String get intervalRemoveTooltip => 'Remove';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeHighContrastLight => 'High contrast (light)';

  @override
  String get settingsThemeHighContrastDark => 'High contrast (dark)';

  @override
  String get settingsAttendanceModeLabel => 'Attendance mode';

  @override
  String get settingsAttendanceModeFlexible => 'Flexible';

  @override
  String get settingsAttendanceModeFixed => 'Fixed';

  @override
  String get settingsAttendanceToleranceLabel => 'Tolerance (minutes)';

  @override
  String get settingsAttendanceModeChangeConfirmTitle =>
      'Change attendance mode?';

  @override
  String get settingsAttendanceModeChangeConfirmMessage =>
      'This affects terminal check-in and check-out behavior for all employees.';

  @override
  String get settingsWorkingHoursLabel => 'Allowed working time';

  @override
  String get settingsWorkingHoursFrom => 'From';

  @override
  String get settingsWorkingHoursTo => 'To';

  @override
  String get settingsWorkingHoursInvalidRange => 'From must be before To';

  @override
  String settingsWorkingHoursFromWithValue(String value) {
    return 'From: $value';
  }

  @override
  String settingsWorkingHoursToWithValue(String value) {
    return 'To: $value';
  }

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsCreateBackup => 'Create backup';

  @override
  String settingsBackupCreated(String path) {
    return 'Backup created: $path';
  }

  @override
  String get settingsBackupSuccessTitle => 'Backup created successfully';

  @override
  String get settingsRestoreCompletedTitle => 'Database restored';

  @override
  String get settingsRestoreCompletedMessage =>
      'The database was restored from a backup. Press OK to continue.';

  @override
  String get settingsBackupErrorPermissionDenied =>
      'Cannot access the file or folder.';

  @override
  String get settingsBackupErrorNotFound => 'File or folder not found.';

  @override
  String get settingsBackupErrorInvalidArchive => 'Invalid backup file.';

  @override
  String get settingsBackupErrorIoFailure => 'A file operation failed.';

  @override
  String get settingsBackupErrorDbFailure => 'Database error.';

  @override
  String get settingsBackupErrorUnknown => 'An unknown error occurred.';

  @override
  String get settingsRestoreFromBackup => 'Restore from backup';

  @override
  String get settingsRestoreConfirmTitle => 'Restore';

  @override
  String get settingsRestoreConfirmMessage =>
      'Current data will be completely replaced by data from the selected file. Continue?';

  @override
  String get settingsRestoreCreated =>
      'Restore complete. Refresh the screen if needed.';

  @override
  String get settingsRestoreScheduledRestart =>
      'Restore scheduled. Please restart the application to complete.';

  @override
  String get settingsRestoreErrorPermissionDenied =>
      'Cannot access the file or folder.';

  @override
  String get settingsRestoreErrorNotFound => 'File or folder not found.';

  @override
  String get settingsRestoreErrorInvalidArchive => 'Invalid backup file.';

  @override
  String get settingsRestoreErrorIoFailure => 'A file operation failed.';

  @override
  String get settingsRestoreErrorDbFailure => 'Database error.';

  @override
  String get settingsRestoreErrorUnknown => 'An unknown error occurred.';

  @override
  String get settingsRestoreSchemaError =>
      'File was created in another app version. Restore is not possible.';

  @override
  String get settingsExportDiagnostics => 'Export diagnostics';

  @override
  String get settingsExportDiagnosticsSuccess =>
      'Diagnostics exported successfully';

  @override
  String settingsExportDiagnosticsFailed(String error) {
    return 'Diagnostics export failed: $error';
  }

  @override
  String get legalTerms => 'Terms / Disclaimer';

  @override
  String get helpTitle => 'Help';

  @override
  String get aboutTitle => 'About';

  @override
  String get legalNoticeWelcomeTitle => 'Welcome';

  @override
  String get legalNoticeWelcomeText =>
      'Please review Privacy Policy and Terms.';

  @override
  String get legalNoticeOpenPrivacy => 'Open Privacy Policy';

  @override
  String get legalNoticeOpenTerms => 'Open Terms';

  @override
  String get legalNoticeClose => 'Close';

  @override
  String get legalCopy => 'Copy';

  @override
  String get legalCopiedToClipboard => 'Copied to clipboard.';

  @override
  String get legalFailedToCopy => 'Failed to copy.';

  @override
  String get sessionsTitle => 'Sessions';

  @override
  String get sessionsEmployeeFilter => 'Employee';

  @override
  String get sessionsEmployeeAll => 'All';

  @override
  String get sessionsNoEmployeesAvailable => 'No employees available.';

  @override
  String sessionsFailedLoadEmployees(String error) {
    return 'Failed to load employees: $error';
  }

  @override
  String get sessionsFilterFrom => 'From';

  @override
  String get sessionsFilterTo => 'To';

  @override
  String get sessionsFilterAny => 'Any';

  @override
  String get sessionsNoSessions => 'No sessions.';

  @override
  String sessionsFailedLoadSessions(String error) {
    return 'Failed to load sessions: $error';
  }

  @override
  String get sessionsTableEmployee => 'Employee';

  @override
  String get sessionsTableStart => 'Start';

  @override
  String get sessionsTableEnd => 'End';

  @override
  String get sessionsTableDuration => 'Duration';

  @override
  String sessionsDurationWithValue(String value) {
    return 'Duration: $value';
  }

  @override
  String get sessionsTableStatus => 'Status';

  @override
  String get sessionsTableNote => 'Note';

  @override
  String get sessionsTableActions => 'Actions';

  @override
  String get sessionsEdit => 'Edit';

  @override
  String get sessionsEditDialogTitle => 'Edit session';

  @override
  String sessionsEmployeePrefix(String name) {
    return 'Employee: $name';
  }

  @override
  String sessionsStartPrefix(String value) {
    return 'Start: $value';
  }

  @override
  String sessionsEndPrefix(String value) {
    return 'End: $value';
  }

  @override
  String get sessionsOpenSessionLabel => 'Open session (end is empty)';

  @override
  String get sessionsSetEndNow => 'Set end = now';

  @override
  String get sessionsClearEnd => 'Clear end';

  @override
  String get sessionsUpdateReason => 'Update reason';

  @override
  String get sessionsEmployeeCannotChangeHint => 'Employee cannot be changed.';

  @override
  String get sessionsUpdateReasonRequired => 'Update reason is required.';

  @override
  String get sessionsErrorSameDayRequired =>
      'Session must start and end on the same day.';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalFilterFrom => 'From';

  @override
  String get journalFilterTo => 'To';

  @override
  String get journalFilterAny => 'Any';

  @override
  String get journalFilterStatusAll => 'All';

  @override
  String get journalFilterStatusOpen => 'Open';

  @override
  String get journalFilterStatusClosed => 'Closed';

  @override
  String get journalFilterStatusNotClosed => 'Not closed';

  @override
  String get journalFilterSearch => 'Search';

  @override
  String get journalFilterEmployee => 'Employee';

  @override
  String get journalScopeDay => 'Day';

  @override
  String get journalScopeWeek => 'Week';

  @override
  String get journalScopeMonth => 'Month';

  @override
  String get journalScopeInterval => 'Custom';

  @override
  String get journalPresetToday => 'Today';

  @override
  String get journalPresetWeek => 'Week';

  @override
  String get journalPresetMonth => 'Month';

  @override
  String get journalPresetLastMonth => 'Last month';

  @override
  String get journalEndEmpty => '—';

  @override
  String get journalEditDialogTitle => 'Edit session';

  @override
  String get journalCloseNow => 'Close now';

  @override
  String get journalErrorEndBeforeStart => 'End time must be after start time.';

  @override
  String get journalErrorCrossDay => 'Start and end must be on the same day.';

  @override
  String get journalErrorOutsideEmployment =>
      'Session dates must fall within the employee\'s employment period.';

  @override
  String get journalUpdateReasonHint =>
      'Required when changing start or end time';

  @override
  String get journalSaved => 'Saved.';

  @override
  String get journalViewTable => 'Table';

  @override
  String get journalViewTimeline => 'Timeline';

  @override
  String get journalViewDetailed => 'Detailed';

  @override
  String get journalIntervalLegendWork => 'Work';

  @override
  String get journalIntervalLegendApprovedAbsence => 'Approved absence';

  @override
  String get journalIntervalLegendOngoing => 'Ongoing';

  @override
  String get journalTimelineStateOngoing => 'Ongoing work';

  @override
  String get journalTimelineStatePresent => 'Present';

  @override
  String get journalTimelineStateApprovedAbsence => 'Approved absence';

  @override
  String get journalTimelineStateExpectedNoShow => 'Expected but no attendance';

  @override
  String get journalTimelineStateNoData => 'No data';

  @override
  String get journalTimelinePickRangeHint =>
      'Pick a date range for timeline view.';

  @override
  String get journalNavPrev => 'Previous';

  @override
  String get journalNavNext => 'Next';

  @override
  String get journalIntervalNow => 'now';

  @override
  String journalIntervalDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsNoData => 'No data.';

  @override
  String reportsFailedLoad(String error) {
    return 'Failed to load report: $error';
  }

  @override
  String get reportsOnlyClosedHint =>
      'Only CLOSED sessions are included in totals.';

  @override
  String get reportsTableEmployee => 'Employee';

  @override
  String get reportsTableTotal => 'Total';

  @override
  String get reportsTableNorm => 'Norm';

  @override
  String get reportsTableDelta => 'Delta';

  @override
  String get reportsTableSessions => 'Sessions';

  @override
  String get reportsExportPdf => 'Export PDF';

  @override
  String get reportsPdfFileType => 'PDF files';

  @override
  String get reportsExported => 'Exported.';

  @override
  String get reportsTableWorked => 'Worked';

  @override
  String get reportsTablePlanned => 'Planned';

  @override
  String get reportsTableBalance => 'Balance (+/−)';

  @override
  String get reportsPlannedNoSchedule => 'No schedule';

  @override
  String get reportsPeriodLabel => 'Period';

  @override
  String get reportsPeriodPresetToday => 'Today';

  @override
  String get reportsPeriodPresetWeek => 'Week';

  @override
  String get reportsPeriodPresetMonth => 'Month';

  @override
  String get reportsPeriodPresetLastMonth => 'Last month';

  @override
  String get reportsPeriodPresetCustom => 'Custom';

  @override
  String get reportsEmployeeFilter => 'Employee';

  @override
  String get reportsDetailsTitle => 'Details';

  @override
  String get reportsExportEmployeePdf => 'Export PDF';

  @override
  String get reportsDetailsClose => 'Close';

  @override
  String get reportsTableDate => 'Date';

  @override
  String get reportsPdfTitle => 'Time report';

  @override
  String reportsPdfPeriod(String from, String to) {
    return 'Period: $from — $to';
  }

  @override
  String reportsPdfGenerated(String datetime) {
    return 'Generated: $datetime';
  }

  @override
  String reportsPdfEmployee(String name) {
    return 'Employee: $name';
  }

  @override
  String reportsPdfSort(String column) {
    return 'Sort: $column';
  }

  @override
  String get reportsPdfFooterBrand => 'Timerevo — offline report';

  @override
  String reportsPdfFooterPage(int current, int total) {
    return 'Page $current / $total';
  }

  @override
  String get adminNavAbsences => 'Absences';

  @override
  String get absencesTitle => 'Absences';

  @override
  String get absencesAdd => 'Add absence';

  @override
  String get absencesEmployee => 'Employee';

  @override
  String get absencesType => 'Type';

  @override
  String get absencesDateFrom => 'From';

  @override
  String get absencesDateTo => 'To';

  @override
  String get absencesStatus => 'Status';

  @override
  String get absencesCreatedBy => 'Created by';

  @override
  String get absencesActions => 'Actions';

  @override
  String get absenceTypeVacation => 'Annual leave';

  @override
  String get absenceTypeSickLeave => 'Sick leave';

  @override
  String get absenceTypeUnpaidLeave => 'Unpaid leave';

  @override
  String get absenceTypeParentalLeave => 'Parental leave';

  @override
  String get absenceTypeStudyLeave => 'Study leave';

  @override
  String get absenceTypeOther => 'Other';

  @override
  String get absenceStatusPending => 'Pending';

  @override
  String get absenceStatusApproved => 'Approved';

  @override
  String get absenceStatusRejected => 'Rejected';

  @override
  String get absenceApprove => 'Approve';

  @override
  String get absenceReject => 'Reject';

  @override
  String get absenceEdit => 'Edit';

  @override
  String get absenceDelete => 'Delete';

  @override
  String get absenceRejectReason => 'Reject reason';

  @override
  String get terminalMyCalendar => 'My work calendar';

  @override
  String get terminalMyPdf => 'Time report (PDF)';

  @override
  String terminalCalendarPageTitle(String name) {
    return 'Work calendar ($name)';
  }

  @override
  String get terminalCalendarSessions => 'Sessions';

  @override
  String get terminalCalendarAbsences => 'Absences';

  @override
  String get terminalCalendarNoData => 'No data for this day';

  @override
  String get terminalCalendarNewAbsence => 'New request';

  @override
  String get terminalCalendarFormatMonth => 'Month';

  @override
  String get terminalCalendarFormatTwoWeeks => '2 weeks';

  @override
  String get terminalCalendarFormatWeek => 'Week';

  @override
  String get absenceCreateTitle => 'New absence request';

  @override
  String get absenceEditTitle => 'Edit absence';

  @override
  String get absenceErrorOverlap => 'Overlap with existing absence.';

  @override
  String get absenceErrorDateRestrictionVacation =>
      'Vacation must start today or later.';

  @override
  String get absenceErrorDateRestrictionSickLeave =>
      'Sick leave cannot start more than 3 days ago.';

  @override
  String get absenceErrorOutsideEmployment =>
      'Absence must be within employee employment period (from hire date to termination date).';

  @override
  String get absencesEmpty => 'No absences.';

  @override
  String get absencesEmptyHint => 'No absences yet. Create your first request.';

  @override
  String get absenceDeleteConfirm => 'Delete this absence request?';

  @override
  String get absenceApproveConfirm => 'Approve this absence request?';

  @override
  String get absenceRejectConfirmHint =>
      'The employee will see the reject reason.';

  @override
  String get absenceCreated => 'Absence request created.';

  @override
  String get absenceUpdated => 'Absence request updated.';

  @override
  String get absenceApproved => 'Absence request approved.';

  @override
  String get absenceRejected => 'Absence request rejected.';

  @override
  String get absenceDeleted => 'Absence request deleted.';

  @override
  String get absencesApprovedBy => 'Approved by';

  @override
  String get absencesApprovedAt => 'Approved at';

  @override
  String get absenceErrorEditPendingOnly => 'Can only edit pending absences.';

  @override
  String get absenceErrorDeletePendingOnly =>
      'Can only delete pending absences.';

  @override
  String get absenceErrorApproveRejectPendingOnly =>
      'Can only approve or reject pending absences.';

  @override
  String get absenceErrorRejectReasonRequired => 'Reject reason is required.';

  @override
  String get absenceErrorDateOrder =>
      'End date must be on or after start date.';

  @override
  String get absenceErrorEmployeeRequired => 'Please select an employee.';

  @override
  String get absenceErrorDateRequired => 'Please select From and To dates.';
}
