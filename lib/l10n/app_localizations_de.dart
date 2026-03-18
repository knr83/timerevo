// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Zeiterfassung';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonOngoing => 'Läuft';

  @override
  String get commonNotAvailable => 'k. A.';

  @override
  String get commonCreate => 'Erstellen';

  @override
  String get commonRename => 'Umbenennen';

  @override
  String get commonActivate => 'Aktivieren';

  @override
  String get commonDeactivate => 'Deaktivieren';

  @override
  String get commonActive => 'Aktiv';

  @override
  String get commonInactive => 'Inaktiv';

  @override
  String get commonNone => 'Keine';

  @override
  String get commonUnknown => 'Unbekannt';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonRemove => 'Entfernen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonErrorOccurred => 'Ein Fehler ist aufgetreten.';

  @override
  String get commonRequiredFieldsLegend => '* Pflichtfelder';

  @override
  String commonFilterLabelWithValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String initFailed(String error) {
    return 'Initialisierung fehlgeschlagen: $error';
  }

  @override
  String get initFailedGeneric =>
      'Initialisierung fehlgeschlagen. Bitte erneut versuchen oder neu installieren.';

  @override
  String get initDbErrorTitle => 'Datenbankfehler';

  @override
  String get initDbErrorMessage =>
      'Die Datenbank konnte nicht geöffnet werden. Stellen Sie aus einem Backup wieder her oder initialisieren Sie neu.';

  @override
  String get initDbErrorRestore => 'Aus Backup wiederherstellen';

  @override
  String get initDbErrorReinitialize =>
      'Neu initialisieren (verloren alle lokalen Daten)';

  @override
  String get initDbErrorRetry => 'Wiederholen';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalAdmin => 'Verwaltung';

  @override
  String get terminalNoActiveEmployees => 'Keine aktiven Mitarbeiter.';

  @override
  String terminalFailedLoadEmployees(String error) {
    return 'Mitarbeiter konnten nicht geladen werden: $error';
  }

  @override
  String get terminalNoOpenSession => 'Keine offene Schicht.';

  @override
  String get terminalStatusOnShift => 'Im Dienst';

  @override
  String terminalOnShiftSince(String time) {
    return 'seit $time';
  }

  @override
  String get terminalStatusReady => 'Bereit zur Stemplung';

  @override
  String terminalCurrentTime(String time) {
    return 'Jetzt $time';
  }

  @override
  String get terminalSwitchEmployee => 'Mitarbeiter wechseln';

  @override
  String get terminalSessionsToday => 'Heute';

  @override
  String get terminalSessionInProgress => 'läuft';

  @override
  String terminalSessionRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get terminalNoSessionsToday => 'Keine Schichten heute';

  @override
  String get terminalDurationLessThanOneMin => '< 1 Min.';

  @override
  String terminalDurationMinutesOnly(int m) {
    return '$m Min.';
  }

  @override
  String terminalDurationHoursOnly(int h) {
    return '$h Std.';
  }

  @override
  String terminalShowMoreSessions(int count) {
    return '$count weitere anzeigen';
  }

  @override
  String get terminalTotalToday => 'Gesamt heute';

  @override
  String terminalTotalTodayWithValue(String value) {
    return 'Gesamt heute: $value';
  }

  @override
  String get terminalErrorSessionAlreadyOpen =>
      'Es gibt bereits eine offene Schicht.';

  @override
  String get terminalErrorNoOpenSession => 'Keine offene Schicht.';

  @override
  String get terminalErrorClockInBeforeStart =>
      'Kommen vor Arbeitsbeginn nicht möglich.';

  @override
  String get terminalErrorClockInAfterEnd =>
      'Kommen nach Arbeitsende nicht möglich.';

  @override
  String get terminalErrorHasApprovedAbsence =>
      'Sie haben heute eine genehmigte Abwesenheit. Antreten ist nicht möglich.';

  @override
  String get terminalErrorNoScheduleForDay => 'Heute keine Arbeit geplant.';

  @override
  String get terminalErrorAttendanceUnavailable =>
      'Einstellungen zur Anwesenheit konnten nicht geladen werden.';

  @override
  String get terminalNoteRequiredTitle => 'Notiz erforderlich';

  @override
  String get terminalNoteRequiredMessage =>
      'Für diese Abweichung ist eine Notiz erforderlich.';

  @override
  String get terminalNoteReasonLateArrival => 'Grund: Später Antritt';

  @override
  String get terminalNoteReasonEarlyDeparture => 'Grund: Früher Austritt';

  @override
  String get terminalNoteReasonLateDeparture => 'Grund: Später Austritt';

  @override
  String get terminalNoteLabel => 'Notiz';

  @override
  String get terminalNoteConfirm => 'Bestätigen';

  @override
  String get terminalNoteCancel => 'Abbrechen';

  @override
  String terminalOpenSince(String time) {
    return 'Offene Schicht seit $time';
  }

  @override
  String get terminalIn => 'KOMMEN';

  @override
  String get terminalOut => 'GEHEN';

  @override
  String get terminalSaved => 'Gespeichert.';

  @override
  String get terminalSuccessClockIn => 'Schönen Arbeitstag';

  @override
  String get terminalSuccessClockOut => 'Schöne Erholung';

  @override
  String get terminalPinPromptTitle => 'PIN eingeben';

  @override
  String get terminalPinConfirm => 'OK';

  @override
  String get terminalPinNotSet =>
      'Für diesen Benutzer ist kein PIN gesetzt. Wenden Sie sich an den Administrator.';

  @override
  String get terminalUnclosedSessionTitle => 'Nicht geschlossene Schicht';

  @override
  String terminalUnclosedSessionMessage(String startTime) {
    return 'Schicht begann am $startTime. Bitte Enddatum und -uhrzeit eingeben.';
  }

  @override
  String get terminalUnclosedSessionEndLabel => 'Enddatum und -uhrzeit';

  @override
  String get terminalUnclosedSessionSelectEnd => 'Datum und Uhrzeit wählen';

  @override
  String get terminalUnclosedSessionConfirm => 'Schicht schließen';

  @override
  String get terminalUnclosedSessionErrorEndBeforeStart =>
      'Ende muss nach dem Anfang liegen.';

  @override
  String get terminalUnclosedSessionErrorEndInFuture =>
      'Ende darf nicht in der Zukunft liegen.';

  @override
  String get terminalUnclosedSessionErrorEndAfterWorkingHours =>
      'Ende darf nicht nach dem Feierabend liegen.';

  @override
  String get terminalPolicyRequiredTitle =>
      'Bestätigung der Richtlinie erforderlich';

  @override
  String get terminalPolicyRequiredMessage =>
      'Um fortzufahren, müssen Sie die Datenschutzerklärung und Nutzungsbedingungen lesen und bestätigen.';

  @override
  String get terminalPolicyCheckboxText =>
      'Ich habe die Datenschutzerklärung und Nutzungsbedingungen gelesen und akzeptiere sie';

  @override
  String get adminTitle => 'Verwaltung';

  @override
  String get adminNavEmployees => 'Mitarbeiter';

  @override
  String get adminNavSchedules => 'Pläne';

  @override
  String get adminNavSessions => 'Schichten';

  @override
  String get adminNavJournal => 'Journal';

  @override
  String get adminNavReports => 'Berichte';

  @override
  String get adminNavSettings => 'Einstellungen';

  @override
  String get dashboardTitle => 'Startseite';

  @override
  String get dashboardNavOverview => 'Startseite';

  @override
  String get dashboardNowAtWork => 'Jetzt im Einsatz';

  @override
  String get dashboardNoOneAtWork => 'Noch niemand da';

  @override
  String get dashboardToday => 'Alle Mitarbeiter heute';

  @override
  String get dashboardRecentActivity => 'Letzte Aktivität';

  @override
  String get dashboardViewAllSessions => 'Alle Schichten';

  @override
  String get dashboardNoRecentActivity => 'Keine letzte Aktivität';

  @override
  String get dashboardNoEmployeesToday => 'Keine Mitarbeiter heute';

  @override
  String get adminEnterPinToContinue => 'PIN eingeben, um fortzufahren.';

  @override
  String get adminPinLabel => 'PIN';

  @override
  String get adminUnlock => 'Entsperren';

  @override
  String get adminInvalidPin => 'Ungültiger PIN.';

  @override
  String get adminPinInvalidFormat =>
      'PIN muss nur aus Ziffern bestehen und mindestens 4 Ziffern haben.';

  @override
  String get adminDefaultPinHint => 'Standard-PIN: 0000';

  @override
  String get adminChangePin => 'PIN ändern';

  @override
  String get adminLock => 'Sperren';

  @override
  String get adminPinUpdated => 'PIN aktualisiert.';

  @override
  String get changePinTitle => 'PIN ändern';

  @override
  String get changePinCurrentPin => 'Aktueller PIN';

  @override
  String get changePinNewPin => 'Neuer PIN';

  @override
  String get changePinConfirmNewPin => 'Neuen PIN bestätigen';

  @override
  String get changePinNewPinRequired => 'Neuer PIN ist erforderlich.';

  @override
  String get changePinConfirmationMismatch =>
      'PIN-Bestätigung stimmt nicht überein.';

  @override
  String get changePinCurrentInvalid => 'Aktueller PIN ist ungültig.';

  @override
  String get changePinInvalidFormat =>
      'PIN muss nur aus Ziffern bestehen und mindestens 4 Ziffern haben.';

  @override
  String get employeesTitle => 'Mitarbeiter';

  @override
  String get employeesNoEmployeesYet => 'Noch keine Mitarbeiter.';

  @override
  String get employeesSelectFromList =>
      'Wählen Sie einen Mitarbeiter aus der Liste.';

  @override
  String get employeesAddEmployee => 'Hinzufügen';

  @override
  String get employeesInactiveHiddenHint =>
      'Inaktive Mitarbeiter sind im Terminal ausgeblendet.';

  @override
  String get employeeDialogAddTitle => 'Mitarbeiter hinzufügen';

  @override
  String get employeeDialogEditTitle => 'Mitarbeiter bearbeiten';

  @override
  String get employeeDialogNewTitle => 'Neuer Mitarbeiter';

  @override
  String get employeeFirstName => 'Vorname';

  @override
  String get employeeLastName => 'Nachname';

  @override
  String get employeeDefaultSchedule => 'Standardplan';

  @override
  String get employeeActiveLabel => 'Aktiv';

  @override
  String get employeeStatusLabel => 'Status';

  @override
  String get employeeStatusActive => 'Aktiv';

  @override
  String get employeeStatusInactive => 'Inaktiv';

  @override
  String get employeeStatusArchived => 'Archiviert';

  @override
  String get employeeTerminationDateLabel => 'Austrittsdatum';

  @override
  String get employeeVacationDaysPerYearLabel => 'Urlaubstage pro Jahr';

  @override
  String get employeeSecondaryPhoneLabel => 'Zweittelefon';

  @override
  String get employeeStatusChangeConfirmTitle => 'Status ändern?';

  @override
  String get employeeStatusChangeConfirmMessage =>
      'Aktive Mitarbeiter werden im Terminal angezeigt. Inaktive und archivierte Mitarbeiter werden nicht angezeigt.';

  @override
  String get employeeStatusChangeConfirmConfirm => 'Ändern';

  @override
  String get employeeVacationDaysPerYearInvalid => 'Muss 0 oder mehr sein';

  @override
  String get employeeTerminationDateBeforeHireError =>
      'Das Austrittsdatum muss am oder nach dem Einstellungsdatum liegen.';

  @override
  String get employeeFirstLastRequired =>
      'Vor- und Nachname sind erforderlich.';

  @override
  String employeeCreateFailed(String error) {
    return 'Mitarbeiter konnte nicht erstellt werden: $error';
  }

  @override
  String employeeUpdateFailed(String error) {
    return 'Mitarbeiter konnte nicht aktualisiert werden: $error';
  }

  @override
  String get employeeSaved => 'Gespeichert.';

  @override
  String get employeeUnsavedChangesTitle => 'Ungespeicherte Änderungen';

  @override
  String get employeeUnsavedChangesMessage =>
      'Sie haben ungespeicherte Änderungen. Speichern, verwerfen oder abbrechen?';

  @override
  String get employeeDiscardChanges => 'Verwerfen';

  @override
  String employeeDefaultScheduleSubtitle(String name) {
    return 'Standardplan: $name';
  }

  @override
  String employeeScheduleButtonLabel(String name) {
    return 'Plan: $name';
  }

  @override
  String get employeeChangeScheduleTooltip => 'Plan ändern';

  @override
  String get employeeId => 'Mitarbeiter-ID';

  @override
  String get employeeCode => 'Mitarbeiternummer';

  @override
  String get employeeCodeHint => 'E001';

  @override
  String get employeeCodeRequired => 'Mitarbeiternummer ist erforderlich.';

  @override
  String get employeeFirstNameRequired => 'Vorname ist erforderlich.';

  @override
  String get employeeLastNameRequired => 'Nachname ist erforderlich.';

  @override
  String get employeeHireDate => 'Einstellungsdatum';

  @override
  String get employeeStatus => 'Status';

  @override
  String get employeeRole => 'Rolle';

  @override
  String get employeeRoleFieldLabel => 'Mitarbeiter / Vorgesetzter';

  @override
  String get employeeUsePin => 'PIN aktivieren';

  @override
  String get employeeUseNfc => 'NFC aktivieren';

  @override
  String get employeeAccessToken => 'Zugangstoken';

  @override
  String get employeePinStatus => 'PIN-Status';

  @override
  String employeePinStatusWithValue(String value) {
    return 'PIN-Status: $value';
  }

  @override
  String get employeeAccessNote => 'Zugangshinweise';

  @override
  String get employeeAccessTokenRequiredWhenNfc =>
      'Erforderlich bei aktiviertem NFC.';

  @override
  String get employeeEmploymentType => 'Beschäftigungsart';

  @override
  String get employeeWeeklyHours => 'Wochenstunden';

  @override
  String get employeeWeeklyHoursHint => '40';

  @override
  String get employeeEmail => 'E-Mail';

  @override
  String get employeePhone => 'Telefon';

  @override
  String get employeeDepartment => 'Abteilung';

  @override
  String get employeeJobTitle => 'Tätigkeitsbezeichnung';

  @override
  String get employeeInternalComment => 'Interne Notiz';

  @override
  String get employeePolicyAcknowledged => 'Richtlinie bestätigt';

  @override
  String get employeePolicyAcknowledgedAt => 'Bestätigt am';

  @override
  String employeePolicyAcknowledgedAtWithValue(String value) {
    return 'Bestätigt: $value';
  }

  @override
  String get employeeDataRetentionPolicy => 'Aufbewahrungsfrist';

  @override
  String get employeeCreatedAt => 'Erstellt am';

  @override
  String employeeCreatedAtWithValue(String value) {
    return 'Erstellt: $value';
  }

  @override
  String get employeeUpdatedAt => 'Aktualisiert am';

  @override
  String employeeUpdatedAtWithValue(String value) {
    return 'Aktualisiert: $value';
  }

  @override
  String get employeeCreatedBy => 'Erstellt von';

  @override
  String get employeeUpdatedBy => 'Aktualisiert von';

  @override
  String get employeePinStatusSet => 'Gesetzt';

  @override
  String get employeePinStatusNotSet => 'Nicht gesetzt';

  @override
  String get employeeRoleEmployee => 'Mitarbeiter';

  @override
  String get employeeRoleManager => 'Vorgesetzter';

  @override
  String get employeeEmploymentTypeFullTime => 'Vollzeit';

  @override
  String get employeeEmploymentTypePartTime => 'Teilzeit';

  @override
  String get employeeEmploymentTypeMinijob => 'Minijob';

  @override
  String get employeeEmploymentTypeCustom => 'Sonstiges';

  @override
  String get employeeTerminalAccessDisabled => 'Terminal-Zugang deaktiviert';

  @override
  String get employeeInactive => 'Mitarbeiter ist inaktiv';

  @override
  String get employeeCodeAlreadyExists => 'Mitarbeiternummer existiert bereits';

  @override
  String get employeePolicyText =>
      'Mitarbeiter hat die Datenschutzerklärung und Nutzungsbedingungen bestätigt';

  @override
  String get employeePolicyPrefix => 'Mitarbeiter hat die ';

  @override
  String get employeePolicyLinkPrivacy => 'Datenschutzerklärung';

  @override
  String get employeePolicyMiddle => ' und ';

  @override
  String get employeePolicyLinkTerms => 'Nutzungsbedingungen';

  @override
  String get employeeSetPin => 'PIN setzen';

  @override
  String get employeeResetPin => 'PIN zurücksetzen';

  @override
  String employeeFieldLabelWithRequired(String label) {
    return '$label *';
  }

  @override
  String get employeeSectionIdentity => 'Stammdaten';

  @override
  String get employeeSectionBasicInfo => 'Stammdaten';

  @override
  String get employeeSectionEmployment => 'Beschäftigung';

  @override
  String get employeeSectionContact => 'Kontakt';

  @override
  String get employeeSectionAccess => 'Terminal-Zugang';

  @override
  String get employeeSectionSchedule => 'Plan';

  @override
  String get employeeScheduleRequired => 'Plan ist erforderlich.';

  @override
  String get employeeSectionPolicy => 'Richtlinie & Compliance';

  @override
  String get employeeSectionAudit => 'Protokoll';

  @override
  String get employeeTabGeneral => 'Allgemein';

  @override
  String get employeeTabContact => 'Kontakt';

  @override
  String get employeeTabTerminalAccess => 'Terminal-Zugang';

  @override
  String get employeeTabAdditional => 'Zusätzlich';

  @override
  String get schedulesEmptyHint => 'Erstellen Sie eine Planvorlage.';

  @override
  String schedulesFailedLoad(String error) {
    return 'Pläne konnten nicht geladen werden: $error';
  }

  @override
  String get schedulesTitle => 'Pläne';

  @override
  String get schedulesAddTemplateTooltip => 'Vorlage hinzufügen';

  @override
  String get schedulesNoTemplates => 'Keine Vorlagen.';

  @override
  String get schedulesCreateTemplateTitle => 'Vorlage erstellen';

  @override
  String get schedulesRenameTemplateTitle => 'Vorlage umbenennen';

  @override
  String get schedulesTemplateNameLabel => 'Name';

  @override
  String get schedulesWeekEditorTitle => 'Wocheneditor';

  @override
  String schedulesFailedLoadTemplate(String error) {
    return 'Vorlage konnte nicht geladen werden: $error';
  }

  @override
  String get schedulesDayOff => 'Frei';

  @override
  String get schedulesNoIntervals => 'Keine Intervalle.';

  @override
  String get schedulesAddInterval => 'Intervall hinzufügen';

  @override
  String get schedulesSaved => 'Gespeichert.';

  @override
  String schedulesCopiedTo(String weekday) {
    return 'Kopiert nach $weekday.';
  }

  @override
  String get schedulesInvalidInput => 'Ungültige Eingabe.';

  @override
  String get schedulesBreadcrumb => 'Admin / Pläne';

  @override
  String get schedulesNewSchedule => 'Neuer Plan';

  @override
  String get schedulesEditIntervalTitle => 'Intervall bearbeiten';

  @override
  String get schedulesAddIntervalTitle => 'Intervall hinzufügen';

  @override
  String get schedulesStartTimeLabel => 'Startzeit';

  @override
  String get schedulesEndTimeLabel => 'Endzeit';

  @override
  String get schedulesDiscardChanges => 'Verwerfen';

  @override
  String get schedulesUnsavedChangesTitle => 'Ungespeicherte Änderungen';

  @override
  String get schedulesUnsavedChangesMessage =>
      'Sie haben ungespeicherte Änderungen. Speichern, verwerfen oder abbrechen?';

  @override
  String schedulesSaveFailed(String reason) {
    return 'Speichern fehlgeschlagen: $reason';
  }

  @override
  String schedulesTotalHours(String hours) {
    return 'Gesamt ${hours}h';
  }

  @override
  String get schedulesIntervalOverlapError =>
      'Dieses Intervall überschneidet sich mit einem anderen.';

  @override
  String get schedulesIntervalEndBeforeStartError =>
      'Die Endzeit muss nach der Startzeit liegen.';

  @override
  String get schedulesScheduleActiveSuffix => ' (Aktiv)';

  @override
  String get schedulesScheduleInactiveSuffix => ' (Inaktiv)';

  @override
  String get schedulesRenameScheduleTooltip => 'Plan umbenennen';

  @override
  String get schedulesNameAlreadyExistsError => 'Name existiert bereits.';

  @override
  String get schedulesNameRequiredError => 'Name ist erforderlich.';

  @override
  String get schedulesDeleteScheduleTooltip => 'Plan löschen';

  @override
  String get schedulesDeleteScheduleTitle => 'Plan löschen?';

  @override
  String get schedulesDeleteScheduleMessage =>
      'Die Planvorlage wird entfernt. Zugewiesenen Mitarbeitern bleibt keine Standardplanung.';

  @override
  String get schedulesDeleteScheduleButton => 'Löschen';

  @override
  String schedulesDeleteFailed(String reason) {
    return 'Löschen fehlgeschlagen: $reason';
  }

  @override
  String get schedulesDeleteBlockedAssignedTitle => 'Löschen nicht möglich';

  @override
  String get schedulesDeleteBlockedAssignedMessage =>
      'Dieser Plan ist Mitarbeitern zugewiesen. Heben Sie die Zuweisung auf, bevor Sie löschen.';

  @override
  String intervalStart(String time) {
    return 'Start: $time';
  }

  @override
  String intervalEnd(String time) {
    return 'Ende: $time';
  }

  @override
  String get intervalRemoveTooltip => 'Entfernen';

  @override
  String get weekdayMonday => 'Montag';

  @override
  String get weekdayTuesday => 'Dienstag';

  @override
  String get weekdayWednesday => 'Mittwoch';

  @override
  String get weekdayThursday => 'Donnerstag';

  @override
  String get weekdayFriday => 'Freitag';

  @override
  String get weekdaySaturday => 'Samstag';

  @override
  String get weekdaySunday => 'Sonntag';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsThemeLabel => 'Design';

  @override
  String get settingsThemeSystem => 'Systemstandard';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeHighContrastLight => 'Hoher Kontrast (hell)';

  @override
  String get settingsThemeHighContrastDark => 'Hoher Kontrast (dunkel)';

  @override
  String get settingsAttendanceModeLabel => 'Anwesenheitsmodus';

  @override
  String get settingsAttendanceModeFlexible => 'Flexibel';

  @override
  String get settingsAttendanceModeFixed => 'Fest';

  @override
  String get settingsAttendanceToleranceLabel => 'Toleranz (Minuten)';

  @override
  String get settingsAttendanceModeChangeConfirmTitle =>
      'Anwesenheitsmodus ändern?';

  @override
  String get settingsAttendanceModeChangeConfirmMessage =>
      'Dies wirkt sich auf die Kommen-/Gehen-Funktion im Terminal für alle Mitarbeiter aus.';

  @override
  String get settingsWorkingHoursLabel => 'Arbeitszeit';

  @override
  String get settingsWorkingHoursFrom => 'Von';

  @override
  String get settingsWorkingHoursTo => 'Bis';

  @override
  String get settingsWorkingHoursInvalidRange => 'Von muss vor Bis liegen';

  @override
  String settingsWorkingHoursFromWithValue(String value) {
    return 'Von: $value';
  }

  @override
  String settingsWorkingHoursToWithValue(String value) {
    return 'Bis: $value';
  }

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsCreateBackup => 'Sicherung erstellen';

  @override
  String settingsBackupCreated(String path) {
    return 'Sicherung erstellt: $path';
  }

  @override
  String get settingsBackupSuccessTitle => 'Sicherung erfolgreich erstellt';

  @override
  String get settingsRestoreCompletedTitle => 'Datenbank wiederhergestellt';

  @override
  String get settingsRestoreCompletedMessage =>
      'Die Datenbank wurde aus einer Sicherung wiederhergestellt. OK zum Fortfahren drücken.';

  @override
  String get settingsBackupErrorPermissionDenied =>
      'Zugriff auf Datei oder Ordner nicht möglich.';

  @override
  String get settingsBackupErrorNotFound => 'Datei oder Ordner nicht gefunden.';

  @override
  String get settingsBackupErrorInvalidArchive => 'Ungültige Sicherungsdatei.';

  @override
  String get settingsBackupErrorIoFailure => 'Dateioperation fehlgeschlagen.';

  @override
  String get settingsBackupErrorDbFailure => 'Datenbankfehler.';

  @override
  String get settingsBackupErrorUnknown =>
      'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get settingsRestoreFromBackup => 'Aus Sicherung wiederherstellen';

  @override
  String get settingsRestoreConfirmTitle => 'Wiederherstellung';

  @override
  String get settingsRestoreConfirmMessage =>
      'Aktuelle Daten werden vollständig durch Daten aus der gewählten Datei ersetzt. Fortfahren?';

  @override
  String get settingsRestoreCreated =>
      'Wiederherstellung abgeschlossen. Bildschirm bei Bedarf aktualisieren.';

  @override
  String get settingsRestoreScheduledRestart =>
      'Wiederherstellung geplant. Bitte starten Sie die Anwendung neu.';

  @override
  String get settingsRestoreErrorPermissionDenied =>
      'Zugriff auf Datei oder Ordner nicht möglich.';

  @override
  String get settingsRestoreErrorNotFound =>
      'Datei oder Ordner nicht gefunden.';

  @override
  String get settingsRestoreErrorInvalidArchive => 'Ungültige Sicherungsdatei.';

  @override
  String get settingsRestoreErrorIoFailure => 'Dateioperation fehlgeschlagen.';

  @override
  String get settingsRestoreErrorDbFailure => 'Datenbankfehler.';

  @override
  String get settingsRestoreErrorUnknown =>
      'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get settingsRestoreSchemaError =>
      'Datei wurde in einer anderen App-Version erstellt. Wiederherstellung nicht möglich.';

  @override
  String get settingsExportDiagnostics => 'Diagnosedaten exportieren';

  @override
  String get settingsExportDiagnosticsSuccess =>
      'Diagnosedaten erfolgreich exportiert';

  @override
  String settingsExportDiagnosticsFailed(String error) {
    return 'Diagnoseexport fehlgeschlagen: $error';
  }

  @override
  String get legalTerms => 'Nutzungsbedingungen';

  @override
  String get helpTitle => 'Hilfe';

  @override
  String get aboutTitle => 'Über';

  @override
  String get legalNoticeWelcomeTitle => 'Willkommen';

  @override
  String get legalNoticeWelcomeText =>
      'Bitte lesen Sie die Datenschutzerklärung und Nutzungsbedingungen.';

  @override
  String get legalNoticeOpenPrivacy => 'Datenschutzerklärung öffnen';

  @override
  String get legalNoticeOpenTerms => 'Nutzungsbedingungen öffnen';

  @override
  String get legalNoticeClose => 'Schließen';

  @override
  String get legalCopy => 'Kopieren';

  @override
  String get legalCopiedToClipboard => 'In die Zwischenablage kopiert.';

  @override
  String get legalFailedToCopy => 'Kopieren fehlgeschlagen.';

  @override
  String get sessionsTitle => 'Schichten';

  @override
  String get sessionsEmployeeFilter => 'Mitarbeiter';

  @override
  String get sessionsEmployeeAll => 'Alle';

  @override
  String get sessionsNoEmployeesAvailable => 'Keine Mitarbeiter verfügbar.';

  @override
  String sessionsFailedLoadEmployees(String error) {
    return 'Mitarbeiter konnten nicht geladen werden: $error';
  }

  @override
  String get sessionsFilterFrom => 'Von';

  @override
  String get sessionsFilterTo => 'Bis';

  @override
  String get sessionsFilterAny => 'Beliebig';

  @override
  String get sessionsNoSessions => 'Keine Schichten.';

  @override
  String sessionsFailedLoadSessions(String error) {
    return 'Schichten konnten nicht geladen werden: $error';
  }

  @override
  String get sessionsTableEmployee => 'Mitarbeiter';

  @override
  String get sessionsTableStart => 'Start';

  @override
  String get sessionsTableEnd => 'Ende';

  @override
  String get sessionsTableDuration => 'Dauer';

  @override
  String sessionsDurationWithValue(String value) {
    return 'Dauer: $value';
  }

  @override
  String get sessionsTableStatus => 'Status';

  @override
  String get sessionsTableNote => 'Notiz';

  @override
  String get sessionsTableActions => 'Aktionen';

  @override
  String get sessionsEdit => 'Bearbeiten';

  @override
  String get sessionsEditDialogTitle => 'Schicht bearbeiten';

  @override
  String sessionsEmployeePrefix(String name) {
    return 'Mitarbeiter: $name';
  }

  @override
  String sessionsStartPrefix(String value) {
    return 'Start: $value';
  }

  @override
  String sessionsEndPrefix(String value) {
    return 'Ende: $value';
  }

  @override
  String get sessionsOpenSessionLabel => 'Offene Schicht (Ende ist leer)';

  @override
  String get sessionsSetEndNow => 'Ende = jetzt setzen';

  @override
  String get sessionsClearEnd => 'Ende löschen';

  @override
  String get sessionsUpdateReason => 'Änderungsgrund';

  @override
  String get sessionsEmployeeCannotChangeHint =>
      'Mitarbeiter kann nicht geändert werden.';

  @override
  String get sessionsUpdateReasonRequired => 'Änderungsgrund ist erforderlich.';

  @override
  String get sessionsErrorSameDayRequired =>
      'Die Sitzung muss am gleichen Tag beginnen und enden.';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalFilterFrom => 'Von';

  @override
  String get journalFilterTo => 'Bis';

  @override
  String get journalFilterAny => 'Beliebig';

  @override
  String get journalFilterStatusAll => 'Alle';

  @override
  String get journalFilterStatusOpen => 'Offen';

  @override
  String get journalFilterStatusClosed => 'Geschlossen';

  @override
  String get journalFilterStatusNotClosed => 'Nicht geschlossen';

  @override
  String get journalFilterSearch => 'Suchen';

  @override
  String get journalFilterEmployee => 'Mitarbeiter';

  @override
  String get journalScopeDay => 'Tag';

  @override
  String get journalScopeWeek => 'Woche';

  @override
  String get journalScopeMonth => 'Monat';

  @override
  String get journalScopeInterval => 'Benutzerdefiniert';

  @override
  String get journalPresetToday => 'Heute';

  @override
  String get journalPresetWeek => 'Woche';

  @override
  String get journalPresetMonth => 'Monat';

  @override
  String get journalPresetLastMonth => 'Letzter Monat';

  @override
  String get journalEndEmpty => '—';

  @override
  String get journalEditDialogTitle => 'Schicht bearbeiten';

  @override
  String get journalCloseNow => 'Jetzt schließen';

  @override
  String get journalErrorEndBeforeStart =>
      'Die Endzeit muss nach der Startzeit liegen.';

  @override
  String get journalErrorCrossDay =>
      'Start und Ende müssen am gleichen Tag liegen.';

  @override
  String get journalErrorOutsideEmployment =>
      'Sitzungsdaten müssen in die Beschäftigungszeit des Mitarbeiters fallen.';

  @override
  String get journalUpdateReasonHint =>
      'Erforderlich bei Änderung von Start- oder Endzeit';

  @override
  String get journalSaved => 'Gespeichert.';

  @override
  String get journalViewTable => 'Tabelle';

  @override
  String get journalViewTimeline => 'Zeitleiste';

  @override
  String get journalViewDetailed => 'Detailliert';

  @override
  String get journalIntervalLegendWork => 'Arbeit';

  @override
  String get journalIntervalLegendApprovedAbsence => 'Genehmigte Abwesenheit';

  @override
  String get journalIntervalLegendOngoing => 'Läuft';

  @override
  String get journalTimelineStateOngoing => 'Arbeit läuft';

  @override
  String get journalTimelineStatePresent => 'Anwesend';

  @override
  String get journalTimelineStateApprovedAbsence => 'Genehmigte Abwesenheit';

  @override
  String get journalTimelineStateExpectedNoShow =>
      'Erwartet, keine Anwesenheit';

  @override
  String get journalTimelineStateNoData => 'Keine Daten';

  @override
  String get journalTimelinePickRangeHint =>
      'Wählen Sie einen Datumsbereich für die Zeitleistenansicht.';

  @override
  String get journalNavPrev => 'Zurück';

  @override
  String get journalNavNext => 'Weiter';

  @override
  String get journalIntervalNow => 'jetzt';

  @override
  String journalIntervalDurationMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get reportsTitle => 'Berichte';

  @override
  String get reportsNoData => 'Keine Daten.';

  @override
  String reportsFailedLoad(String error) {
    return 'Bericht konnte nicht geladen werden: $error';
  }

  @override
  String get reportsOnlyClosedHint =>
      'Nur GESCHLOSSENE Schichten werden summiert.';

  @override
  String get reportsTableEmployee => 'Mitarbeiter';

  @override
  String get reportsTableTotal => 'Summe';

  @override
  String get reportsTableNorm => 'Norm';

  @override
  String get reportsTableDelta => 'Delta';

  @override
  String get reportsTableSessions => 'Schichten';

  @override
  String get reportsExportPdf => 'PDF exportieren';

  @override
  String get reportsPdfFileType => 'PDF-Dateien';

  @override
  String get reportsExported => 'Exportiert.';

  @override
  String get reportsTableWorked => 'Gearbeitet';

  @override
  String get reportsTablePlanned => 'Geplant';

  @override
  String get reportsTableBalance => 'Saldo (+/−)';

  @override
  String get reportsPlannedNoSchedule => 'Kein Plan';

  @override
  String get reportsPeriodLabel => 'Zeitraum';

  @override
  String get reportsPeriodPresetToday => 'Heute';

  @override
  String get reportsPeriodPresetWeek => 'Woche';

  @override
  String get reportsPeriodPresetMonth => 'Monat';

  @override
  String get reportsPeriodPresetLastMonth => 'Letzter Monat';

  @override
  String get reportsPeriodPresetCustom => 'Benutzerdefiniert';

  @override
  String get reportsEmployeeFilter => 'Mitarbeiter';

  @override
  String get reportsDetailsTitle => 'Details';

  @override
  String get reportsExportEmployeePdf => 'PDF exportieren';

  @override
  String get reportsDetailsClose => 'Schließen';

  @override
  String get reportsTableDate => 'Datum';

  @override
  String get reportsPdfTitle => 'Arbeitszeitbericht';

  @override
  String reportsPdfPeriod(String from, String to) {
    return 'Zeitraum: $from — $to';
  }

  @override
  String reportsPdfGenerated(String datetime) {
    return 'Erstellt: $datetime';
  }

  @override
  String reportsPdfEmployee(String name) {
    return 'Mitarbeiter: $name';
  }

  @override
  String reportsPdfSort(String column) {
    return 'Sortierung: $column';
  }

  @override
  String get reportsPdfFooterBrand => 'Timerevo — Offline-Bericht';

  @override
  String reportsPdfFooterPage(int current, int total) {
    return 'Seite $current / $total';
  }

  @override
  String get adminNavAbsences => 'Abwesenheiten';

  @override
  String get absencesTitle => 'Abwesenheiten';

  @override
  String get absencesAdd => 'Abwesenheit hinzufügen';

  @override
  String get absencesEmployee => 'Mitarbeiter';

  @override
  String get absencesType => 'Typ';

  @override
  String get absencesDateFrom => 'Von';

  @override
  String get absencesDateTo => 'Bis';

  @override
  String get absencesStatus => 'Status';

  @override
  String get absencesCreatedBy => 'Erstellt von';

  @override
  String get absencesActions => 'Aktionen';

  @override
  String get absenceTypeVacation => 'Jahresurlaub';

  @override
  String get absenceTypeSickLeave => 'Krankschreibung';

  @override
  String get absenceTypeUnpaidLeave => 'Unbezahlter Urlaub';

  @override
  String get absenceTypeParentalLeave => 'Elternzeit';

  @override
  String get absenceTypeStudyLeave => 'Bildungsurlaub';

  @override
  String get absenceTypeOther => 'Sonstiges';

  @override
  String get absenceStatusPending => 'Ausstehend';

  @override
  String get absenceStatusApproved => 'Genehmigt';

  @override
  String get absenceStatusRejected => 'Abgelehnt';

  @override
  String get absenceApprove => 'Genehmigen';

  @override
  String get absenceReject => 'Ablehnen';

  @override
  String get absenceEdit => 'Bearbeiten';

  @override
  String get absenceDelete => 'Löschen';

  @override
  String get absenceRejectReason => 'Ablehnungsgrund';

  @override
  String get terminalMyCalendar => 'Mein Arbeitskalender';

  @override
  String get terminalMyPdf => 'Zeitbericht (PDF)';

  @override
  String terminalCalendarPageTitle(String name) {
    return 'Arbeitskalender ($name)';
  }

  @override
  String get terminalCalendarSessions => 'Schichten';

  @override
  String get terminalCalendarAbsences => 'Abwesenheiten';

  @override
  String get terminalCalendarNoData => 'Keine Daten für diesen Tag';

  @override
  String get terminalCalendarNewAbsence => 'Neue Anfrage';

  @override
  String get terminalCalendarFormatMonth => 'Monat';

  @override
  String get terminalCalendarFormatTwoWeeks => '2 Wochen';

  @override
  String get terminalCalendarFormatWeek => 'Woche';

  @override
  String get absenceCreateTitle => 'Neuer Abwesenheitsantrag';

  @override
  String get absenceEditTitle => 'Abwesenheit bearbeiten';

  @override
  String get absenceErrorOverlap =>
      'Überschneidung mit bestehender Abwesenheit.';

  @override
  String get absenceErrorDateRestrictionVacation =>
      'Urlaub muss heute oder später beginnen.';

  @override
  String get absenceErrorDateRestrictionSickLeave =>
      'Krankschreibung kann nicht mehr als 3 Tage zurück datiert werden.';

  @override
  String get absenceErrorOutsideEmployment =>
      'Abwesenheit muss innerhalb der Beschäftigungszeit des Mitarbeiters liegen (Einstellungsdatum bis Austrittsdatum).';

  @override
  String get absencesEmpty => 'Keine Abwesenheiten.';

  @override
  String get absencesEmptyHint =>
      'Noch keine Abwesenheiten. Erstellen Sie Ihren ersten Antrag.';

  @override
  String get absenceDeleteConfirm => 'Diesen Abwesenheitsantrag löschen?';

  @override
  String get absenceApproveConfirm => 'Diesen Abwesenheitsantrag genehmigen?';

  @override
  String get absenceRejectConfirmHint =>
      'Der Mitarbeiter wird den Ablehnungsgrund sehen.';

  @override
  String get absenceCreated => 'Abwesenheitsantrag erstellt.';

  @override
  String get absenceUpdated => 'Abwesenheitsantrag aktualisiert.';

  @override
  String get absenceApproved => 'Abwesenheitsantrag genehmigt.';

  @override
  String get absenceRejected => 'Abwesenheitsantrag abgelehnt.';

  @override
  String get absenceDeleted => 'Abwesenheitsantrag gelöscht.';

  @override
  String get absencesApprovedBy => 'Genehmigt von';

  @override
  String get absencesApprovedAt => 'Genehmigt am';

  @override
  String get absenceErrorEditPendingOnly =>
      'Nur ausstehende Anträge können bearbeitet werden.';

  @override
  String get absenceErrorDeletePendingOnly =>
      'Nur ausstehende Anträge können gelöscht werden.';

  @override
  String get absenceErrorApproveRejectPendingOnly =>
      'Nur ausstehende Anträge können genehmigt oder abgelehnt werden.';

  @override
  String get absenceErrorRejectReasonRequired =>
      'Ablehnungsgrund ist erforderlich.';

  @override
  String get absenceErrorDateOrder =>
      'Enddatum muss am oder nach dem Startdatum liegen.';

  @override
  String get absenceErrorEmployeeRequired =>
      'Bitte wählen Sie einen Mitarbeiter.';

  @override
  String get absenceErrorDateRequired =>
      'Bitte wählen Sie die Daten Von und Bis.';
}
