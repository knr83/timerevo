import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Tracker'**
  String get appTitle;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get commonOngoing;

  /// No description provided for @commonNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get commonNotAvailable;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @commonActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get commonActivate;

  /// No description provided for @commonDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get commonDeactivate;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get commonInactive;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonUnknown;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred.'**
  String get commonErrorOccurred;

  /// No description provided for @commonRequiredFieldsLegend.
  ///
  /// In en, this message translates to:
  /// **'* Required fields'**
  String get commonRequiredFieldsLegend;

  /// No description provided for @commonFilterLabelWithValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String commonFilterLabelWithValue(String label, String value);

  /// No description provided for @initFailed.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed: {error}'**
  String initFailed(String error);

  /// No description provided for @initFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed. Please try again or reinstall.'**
  String get initFailedGeneric;

  /// No description provided for @initDbErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Database error'**
  String get initDbErrorTitle;

  /// No description provided for @initDbErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The database could not be opened. Restore from a backup or reinitialize to continue.'**
  String get initDbErrorMessage;

  /// No description provided for @initDbErrorRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get initDbErrorRestore;

  /// No description provided for @initDbErrorReinitialize.
  ///
  /// In en, this message translates to:
  /// **'Reinitialize (loses all local data)'**
  String get initDbErrorReinitialize;

  /// No description provided for @initDbErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get initDbErrorRetry;

  /// No description provided for @terminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminalTitle;

  /// No description provided for @terminalAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get terminalAdmin;

  /// No description provided for @terminalNoActiveEmployees.
  ///
  /// In en, this message translates to:
  /// **'No active employees.'**
  String get terminalNoActiveEmployees;

  /// No description provided for @terminalFailedLoadEmployees.
  ///
  /// In en, this message translates to:
  /// **'Failed to load employees: {error}'**
  String terminalFailedLoadEmployees(String error);

  /// No description provided for @terminalNoOpenSession.
  ///
  /// In en, this message translates to:
  /// **'No open session.'**
  String get terminalNoOpenSession;

  /// No description provided for @terminalStatusOnShift.
  ///
  /// In en, this message translates to:
  /// **'On shift'**
  String get terminalStatusOnShift;

  /// No description provided for @terminalOnShiftSince.
  ///
  /// In en, this message translates to:
  /// **'since {time}'**
  String terminalOnShiftSince(String time);

  /// No description provided for @terminalStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to clock in'**
  String get terminalStatusReady;

  /// No description provided for @terminalCurrentTime.
  ///
  /// In en, this message translates to:
  /// **'Now {time}'**
  String terminalCurrentTime(String time);

  /// No description provided for @terminalSwitchEmployee.
  ///
  /// In en, this message translates to:
  /// **'Change employee'**
  String get terminalSwitchEmployee;

  /// No description provided for @terminalSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get terminalSessionsToday;

  /// No description provided for @terminalSessionInProgress.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get terminalSessionInProgress;

  /// No description provided for @terminalSessionRange.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String terminalSessionRange(String start, String end);

  /// No description provided for @terminalNoSessionsToday.
  ///
  /// In en, this message translates to:
  /// **'No sessions today'**
  String get terminalNoSessionsToday;

  /// No description provided for @terminalDurationLessThanOneMin.
  ///
  /// In en, this message translates to:
  /// **'< 1 min'**
  String get terminalDurationLessThanOneMin;

  /// No description provided for @terminalDurationMinutesOnly.
  ///
  /// In en, this message translates to:
  /// **'{m} min'**
  String terminalDurationMinutesOnly(int m);

  /// No description provided for @terminalDurationHoursOnly.
  ///
  /// In en, this message translates to:
  /// **'{h} h'**
  String terminalDurationHoursOnly(int h);

  /// No description provided for @terminalShowMoreSessions.
  ///
  /// In en, this message translates to:
  /// **'Show {count} more'**
  String terminalShowMoreSessions(int count);

  /// No description provided for @terminalTotalToday.
  ///
  /// In en, this message translates to:
  /// **'Total today'**
  String get terminalTotalToday;

  /// No description provided for @terminalTotalTodayWithValue.
  ///
  /// In en, this message translates to:
  /// **'Total today: {value}'**
  String terminalTotalTodayWithValue(String value);

  /// No description provided for @terminalErrorSessionAlreadyOpen.
  ///
  /// In en, this message translates to:
  /// **'Session is already open.'**
  String get terminalErrorSessionAlreadyOpen;

  /// No description provided for @terminalErrorNoOpenSession.
  ///
  /// In en, this message translates to:
  /// **'No open session.'**
  String get terminalErrorNoOpenSession;

  /// No description provided for @terminalErrorClockInBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Cannot clock in before working hours start.'**
  String get terminalErrorClockInBeforeStart;

  /// No description provided for @terminalErrorClockInAfterEnd.
  ///
  /// In en, this message translates to:
  /// **'Cannot clock in after working hours end.'**
  String get terminalErrorClockInAfterEnd;

  /// No description provided for @terminalErrorHasApprovedAbsence.
  ///
  /// In en, this message translates to:
  /// **'You have an approved absence today. Clock-in is not available.'**
  String get terminalErrorHasApprovedAbsence;

  /// No description provided for @terminalErrorNoScheduleForDay.
  ///
  /// In en, this message translates to:
  /// **'No scheduled work today.'**
  String get terminalErrorNoScheduleForDay;

  /// No description provided for @terminalErrorAttendanceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Attendance settings could not be loaded.'**
  String get terminalErrorAttendanceUnavailable;

  /// No description provided for @terminalNoteRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Note required'**
  String get terminalNoteRequiredTitle;

  /// No description provided for @terminalNoteRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'A note is required for this attendance deviation.'**
  String get terminalNoteRequiredMessage;

  /// No description provided for @terminalNoteReasonLateArrival.
  ///
  /// In en, this message translates to:
  /// **'Reason: Late arrival'**
  String get terminalNoteReasonLateArrival;

  /// No description provided for @terminalNoteReasonEarlyDeparture.
  ///
  /// In en, this message translates to:
  /// **'Reason: Early departure'**
  String get terminalNoteReasonEarlyDeparture;

  /// No description provided for @terminalNoteReasonLateDeparture.
  ///
  /// In en, this message translates to:
  /// **'Reason: Late departure'**
  String get terminalNoteReasonLateDeparture;

  /// No description provided for @terminalNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get terminalNoteLabel;

  /// No description provided for @terminalNoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get terminalNoteConfirm;

  /// No description provided for @terminalNoteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get terminalNoteCancel;

  /// No description provided for @terminalOpenSince.
  ///
  /// In en, this message translates to:
  /// **'OPEN session since {time}'**
  String terminalOpenSince(String time);

  /// No description provided for @terminalIn.
  ///
  /// In en, this message translates to:
  /// **'IN'**
  String get terminalIn;

  /// No description provided for @terminalOut.
  ///
  /// In en, this message translates to:
  /// **'OUT'**
  String get terminalOut;

  /// No description provided for @terminalSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get terminalSaved;

  /// No description provided for @terminalSuccessClockIn.
  ///
  /// In en, this message translates to:
  /// **'Have a good workday'**
  String get terminalSuccessClockIn;

  /// No description provided for @terminalSuccessClockOut.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your rest'**
  String get terminalSuccessClockOut;

  /// No description provided for @terminalPinPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get terminalPinPromptTitle;

  /// No description provided for @terminalPinConfirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get terminalPinConfirm;

  /// No description provided for @terminalPinNotSet.
  ///
  /// In en, this message translates to:
  /// **'PIN is not set for this user. Contact the administrator.'**
  String get terminalPinNotSet;

  /// No description provided for @terminalUnclosedSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Unclosed session'**
  String get terminalUnclosedSessionTitle;

  /// No description provided for @terminalUnclosedSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Session started at {startTime}. Enter the end date and time.'**
  String terminalUnclosedSessionMessage(String startTime);

  /// No description provided for @terminalUnclosedSessionEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End date and time'**
  String get terminalUnclosedSessionEndLabel;

  /// No description provided for @terminalUnclosedSessionSelectEnd.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get terminalUnclosedSessionSelectEnd;

  /// No description provided for @terminalUnclosedSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get terminalUnclosedSessionConfirm;

  /// No description provided for @terminalUnclosedSessionErrorEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'End must be after start.'**
  String get terminalUnclosedSessionErrorEndBeforeStart;

  /// No description provided for @terminalUnclosedSessionErrorEndInFuture.
  ///
  /// In en, this message translates to:
  /// **'End cannot be in the future.'**
  String get terminalUnclosedSessionErrorEndInFuture;

  /// No description provided for @terminalUnclosedSessionErrorEndAfterWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'End time cannot exceed working hours.'**
  String get terminalUnclosedSessionErrorEndAfterWorkingHours;

  /// No description provided for @terminalPolicyRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Policy acknowledgment required'**
  String get terminalPolicyRequiredTitle;

  /// No description provided for @terminalPolicyRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'To continue, you must read and acknowledge the Privacy Policy and Terms.'**
  String get terminalPolicyRequiredMessage;

  /// No description provided for @terminalPolicyCheckboxText.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Privacy Policy and Terms'**
  String get terminalPolicyCheckboxText;

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get adminTitle;

  /// No description provided for @adminNavEmployees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get adminNavEmployees;

  /// No description provided for @adminNavSchedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get adminNavSchedules;

  /// No description provided for @adminNavSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get adminNavSessions;

  /// No description provided for @adminNavJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get adminNavJournal;

  /// No description provided for @adminNavReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get adminNavReports;

  /// No description provided for @adminNavSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminNavSettings;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardTitle;

  /// No description provided for @dashboardNavOverview.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardNavOverview;

  /// No description provided for @dashboardNowAtWork.
  ///
  /// In en, this message translates to:
  /// **'Now at work'**
  String get dashboardNowAtWork;

  /// No description provided for @dashboardNoOneAtWork.
  ///
  /// In en, this message translates to:
  /// **'No one at work yet'**
  String get dashboardNoOneAtWork;

  /// No description provided for @dashboardToday.
  ///
  /// In en, this message translates to:
  /// **'All employees for today'**
  String get dashboardToday;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardViewAllSessions.
  ///
  /// In en, this message translates to:
  /// **'All sessions'**
  String get dashboardViewAllSessions;

  /// No description provided for @dashboardNoRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get dashboardNoRecentActivity;

  /// No description provided for @dashboardNoEmployeesToday.
  ///
  /// In en, this message translates to:
  /// **'No employees today'**
  String get dashboardNoEmployeesToday;

  /// No description provided for @adminEnterPinToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN to continue.'**
  String get adminEnterPinToContinue;

  /// No description provided for @adminPinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get adminPinLabel;

  /// No description provided for @adminUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get adminUnlock;

  /// No description provided for @adminInvalidPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN.'**
  String get adminInvalidPin;

  /// No description provided for @adminPinInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'PIN must be digits only and at least 4 digits.'**
  String get adminPinInvalidFormat;

  /// No description provided for @adminDefaultPinHint.
  ///
  /// In en, this message translates to:
  /// **'Default PIN: 0000'**
  String get adminDefaultPinHint;

  /// No description provided for @adminChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get adminChangePin;

  /// No description provided for @adminLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get adminLock;

  /// No description provided for @adminPinUpdated.
  ///
  /// In en, this message translates to:
  /// **'PIN updated.'**
  String get adminPinUpdated;

  /// No description provided for @changePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinTitle;

  /// No description provided for @changePinCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get changePinCurrentPin;

  /// No description provided for @changePinNewPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get changePinNewPin;

  /// No description provided for @changePinConfirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get changePinConfirmNewPin;

  /// No description provided for @changePinNewPinRequired.
  ///
  /// In en, this message translates to:
  /// **'New PIN is required.'**
  String get changePinNewPinRequired;

  /// No description provided for @changePinConfirmationMismatch.
  ///
  /// In en, this message translates to:
  /// **'PIN confirmation does not match.'**
  String get changePinConfirmationMismatch;

  /// No description provided for @changePinCurrentInvalid.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is invalid.'**
  String get changePinCurrentInvalid;

  /// No description provided for @changePinInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'PIN must be digits only and at least 4 digits.'**
  String get changePinInvalidFormat;

  /// No description provided for @employeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employeesTitle;

  /// No description provided for @employeesNoEmployeesYet.
  ///
  /// In en, this message translates to:
  /// **'No employees yet.'**
  String get employeesNoEmployeesYet;

  /// No description provided for @employeesSelectFromList.
  ///
  /// In en, this message translates to:
  /// **'Select an employee from the list.'**
  String get employeesSelectFromList;

  /// No description provided for @employeesAddEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get employeesAddEmployee;

  /// No description provided for @employeesInactiveHiddenHint.
  ///
  /// In en, this message translates to:
  /// **'Inactive employees are hidden in the Terminal.'**
  String get employeesInactiveHiddenHint;

  /// No description provided for @employeeDialogAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add employee'**
  String get employeeDialogAddTitle;

  /// No description provided for @employeeDialogEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit employee'**
  String get employeeDialogEditTitle;

  /// No description provided for @employeeDialogNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New employee'**
  String get employeeDialogNewTitle;

  /// No description provided for @employeeFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get employeeFirstName;

  /// No description provided for @employeeLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get employeeLastName;

  /// No description provided for @employeeDefaultSchedule.
  ///
  /// In en, this message translates to:
  /// **'Default schedule'**
  String get employeeDefaultSchedule;

  /// No description provided for @employeeActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get employeeActiveLabel;

  /// No description provided for @employeeStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get employeeStatusLabel;

  /// No description provided for @employeeStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get employeeStatusActive;

  /// No description provided for @employeeStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get employeeStatusInactive;

  /// No description provided for @employeeStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get employeeStatusArchived;

  /// No description provided for @employeeTerminationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Termination date'**
  String get employeeTerminationDateLabel;

  /// No description provided for @employeeVacationDaysPerYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Vacation days per year'**
  String get employeeVacationDaysPerYearLabel;

  /// No description provided for @employeeSecondaryPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary phone'**
  String get employeeSecondaryPhoneLabel;

  /// No description provided for @employeeStatusChangeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Change status?'**
  String get employeeStatusChangeConfirmTitle;

  /// No description provided for @employeeStatusChangeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Active employees are shown in the Terminal. Inactive and archived employees are not shown.'**
  String get employeeStatusChangeConfirmMessage;

  /// No description provided for @employeeStatusChangeConfirmConfirm.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get employeeStatusChangeConfirmConfirm;

  /// No description provided for @employeeVacationDaysPerYearInvalid.
  ///
  /// In en, this message translates to:
  /// **'Must be 0 or more'**
  String get employeeVacationDaysPerYearInvalid;

  /// No description provided for @employeeTerminationDateBeforeHireError.
  ///
  /// In en, this message translates to:
  /// **'Termination date must be on or after hire date.'**
  String get employeeTerminationDateBeforeHireError;

  /// No description provided for @employeeFirstLastRequired.
  ///
  /// In en, this message translates to:
  /// **'First name and last name are required.'**
  String get employeeFirstLastRequired;

  /// No description provided for @employeeCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create employee: {error}'**
  String employeeCreateFailed(String error);

  /// No description provided for @employeeUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update employee: {error}'**
  String employeeUpdateFailed(String error);

  /// No description provided for @employeeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get employeeSaved;

  /// No description provided for @employeeUnsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get employeeUnsavedChangesTitle;

  /// No description provided for @employeeUnsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Save, discard, or cancel?'**
  String get employeeUnsavedChangesMessage;

  /// No description provided for @employeeDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get employeeDiscardChanges;

  /// No description provided for @employeeDefaultScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default schedule: {name}'**
  String employeeDefaultScheduleSubtitle(String name);

  /// No description provided for @employeeScheduleButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule: {name}'**
  String employeeScheduleButtonLabel(String name);

  /// No description provided for @employeeChangeScheduleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change schedule'**
  String get employeeChangeScheduleTooltip;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// No description provided for @employeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee code'**
  String get employeeCode;

  /// No description provided for @employeeCodeHint.
  ///
  /// In en, this message translates to:
  /// **'E001'**
  String get employeeCodeHint;

  /// No description provided for @employeeCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Employee code is required.'**
  String get employeeCodeRequired;

  /// No description provided for @employeeFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required.'**
  String get employeeFirstNameRequired;

  /// No description provided for @employeeLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required.'**
  String get employeeLastNameRequired;

  /// No description provided for @employeeHireDate.
  ///
  /// In en, this message translates to:
  /// **'Hire date'**
  String get employeeHireDate;

  /// No description provided for @employeeStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get employeeStatus;

  /// No description provided for @employeeRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get employeeRole;

  /// No description provided for @employeeRoleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee / Manager'**
  String get employeeRoleFieldLabel;

  /// No description provided for @employeeUsePin.
  ///
  /// In en, this message translates to:
  /// **'Enable PIN'**
  String get employeeUsePin;

  /// No description provided for @employeeUseNfc.
  ///
  /// In en, this message translates to:
  /// **'Enable NFC'**
  String get employeeUseNfc;

  /// No description provided for @employeeAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get employeeAccessToken;

  /// No description provided for @employeePinStatus.
  ///
  /// In en, this message translates to:
  /// **'PIN Status'**
  String get employeePinStatus;

  /// No description provided for @employeePinStatusWithValue.
  ///
  /// In en, this message translates to:
  /// **'PIN Status: {value}'**
  String employeePinStatusWithValue(String value);

  /// No description provided for @employeeAccessNote.
  ///
  /// In en, this message translates to:
  /// **'Access notes'**
  String get employeeAccessNote;

  /// No description provided for @employeeAccessTokenRequiredWhenNfc.
  ///
  /// In en, this message translates to:
  /// **'Required when NFC enabled.'**
  String get employeeAccessTokenRequiredWhenNfc;

  /// No description provided for @employeeEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment type'**
  String get employeeEmploymentType;

  /// No description provided for @employeeWeeklyHours.
  ///
  /// In en, this message translates to:
  /// **'Weekly hours'**
  String get employeeWeeklyHours;

  /// No description provided for @weeklyHoursShortUnitSuffix.
  ///
  /// In en, this message translates to:
  /// **' h'**
  String get weeklyHoursShortUnitSuffix;

  /// No description provided for @employeeEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get employeeEmail;

  /// No description provided for @employeeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get employeeEmailHint;

  /// No description provided for @employeeEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get employeeEmailInvalid;

  /// No description provided for @employeePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get employeePhone;

  /// No description provided for @employeeDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get employeeDepartment;

  /// No description provided for @employeeJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get employeeJobTitle;

  /// No description provided for @employeeInternalComment.
  ///
  /// In en, this message translates to:
  /// **'Internal Comment'**
  String get employeeInternalComment;

  /// No description provided for @employeePolicyAcknowledged.
  ///
  /// In en, this message translates to:
  /// **'Policy Acknowledged'**
  String get employeePolicyAcknowledged;

  /// No description provided for @employeePolicyAcknowledgedAt.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged At'**
  String get employeePolicyAcknowledgedAt;

  /// No description provided for @employeePolicyAcknowledgedAtWithValue.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged: {value}'**
  String employeePolicyAcknowledgedAtWithValue(String value);

  /// No description provided for @employeeDataRetentionPolicy.
  ///
  /// In en, this message translates to:
  /// **'Data Retention Policy'**
  String get employeeDataRetentionPolicy;

  /// No description provided for @employeeCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get employeeCreatedAt;

  /// No description provided for @employeeCreatedAtWithValue.
  ///
  /// In en, this message translates to:
  /// **'Created: {value}'**
  String employeeCreatedAtWithValue(String value);

  /// No description provided for @employeeUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get employeeUpdatedAt;

  /// No description provided for @employeeUpdatedAtWithValue.
  ///
  /// In en, this message translates to:
  /// **'Updated: {value}'**
  String employeeUpdatedAtWithValue(String value);

  /// No description provided for @employeeCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get employeeCreatedBy;

  /// No description provided for @employeeUpdatedBy.
  ///
  /// In en, this message translates to:
  /// **'Updated By'**
  String get employeeUpdatedBy;

  /// No description provided for @employeePinStatusSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get employeePinStatusSet;

  /// No description provided for @employeePinStatusNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get employeePinStatusNotSet;

  /// No description provided for @employeeRoleEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeRoleEmployee;

  /// No description provided for @employeeRoleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get employeeRoleManager;

  /// No description provided for @employeeEmploymentTypeFullTime.
  ///
  /// In en, this message translates to:
  /// **'Full time'**
  String get employeeEmploymentTypeFullTime;

  /// No description provided for @employeeEmploymentTypePartTime.
  ///
  /// In en, this message translates to:
  /// **'Part time'**
  String get employeeEmploymentTypePartTime;

  /// No description provided for @employeeEmploymentTypeMinijob.
  ///
  /// In en, this message translates to:
  /// **'Minijob'**
  String get employeeEmploymentTypeMinijob;

  /// No description provided for @employeeEmploymentTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get employeeEmploymentTypeCustom;

  /// No description provided for @employeeTerminalAccessDisabled.
  ///
  /// In en, this message translates to:
  /// **'Terminal access disabled'**
  String get employeeTerminalAccessDisabled;

  /// No description provided for @employeeInactive.
  ///
  /// In en, this message translates to:
  /// **'Employee is inactive'**
  String get employeeInactive;

  /// No description provided for @employeeCodeAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Employee code already exists'**
  String get employeeCodeAlreadyExists;

  /// No description provided for @employeePolicyText.
  ///
  /// In en, this message translates to:
  /// **'Employee has acknowledged the Privacy Policy and Terms'**
  String get employeePolicyText;

  /// No description provided for @employeePolicyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Employee has acknowledged the '**
  String get employeePolicyPrefix;

  /// No description provided for @employeePolicyLinkPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get employeePolicyLinkPrivacy;

  /// No description provided for @employeePolicyMiddle.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get employeePolicyMiddle;

  /// No description provided for @employeePolicyLinkTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get employeePolicyLinkTerms;

  /// No description provided for @employeeSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get employeeSetPin;

  /// No description provided for @employeeResetPin.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN'**
  String get employeeResetPin;

  /// No description provided for @employeeFieldLabelWithRequired.
  ///
  /// In en, this message translates to:
  /// **'{label} *'**
  String employeeFieldLabelWithRequired(String label);

  /// No description provided for @employeeSectionIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get employeeSectionIdentity;

  /// No description provided for @employeeSectionBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get employeeSectionBasicInfo;

  /// No description provided for @employeeSectionEmployment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get employeeSectionEmployment;

  /// No description provided for @employeeSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get employeeSectionContact;

  /// No description provided for @employeeSectionAccess.
  ///
  /// In en, this message translates to:
  /// **'Terminal Access'**
  String get employeeSectionAccess;

  /// No description provided for @employeeSectionSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get employeeSectionSchedule;

  /// No description provided for @employeeSectionWorkSetup.
  ///
  /// In en, this message translates to:
  /// **'Work setup'**
  String get employeeSectionWorkSetup;

  /// No description provided for @employeeStartingBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Starting balance (hours)'**
  String get employeeStartingBalanceLabel;

  /// No description provided for @employeeStartingBalanceHint.
  ///
  /// In en, this message translates to:
  /// **'Hours with one decimal. Leave empty if none.'**
  String get employeeStartingBalanceHint;

  /// No description provided for @employeeStartingBalanceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid hours value (one decimal).'**
  String get employeeStartingBalanceInvalid;

  /// No description provided for @employeeScheduleRequired.
  ///
  /// In en, this message translates to:
  /// **'Schedule is required.'**
  String get employeeScheduleRequired;

  /// No description provided for @employeeScheduleTemplateWithWeeklyHours.
  ///
  /// In en, this message translates to:
  /// **'{name} ({hours})'**
  String employeeScheduleTemplateWithWeeklyHours(String name, String hours);

  /// No description provided for @employeeSectionPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy & Compliance'**
  String get employeeSectionPolicy;

  /// No description provided for @employeeSectionAudit.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get employeeSectionAudit;

  /// No description provided for @employeeTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get employeeTabGeneral;

  /// No description provided for @employeeTabContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get employeeTabContact;

  /// No description provided for @employeeTabTerminalAccess.
  ///
  /// In en, this message translates to:
  /// **'Terminal Access'**
  String get employeeTabTerminalAccess;

  /// No description provided for @employeeTabAdditional.
  ///
  /// In en, this message translates to:
  /// **'Additional'**
  String get employeeTabAdditional;

  /// No description provided for @employeeDataPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Data'**
  String get employeeDataPdfTitle;

  /// No description provided for @employeeDataPdfSectionEmployeeInfo.
  ///
  /// In en, this message translates to:
  /// **'Employee Information'**
  String get employeeDataPdfSectionEmployeeInfo;

  /// No description provided for @employeeExportEmployeeData.
  ///
  /// In en, this message translates to:
  /// **'Export employee data'**
  String get employeeExportEmployeeData;

  /// No description provided for @employeeDataPdfExported.
  ///
  /// In en, this message translates to:
  /// **'Employee data exported.'**
  String get employeeDataPdfExported;

  /// No description provided for @employeeMarkForRemovalTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark for removal from active lists'**
  String get employeeMarkForRemovalTooltip;

  /// No description provided for @employeeMarkForRemovalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark for removal from active lists?'**
  String get employeeMarkForRemovalConfirmTitle;

  /// No description provided for @employeeMarkForRemovalConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'The employee will be archived and hidden from active lists and reports. Historical data (sessions, absences) remains available.'**
  String get employeeMarkForRemovalConfirmMessage;

  /// No description provided for @employeeMarkForRemovalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get employeeMarkForRemovalConfirm;

  /// No description provided for @employeeMarkForRemovalSuccess.
  ///
  /// In en, this message translates to:
  /// **'Employee removed from active lists.'**
  String get employeeMarkForRemovalSuccess;

  /// No description provided for @employeeDataPdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export employee data: {error}'**
  String employeeDataPdfFailed(String error);

  /// No description provided for @employeeDataPdfAdminOnly.
  ///
  /// In en, this message translates to:
  /// **'Export is available only in admin mode.'**
  String get employeeDataPdfAdminOnly;

  /// No description provided for @schedulesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Create a schedule template.'**
  String get schedulesEmptyHint;

  /// No description provided for @schedulesFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load schedules: {error}'**
  String schedulesFailedLoad(String error);

  /// No description provided for @schedulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedulesTitle;

  /// No description provided for @schedulesAddTemplateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add template'**
  String get schedulesAddTemplateTooltip;

  /// No description provided for @schedulesNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates.'**
  String get schedulesNoTemplates;

  /// No description provided for @schedulesCreateTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get schedulesCreateTemplateTitle;

  /// No description provided for @schedulesRenameTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename template'**
  String get schedulesRenameTemplateTitle;

  /// No description provided for @schedulesTemplateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get schedulesTemplateNameLabel;

  /// No description provided for @schedulesWeekEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Week editor'**
  String get schedulesWeekEditorTitle;

  /// No description provided for @schedulesFailedLoadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Failed to load template: {error}'**
  String schedulesFailedLoadTemplate(String error);

  /// No description provided for @schedulesDayOff.
  ///
  /// In en, this message translates to:
  /// **'Day off'**
  String get schedulesDayOff;

  /// No description provided for @schedulesNoIntervals.
  ///
  /// In en, this message translates to:
  /// **'No intervals.'**
  String get schedulesNoIntervals;

  /// No description provided for @schedulesAddInterval.
  ///
  /// In en, this message translates to:
  /// **'Add interval'**
  String get schedulesAddInterval;

  /// No description provided for @schedulesSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get schedulesSaved;

  /// No description provided for @schedulesCopiedTo.
  ///
  /// In en, this message translates to:
  /// **'Copied to {weekday}.'**
  String schedulesCopiedTo(String weekday);

  /// No description provided for @schedulesInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input.'**
  String get schedulesInvalidInput;

  /// No description provided for @schedulesBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Admin / Schedules'**
  String get schedulesBreadcrumb;

  /// No description provided for @schedulesNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'New schedule'**
  String get schedulesNewSchedule;

  /// No description provided for @schedulesEditIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit interval'**
  String get schedulesEditIntervalTitle;

  /// No description provided for @schedulesAddIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add interval'**
  String get schedulesAddIntervalTitle;

  /// No description provided for @schedulesStartTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get schedulesStartTimeLabel;

  /// No description provided for @schedulesEndTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get schedulesEndTimeLabel;

  /// No description provided for @schedulesDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get schedulesDiscardChanges;

  /// No description provided for @schedulesUnsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get schedulesUnsavedChangesTitle;

  /// No description provided for @schedulesUnsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Save, discard, or cancel?'**
  String get schedulesUnsavedChangesMessage;

  /// No description provided for @schedulesSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {reason}'**
  String schedulesSaveFailed(String reason);

  /// No description provided for @schedulesTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Total {hours}h'**
  String schedulesTotalHours(String hours);

  /// No description provided for @schedulesIntervalOverlapError.
  ///
  /// In en, this message translates to:
  /// **'This interval overlaps with another.'**
  String get schedulesIntervalOverlapError;

  /// No description provided for @schedulesIntervalEndBeforeStartError.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get schedulesIntervalEndBeforeStartError;

  /// No description provided for @schedulesScheduleActiveSuffix.
  ///
  /// In en, this message translates to:
  /// **' (Active)'**
  String get schedulesScheduleActiveSuffix;

  /// No description provided for @schedulesScheduleInactiveSuffix.
  ///
  /// In en, this message translates to:
  /// **' (Inactive)'**
  String get schedulesScheduleInactiveSuffix;

  /// No description provided for @schedulesRenameScheduleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rename schedule'**
  String get schedulesRenameScheduleTooltip;

  /// No description provided for @schedulesNameAlreadyExistsError.
  ///
  /// In en, this message translates to:
  /// **'Name already exists.'**
  String get schedulesNameAlreadyExistsError;

  /// No description provided for @schedulesNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get schedulesNameRequiredError;

  /// No description provided for @schedulesDeleteScheduleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get schedulesDeleteScheduleTooltip;

  /// No description provided for @schedulesDeleteScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule?'**
  String get schedulesDeleteScheduleTitle;

  /// No description provided for @schedulesDeleteScheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove the schedule template. Employees assigned to it will have no default schedule.'**
  String get schedulesDeleteScheduleMessage;

  /// No description provided for @schedulesDeleteScheduleButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get schedulesDeleteScheduleButton;

  /// No description provided for @schedulesDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete: {reason}'**
  String schedulesDeleteFailed(String reason);

  /// No description provided for @schedulesDeleteBlockedAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete'**
  String get schedulesDeleteBlockedAssignedTitle;

  /// No description provided for @schedulesDeleteBlockedAssignedMessage.
  ///
  /// In en, this message translates to:
  /// **'This schedule is assigned to employees. Unassign it before deleting.'**
  String get schedulesDeleteBlockedAssignedMessage;

  /// No description provided for @schedulesRosterPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Work schedule roster'**
  String get schedulesRosterPdfTitle;

  /// No description provided for @schedulesRosterPdfExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export schedule roster (PDF)'**
  String get schedulesRosterPdfExportTooltip;

  /// No description provided for @schedulesRosterPdfColumnEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get schedulesRosterPdfColumnEmployee;

  /// No description provided for @schedulesRosterPdfColumnWeeklyHours.
  ///
  /// In en, this message translates to:
  /// **'Weekly hours'**
  String get schedulesRosterPdfColumnWeeklyHours;

  /// No description provided for @schedulesRosterPdfExported.
  ///
  /// In en, this message translates to:
  /// **'Exported.'**
  String get schedulesRosterPdfExported;

  /// No description provided for @schedulesRosterPdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export schedule roster: {error}'**
  String schedulesRosterPdfFailed(String error);

  /// No description provided for @intervalStart.
  ///
  /// In en, this message translates to:
  /// **'Start: {time}'**
  String intervalStart(String time);

  /// No description provided for @intervalEnd.
  ///
  /// In en, this message translates to:
  /// **'End: {time}'**
  String intervalEnd(String time);

  /// No description provided for @intervalRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get intervalRemoveTooltip;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get settingsLanguageRussian;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeHighContrastLight.
  ///
  /// In en, this message translates to:
  /// **'High contrast (light)'**
  String get settingsThemeHighContrastLight;

  /// No description provided for @settingsThemeHighContrastDark.
  ///
  /// In en, this message translates to:
  /// **'High contrast (dark)'**
  String get settingsThemeHighContrastDark;

  /// No description provided for @settingsAttendanceModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Attendance mode'**
  String get settingsAttendanceModeLabel;

  /// No description provided for @settingsAttendanceModeFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get settingsAttendanceModeFlexible;

  /// No description provided for @settingsAttendanceModeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get settingsAttendanceModeFixed;

  /// No description provided for @settingsAttendanceToleranceLabel.
  ///
  /// In en, this message translates to:
  /// **'Tolerance (minutes)'**
  String get settingsAttendanceToleranceLabel;

  /// No description provided for @settingsAttendanceModeChangeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Change attendance mode?'**
  String get settingsAttendanceModeChangeConfirmTitle;

  /// No description provided for @settingsAttendanceModeChangeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This affects terminal check-in and check-out behavior for all employees.'**
  String get settingsAttendanceModeChangeConfirmMessage;

  /// No description provided for @settingsWorkingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Allowed working time'**
  String get settingsWorkingHoursLabel;

  /// No description provided for @settingsWorkingHoursFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get settingsWorkingHoursFrom;

  /// No description provided for @settingsWorkingHoursTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get settingsWorkingHoursTo;

  /// No description provided for @settingsWorkingHoursInvalidRange.
  ///
  /// In en, this message translates to:
  /// **'From must be before To'**
  String get settingsWorkingHoursInvalidRange;

  /// No description provided for @settingsWorkingHoursFromWithValue.
  ///
  /// In en, this message translates to:
  /// **'From: {value}'**
  String settingsWorkingHoursFromWithValue(String value);

  /// No description provided for @settingsWorkingHoursToWithValue.
  ///
  /// In en, this message translates to:
  /// **'To: {value}'**
  String settingsWorkingHoursToWithValue(String value);

  /// No description provided for @settingsTrackingStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracking start date'**
  String get settingsTrackingStartDateLabel;

  /// No description provided for @settingsTrackingStartDateHelp.
  ///
  /// In en, this message translates to:
  /// **'Data analysis starts from this date. Earlier entries are not included in reports.'**
  String get settingsTrackingStartDateHelp;

  /// No description provided for @settingsTrackingStartDateUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsTrackingStartDateUnset;

  /// No description provided for @settingsTrackingStartDateClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsTrackingStartDateClear;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsCreateBackup.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get settingsCreateBackup;

  /// No description provided for @settingsBackupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created: {path}'**
  String settingsBackupCreated(String path);

  /// No description provided for @settingsBackupSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully'**
  String get settingsBackupSuccessTitle;

  /// No description provided for @settingsRestoreCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Database restored'**
  String get settingsRestoreCompletedTitle;

  /// No description provided for @settingsRestoreCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'The database was restored from a backup. Press OK to continue.'**
  String get settingsRestoreCompletedMessage;

  /// No description provided for @settingsBackupErrorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Cannot access the file or folder.'**
  String get settingsBackupErrorPermissionDenied;

  /// No description provided for @settingsBackupErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'File or folder not found.'**
  String get settingsBackupErrorNotFound;

  /// No description provided for @settingsBackupErrorInvalidArchive.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file.'**
  String get settingsBackupErrorInvalidArchive;

  /// No description provided for @settingsBackupErrorIoFailure.
  ///
  /// In en, this message translates to:
  /// **'A file operation failed.'**
  String get settingsBackupErrorIoFailure;

  /// No description provided for @settingsBackupErrorDbFailure.
  ///
  /// In en, this message translates to:
  /// **'Database error.'**
  String get settingsBackupErrorDbFailure;

  /// No description provided for @settingsBackupErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get settingsBackupErrorUnknown;

  /// No description provided for @settingsRestoreFromBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get settingsRestoreFromBackup;

  /// No description provided for @settingsRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get settingsRestoreConfirmTitle;

  /// No description provided for @settingsRestoreConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Current data will be completely replaced by data from the selected file. Continue?'**
  String get settingsRestoreConfirmMessage;

  /// No description provided for @settingsRestoreCreated.
  ///
  /// In en, this message translates to:
  /// **'Restore complete. Refresh the screen if needed.'**
  String get settingsRestoreCreated;

  /// No description provided for @settingsRestoreScheduledRestart.
  ///
  /// In en, this message translates to:
  /// **'Restore scheduled. Please restart the application to complete.'**
  String get settingsRestoreScheduledRestart;

  /// No description provided for @settingsRestoreErrorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Cannot access the file or folder.'**
  String get settingsRestoreErrorPermissionDenied;

  /// No description provided for @settingsRestoreErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'File or folder not found.'**
  String get settingsRestoreErrorNotFound;

  /// No description provided for @settingsRestoreErrorInvalidArchive.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file.'**
  String get settingsRestoreErrorInvalidArchive;

  /// No description provided for @settingsRestoreErrorIoFailure.
  ///
  /// In en, this message translates to:
  /// **'A file operation failed.'**
  String get settingsRestoreErrorIoFailure;

  /// No description provided for @settingsRestoreErrorDbFailure.
  ///
  /// In en, this message translates to:
  /// **'Database error.'**
  String get settingsRestoreErrorDbFailure;

  /// No description provided for @settingsRestoreErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get settingsRestoreErrorUnknown;

  /// No description provided for @settingsRestoreSchemaError.
  ///
  /// In en, this message translates to:
  /// **'File was created in another app version. Restore is not possible.'**
  String get settingsRestoreSchemaError;

  /// No description provided for @settingsExportDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Export diagnostics'**
  String get settingsExportDiagnostics;

  /// No description provided for @settingsExportDiagnosticsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics exported successfully'**
  String get settingsExportDiagnosticsSuccess;

  /// No description provided for @settingsExportDiagnosticsFailed.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics export failed: {error}'**
  String settingsExportDiagnosticsFailed(String error);

  /// No description provided for @legalTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms / Disclaimer'**
  String get legalTerms;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @legalNoticeWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get legalNoticeWelcomeTitle;

  /// No description provided for @legalNoticeWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Please review Privacy Policy and Terms.'**
  String get legalNoticeWelcomeText;

  /// No description provided for @legalNoticeOpenPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Open Privacy Policy'**
  String get legalNoticeOpenPrivacy;

  /// No description provided for @legalNoticeOpenTerms.
  ///
  /// In en, this message translates to:
  /// **'Open Terms'**
  String get legalNoticeOpenTerms;

  /// No description provided for @legalNoticeClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get legalNoticeClose;

  /// No description provided for @legalCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get legalCopy;

  /// No description provided for @legalCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard.'**
  String get legalCopiedToClipboard;

  /// No description provided for @legalFailedToCopy.
  ///
  /// In en, this message translates to:
  /// **'Failed to copy.'**
  String get legalFailedToCopy;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @sessionsEmployeeFilter.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get sessionsEmployeeFilter;

  /// No description provided for @sessionsEmployeeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get sessionsEmployeeAll;

  /// No description provided for @sessionsNoEmployeesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No employees available.'**
  String get sessionsNoEmployeesAvailable;

  /// No description provided for @sessionsFailedLoadEmployees.
  ///
  /// In en, this message translates to:
  /// **'Failed to load employees: {error}'**
  String sessionsFailedLoadEmployees(String error);

  /// No description provided for @sessionsFilterFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get sessionsFilterFrom;

  /// No description provided for @sessionsFilterTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get sessionsFilterTo;

  /// No description provided for @sessionsFilterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get sessionsFilterAny;

  /// No description provided for @sessionsNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions.'**
  String get sessionsNoSessions;

  /// No description provided for @sessionsFailedLoadSessions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load sessions: {error}'**
  String sessionsFailedLoadSessions(String error);

  /// No description provided for @sessionsTableEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get sessionsTableEmployee;

  /// No description provided for @sessionsTableStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get sessionsTableStart;

  /// No description provided for @sessionsTableEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get sessionsTableEnd;

  /// No description provided for @sessionsTableDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sessionsTableDuration;

  /// No description provided for @sessionsDurationWithValue.
  ///
  /// In en, this message translates to:
  /// **'Duration: {value}'**
  String sessionsDurationWithValue(String value);

  /// No description provided for @sessionsTableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sessionsTableStatus;

  /// No description provided for @sessionsTableNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get sessionsTableNote;

  /// No description provided for @sessionsTableActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get sessionsTableActions;

  /// No description provided for @sessionsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sessionsEdit;

  /// No description provided for @sessionsEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get sessionsEditDialogTitle;

  /// No description provided for @sessionsEmployeePrefix.
  ///
  /// In en, this message translates to:
  /// **'Employee: {name}'**
  String sessionsEmployeePrefix(String name);

  /// No description provided for @sessionsStartPrefix.
  ///
  /// In en, this message translates to:
  /// **'Start: {value}'**
  String sessionsStartPrefix(String value);

  /// No description provided for @sessionsEndPrefix.
  ///
  /// In en, this message translates to:
  /// **'End: {value}'**
  String sessionsEndPrefix(String value);

  /// No description provided for @sessionsOpenSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Open session (end is empty)'**
  String get sessionsOpenSessionLabel;

  /// No description provided for @sessionsSetEndNow.
  ///
  /// In en, this message translates to:
  /// **'Set end = now'**
  String get sessionsSetEndNow;

  /// No description provided for @sessionsClearEnd.
  ///
  /// In en, this message translates to:
  /// **'Clear end'**
  String get sessionsClearEnd;

  /// No description provided for @sessionsUpdateReason.
  ///
  /// In en, this message translates to:
  /// **'Update reason'**
  String get sessionsUpdateReason;

  /// No description provided for @sessionsEmployeeCannotChangeHint.
  ///
  /// In en, this message translates to:
  /// **'Employee cannot be changed.'**
  String get sessionsEmployeeCannotChangeHint;

  /// No description provided for @sessionsUpdateReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Update reason is required.'**
  String get sessionsUpdateReasonRequired;

  /// No description provided for @sessionsErrorSameDayRequired.
  ///
  /// In en, this message translates to:
  /// **'Session must start and end on the same day.'**
  String get sessionsErrorSameDayRequired;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalFilterFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get journalFilterFrom;

  /// No description provided for @journalFilterTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get journalFilterTo;

  /// No description provided for @journalFilterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get journalFilterAny;

  /// No description provided for @journalFilterStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get journalFilterStatusAll;

  /// No description provided for @journalFilterStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get journalFilterStatusOpen;

  /// No description provided for @journalFilterStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get journalFilterStatusClosed;

  /// No description provided for @journalFilterStatusNotClosed.
  ///
  /// In en, this message translates to:
  /// **'Not closed'**
  String get journalFilterStatusNotClosed;

  /// No description provided for @journalFilterSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get journalFilterSearch;

  /// No description provided for @journalFilterEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get journalFilterEmployee;

  /// No description provided for @journalScopeDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get journalScopeDay;

  /// No description provided for @journalScopeWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get journalScopeWeek;

  /// No description provided for @journalScopeMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get journalScopeMonth;

  /// No description provided for @journalScopeInterval.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get journalScopeInterval;

  /// No description provided for @journalPresetToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get journalPresetToday;

  /// No description provided for @journalPresetWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get journalPresetWeek;

  /// No description provided for @journalPresetMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get journalPresetMonth;

  /// No description provided for @journalPresetLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get journalPresetLastMonth;

  /// No description provided for @journalEndEmpty.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get journalEndEmpty;

  /// No description provided for @journalEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get journalEditDialogTitle;

  /// No description provided for @journalCloseNow.
  ///
  /// In en, this message translates to:
  /// **'Close now'**
  String get journalCloseNow;

  /// No description provided for @journalErrorEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time.'**
  String get journalErrorEndBeforeStart;

  /// No description provided for @journalErrorCrossDay.
  ///
  /// In en, this message translates to:
  /// **'Start and end must be on the same day.'**
  String get journalErrorCrossDay;

  /// No description provided for @journalErrorOutsideEmployment.
  ///
  /// In en, this message translates to:
  /// **'Session dates must fall within the employee\'s employment period.'**
  String get journalErrorOutsideEmployment;

  /// No description provided for @journalUpdateReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Required when changing start or end time'**
  String get journalUpdateReasonHint;

  /// No description provided for @journalSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get journalSaved;

  /// No description provided for @sessionsCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this work session?'**
  String get sessionsCancelConfirmTitle;

  /// No description provided for @sessionsCancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The session will be excluded from totals and reports. It will remain visible in the journal table.'**
  String get sessionsCancelConfirmBody;

  /// No description provided for @sessionsCancelWorkSession.
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get sessionsCancelWorkSession;

  /// No description provided for @sessionsCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Session canceled.'**
  String get sessionsCancelSuccess;

  /// No description provided for @sessionStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get sessionStatusCanceled;

  /// No description provided for @sessionsEditDisabledCanceled.
  ///
  /// In en, this message translates to:
  /// **'Editing is disabled for canceled sessions'**
  String get sessionsEditDisabledCanceled;

  /// No description provided for @sessionsEditCanceledError.
  ///
  /// In en, this message translates to:
  /// **'Canceled sessions cannot be edited.'**
  String get sessionsEditCanceledError;

  /// No description provided for @sessionsCancelNotClosedError.
  ///
  /// In en, this message translates to:
  /// **'Only closed sessions can be canceled.'**
  String get sessionsCancelNotClosedError;

  /// No description provided for @sessionsCancelAlreadyCanceledError.
  ///
  /// In en, this message translates to:
  /// **'This session is already canceled.'**
  String get sessionsCancelAlreadyCanceledError;

  /// No description provided for @sessionsCancelNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'Session not found.'**
  String get sessionsCancelNotFoundError;

  /// No description provided for @journalViewTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get journalViewTable;

  /// No description provided for @journalViewTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get journalViewTimeline;

  /// No description provided for @journalViewDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get journalViewDetailed;

  /// No description provided for @journalIntervalLegendWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get journalIntervalLegendWork;

  /// No description provided for @journalIntervalLegendApprovedAbsence.
  ///
  /// In en, this message translates to:
  /// **'Approved absence'**
  String get journalIntervalLegendApprovedAbsence;

  /// No description provided for @journalIntervalLegendOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get journalIntervalLegendOngoing;

  /// No description provided for @journalTimelineStateOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing work'**
  String get journalTimelineStateOngoing;

  /// No description provided for @journalTimelineStatePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get journalTimelineStatePresent;

  /// No description provided for @journalTimelineStateApprovedAbsence.
  ///
  /// In en, this message translates to:
  /// **'Approved absence'**
  String get journalTimelineStateApprovedAbsence;

  /// No description provided for @journalTimelineStateExpectedNoShow.
  ///
  /// In en, this message translates to:
  /// **'Expected but no attendance'**
  String get journalTimelineStateExpectedNoShow;

  /// No description provided for @journalTimelineStateNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get journalTimelineStateNoData;

  /// No description provided for @journalTimelinePickRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a date range for timeline view.'**
  String get journalTimelinePickRangeHint;

  /// No description provided for @journalNavPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get journalNavPrev;

  /// No description provided for @journalNavNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get journalNavNext;

  /// No description provided for @journalIntervalNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get journalIntervalNow;

  /// No description provided for @journalIntervalDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String journalIntervalDurationMinutes(int minutes);

  /// No description provided for @durationHm.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHm(int hours, int minutes);

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data.'**
  String get reportsNoData;

  /// No description provided for @reportsFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load report: {error}'**
  String reportsFailedLoad(String error);

  /// No description provided for @reportsOnlyClosedHint.
  ///
  /// In en, this message translates to:
  /// **'Only CLOSED sessions are included in totals.'**
  String get reportsOnlyClosedHint;

  /// No description provided for @reportsTableEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get reportsTableEmployee;

  /// No description provided for @reportsTableTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reportsTableTotal;

  /// No description provided for @reportsTableNorm.
  ///
  /// In en, this message translates to:
  /// **'Norm'**
  String get reportsTableNorm;

  /// No description provided for @reportsTableDelta.
  ///
  /// In en, this message translates to:
  /// **'Delta'**
  String get reportsTableDelta;

  /// No description provided for @reportsTableSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get reportsTableSessions;

  /// No description provided for @reportsExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get reportsExportPdf;

  /// No description provided for @reportsPdfFileType.
  ///
  /// In en, this message translates to:
  /// **'PDF files'**
  String get reportsPdfFileType;

  /// No description provided for @reportsExported.
  ///
  /// In en, this message translates to:
  /// **'Exported.'**
  String get reportsExported;

  /// No description provided for @reportsTableWorked.
  ///
  /// In en, this message translates to:
  /// **'Worked'**
  String get reportsTableWorked;

  /// No description provided for @reportsTablePlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get reportsTablePlanned;

  /// No description provided for @reportsTableBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance (+/−)'**
  String get reportsTableBalance;

  /// No description provided for @reportsPlannedNoSchedule.
  ///
  /// In en, this message translates to:
  /// **'No schedule'**
  String get reportsPlannedNoSchedule;

  /// No description provided for @reportsPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get reportsPeriodLabel;

  /// No description provided for @reportsPeriodPresetToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reportsPeriodPresetToday;

  /// No description provided for @reportsPeriodPresetWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get reportsPeriodPresetWeek;

  /// No description provided for @reportsPeriodPresetMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportsPeriodPresetMonth;

  /// No description provided for @reportsPeriodPresetLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get reportsPeriodPresetLastMonth;

  /// No description provided for @reportsPeriodPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reportsPeriodPresetCustom;

  /// No description provided for @reportsEmployeeFilter.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get reportsEmployeeFilter;

  /// No description provided for @reportsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get reportsDetailsTitle;

  /// No description provided for @reportsExportEmployeePdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get reportsExportEmployeePdf;

  /// No description provided for @reportsDetailsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get reportsDetailsClose;

  /// No description provided for @reportsTableDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reportsTableDate;

  /// No description provided for @reportsPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Time report'**
  String get reportsPdfTitle;

  /// No description provided for @reportsPdfStartingBalance.
  ///
  /// In en, this message translates to:
  /// **'Starting balance'**
  String get reportsPdfStartingBalance;

  /// No description provided for @reportsPdfPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: {from} — {to}'**
  String reportsPdfPeriod(String from, String to);

  /// No description provided for @reportsPdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated: {datetime}'**
  String reportsPdfGenerated(String datetime);

  /// No description provided for @reportsPdfEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee: {name}'**
  String reportsPdfEmployee(String name);

  /// No description provided for @reportsPdfSort.
  ///
  /// In en, this message translates to:
  /// **'Sort: {column}'**
  String reportsPdfSort(String column);

  /// No description provided for @reportsPdfFooterBrand.
  ///
  /// In en, this message translates to:
  /// **'Timerevo — offline report'**
  String get reportsPdfFooterBrand;

  /// No description provided for @reportsPdfFooterPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} / {total}'**
  String reportsPdfFooterPage(int current, int total);

  /// No description provided for @adminNavAbsences.
  ///
  /// In en, this message translates to:
  /// **'Absences'**
  String get adminNavAbsences;

  /// No description provided for @absencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Absences'**
  String get absencesTitle;

  /// No description provided for @absencesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add absence'**
  String get absencesAdd;

  /// No description provided for @absencesEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get absencesEmployee;

  /// No description provided for @absencesType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get absencesType;

  /// No description provided for @absencesDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get absencesDateFrom;

  /// No description provided for @absencesDateTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get absencesDateTo;

  /// No description provided for @absencesStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get absencesStatus;

  /// No description provided for @absencesCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get absencesCreatedBy;

  /// No description provided for @absencesActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get absencesActions;

  /// No description provided for @absenceTypeVacation.
  ///
  /// In en, this message translates to:
  /// **'Annual leave'**
  String get absenceTypeVacation;

  /// No description provided for @absenceTypeSickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick leave'**
  String get absenceTypeSickLeave;

  /// No description provided for @absenceTypeUnpaidLeave.
  ///
  /// In en, this message translates to:
  /// **'Unpaid leave'**
  String get absenceTypeUnpaidLeave;

  /// No description provided for @absenceTypeParentalLeave.
  ///
  /// In en, this message translates to:
  /// **'Parental leave'**
  String get absenceTypeParentalLeave;

  /// No description provided for @absenceTypeStudyLeave.
  ///
  /// In en, this message translates to:
  /// **'Study leave'**
  String get absenceTypeStudyLeave;

  /// No description provided for @absenceTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get absenceTypeOther;

  /// No description provided for @absenceStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get absenceStatusPending;

  /// No description provided for @absenceStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get absenceStatusApproved;

  /// No description provided for @absenceStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get absenceStatusRejected;

  /// No description provided for @absenceApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get absenceApprove;

  /// No description provided for @absenceReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get absenceReject;

  /// No description provided for @absenceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get absenceEdit;

  /// No description provided for @absenceDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get absenceDelete;

  /// No description provided for @absenceRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Reject reason'**
  String get absenceRejectReason;

  /// No description provided for @terminalMyCalendar.
  ///
  /// In en, this message translates to:
  /// **'My work calendar'**
  String get terminalMyCalendar;

  /// No description provided for @terminalMyPdf.
  ///
  /// In en, this message translates to:
  /// **'Time report (PDF)'**
  String get terminalMyPdf;

  /// No description provided for @terminalCalendarPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Work calendar ({name})'**
  String terminalCalendarPageTitle(String name);

  /// No description provided for @terminalCalendarSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get terminalCalendarSessions;

  /// No description provided for @terminalCalendarAbsences.
  ///
  /// In en, this message translates to:
  /// **'Absences'**
  String get terminalCalendarAbsences;

  /// No description provided for @terminalCalendarNoData.
  ///
  /// In en, this message translates to:
  /// **'No data for this day'**
  String get terminalCalendarNoData;

  /// No description provided for @terminalCalendarNewAbsence.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get terminalCalendarNewAbsence;

  /// No description provided for @terminalCalendarFormatMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get terminalCalendarFormatMonth;

  /// No description provided for @terminalCalendarFormatTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get terminalCalendarFormatTwoWeeks;

  /// No description provided for @terminalCalendarFormatWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get terminalCalendarFormatWeek;

  /// No description provided for @absenceCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New absence request'**
  String get absenceCreateTitle;

  /// No description provided for @absenceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit absence'**
  String get absenceEditTitle;

  /// No description provided for @absenceErrorOverlap.
  ///
  /// In en, this message translates to:
  /// **'Overlap with existing absence.'**
  String get absenceErrorOverlap;

  /// No description provided for @absenceErrorDateRestrictionVacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation must start today or later.'**
  String get absenceErrorDateRestrictionVacation;

  /// No description provided for @absenceErrorDateRestrictionSickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick leave cannot start more than 3 days ago.'**
  String get absenceErrorDateRestrictionSickLeave;

  /// No description provided for @absenceErrorOutsideEmployment.
  ///
  /// In en, this message translates to:
  /// **'Absence must be within employee employment period (from hire date to termination date).'**
  String get absenceErrorOutsideEmployment;

  /// No description provided for @absencesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No absences.'**
  String get absencesEmpty;

  /// No description provided for @absencesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No absences yet. Create your first request.'**
  String get absencesEmptyHint;

  /// No description provided for @absenceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this absence request?'**
  String get absenceDeleteConfirm;

  /// No description provided for @absenceApproveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Approve this absence request?'**
  String get absenceApproveConfirm;

  /// No description provided for @absenceRejectConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'The employee will see the reject reason.'**
  String get absenceRejectConfirmHint;

  /// No description provided for @absenceCreated.
  ///
  /// In en, this message translates to:
  /// **'Absence request created.'**
  String get absenceCreated;

  /// No description provided for @absenceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Absence request updated.'**
  String get absenceUpdated;

  /// No description provided for @absenceApproved.
  ///
  /// In en, this message translates to:
  /// **'Absence request approved.'**
  String get absenceApproved;

  /// No description provided for @absenceRejected.
  ///
  /// In en, this message translates to:
  /// **'Absence request rejected.'**
  String get absenceRejected;

  /// No description provided for @absenceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Absence request deleted.'**
  String get absenceDeleted;

  /// No description provided for @absencesApprovedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved by'**
  String get absencesApprovedBy;

  /// No description provided for @absencesApprovedAt.
  ///
  /// In en, this message translates to:
  /// **'Approved at'**
  String get absencesApprovedAt;

  /// No description provided for @absenceErrorEditPendingOnly.
  ///
  /// In en, this message translates to:
  /// **'Can only edit pending absences.'**
  String get absenceErrorEditPendingOnly;

  /// No description provided for @absenceErrorDeletePendingOnly.
  ///
  /// In en, this message translates to:
  /// **'Can only delete pending absences.'**
  String get absenceErrorDeletePendingOnly;

  /// No description provided for @absenceErrorApproveRejectPendingOnly.
  ///
  /// In en, this message translates to:
  /// **'Can only approve or reject pending absences.'**
  String get absenceErrorApproveRejectPendingOnly;

  /// No description provided for @absenceErrorRejectReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reject reason is required.'**
  String get absenceErrorRejectReasonRequired;

  /// No description provided for @absenceErrorDateOrder.
  ///
  /// In en, this message translates to:
  /// **'End date must be on or after start date.'**
  String get absenceErrorDateOrder;

  /// No description provided for @absenceErrorEmployeeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select an employee.'**
  String get absenceErrorEmployeeRequired;

  /// No description provided for @absenceErrorDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select From and To dates.'**
  String get absenceErrorDateRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
