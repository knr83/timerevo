// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Учёт времени';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonOngoing => 'Идёт';

  @override
  String get commonNotAvailable => 'н/д';

  @override
  String get commonCreate => 'Создать';

  @override
  String get commonRename => 'Переименовать';

  @override
  String get commonActivate => 'Активировать';

  @override
  String get commonDeactivate => 'Деактивировать';

  @override
  String get commonActive => 'Активный';

  @override
  String get commonInactive => 'Неактивный';

  @override
  String get commonNone => 'Нет';

  @override
  String get commonUnknown => 'Неизвестно';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonRemove => 'Удалить';

  @override
  String get commonOk => 'ОК';

  @override
  String get commonErrorOccurred => 'Произошла ошибка.';

  @override
  String get commonRequiredFieldsLegend => '* Обязательные поля';

  @override
  String commonFilterLabelWithValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String initFailed(String error) {
    return 'Ошибка инициализации: $error';
  }

  @override
  String get initFailedGeneric =>
      'Ошибка инициализации. Попробуйте снова или переустановите приложение.';

  @override
  String get initDbErrorTitle => 'Ошибка базы данных';

  @override
  String get initDbErrorMessage =>
      'База данных не открывается. Восстановите из резервной копии или выполните переинициализацию.';

  @override
  String get initDbErrorRestore => 'Восстановить из резервной копии';

  @override
  String get initDbErrorReinitialize =>
      'Переинициализировать (все локальные данные будут удалены)';

  @override
  String get initDbErrorRetry => 'Повторить';

  @override
  String get terminalTitle => 'Терминал';

  @override
  String get terminalAdmin => 'Администрирование';

  @override
  String get terminalNoActiveEmployees => 'Нет активных сотрудников.';

  @override
  String terminalFailedLoadEmployees(String error) {
    return 'Не удалось загрузить сотрудников: $error';
  }

  @override
  String get terminalNoOpenSession => 'Нет открытой смены.';

  @override
  String get terminalStatusOnShift => 'На смене';

  @override
  String terminalOnShiftSince(String time) {
    return 'с $time';
  }

  @override
  String get terminalStatusReady => 'Готов к отметке';

  @override
  String terminalCurrentTime(String time) {
    return 'Сейчас $time';
  }

  @override
  String get terminalSwitchEmployee => 'Сменить сотрудника';

  @override
  String get terminalSessionsToday => 'Сегодня';

  @override
  String get terminalSessionInProgress => 'идёт';

  @override
  String terminalSessionRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get terminalNoSessionsToday => 'Нет смен за сегодня';

  @override
  String get terminalDurationLessThanOneMin => '< 1 мин';

  @override
  String terminalDurationMinutesOnly(int m) {
    return '$m мин';
  }

  @override
  String terminalDurationHoursOnly(int h) {
    return '$h ч';
  }

  @override
  String terminalShowMoreSessions(int count) {
    return 'Показать ещё $count';
  }

  @override
  String get terminalTotalToday => 'Всего за сегодня';

  @override
  String terminalTotalTodayWithValue(String value) {
    return 'Всего за сегодня: $value';
  }

  @override
  String get terminalErrorSessionAlreadyOpen => 'Смена уже открыта.';

  @override
  String get terminalErrorNoOpenSession => 'Нет открытой смены.';

  @override
  String get terminalErrorClockInBeforeStart =>
      'Нельзя отмечаться до начала рабочего времени.';

  @override
  String get terminalErrorClockInAfterEnd =>
      'Нельзя отмечаться после окончания рабочего времени.';

  @override
  String get terminalErrorHasApprovedAbsence =>
      'Сегодня у вас одобренное отсутствие. Отметка прихода недоступна.';

  @override
  String get terminalErrorNoScheduleForDay =>
      'Сегодня нет запланированной работы.';

  @override
  String get terminalNoteRequiredTitle => 'Требуется заметка';

  @override
  String get terminalNoteRequiredMessage =>
      'Для этого отклонения требуется заметка.';

  @override
  String get terminalNoteLabel => 'Заметка';

  @override
  String get terminalNoteConfirm => 'Подтвердить';

  @override
  String get terminalNoteCancel => 'Отмена';

  @override
  String terminalOpenSince(String time) {
    return 'Открытая смена с $time';
  }

  @override
  String get terminalIn => 'ПРИШЁЛ';

  @override
  String get terminalOut => 'УШЁЛ';

  @override
  String get terminalSaved => 'Сохранено.';

  @override
  String get terminalSuccessClockIn => 'Хорошего рабочего дня';

  @override
  String get terminalSuccessClockOut => 'Приятного отдыха';

  @override
  String get terminalPinPromptTitle => 'Введите PIN';

  @override
  String get terminalPinConfirm => 'OK';

  @override
  String get terminalPinNotSet =>
      'Для пользователя не задан PIN. Обратитесь к администратору.';

  @override
  String get terminalUnclosedSessionTitle => 'Незакрытая смена';

  @override
  String terminalUnclosedSessionMessage(String startTime) {
    return 'Смена началась $startTime. Укажите дату и время окончания.';
  }

  @override
  String get terminalUnclosedSessionEndLabel => 'Конец смены';

  @override
  String get terminalUnclosedSessionSelectEnd => 'Выбрать дату и время';

  @override
  String get terminalUnclosedSessionConfirm => 'Закрыть смену';

  @override
  String get terminalUnclosedSessionErrorEndBeforeStart =>
      'Время окончания должно быть позже начала.';

  @override
  String get terminalUnclosedSessionErrorEndInFuture =>
      'Время окончания не может быть в будущем.';

  @override
  String get terminalUnclosedSessionErrorEndAfterWorkingHours =>
      'Время окончания не может быть позже конца рабочего дня.';

  @override
  String get terminalPolicyRequiredTitle => 'Требуется подтверждение политики';

  @override
  String get terminalPolicyRequiredMessage =>
      'Для продолжения необходимо ознакомиться с Политикой конфиденциальности и Условиями использования и подтвердить их.';

  @override
  String get terminalPolicyCheckboxText =>
      'Я ознакомился(ась) с Политикой конфиденциальности и Условиями использования';

  @override
  String get adminTitle => 'Администрирование';

  @override
  String get adminNavEmployees => 'Сотрудники';

  @override
  String get adminNavSchedules => 'Расписания';

  @override
  String get adminNavSessions => 'Смены';

  @override
  String get adminNavJournal => 'Журнал';

  @override
  String get adminNavReports => 'Отчёты';

  @override
  String get adminNavSettings => 'Настройки';

  @override
  String get dashboardTitle => 'Главная';

  @override
  String get dashboardNavOverview => 'Главная';

  @override
  String get dashboardNowAtWork => 'Сейчас на смене';

  @override
  String get dashboardNoOneAtWork => 'Пока никого нет';

  @override
  String get dashboardToday => 'Все сотрудники за сегодня';

  @override
  String get dashboardRecentActivity => 'Недавняя активность';

  @override
  String get dashboardViewAllSessions => 'Все сессии';

  @override
  String get dashboardNoRecentActivity => 'Нет недавней активности';

  @override
  String get dashboardNoEmployeesToday => 'Нет сотрудников за сегодня';

  @override
  String get adminEnterPinToContinue => 'Введите PIN, чтобы продолжить.';

  @override
  String get adminPinLabel => 'PIN';

  @override
  String get adminUnlock => 'Открыть';

  @override
  String get adminInvalidPin => 'Неверный PIN.';

  @override
  String get adminPinInvalidFormat =>
      'PIN должен содержать только цифры, минимум 4.';

  @override
  String get adminDefaultPinHint => 'PIN по умолчанию: 0000';

  @override
  String get adminChangePin => 'Сменить PIN';

  @override
  String get adminLock => 'Заблокировать';

  @override
  String get adminPinUpdated => 'PIN обновлён.';

  @override
  String get changePinTitle => 'Смена PIN';

  @override
  String get changePinCurrentPin => 'Текущий PIN';

  @override
  String get changePinNewPin => 'Новый PIN';

  @override
  String get changePinConfirmNewPin => 'Повторите новый PIN';

  @override
  String get changePinNewPinRequired => 'Новый PIN обязателен.';

  @override
  String get changePinConfirmationMismatch => 'Подтверждение PIN не совпадает.';

  @override
  String get changePinCurrentInvalid => 'Текущий PIN неверен.';

  @override
  String get changePinInvalidFormat =>
      'PIN должен содержать только цифры, минимум 4.';

  @override
  String get employeesTitle => 'Сотрудники';

  @override
  String get employeesNoEmployeesYet => 'Пока нет сотрудников.';

  @override
  String get employeesSelectFromList => 'Выберите сотрудника из списка.';

  @override
  String get employeesAddEmployee => 'Добавить';

  @override
  String get employeesInactiveHiddenHint =>
      'Неактивные сотрудники скрыты в терминале.';

  @override
  String get employeeDialogAddTitle => 'Добавить сотрудника';

  @override
  String get employeeDialogEditTitle => 'Редактировать сотрудника';

  @override
  String get employeeDialogNewTitle => 'Новый сотрудник';

  @override
  String get employeeFirstName => 'Имя';

  @override
  String get employeeLastName => 'Фамилия';

  @override
  String get employeeDefaultSchedule => 'Расписание по умолчанию';

  @override
  String get employeeActiveLabel => 'Активен';

  @override
  String get employeeStatusLabel => 'Статус';

  @override
  String get employeeStatusActive => 'Активный';

  @override
  String get employeeStatusInactive => 'Неактивный';

  @override
  String get employeeStatusArchived => 'Архивный';

  @override
  String get employeeTerminationDateLabel => 'Дата увольнения';

  @override
  String get employeeVacationDaysPerYearLabel => 'Дней отпуска в год';

  @override
  String get employeeSecondaryPhoneLabel => 'Дополнительный телефон';

  @override
  String get employeeStatusChangeConfirmTitle => 'Изменить статус?';

  @override
  String get employeeStatusChangeConfirmMessage =>
      'Активные сотрудники отображаются в терминале. Неактивные и архивные — не отображаются.';

  @override
  String get employeeStatusChangeConfirmConfirm => 'Изменить';

  @override
  String get employeeVacationDaysPerYearInvalid => 'Должно быть 0 или больше';

  @override
  String get employeeFirstLastRequired => 'Имя и фамилия обязательны.';

  @override
  String employeeCreateFailed(String error) {
    return 'Не удалось создать сотрудника: $error';
  }

  @override
  String employeeUpdateFailed(String error) {
    return 'Не удалось обновить сотрудника: $error';
  }

  @override
  String get employeeSaved => 'Сохранено.';

  @override
  String get employeeUnsavedChangesTitle => 'Несохранённые изменения';

  @override
  String get employeeUnsavedChangesMessage =>
      'У вас есть несохранённые изменения. Сохранить, отменить или остаться?';

  @override
  String get employeeDiscardChanges => 'Отменить';

  @override
  String employeeDefaultScheduleSubtitle(String name) {
    return 'Расписание по умолчанию: $name';
  }

  @override
  String employeeScheduleButtonLabel(String name) {
    return 'Расписание: $name';
  }

  @override
  String get employeeChangeScheduleTooltip => 'Сменить расписание';

  @override
  String get employeeId => 'ID сотрудника';

  @override
  String get employeeCode => 'Код сотрудника';

  @override
  String get employeeCodeHint => 'E001';

  @override
  String get employeeCodeRequired => 'Укажите код сотрудника.';

  @override
  String get employeeFirstNameRequired => 'Укажите имя.';

  @override
  String get employeeLastNameRequired => 'Укажите фамилию.';

  @override
  String get employeeHireDate => 'Дата приёма';

  @override
  String get employeeStatus => 'Статус';

  @override
  String get employeeRole => 'Роль';

  @override
  String get employeeRoleFieldLabel => 'Сотрудник / Руководитель';

  @override
  String get employeeUsePin => 'Включить PIN';

  @override
  String get employeeUseNfc => 'Включить NFC';

  @override
  String get employeeAccessToken => 'Токен доступа';

  @override
  String get employeePinStatus => 'Статус PIN';

  @override
  String employeePinStatusWithValue(String value) {
    return 'Статус PIN: $value';
  }

  @override
  String get employeeAccessNote => 'Заметки о доступе';

  @override
  String get employeeAccessTokenRequiredWhenNfc =>
      'Обязательно при включённом NFC.';

  @override
  String get employeeEmploymentType => 'Тип занятости';

  @override
  String get employeeWeeklyHours => 'Часов в неделю';

  @override
  String get employeeWeeklyHoursHint => '40';

  @override
  String get employeeEmail => 'E-mail';

  @override
  String get employeePhone => 'Телефон';

  @override
  String get employeeDepartment => 'Отдел';

  @override
  String get employeeJobTitle => 'Должность';

  @override
  String get employeeInternalComment => 'Внутренний комментарий';

  @override
  String get employeePolicyAcknowledged => 'Политика подтверждена';

  @override
  String get employeePolicyAcknowledgedAt => 'Подтверждено';

  @override
  String employeePolicyAcknowledgedAtWithValue(String value) {
    return 'Подтверждено: $value';
  }

  @override
  String get employeeDataRetentionPolicy => 'Политика хранения данных';

  @override
  String get employeeCreatedAt => 'Создано';

  @override
  String employeeCreatedAtWithValue(String value) {
    return 'Создано: $value';
  }

  @override
  String get employeeUpdatedAt => 'Обновлено';

  @override
  String employeeUpdatedAtWithValue(String value) {
    return 'Обновлено: $value';
  }

  @override
  String get employeeCreatedBy => 'Создано';

  @override
  String get employeeUpdatedBy => 'Обновлено';

  @override
  String get employeePinStatusSet => 'Установлен';

  @override
  String get employeePinStatusNotSet => 'Не установлен';

  @override
  String get employeeRoleEmployee => 'Сотрудник';

  @override
  String get employeeRoleManager => 'Руководитель';

  @override
  String get employeeEmploymentTypeFullTime => 'Полная занятость';

  @override
  String get employeeEmploymentTypePartTime => 'Частичная занятость';

  @override
  String get employeeEmploymentTypeMinijob => 'Мини-занятость';

  @override
  String get employeeEmploymentTypeCustom => 'Иное';

  @override
  String get employeeTerminalAccessDisabled => 'Доступ к терминалу отключён';

  @override
  String get employeeInactive => 'Сотрудник неактивен';

  @override
  String get employeeCodeAlreadyExists => 'Код сотрудника уже существует';

  @override
  String get employeePolicyText =>
      'Сотрудник ознакомился с Политикой конфиденциальности и Условиями использования';

  @override
  String get employeePolicyPrefix => 'Сотрудник ознакомился с ';

  @override
  String get employeePolicyLinkPrivacy => 'Политикой конфиденциальности';

  @override
  String get employeePolicyMiddle => ' и ';

  @override
  String get employeePolicyLinkTerms => 'Условиями использования';

  @override
  String get employeeSetPin => 'Установить PIN';

  @override
  String get employeeResetPin => 'Сбросить PIN';

  @override
  String employeeFieldLabelWithRequired(String label) {
    return '$label *';
  }

  @override
  String get employeeSectionIdentity => 'Данные';

  @override
  String get employeeSectionBasicInfo => 'Основные данные';

  @override
  String get employeeSectionEmployment => 'Трудоустройство';

  @override
  String get employeeSectionContact => 'Контакт';

  @override
  String get employeeSectionAccess => 'Доступ к терминалу';

  @override
  String get employeeSectionSchedule => 'Расписание';

  @override
  String get employeeScheduleRequired => 'Укажите расписание.';

  @override
  String get employeeSectionPolicy => 'Политика и соответствие';

  @override
  String get employeeSectionAudit => 'Запись';

  @override
  String get employeeTabGeneral => 'Общие';

  @override
  String get employeeTabContact => 'Контакт';

  @override
  String get employeeTabTerminalAccess => 'Доступ к терминалу';

  @override
  String get employeeTabAdditional => 'Дополнительно';

  @override
  String get schedulesEmptyHint => 'Создайте шаблон расписания.';

  @override
  String schedulesFailedLoad(String error) {
    return 'Не удалось загрузить расписания: $error';
  }

  @override
  String get schedulesTitle => 'Расписания';

  @override
  String get schedulesAddTemplateTooltip => 'Добавить шаблон';

  @override
  String get schedulesNoTemplates => 'Нет шаблонов.';

  @override
  String get schedulesCreateTemplateTitle => 'Создать шаблон';

  @override
  String get schedulesRenameTemplateTitle => 'Переименовать шаблон';

  @override
  String get schedulesTemplateNameLabel => 'Название';

  @override
  String get schedulesWeekEditorTitle => 'Редактор недели';

  @override
  String schedulesFailedLoadTemplate(String error) {
    return 'Не удалось загрузить шаблон: $error';
  }

  @override
  String get schedulesDayOff => 'Выходной';

  @override
  String get schedulesNoIntervals => 'Нет интервалов.';

  @override
  String get schedulesAddInterval => 'Добавить интервал';

  @override
  String get schedulesSaved => 'Сохранено.';

  @override
  String schedulesCopiedTo(String weekday) {
    return 'Скопировано на $weekday.';
  }

  @override
  String get schedulesInvalidInput => 'Некорректный ввод.';

  @override
  String get schedulesBreadcrumb => 'Админ / Расписания';

  @override
  String get schedulesNewSchedule => 'Новое расписание';

  @override
  String get schedulesEditIntervalTitle => 'Редактировать интервал';

  @override
  String get schedulesAddIntervalTitle => 'Добавить интервал';

  @override
  String get schedulesStartTimeLabel => 'Время начала';

  @override
  String get schedulesEndTimeLabel => 'Время окончания';

  @override
  String get schedulesDiscardChanges => 'Отменить';

  @override
  String get schedulesUnsavedChangesTitle => 'Несохранённые изменения';

  @override
  String get schedulesUnsavedChangesMessage =>
      'У вас есть несохранённые изменения. Сохранить, отменить или остаться?';

  @override
  String schedulesSaveFailed(String reason) {
    return 'Не удалось сохранить: $reason';
  }

  @override
  String schedulesTotalHours(String hours) {
    return 'Всего $hours ч';
  }

  @override
  String get schedulesIntervalOverlapError =>
      'Этот интервал пересекается с другим.';

  @override
  String get schedulesIntervalEndBeforeStartError =>
      'Время окончания должно быть позже времени начала.';

  @override
  String get schedulesScheduleActiveSuffix => ' (Активно)';

  @override
  String get schedulesScheduleInactiveSuffix => ' (Неактивно)';

  @override
  String get schedulesRenameScheduleTooltip => 'Переименовать расписание';

  @override
  String get schedulesNameAlreadyExistsError =>
      'Такое название уже существует.';

  @override
  String get schedulesNameRequiredError => 'Название обязательно.';

  @override
  String get schedulesDeleteScheduleTooltip => 'Удалить расписание';

  @override
  String get schedulesDeleteScheduleTitle => 'Удалить расписание?';

  @override
  String get schedulesDeleteScheduleMessage =>
      'Шаблон расписания будет удалён. У назначенных сотрудников не останется расписания по умолчанию.';

  @override
  String get schedulesDeleteScheduleButton => 'Удалить';

  @override
  String schedulesDeleteFailed(String reason) {
    return 'Не удалось удалить: $reason';
  }

  @override
  String get schedulesDeleteBlockedAssignedTitle => 'Удалить невозможно';

  @override
  String get schedulesDeleteBlockedAssignedMessage =>
      'Расписание назначено сотрудникам. Снимите назначение перед удалением.';

  @override
  String intervalStart(String time) {
    return 'Начало: $time';
  }

  @override
  String intervalEnd(String time) {
    return 'Конец: $time';
  }

  @override
  String get intervalRemoveTooltip => 'Удалить';

  @override
  String get weekdayMonday => 'Понедельник';

  @override
  String get weekdayTuesday => 'Вторник';

  @override
  String get weekdayWednesday => 'Среда';

  @override
  String get weekdayThursday => 'Четверг';

  @override
  String get weekdayFriday => 'Пятница';

  @override
  String get weekdaySaturday => 'Суббота';

  @override
  String get weekdaySunday => 'Воскресенье';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguageLabel => 'Язык';

  @override
  String get settingsLanguageSystem => 'Как в системе';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsThemeLabel => 'Тема';

  @override
  String get settingsThemeSystem => 'Как в системе';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeHighContrastLight => 'Контрастная (светлая)';

  @override
  String get settingsThemeHighContrastDark => 'Контрастная (тёмная)';

  @override
  String get settingsAttendanceModeLabel => 'Режим учёта';

  @override
  String get settingsAttendanceModeFlexible => 'Гибкий';

  @override
  String get settingsAttendanceModeFixed => 'Фиксированный';

  @override
  String get settingsAttendanceToleranceLabel => 'Допуск (минуты)';

  @override
  String get settingsAttendanceModeChangeConfirmTitle =>
      'Изменить режим учёта?';

  @override
  String get settingsAttendanceModeChangeConfirmMessage =>
      'Это повлияет на отметки прихода и ухода в терминале для всех сотрудников.';

  @override
  String get settingsWorkingHoursLabel => 'Рабочее время';

  @override
  String get settingsWorkingHoursFrom => 'С';

  @override
  String get settingsWorkingHoursTo => 'До';

  @override
  String get settingsWorkingHoursInvalidRange =>
      'Время «с» должно быть раньше «до»';

  @override
  String settingsWorkingHoursFromWithValue(String value) {
    return 'С: $value';
  }

  @override
  String settingsWorkingHoursToWithValue(String value) {
    return 'До: $value';
  }

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get settingsCreateBackup => 'Создать резервную копию';

  @override
  String settingsBackupCreated(String path) {
    return 'Резервная копия создана: $path';
  }

  @override
  String get settingsBackupSuccessTitle => 'Резервная копия успешно создана';

  @override
  String get settingsRestoreCompletedTitle => 'База данных восстановлена';

  @override
  String get settingsRestoreCompletedMessage =>
      'База данных была восстановлена из резервной копии. Нажмите OK для продолжения.';

  @override
  String get settingsBackupErrorPermissionDenied =>
      'Нет доступа к файлу или папке.';

  @override
  String get settingsBackupErrorNotFound => 'Файл или папка не найдены.';

  @override
  String get settingsBackupErrorInvalidArchive =>
      'Недопустимый файл резервной копии.';

  @override
  String get settingsBackupErrorIoFailure => 'Ошибка при операции с файлом.';

  @override
  String get settingsBackupErrorDbFailure => 'Ошибка базы данных.';

  @override
  String get settingsBackupErrorUnknown => 'Произошла неизвестная ошибка.';

  @override
  String get settingsRestoreFromBackup => 'Восстановить из резервной копии';

  @override
  String get settingsRestoreConfirmTitle => 'Восстановление';

  @override
  String get settingsRestoreConfirmMessage =>
      'Текущие данные будут полностью заменены данными из выбранного файла. Продолжить?';

  @override
  String get settingsRestoreCreated =>
      'Восстановление выполнено. Обновите экран при необходимости.';

  @override
  String get settingsRestoreScheduledRestart =>
      'Восстановление запланировано. Перезапустите приложение для завершения.';

  @override
  String get settingsRestoreErrorPermissionDenied =>
      'Нет доступа к файлу или папке.';

  @override
  String get settingsRestoreErrorNotFound => 'Файл или папка не найдены.';

  @override
  String get settingsRestoreErrorInvalidArchive =>
      'Недопустимый файл резервной копии.';

  @override
  String get settingsRestoreErrorIoFailure => 'Ошибка при операции с файлом.';

  @override
  String get settingsRestoreErrorDbFailure => 'Ошибка базы данных.';

  @override
  String get settingsRestoreErrorUnknown => 'Произошла неизвестная ошибка.';

  @override
  String get settingsRestoreSchemaError =>
      'Файл создан в другой версии приложения. Восстановление невозможно.';

  @override
  String get settingsExportDiagnostics => 'Экспорт диагностики';

  @override
  String get settingsExportDiagnosticsSuccess =>
      'Диагностика успешно экспортирована';

  @override
  String settingsExportDiagnosticsFailed(String error) {
    return 'Ошибка экспорта диагностики: $error';
  }

  @override
  String get legalTerms => 'Условия использования';

  @override
  String get helpTitle => 'Справка';

  @override
  String get aboutTitle => 'О программе';

  @override
  String get legalNoticeWelcomeTitle => 'Добро пожаловать';

  @override
  String get legalNoticeWelcomeText =>
      'Пожалуйста, ознакомьтесь с Политикой конфиденциальности и Условиями использования.';

  @override
  String get legalNoticeOpenPrivacy => 'Открыть Политику конфиденциальности';

  @override
  String get legalNoticeOpenTerms => 'Открыть Условия использования';

  @override
  String get legalNoticeClose => 'Закрыть';

  @override
  String get legalCopy => 'Копировать';

  @override
  String get legalCopiedToClipboard => 'Скопировано в буфер обмена.';

  @override
  String get legalFailedToCopy => 'Не удалось скопировать.';

  @override
  String get sessionsTitle => 'Смены';

  @override
  String get sessionsEmployeeFilter => 'Сотрудник';

  @override
  String get sessionsEmployeeAll => 'Все';

  @override
  String get sessionsNoEmployeesAvailable => 'Нет доступных сотрудников.';

  @override
  String sessionsFailedLoadEmployees(String error) {
    return 'Не удалось загрузить сотрудников: $error';
  }

  @override
  String get sessionsFilterFrom => 'С';

  @override
  String get sessionsFilterTo => 'По';

  @override
  String get sessionsFilterAny => 'Любое';

  @override
  String get sessionsNoSessions => 'Нет смен.';

  @override
  String sessionsFailedLoadSessions(String error) {
    return 'Не удалось загрузить смены: $error';
  }

  @override
  String get sessionsTableEmployee => 'Сотрудник';

  @override
  String get sessionsTableStart => 'Начало';

  @override
  String get sessionsTableEnd => 'Конец';

  @override
  String get sessionsTableDuration => 'Длительность';

  @override
  String sessionsDurationWithValue(String value) {
    return 'Длительность: $value';
  }

  @override
  String get sessionsTableStatus => 'Статус';

  @override
  String get sessionsTableNote => 'Заметка';

  @override
  String get sessionsTableActions => 'Действия';

  @override
  String get sessionsEdit => 'Редактировать';

  @override
  String get sessionsEditDialogTitle => 'Редактировать смену';

  @override
  String sessionsEmployeePrefix(String name) {
    return 'Сотрудник: $name';
  }

  @override
  String sessionsStartPrefix(String value) {
    return 'Начало: $value';
  }

  @override
  String sessionsEndPrefix(String value) {
    return 'Конец: $value';
  }

  @override
  String get sessionsOpenSessionLabel => 'Открытая смена (конец пустой)';

  @override
  String get sessionsSetEndNow => 'Конец = сейчас';

  @override
  String get sessionsClearEnd => 'Очистить конец';

  @override
  String get sessionsUpdateReason => 'Причина изменения';

  @override
  String get sessionsEmployeeCannotChangeHint => 'Сотрудника нельзя менять.';

  @override
  String get sessionsUpdateReasonRequired => 'Причина изменения обязательна.';

  @override
  String get sessionsErrorSameDayRequired =>
      'Сессия должна начинаться и заканчиваться в один день.';

  @override
  String get journalTitle => 'Журнал';

  @override
  String get journalFilterFrom => 'С';

  @override
  String get journalFilterTo => 'По';

  @override
  String get journalFilterAny => 'Любое';

  @override
  String get journalFilterStatusAll => 'Все';

  @override
  String get journalFilterStatusOpen => 'Открытые';

  @override
  String get journalFilterStatusClosed => 'Закрытые';

  @override
  String get journalFilterSearch => 'Поиск';

  @override
  String get journalFilterEmployee => 'Сотрудник';

  @override
  String get journalScopeDay => 'День';

  @override
  String get journalScopeWeek => 'Неделя';

  @override
  String get journalScopeMonth => 'Месяц';

  @override
  String get journalScopeInterval => 'Интервал';

  @override
  String get journalPresetToday => 'Сегодня';

  @override
  String get journalPresetWeek => 'Неделя';

  @override
  String get journalPresetMonth => 'Месяц';

  @override
  String get journalPresetLastMonth => 'Прошлый месяц';

  @override
  String get journalEndEmpty => '—';

  @override
  String get journalEditDialogTitle => 'Редактировать смену';

  @override
  String get journalCloseNow => 'Закрыть сейчас';

  @override
  String get journalErrorEndBeforeStart =>
      'Время конца должно быть позже времени начала.';

  @override
  String get journalErrorCrossDay => 'Начало и конец должны быть в один день.';

  @override
  String get journalUpdateReasonHint =>
      'Обязательно при изменении времени начала или конца';

  @override
  String get journalSaved => 'Сохранено.';

  @override
  String get journalViewTable => 'Таблица';

  @override
  String get journalViewTimeline => 'Временная шкала';

  @override
  String get journalViewDetailed => 'По интервалам';

  @override
  String get journalIntervalLegendWork => 'Работа';

  @override
  String get journalIntervalLegendApprovedAbsence => 'Утверждённое отсутствие';

  @override
  String get journalIntervalLegendOngoing => 'Идёт';

  @override
  String get journalTimelineStateOngoing => 'Работа идёт';

  @override
  String get journalTimelineStatePresent => 'Присутствует';

  @override
  String get journalTimelineStateApprovedAbsence => 'Утверждённое отсутствие';

  @override
  String get journalTimelineStateExpectedNoShow => 'Ожидался, не отметился';

  @override
  String get journalTimelineStateNoData => 'Нет данных';

  @override
  String get journalTimelinePickRangeHint =>
      'Выберите диапазон дат для вида по дням.';

  @override
  String get journalNavPrev => 'Назад';

  @override
  String get journalNavNext => 'Вперёд';

  @override
  String get journalIntervalNow => 'сейчас';

  @override
  String journalIntervalDurationMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get reportsTitle => 'Отчёты';

  @override
  String get reportsNoData => 'Нет данных.';

  @override
  String reportsFailedLoad(String error) {
    return 'Не удалось загрузить отчёт: $error';
  }

  @override
  String get reportsOnlyClosedHint => 'В итоги входят только ЗАКРЫТЫЕ смены.';

  @override
  String get reportsTableEmployee => 'Сотрудник';

  @override
  String get reportsTableTotal => 'Итого';

  @override
  String get reportsTableNorm => 'Норма';

  @override
  String get reportsTableDelta => 'Дельта';

  @override
  String get reportsTableSessions => 'Смены';

  @override
  String get reportsExportPdf => 'Экспорт PDF';

  @override
  String get reportsPdfFileType => 'PDF-файлы';

  @override
  String get reportsExported => 'Экспортировано.';

  @override
  String get reportsTableWorked => 'Отработано';

  @override
  String get reportsTablePlanned => 'План';

  @override
  String get reportsTableBalance => 'Баланс (+/−)';

  @override
  String get reportsPlannedNoSchedule => 'Нет графика';

  @override
  String get reportsPeriodLabel => 'Период';

  @override
  String get reportsPeriodPresetToday => 'Сегодня';

  @override
  String get reportsPeriodPresetWeek => 'Неделя';

  @override
  String get reportsPeriodPresetMonth => 'Месяц';

  @override
  String get reportsPeriodPresetLastMonth => 'Прошлый месяц';

  @override
  String get reportsPeriodPresetCustom => 'Произвольный';

  @override
  String get reportsEmployeeFilter => 'Сотрудник';

  @override
  String get reportsDetailsTitle => 'Детали';

  @override
  String get reportsExportEmployeePdf => 'Экспорт PDF';

  @override
  String get reportsDetailsClose => 'Закрыть';

  @override
  String get reportsTableDate => 'Дата';

  @override
  String get reportsPdfTitle => 'Отчёт по времени';

  @override
  String reportsPdfPeriod(String from, String to) {
    return 'Период: $from — $to';
  }

  @override
  String reportsPdfGenerated(String datetime) {
    return 'Создан: $datetime';
  }

  @override
  String reportsPdfEmployee(String name) {
    return 'Сотрудник: $name';
  }

  @override
  String reportsPdfSort(String column) {
    return 'Сортировка: $column';
  }

  @override
  String get reportsPdfFooterBrand => 'Timerevo — офлайн-отчёт';

  @override
  String reportsPdfFooterPage(int current, int total) {
    return 'Стр. $current / $total';
  }

  @override
  String get adminNavAbsences => 'Отсутствия';

  @override
  String get absencesTitle => 'Отсутствия';

  @override
  String get absencesAdd => 'Добавить отсутствие';

  @override
  String get absencesEmployee => 'Сотрудник';

  @override
  String get absencesType => 'Тип';

  @override
  String get absencesDateFrom => 'С';

  @override
  String get absencesDateTo => 'По';

  @override
  String get absencesStatus => 'Статус';

  @override
  String get absencesCreatedBy => 'Создал';

  @override
  String get absencesActions => 'Действия';

  @override
  String get absenceTypeVacation => 'Ежегодный отпуск';

  @override
  String get absenceTypeSickLeave => 'Больничный';

  @override
  String get absenceTypeUnpaidLeave => 'Без сохранения';

  @override
  String get absenceTypeParentalLeave => 'Декретный/уход';

  @override
  String get absenceTypeStudyLeave => 'Учебный отпуск';

  @override
  String get absenceTypeOther => 'Другое';

  @override
  String get absenceStatusPending => 'На рассмотрении';

  @override
  String get absenceStatusApproved => 'Одобрено';

  @override
  String get absenceStatusRejected => 'Отклонено';

  @override
  String get absenceApprove => 'Одобрить';

  @override
  String get absenceReject => 'Отклонить';

  @override
  String get absenceEdit => 'Редактировать';

  @override
  String get absenceDelete => 'Удалить';

  @override
  String get absenceRejectReason => 'Причина отклонения';

  @override
  String get terminalMyCalendar => 'Мой рабочий календарь';

  @override
  String get terminalMyPdf => 'Отчёт времени (PDF)';

  @override
  String terminalCalendarPageTitle(String name) {
    return 'Рабочий календарь ($name)';
  }

  @override
  String get terminalCalendarSessions => 'Смены';

  @override
  String get terminalCalendarAbsences => 'Отсутствия';

  @override
  String get terminalCalendarNoData => 'Нет данных за день';

  @override
  String get terminalCalendarNewAbsence => 'Новая заявка';

  @override
  String get terminalCalendarFormatMonth => 'Месяц';

  @override
  String get terminalCalendarFormatTwoWeeks => '2 недели';

  @override
  String get terminalCalendarFormatWeek => 'Неделя';

  @override
  String get absenceCreateTitle => 'Новая заявка на отсутствие';

  @override
  String get absenceEditTitle => 'Редактировать отсутствие';

  @override
  String get absenceErrorOverlap => 'Пересечение с существующим отсутствием.';

  @override
  String get absenceErrorDateRestrictionVacation =>
      'Отпуск должен начинаться сегодня или позже.';

  @override
  String get absenceErrorDateRestrictionSickLeave =>
      'Больничный не может начинаться более чем 3 дня назад.';

  @override
  String get absencesEmpty => 'Нет заявок на отсутствие.';

  @override
  String get absencesEmptyHint => 'Заявок пока нет. Создайте первую заявку.';

  @override
  String get absenceDeleteConfirm => 'Удалить эту заявку на отсутствие?';

  @override
  String get absenceApproveConfirm => 'Одобрить эту заявку на отсутствие?';

  @override
  String get absenceRejectConfirmHint => 'Сотрудник увидит причину отклонения.';

  @override
  String get absenceCreated => 'Заявка на отсутствие создана.';

  @override
  String get absenceUpdated => 'Заявка на отсутствие обновлена.';

  @override
  String get absenceApproved => 'Заявка на отсутствие одобрена.';

  @override
  String get absenceRejected => 'Заявка на отсутствие отклонена.';

  @override
  String get absenceDeleted => 'Заявка на отсутствие удалена.';

  @override
  String get absencesApprovedBy => 'Одобрил';

  @override
  String get absencesApprovedAt => 'Дата одобрения';

  @override
  String get absenceErrorEditPendingOnly =>
      'Редактировать можно только заявки на рассмотрении.';

  @override
  String get absenceErrorDeletePendingOnly =>
      'Удалить можно только заявки на рассмотрении.';

  @override
  String get absenceErrorApproveRejectPendingOnly =>
      'Одобрять или отклонять можно только заявки на рассмотрении.';

  @override
  String get absenceErrorRejectReasonRequired => 'Укажите причину отклонения.';

  @override
  String get absenceErrorDateOrder =>
      'Дата окончания должна быть не раньше даты начала.';

  @override
  String get absenceErrorEmployeeRequired => 'Выберите сотрудника.';

  @override
  String get absenceErrorDateRequired => 'Укажите даты «От» и «До».';
}
