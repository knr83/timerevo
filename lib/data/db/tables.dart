import 'package:drift/drift.dart';

class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();

  TextColumn get status => text()
      .named('status')
      .withDefault(const Constant('active'))
      .customConstraint(
        "NOT NULL CHECK (status IN ('active','inactive','archived'))",
      )();

  IntColumn get terminationDate =>
      integer().named('termination_date').nullable()();

  IntColumn get deletedAt => integer().named('deleted_at').nullable()();

  IntColumn get vacationDaysPerYear =>
      integer().named('vacation_days_per_year').nullable()();

  TextColumn get secondaryPhone => text().named('secondary_phone').nullable()();

  IntColumn get hireDate => integer().named('hire_date').nullable()();

  TextColumn get employeeRole =>
      text().named('employee_role').withDefault(const Constant('employee'))();

  IntColumn get usePin =>
      integer().named('use_pin').withDefault(const Constant(0))();

  IntColumn get useNfc =>
      integer().named('use_nfc').withDefault(const Constant(0))();

  TextColumn get accessToken => text().named('access_token').nullable()();

  TextColumn get accessNote => text().named('access_note').nullable()();

  TextColumn get employmentType => text().named('employment_type').nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get phone => text().nullable()();

  TextColumn get department => text().nullable()();

  TextColumn get jobTitle => text().named('job_title').nullable()();

  TextColumn get internalComment =>
      text().named('internal_comment').nullable()();

  IntColumn get policyAcknowledged =>
      integer().named('policy_acknowledged').withDefault(const Constant(0))();

  IntColumn get policyAcknowledgedAt =>
      integer().named('policy_acknowledged_at').nullable()();

  IntColumn get createdAt => integer().named('created_at')();

  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  TextColumn get createdBy => text().named('created_by').nullable()();

  TextColumn get updatedBy => text().named('updated_by').nullable()();

  IntColumn get startingBalanceTenths =>
      integer().named('starting_balance_tenths').nullable()();

  IntColumn get startingBalanceUpdatedAt =>
      integer().named('starting_balance_updated_at').nullable()();

  TextColumn get startingBalanceUpdatedBy =>
      text().named('starting_balance_updated_by').nullable()();
}

class EmployeeAuths extends Table {
  IntColumn get employeeId =>
      integer().named('employee_id').references(Employees, #id)();

  TextColumn get pinHash => text().named('pin_hash')();

  BlobColumn get pinSalt => blob().named('pin_salt')();

  IntColumn get pinUpdatedAt => integer().named('pin_updated_at')();

  @override
  Set<Column> get primaryKey => {employeeId};
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get username => text().unique()();

  TextColumn get passwordHash => text().named('password_hash')();

  TextColumn get role => text().customConstraint(
    "NOT NULL CHECK (role IN ('ADMIN','OPERATOR'))",
  )();

  IntColumn get isActive =>
      integer().named('is_active').withDefault(const Constant(1))();

  IntColumn get createdAt => integer().named('created_at')();
}

class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get location => text().nullable()();

  IntColumn get isActive =>
      integer().named('is_active').withDefault(const Constant(1))();

  IntColumn get createdAt => integer().named('created_at')();
}

class WorkSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get employeeId =>
      integer().named('employee_id').references(Employees, #id)();

  IntColumn get deviceId =>
      integer().named('device_id').nullable().references(Devices, #id)();

  IntColumn get startTs => integer().named('start_ts')();

  IntColumn get endTs => integer().named('end_ts').nullable()();

  TextColumn get status =>
      text().customConstraint("NOT NULL CHECK (status IN ('OPEN','CLOSED'))")();

  TextColumn get source => text().customConstraint(
    "NOT NULL CHECK (source IN ('terminal','admin','import'))",
  )();

  TextColumn get note => text().nullable()();

  // Audit fields
  IntColumn get createdAt => integer().named('created_at')();
  TextColumn get createdBy => text().named('created_by').nullable()();

  IntColumn get updatedAt => integer().named('updated_at').nullable()();
  TextColumn get updatedBy => text().named('updated_by').nullable()();

  TextColumn get updateReason => text().named('update_reason').nullable()();

  /// UTC ms when the session was canceled (excluded from totals). Null = active.
  IntColumn get canceledAt => integer().named('canceled_at').nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK (end_ts IS NULL OR end_ts >= start_ts)',
    "CHECK ((status = 'OPEN' AND end_ts IS NULL) OR (status = 'CLOSED' AND end_ts IS NOT NULL))",
  ];
}

class ShiftScheduleTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().unique()();

  IntColumn get isActive =>
      integer().named('is_active').withDefault(const Constant(1))();

  IntColumn get createdAt => integer().named('created_at')();
}

class ShiftScheduleTemplateDays extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get templateId =>
      integer().named('template_id').references(ShiftScheduleTemplates, #id)();

  IntColumn get weekday => integer()();

  IntColumn get isDayOff =>
      integer().named('is_day_off').withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {templateId, weekday},
  ];
}

class ShiftScheduleTemplateIntervals extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get templateDayId => integer()
      .named('template_day_id')
      .references(ShiftScheduleTemplateDays, #id)();

  IntColumn get startMin => integer().named('start_min')();
  IntColumn get endMin => integer().named('end_min')();

  IntColumn get crossesMidnight =>
      integer().named('crosses_midnight').withDefault(const Constant(0))();
}

class EmployeeScheduleAssignments extends Table {
  IntColumn get employeeId =>
      integer().named('employee_id').references(Employees, #id)();

  IntColumn get templateId =>
      integer().named('template_id').references(ShiftScheduleTemplates, #id)();

  IntColumn get createdAt => integer().named('created_at')();

  @override
  Set<Column> get primaryKey => {employeeId};
}

class Absences extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get employeeId =>
      integer().named('employee_id').references(Employees, #id)();

  TextColumn get dateFrom => text().named('date_from')();
  TextColumn get dateTo => text().named('date_to')();

  TextColumn get type => text().customConstraint(
    "NOT NULL CHECK (type IN ('vacation','sick_leave','unpaid_leave','parental_leave','study_leave','other'))",
  )();

  TextColumn get note => text().nullable()();

  TextColumn get status => text().customConstraint(
    "NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED'))",
  )();

  IntColumn get createdAt => integer().named('created_at')();

  IntColumn get createdByEmployeeId => integer()
      .named('created_by_employee_id')
      .nullable()
      .references(Employees, #id)();

  IntColumn get approvedAt => integer().named('approved_at').nullable()();

  TextColumn get approvedBy => text().named('approved_by').nullable()();

  TextColumn get rejectReason => text().named('reject_reason').nullable()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
