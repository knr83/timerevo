// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL CHECK (status IN (\'active\',\'inactive\',\'archived\'))',
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _terminationDateMeta = const VerificationMeta(
    'terminationDate',
  );
  @override
  late final GeneratedColumn<int> terminationDate = GeneratedColumn<int>(
    'termination_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vacationDaysPerYearMeta =
      const VerificationMeta('vacationDaysPerYear');
  @override
  late final GeneratedColumn<int> vacationDaysPerYear = GeneratedColumn<int>(
    'vacation_days_per_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _secondaryPhoneMeta = const VerificationMeta(
    'secondaryPhone',
  );
  @override
  late final GeneratedColumn<String> secondaryPhone = GeneratedColumn<String>(
    'secondary_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hireDateMeta = const VerificationMeta(
    'hireDate',
  );
  @override
  late final GeneratedColumn<int> hireDate = GeneratedColumn<int>(
    'hire_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeRoleMeta = const VerificationMeta(
    'employeeRole',
  );
  @override
  late final GeneratedColumn<String> employeeRole = GeneratedColumn<String>(
    'employee_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('employee'),
  );
  static const VerificationMeta _usePinMeta = const VerificationMeta('usePin');
  @override
  late final GeneratedColumn<int> usePin = GeneratedColumn<int>(
    'use_pin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _useNfcMeta = const VerificationMeta('useNfc');
  @override
  late final GeneratedColumn<int> useNfc = GeneratedColumn<int>(
    'use_nfc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessNoteMeta = const VerificationMeta(
    'accessNote',
  );
  @override
  late final GeneratedColumn<String> accessNote = GeneratedColumn<String>(
    'access_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employmentTypeMeta = const VerificationMeta(
    'employmentType',
  );
  @override
  late final GeneratedColumn<String> employmentType = GeneratedColumn<String>(
    'employment_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _internalCommentMeta = const VerificationMeta(
    'internalComment',
  );
  @override
  late final GeneratedColumn<String> internalComment = GeneratedColumn<String>(
    'internal_comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _policyAcknowledgedMeta =
      const VerificationMeta('policyAcknowledged');
  @override
  late final GeneratedColumn<int> policyAcknowledged = GeneratedColumn<int>(
    'policy_acknowledged',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _policyAcknowledgedAtMeta =
      const VerificationMeta('policyAcknowledgedAt');
  @override
  late final GeneratedColumn<int> policyAcknowledgedAt = GeneratedColumn<int>(
    'policy_acknowledged_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    firstName,
    lastName,
    status,
    terminationDate,
    vacationDaysPerYear,
    secondaryPhone,
    hireDate,
    employeeRole,
    usePin,
    useNfc,
    accessToken,
    accessNote,
    employmentType,
    email,
    phone,
    department,
    jobTitle,
    internalComment,
    policyAcknowledged,
    policyAcknowledgedAt,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('termination_date')) {
      context.handle(
        _terminationDateMeta,
        terminationDate.isAcceptableOrUnknown(
          data['termination_date']!,
          _terminationDateMeta,
        ),
      );
    }
    if (data.containsKey('vacation_days_per_year')) {
      context.handle(
        _vacationDaysPerYearMeta,
        vacationDaysPerYear.isAcceptableOrUnknown(
          data['vacation_days_per_year']!,
          _vacationDaysPerYearMeta,
        ),
      );
    }
    if (data.containsKey('secondary_phone')) {
      context.handle(
        _secondaryPhoneMeta,
        secondaryPhone.isAcceptableOrUnknown(
          data['secondary_phone']!,
          _secondaryPhoneMeta,
        ),
      );
    }
    if (data.containsKey('hire_date')) {
      context.handle(
        _hireDateMeta,
        hireDate.isAcceptableOrUnknown(data['hire_date']!, _hireDateMeta),
      );
    }
    if (data.containsKey('employee_role')) {
      context.handle(
        _employeeRoleMeta,
        employeeRole.isAcceptableOrUnknown(
          data['employee_role']!,
          _employeeRoleMeta,
        ),
      );
    }
    if (data.containsKey('use_pin')) {
      context.handle(
        _usePinMeta,
        usePin.isAcceptableOrUnknown(data['use_pin']!, _usePinMeta),
      );
    }
    if (data.containsKey('use_nfc')) {
      context.handle(
        _useNfcMeta,
        useNfc.isAcceptableOrUnknown(data['use_nfc']!, _useNfcMeta),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('access_note')) {
      context.handle(
        _accessNoteMeta,
        accessNote.isAcceptableOrUnknown(data['access_note']!, _accessNoteMeta),
      );
    }
    if (data.containsKey('employment_type')) {
      context.handle(
        _employmentTypeMeta,
        employmentType.isAcceptableOrUnknown(
          data['employment_type']!,
          _employmentTypeMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    }
    if (data.containsKey('internal_comment')) {
      context.handle(
        _internalCommentMeta,
        internalComment.isAcceptableOrUnknown(
          data['internal_comment']!,
          _internalCommentMeta,
        ),
      );
    }
    if (data.containsKey('policy_acknowledged')) {
      context.handle(
        _policyAcknowledgedMeta,
        policyAcknowledged.isAcceptableOrUnknown(
          data['policy_acknowledged']!,
          _policyAcknowledgedMeta,
        ),
      );
    }
    if (data.containsKey('policy_acknowledged_at')) {
      context.handle(
        _policyAcknowledgedAtMeta,
        policyAcknowledgedAt.isAcceptableOrUnknown(
          data['policy_acknowledged_at']!,
          _policyAcknowledgedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      terminationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}termination_date'],
      ),
      vacationDaysPerYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vacation_days_per_year'],
      ),
      secondaryPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_phone'],
      ),
      hireDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hire_date'],
      ),
      employeeRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_role'],
      )!,
      usePin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_pin'],
      )!,
      useNfc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_nfc'],
      )!,
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      accessNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_note'],
      ),
      employmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employment_type'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      ),
      internalComment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_comment'],
      ),
      policyAcknowledged: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}policy_acknowledged'],
      )!,
      policyAcknowledgedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}policy_acknowledged_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String code;
  final String firstName;
  final String lastName;
  final String status;
  final int? terminationDate;
  final int? vacationDaysPerYear;
  final String? secondaryPhone;
  final int? hireDate;
  final String employeeRole;
  final int usePin;
  final int useNfc;
  final String? accessToken;
  final String? accessNote;
  final String? employmentType;
  final String? email;
  final String? phone;
  final String? department;
  final String? jobTitle;
  final String? internalComment;
  final int policyAcknowledged;
  final int? policyAcknowledgedAt;
  final int createdAt;
  final int? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  const Employee({
    required this.id,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.terminationDate,
    this.vacationDaysPerYear,
    this.secondaryPhone,
    this.hireDate,
    required this.employeeRole,
    required this.usePin,
    required this.useNfc,
    this.accessToken,
    this.accessNote,
    this.employmentType,
    this.email,
    this.phone,
    this.department,
    this.jobTitle,
    this.internalComment,
    required this.policyAcknowledged,
    this.policyAcknowledgedAt,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || terminationDate != null) {
      map['termination_date'] = Variable<int>(terminationDate);
    }
    if (!nullToAbsent || vacationDaysPerYear != null) {
      map['vacation_days_per_year'] = Variable<int>(vacationDaysPerYear);
    }
    if (!nullToAbsent || secondaryPhone != null) {
      map['secondary_phone'] = Variable<String>(secondaryPhone);
    }
    if (!nullToAbsent || hireDate != null) {
      map['hire_date'] = Variable<int>(hireDate);
    }
    map['employee_role'] = Variable<String>(employeeRole);
    map['use_pin'] = Variable<int>(usePin);
    map['use_nfc'] = Variable<int>(useNfc);
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || accessNote != null) {
      map['access_note'] = Variable<String>(accessNote);
    }
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<String>(employmentType);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    if (!nullToAbsent || jobTitle != null) {
      map['job_title'] = Variable<String>(jobTitle);
    }
    if (!nullToAbsent || internalComment != null) {
      map['internal_comment'] = Variable<String>(internalComment);
    }
    map['policy_acknowledged'] = Variable<int>(policyAcknowledged);
    if (!nullToAbsent || policyAcknowledgedAt != null) {
      map['policy_acknowledged_at'] = Variable<int>(policyAcknowledgedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      code: Value(code),
      firstName: Value(firstName),
      lastName: Value(lastName),
      status: Value(status),
      terminationDate: terminationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(terminationDate),
      vacationDaysPerYear: vacationDaysPerYear == null && nullToAbsent
          ? const Value.absent()
          : Value(vacationDaysPerYear),
      secondaryPhone: secondaryPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryPhone),
      hireDate: hireDate == null && nullToAbsent
          ? const Value.absent()
          : Value(hireDate),
      employeeRole: Value(employeeRole),
      usePin: Value(usePin),
      useNfc: Value(useNfc),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      accessNote: accessNote == null && nullToAbsent
          ? const Value.absent()
          : Value(accessNote),
      employmentType: employmentType == null && nullToAbsent
          ? const Value.absent()
          : Value(employmentType),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      jobTitle: jobTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(jobTitle),
      internalComment: internalComment == null && nullToAbsent
          ? const Value.absent()
          : Value(internalComment),
      policyAcknowledged: Value(policyAcknowledged),
      policyAcknowledgedAt: policyAcknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(policyAcknowledgedAt),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      status: serializer.fromJson<String>(json['status']),
      terminationDate: serializer.fromJson<int?>(json['terminationDate']),
      vacationDaysPerYear: serializer.fromJson<int?>(
        json['vacationDaysPerYear'],
      ),
      secondaryPhone: serializer.fromJson<String?>(json['secondaryPhone']),
      hireDate: serializer.fromJson<int?>(json['hireDate']),
      employeeRole: serializer.fromJson<String>(json['employeeRole']),
      usePin: serializer.fromJson<int>(json['usePin']),
      useNfc: serializer.fromJson<int>(json['useNfc']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      accessNote: serializer.fromJson<String?>(json['accessNote']),
      employmentType: serializer.fromJson<String?>(json['employmentType']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      department: serializer.fromJson<String?>(json['department']),
      jobTitle: serializer.fromJson<String?>(json['jobTitle']),
      internalComment: serializer.fromJson<String?>(json['internalComment']),
      policyAcknowledged: serializer.fromJson<int>(json['policyAcknowledged']),
      policyAcknowledgedAt: serializer.fromJson<int?>(
        json['policyAcknowledgedAt'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'status': serializer.toJson<String>(status),
      'terminationDate': serializer.toJson<int?>(terminationDate),
      'vacationDaysPerYear': serializer.toJson<int?>(vacationDaysPerYear),
      'secondaryPhone': serializer.toJson<String?>(secondaryPhone),
      'hireDate': serializer.toJson<int?>(hireDate),
      'employeeRole': serializer.toJson<String>(employeeRole),
      'usePin': serializer.toJson<int>(usePin),
      'useNfc': serializer.toJson<int>(useNfc),
      'accessToken': serializer.toJson<String?>(accessToken),
      'accessNote': serializer.toJson<String?>(accessNote),
      'employmentType': serializer.toJson<String?>(employmentType),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'department': serializer.toJson<String?>(department),
      'jobTitle': serializer.toJson<String?>(jobTitle),
      'internalComment': serializer.toJson<String?>(internalComment),
      'policyAcknowledged': serializer.toJson<int>(policyAcknowledged),
      'policyAcknowledgedAt': serializer.toJson<int?>(policyAcknowledgedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'updatedBy': serializer.toJson<String?>(updatedBy),
    };
  }

  Employee copyWith({
    int? id,
    String? code,
    String? firstName,
    String? lastName,
    String? status,
    Value<int?> terminationDate = const Value.absent(),
    Value<int?> vacationDaysPerYear = const Value.absent(),
    Value<String?> secondaryPhone = const Value.absent(),
    Value<int?> hireDate = const Value.absent(),
    String? employeeRole,
    int? usePin,
    int? useNfc,
    Value<String?> accessToken = const Value.absent(),
    Value<String?> accessNote = const Value.absent(),
    Value<String?> employmentType = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> department = const Value.absent(),
    Value<String?> jobTitle = const Value.absent(),
    Value<String?> internalComment = const Value.absent(),
    int? policyAcknowledged,
    Value<int?> policyAcknowledgedAt = const Value.absent(),
    int? createdAt,
    Value<int?> updatedAt = const Value.absent(),
    Value<String?> createdBy = const Value.absent(),
    Value<String?> updatedBy = const Value.absent(),
  }) => Employee(
    id: id ?? this.id,
    code: code ?? this.code,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    status: status ?? this.status,
    terminationDate: terminationDate.present
        ? terminationDate.value
        : this.terminationDate,
    vacationDaysPerYear: vacationDaysPerYear.present
        ? vacationDaysPerYear.value
        : this.vacationDaysPerYear,
    secondaryPhone: secondaryPhone.present
        ? secondaryPhone.value
        : this.secondaryPhone,
    hireDate: hireDate.present ? hireDate.value : this.hireDate,
    employeeRole: employeeRole ?? this.employeeRole,
    usePin: usePin ?? this.usePin,
    useNfc: useNfc ?? this.useNfc,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    accessNote: accessNote.present ? accessNote.value : this.accessNote,
    employmentType: employmentType.present
        ? employmentType.value
        : this.employmentType,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    department: department.present ? department.value : this.department,
    jobTitle: jobTitle.present ? jobTitle.value : this.jobTitle,
    internalComment: internalComment.present
        ? internalComment.value
        : this.internalComment,
    policyAcknowledged: policyAcknowledged ?? this.policyAcknowledged,
    policyAcknowledgedAt: policyAcknowledgedAt.present
        ? policyAcknowledgedAt.value
        : this.policyAcknowledgedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
  );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      status: data.status.present ? data.status.value : this.status,
      terminationDate: data.terminationDate.present
          ? data.terminationDate.value
          : this.terminationDate,
      vacationDaysPerYear: data.vacationDaysPerYear.present
          ? data.vacationDaysPerYear.value
          : this.vacationDaysPerYear,
      secondaryPhone: data.secondaryPhone.present
          ? data.secondaryPhone.value
          : this.secondaryPhone,
      hireDate: data.hireDate.present ? data.hireDate.value : this.hireDate,
      employeeRole: data.employeeRole.present
          ? data.employeeRole.value
          : this.employeeRole,
      usePin: data.usePin.present ? data.usePin.value : this.usePin,
      useNfc: data.useNfc.present ? data.useNfc.value : this.useNfc,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      accessNote: data.accessNote.present
          ? data.accessNote.value
          : this.accessNote,
      employmentType: data.employmentType.present
          ? data.employmentType.value
          : this.employmentType,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      department: data.department.present
          ? data.department.value
          : this.department,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      internalComment: data.internalComment.present
          ? data.internalComment.value
          : this.internalComment,
      policyAcknowledged: data.policyAcknowledged.present
          ? data.policyAcknowledged.value
          : this.policyAcknowledged,
      policyAcknowledgedAt: data.policyAcknowledgedAt.present
          ? data.policyAcknowledgedAt.value
          : this.policyAcknowledgedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('status: $status, ')
          ..write('terminationDate: $terminationDate, ')
          ..write('vacationDaysPerYear: $vacationDaysPerYear, ')
          ..write('secondaryPhone: $secondaryPhone, ')
          ..write('hireDate: $hireDate, ')
          ..write('employeeRole: $employeeRole, ')
          ..write('usePin: $usePin, ')
          ..write('useNfc: $useNfc, ')
          ..write('accessToken: $accessToken, ')
          ..write('accessNote: $accessNote, ')
          ..write('employmentType: $employmentType, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('department: $department, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('internalComment: $internalComment, ')
          ..write('policyAcknowledged: $policyAcknowledged, ')
          ..write('policyAcknowledgedAt: $policyAcknowledgedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    code,
    firstName,
    lastName,
    status,
    terminationDate,
    vacationDaysPerYear,
    secondaryPhone,
    hireDate,
    employeeRole,
    usePin,
    useNfc,
    accessToken,
    accessNote,
    employmentType,
    email,
    phone,
    department,
    jobTitle,
    internalComment,
    policyAcknowledged,
    policyAcknowledgedAt,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.code == this.code &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.status == this.status &&
          other.terminationDate == this.terminationDate &&
          other.vacationDaysPerYear == this.vacationDaysPerYear &&
          other.secondaryPhone == this.secondaryPhone &&
          other.hireDate == this.hireDate &&
          other.employeeRole == this.employeeRole &&
          other.usePin == this.usePin &&
          other.useNfc == this.useNfc &&
          other.accessToken == this.accessToken &&
          other.accessNote == this.accessNote &&
          other.employmentType == this.employmentType &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.department == this.department &&
          other.jobTitle == this.jobTitle &&
          other.internalComment == this.internalComment &&
          other.policyAcknowledged == this.policyAcknowledged &&
          other.policyAcknowledgedAt == this.policyAcknowledgedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> status;
  final Value<int?> terminationDate;
  final Value<int?> vacationDaysPerYear;
  final Value<String?> secondaryPhone;
  final Value<int?> hireDate;
  final Value<String> employeeRole;
  final Value<int> usePin;
  final Value<int> useNfc;
  final Value<String?> accessToken;
  final Value<String?> accessNote;
  final Value<String?> employmentType;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> department;
  final Value<String?> jobTitle;
  final Value<String?> internalComment;
  final Value<int> policyAcknowledged;
  final Value<int?> policyAcknowledgedAt;
  final Value<int> createdAt;
  final Value<int?> updatedAt;
  final Value<String?> createdBy;
  final Value<String?> updatedBy;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.status = const Value.absent(),
    this.terminationDate = const Value.absent(),
    this.vacationDaysPerYear = const Value.absent(),
    this.secondaryPhone = const Value.absent(),
    this.hireDate = const Value.absent(),
    this.employeeRole = const Value.absent(),
    this.usePin = const Value.absent(),
    this.useNfc = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.accessNote = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.department = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.internalComment = const Value.absent(),
    this.policyAcknowledged = const Value.absent(),
    this.policyAcknowledgedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String firstName,
    required String lastName,
    this.status = const Value.absent(),
    this.terminationDate = const Value.absent(),
    this.vacationDaysPerYear = const Value.absent(),
    this.secondaryPhone = const Value.absent(),
    this.hireDate = const Value.absent(),
    this.employeeRole = const Value.absent(),
    this.usePin = const Value.absent(),
    this.useNfc = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.accessNote = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.department = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.internalComment = const Value.absent(),
    this.policyAcknowledged = const Value.absent(),
    this.policyAcknowledgedAt = const Value.absent(),
    required int createdAt,
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
  }) : code = Value(code),
       firstName = Value(firstName),
       lastName = Value(lastName),
       createdAt = Value(createdAt);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? status,
    Expression<int>? terminationDate,
    Expression<int>? vacationDaysPerYear,
    Expression<String>? secondaryPhone,
    Expression<int>? hireDate,
    Expression<String>? employeeRole,
    Expression<int>? usePin,
    Expression<int>? useNfc,
    Expression<String>? accessToken,
    Expression<String>? accessNote,
    Expression<String>? employmentType,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? department,
    Expression<String>? jobTitle,
    Expression<String>? internalComment,
    Expression<int>? policyAcknowledged,
    Expression<int>? policyAcknowledgedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (status != null) 'status': status,
      if (terminationDate != null) 'termination_date': terminationDate,
      if (vacationDaysPerYear != null)
        'vacation_days_per_year': vacationDaysPerYear,
      if (secondaryPhone != null) 'secondary_phone': secondaryPhone,
      if (hireDate != null) 'hire_date': hireDate,
      if (employeeRole != null) 'employee_role': employeeRole,
      if (usePin != null) 'use_pin': usePin,
      if (useNfc != null) 'use_nfc': useNfc,
      if (accessToken != null) 'access_token': accessToken,
      if (accessNote != null) 'access_note': accessNote,
      if (employmentType != null) 'employment_type': employmentType,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (department != null) 'department': department,
      if (jobTitle != null) 'job_title': jobTitle,
      if (internalComment != null) 'internal_comment': internalComment,
      if (policyAcknowledged != null) 'policy_acknowledged': policyAcknowledged,
      if (policyAcknowledgedAt != null)
        'policy_acknowledged_at': policyAcknowledgedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? status,
    Value<int?>? terminationDate,
    Value<int?>? vacationDaysPerYear,
    Value<String?>? secondaryPhone,
    Value<int?>? hireDate,
    Value<String>? employeeRole,
    Value<int>? usePin,
    Value<int>? useNfc,
    Value<String?>? accessToken,
    Value<String?>? accessNote,
    Value<String?>? employmentType,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? department,
    Value<String?>? jobTitle,
    Value<String?>? internalComment,
    Value<int>? policyAcknowledged,
    Value<int?>? policyAcknowledgedAt,
    Value<int>? createdAt,
    Value<int?>? updatedAt,
    Value<String?>? createdBy,
    Value<String?>? updatedBy,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
      terminationDate: terminationDate ?? this.terminationDate,
      vacationDaysPerYear: vacationDaysPerYear ?? this.vacationDaysPerYear,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      hireDate: hireDate ?? this.hireDate,
      employeeRole: employeeRole ?? this.employeeRole,
      usePin: usePin ?? this.usePin,
      useNfc: useNfc ?? this.useNfc,
      accessToken: accessToken ?? this.accessToken,
      accessNote: accessNote ?? this.accessNote,
      employmentType: employmentType ?? this.employmentType,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      jobTitle: jobTitle ?? this.jobTitle,
      internalComment: internalComment ?? this.internalComment,
      policyAcknowledged: policyAcknowledged ?? this.policyAcknowledged,
      policyAcknowledgedAt: policyAcknowledgedAt ?? this.policyAcknowledgedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (terminationDate.present) {
      map['termination_date'] = Variable<int>(terminationDate.value);
    }
    if (vacationDaysPerYear.present) {
      map['vacation_days_per_year'] = Variable<int>(vacationDaysPerYear.value);
    }
    if (secondaryPhone.present) {
      map['secondary_phone'] = Variable<String>(secondaryPhone.value);
    }
    if (hireDate.present) {
      map['hire_date'] = Variable<int>(hireDate.value);
    }
    if (employeeRole.present) {
      map['employee_role'] = Variable<String>(employeeRole.value);
    }
    if (usePin.present) {
      map['use_pin'] = Variable<int>(usePin.value);
    }
    if (useNfc.present) {
      map['use_nfc'] = Variable<int>(useNfc.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (accessNote.present) {
      map['access_note'] = Variable<String>(accessNote.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<String>(employmentType.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (internalComment.present) {
      map['internal_comment'] = Variable<String>(internalComment.value);
    }
    if (policyAcknowledged.present) {
      map['policy_acknowledged'] = Variable<int>(policyAcknowledged.value);
    }
    if (policyAcknowledgedAt.present) {
      map['policy_acknowledged_at'] = Variable<int>(policyAcknowledgedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('status: $status, ')
          ..write('terminationDate: $terminationDate, ')
          ..write('vacationDaysPerYear: $vacationDaysPerYear, ')
          ..write('secondaryPhone: $secondaryPhone, ')
          ..write('hireDate: $hireDate, ')
          ..write('employeeRole: $employeeRole, ')
          ..write('usePin: $usePin, ')
          ..write('useNfc: $useNfc, ')
          ..write('accessToken: $accessToken, ')
          ..write('accessNote: $accessNote, ')
          ..write('employmentType: $employmentType, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('department: $department, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('internalComment: $internalComment, ')
          ..write('policyAcknowledged: $policyAcknowledged, ')
          ..write('policyAcknowledgedAt: $policyAcknowledgedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }
}

class $EmployeeAuthsTable extends EmployeeAuths
    with TableInfo<$EmployeeAuthsTable, EmployeeAuth> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeAuthsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<Uint8List> pinSalt = GeneratedColumn<Uint8List>(
    'pin_salt',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinUpdatedAtMeta = const VerificationMeta(
    'pinUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> pinUpdatedAt = GeneratedColumn<int>(
    'pin_updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    employeeId,
    pinHash,
    pinSalt,
    pinUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_auths';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeAuth> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    } else if (isInserting) {
      context.missing(_pinSaltMeta);
    }
    if (data.containsKey('pin_updated_at')) {
      context.handle(
        _pinUpdatedAtMeta,
        pinUpdatedAt.isAcceptableOrUnknown(
          data['pin_updated_at']!,
          _pinUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pinUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeeAuth map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeAuth(
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}pin_salt'],
      )!,
      pinUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pin_updated_at'],
      )!,
    );
  }

  @override
  $EmployeeAuthsTable createAlias(String alias) {
    return $EmployeeAuthsTable(attachedDatabase, alias);
  }
}

class EmployeeAuth extends DataClass implements Insertable<EmployeeAuth> {
  final int employeeId;
  final String pinHash;
  final Uint8List pinSalt;
  final int pinUpdatedAt;
  const EmployeeAuth({
    required this.employeeId,
    required this.pinHash,
    required this.pinSalt,
    required this.pinUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<int>(employeeId);
    map['pin_hash'] = Variable<String>(pinHash);
    map['pin_salt'] = Variable<Uint8List>(pinSalt);
    map['pin_updated_at'] = Variable<int>(pinUpdatedAt);
    return map;
  }

  EmployeeAuthsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeAuthsCompanion(
      employeeId: Value(employeeId),
      pinHash: Value(pinHash),
      pinSalt: Value(pinSalt),
      pinUpdatedAt: Value(pinUpdatedAt),
    );
  }

  factory EmployeeAuth.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeAuth(
      employeeId: serializer.fromJson<int>(json['employeeId']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<Uint8List>(json['pinSalt']),
      pinUpdatedAt: serializer.fromJson<int>(json['pinUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<int>(employeeId),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<Uint8List>(pinSalt),
      'pinUpdatedAt': serializer.toJson<int>(pinUpdatedAt),
    };
  }

  EmployeeAuth copyWith({
    int? employeeId,
    String? pinHash,
    Uint8List? pinSalt,
    int? pinUpdatedAt,
  }) => EmployeeAuth(
    employeeId: employeeId ?? this.employeeId,
    pinHash: pinHash ?? this.pinHash,
    pinSalt: pinSalt ?? this.pinSalt,
    pinUpdatedAt: pinUpdatedAt ?? this.pinUpdatedAt,
  );
  EmployeeAuth copyWithCompanion(EmployeeAuthsCompanion data) {
    return EmployeeAuth(
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinUpdatedAt: data.pinUpdatedAt.present
          ? data.pinUpdatedAt.value
          : this.pinUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeAuth(')
          ..write('employeeId: $employeeId, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinUpdatedAt: $pinUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    employeeId,
    pinHash,
    $driftBlobEquality.hash(pinSalt),
    pinUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeAuth &&
          other.employeeId == this.employeeId &&
          other.pinHash == this.pinHash &&
          $driftBlobEquality.equals(other.pinSalt, this.pinSalt) &&
          other.pinUpdatedAt == this.pinUpdatedAt);
}

class EmployeeAuthsCompanion extends UpdateCompanion<EmployeeAuth> {
  final Value<int> employeeId;
  final Value<String> pinHash;
  final Value<Uint8List> pinSalt;
  final Value<int> pinUpdatedAt;
  const EmployeeAuthsCompanion({
    this.employeeId = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinUpdatedAt = const Value.absent(),
  });
  EmployeeAuthsCompanion.insert({
    this.employeeId = const Value.absent(),
    required String pinHash,
    required Uint8List pinSalt,
    required int pinUpdatedAt,
  }) : pinHash = Value(pinHash),
       pinSalt = Value(pinSalt),
       pinUpdatedAt = Value(pinUpdatedAt);
  static Insertable<EmployeeAuth> custom({
    Expression<int>? employeeId,
    Expression<String>? pinHash,
    Expression<Uint8List>? pinSalt,
    Expression<int>? pinUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinUpdatedAt != null) 'pin_updated_at': pinUpdatedAt,
    });
  }

  EmployeeAuthsCompanion copyWith({
    Value<int>? employeeId,
    Value<String>? pinHash,
    Value<Uint8List>? pinSalt,
    Value<int>? pinUpdatedAt,
  }) {
    return EmployeeAuthsCompanion(
      employeeId: employeeId ?? this.employeeId,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      pinUpdatedAt: pinUpdatedAt ?? this.pinUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<Uint8List>(pinSalt.value);
    }
    if (pinUpdatedAt.present) {
      map['pin_updated_at'] = Variable<int>(pinUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeAuthsCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinUpdatedAt: $pinUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (role IN (\'ADMIN\',\'OPERATOR\'))',
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    passwordHash,
    role,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String passwordHash;
  final String role;
  final int isActive;
  final int createdAt;
  const User({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<int>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      role: Value(role),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? role,
    int? isActive,
    int? createdAt,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, passwordHash, role, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<int> isActive;
  final Value<int> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String passwordHash,
    required String role,
    this.isActive = const Value.absent(),
    required int createdAt,
  }) : username = Value(username),
       passwordHash = Value(passwordHash),
       role = Value(role),
       createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<int>? isActive,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String>? role,
    Value<int>? isActive,
    Value<int>? createdAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    location,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Device> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String name;
  final String? location;
  final int isActive;
  final int createdAt;
  const Device({
    required this.id,
    required this.name,
    this.location,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['is_active'] = Variable<int>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Device.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Device copyWith({
    int? id,
    String? name,
    Value<String?> location = const Value.absent(),
    int? isActive,
    int? createdAt,
  }) => Device(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> location;
  final Value<int> isActive;
  final Value<int> createdAt;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.location = const Value.absent(),
    this.isActive = const Value.absent(),
    required int createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Device> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<int>? isActive,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DevicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? location,
    Value<int>? isActive,
    Value<int>? createdAt,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorkSessionsTable extends WorkSessions
    with TableInfo<$WorkSessionsTable, WorkSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id)',
    ),
  );
  static const VerificationMeta _startTsMeta = const VerificationMeta(
    'startTs',
  );
  @override
  late final GeneratedColumn<int> startTs = GeneratedColumn<int>(
    'start_ts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTsMeta = const VerificationMeta('endTs');
  @override
  late final GeneratedColumn<int> endTs = GeneratedColumn<int>(
    'end_ts',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (status IN (\'OPEN\',\'CLOSED\'))',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (source IN (\'terminal\',\'admin\',\'import\'))',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updateReasonMeta = const VerificationMeta(
    'updateReason',
  );
  @override
  late final GeneratedColumn<String> updateReason = GeneratedColumn<String>(
    'update_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    deviceId,
    startTs,
    endTs,
    status,
    source,
    note,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    updateReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('start_ts')) {
      context.handle(
        _startTsMeta,
        startTs.isAcceptableOrUnknown(data['start_ts']!, _startTsMeta),
      );
    } else if (isInserting) {
      context.missing(_startTsMeta);
    }
    if (data.containsKey('end_ts')) {
      context.handle(
        _endTsMeta,
        endTs.isAcceptableOrUnknown(data['end_ts']!, _endTsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('update_reason')) {
      context.handle(
        _updateReasonMeta,
        updateReason.isAcceptableOrUnknown(
          data['update_reason']!,
          _updateReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_id'],
      ),
      startTs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ts'],
      )!,
      endTs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_ts'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      updateReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}update_reason'],
      ),
    );
  }

  @override
  $WorkSessionsTable createAlias(String alias) {
    return $WorkSessionsTable(attachedDatabase, alias);
  }
}

class WorkSession extends DataClass implements Insertable<WorkSession> {
  final int id;
  final int employeeId;
  final int? deviceId;
  final int startTs;
  final int? endTs;
  final String status;
  final String source;
  final String? note;
  final int createdAt;
  final String? createdBy;
  final int? updatedAt;
  final String? updatedBy;
  final String? updateReason;
  const WorkSession({
    required this.id,
    required this.employeeId,
    this.deviceId,
    required this.startTs,
    this.endTs,
    required this.status,
    required this.source,
    this.note,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.updateReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<int>(deviceId);
    }
    map['start_ts'] = Variable<int>(startTs);
    if (!nullToAbsent || endTs != null) {
      map['end_ts'] = Variable<int>(endTs);
    }
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    if (!nullToAbsent || updateReason != null) {
      map['update_reason'] = Variable<String>(updateReason);
    }
    return map;
  }

  WorkSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkSessionsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      startTs: Value(startTs),
      endTs: endTs == null && nullToAbsent
          ? const Value.absent()
          : Value(endTs),
      status: Value(status),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      updateReason: updateReason == null && nullToAbsent
          ? const Value.absent()
          : Value(updateReason),
    );
  }

  factory WorkSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkSession(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      deviceId: serializer.fromJson<int?>(json['deviceId']),
      startTs: serializer.fromJson<int>(json['startTs']),
      endTs: serializer.fromJson<int?>(json['endTs']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      updateReason: serializer.fromJson<String?>(json['updateReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'deviceId': serializer.toJson<int?>(deviceId),
      'startTs': serializer.toJson<int>(startTs),
      'endTs': serializer.toJson<int?>(endTs),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'updatedAt': serializer.toJson<int?>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'updateReason': serializer.toJson<String?>(updateReason),
    };
  }

  WorkSession copyWith({
    int? id,
    int? employeeId,
    Value<int?> deviceId = const Value.absent(),
    int? startTs,
    Value<int?> endTs = const Value.absent(),
    String? status,
    String? source,
    Value<String?> note = const Value.absent(),
    int? createdAt,
    Value<String?> createdBy = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
    Value<String?> updatedBy = const Value.absent(),
    Value<String?> updateReason = const Value.absent(),
  }) => WorkSession(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    startTs: startTs ?? this.startTs,
    endTs: endTs.present ? endTs.value : this.endTs,
    status: status ?? this.status,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    updateReason: updateReason.present ? updateReason.value : this.updateReason,
  );
  WorkSession copyWithCompanion(WorkSessionsCompanion data) {
    return WorkSession(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      startTs: data.startTs.present ? data.startTs.value : this.startTs,
      endTs: data.endTs.present ? data.endTs.value : this.endTs,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      updateReason: data.updateReason.present
          ? data.updateReason.value
          : this.updateReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkSession(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('deviceId: $deviceId, ')
          ..write('startTs: $startTs, ')
          ..write('endTs: $endTs, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('updateReason: $updateReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    deviceId,
    startTs,
    endTs,
    status,
    source,
    note,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    updateReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkSession &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.deviceId == this.deviceId &&
          other.startTs == this.startTs &&
          other.endTs == this.endTs &&
          other.status == this.status &&
          other.source == this.source &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.updateReason == this.updateReason);
}

class WorkSessionsCompanion extends UpdateCompanion<WorkSession> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<int?> deviceId;
  final Value<int> startTs;
  final Value<int?> endTs;
  final Value<String> status;
  final Value<String> source;
  final Value<String?> note;
  final Value<int> createdAt;
  final Value<String?> createdBy;
  final Value<int?> updatedAt;
  final Value<String?> updatedBy;
  final Value<String?> updateReason;
  const WorkSessionsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.startTs = const Value.absent(),
    this.endTs = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.updateReason = const Value.absent(),
  });
  WorkSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    this.deviceId = const Value.absent(),
    required int startTs,
    this.endTs = const Value.absent(),
    required String status,
    required String source,
    this.note = const Value.absent(),
    required int createdAt,
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.updateReason = const Value.absent(),
  }) : employeeId = Value(employeeId),
       startTs = Value(startTs),
       status = Value(status),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<WorkSession> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<int>? deviceId,
    Expression<int>? startTs,
    Expression<int>? endTs,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<String>? createdBy,
    Expression<int>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? updateReason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (deviceId != null) 'device_id': deviceId,
      if (startTs != null) 'start_ts': startTs,
      if (endTs != null) 'end_ts': endTs,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (updateReason != null) 'update_reason': updateReason,
    });
  }

  WorkSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<int?>? deviceId,
    Value<int>? startTs,
    Value<int?>? endTs,
    Value<String>? status,
    Value<String>? source,
    Value<String?>? note,
    Value<int>? createdAt,
    Value<String?>? createdBy,
    Value<int?>? updatedAt,
    Value<String?>? updatedBy,
    Value<String?>? updateReason,
  }) {
    return WorkSessionsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      deviceId: deviceId ?? this.deviceId,
      startTs: startTs ?? this.startTs,
      endTs: endTs ?? this.endTs,
      status: status ?? this.status,
      source: source ?? this.source,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updateReason: updateReason ?? this.updateReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (startTs.present) {
      map['start_ts'] = Variable<int>(startTs.value);
    }
    if (endTs.present) {
      map['end_ts'] = Variable<int>(endTs.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (updateReason.present) {
      map['update_reason'] = Variable<String>(updateReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkSessionsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('deviceId: $deviceId, ')
          ..write('startTs: $startTs, ')
          ..write('endTs: $endTs, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('updateReason: $updateReason')
          ..write(')'))
        .toString();
  }
}

class $ShiftScheduleTemplatesTable extends ShiftScheduleTemplates
    with TableInfo<$ShiftScheduleTemplatesTable, ShiftScheduleTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftScheduleTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_schedule_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftScheduleTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftScheduleTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftScheduleTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShiftScheduleTemplatesTable createAlias(String alias) {
    return $ShiftScheduleTemplatesTable(attachedDatabase, alias);
  }
}

class ShiftScheduleTemplate extends DataClass
    implements Insertable<ShiftScheduleTemplate> {
  final int id;
  final String name;
  final int isActive;
  final int createdAt;
  const ShiftScheduleTemplate({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<int>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ShiftScheduleTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ShiftScheduleTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory ShiftScheduleTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftScheduleTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ShiftScheduleTemplate copyWith({
    int? id,
    String? name,
    int? isActive,
    int? createdAt,
  }) => ShiftScheduleTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  ShiftScheduleTemplate copyWithCompanion(
    ShiftScheduleTemplatesCompanion data,
  ) {
    return ShiftScheduleTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftScheduleTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftScheduleTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ShiftScheduleTemplatesCompanion
    extends UpdateCompanion<ShiftScheduleTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> isActive;
  final Value<int> createdAt;
  const ShiftScheduleTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ShiftScheduleTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    required int createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<ShiftScheduleTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? isActive,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ShiftScheduleTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? isActive,
    Value<int>? createdAt,
  }) {
    return ShiftScheduleTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftScheduleTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ShiftScheduleTemplateDaysTable extends ShiftScheduleTemplateDays
    with TableInfo<$ShiftScheduleTemplateDaysTable, ShiftScheduleTemplateDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftScheduleTemplateDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_schedule_templates (id)',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDayOffMeta = const VerificationMeta(
    'isDayOff',
  );
  @override
  late final GeneratedColumn<int> isDayOff = GeneratedColumn<int>(
    'is_day_off',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, templateId, weekday, isDayOff];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_schedule_template_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftScheduleTemplateDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('is_day_off')) {
      context.handle(
        _isDayOffMeta,
        isDayOff.isAcceptableOrUnknown(data['is_day_off']!, _isDayOffMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {templateId, weekday},
  ];
  @override
  ShiftScheduleTemplateDay map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftScheduleTemplateDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      isDayOff: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_day_off'],
      )!,
    );
  }

  @override
  $ShiftScheduleTemplateDaysTable createAlias(String alias) {
    return $ShiftScheduleTemplateDaysTable(attachedDatabase, alias);
  }
}

class ShiftScheduleTemplateDay extends DataClass
    implements Insertable<ShiftScheduleTemplateDay> {
  final int id;
  final int templateId;
  final int weekday;
  final int isDayOff;
  const ShiftScheduleTemplateDay({
    required this.id,
    required this.templateId,
    required this.weekday,
    required this.isDayOff,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['weekday'] = Variable<int>(weekday);
    map['is_day_off'] = Variable<int>(isDayOff);
    return map;
  }

  ShiftScheduleTemplateDaysCompanion toCompanion(bool nullToAbsent) {
    return ShiftScheduleTemplateDaysCompanion(
      id: Value(id),
      templateId: Value(templateId),
      weekday: Value(weekday),
      isDayOff: Value(isDayOff),
    );
  }

  factory ShiftScheduleTemplateDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftScheduleTemplateDay(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      isDayOff: serializer.fromJson<int>(json['isDayOff']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'weekday': serializer.toJson<int>(weekday),
      'isDayOff': serializer.toJson<int>(isDayOff),
    };
  }

  ShiftScheduleTemplateDay copyWith({
    int? id,
    int? templateId,
    int? weekday,
    int? isDayOff,
  }) => ShiftScheduleTemplateDay(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    weekday: weekday ?? this.weekday,
    isDayOff: isDayOff ?? this.isDayOff,
  );
  ShiftScheduleTemplateDay copyWithCompanion(
    ShiftScheduleTemplateDaysCompanion data,
  ) {
    return ShiftScheduleTemplateDay(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      isDayOff: data.isDayOff.present ? data.isDayOff.value : this.isDayOff,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftScheduleTemplateDay(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('weekday: $weekday, ')
          ..write('isDayOff: $isDayOff')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, weekday, isDayOff);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftScheduleTemplateDay &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.weekday == this.weekday &&
          other.isDayOff == this.isDayOff);
}

class ShiftScheduleTemplateDaysCompanion
    extends UpdateCompanion<ShiftScheduleTemplateDay> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<int> weekday;
  final Value<int> isDayOff;
  const ShiftScheduleTemplateDaysCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.isDayOff = const Value.absent(),
  });
  ShiftScheduleTemplateDaysCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required int weekday,
    this.isDayOff = const Value.absent(),
  }) : templateId = Value(templateId),
       weekday = Value(weekday);
  static Insertable<ShiftScheduleTemplateDay> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<int>? weekday,
    Expression<int>? isDayOff,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (weekday != null) 'weekday': weekday,
      if (isDayOff != null) 'is_day_off': isDayOff,
    });
  }

  ShiftScheduleTemplateDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? templateId,
    Value<int>? weekday,
    Value<int>? isDayOff,
  }) {
    return ShiftScheduleTemplateDaysCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      weekday: weekday ?? this.weekday,
      isDayOff: isDayOff ?? this.isDayOff,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (isDayOff.present) {
      map['is_day_off'] = Variable<int>(isDayOff.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftScheduleTemplateDaysCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('weekday: $weekday, ')
          ..write('isDayOff: $isDayOff')
          ..write(')'))
        .toString();
  }
}

class $ShiftScheduleTemplateIntervalsTable
    extends ShiftScheduleTemplateIntervals
    with
        TableInfo<
          $ShiftScheduleTemplateIntervalsTable,
          ShiftScheduleTemplateInterval
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftScheduleTemplateIntervalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _templateDayIdMeta = const VerificationMeta(
    'templateDayId',
  );
  @override
  late final GeneratedColumn<int> templateDayId = GeneratedColumn<int>(
    'template_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_schedule_template_days (id)',
    ),
  );
  static const VerificationMeta _startMinMeta = const VerificationMeta(
    'startMin',
  );
  @override
  late final GeneratedColumn<int> startMin = GeneratedColumn<int>(
    'start_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinMeta = const VerificationMeta('endMin');
  @override
  late final GeneratedColumn<int> endMin = GeneratedColumn<int>(
    'end_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _crossesMidnightMeta = const VerificationMeta(
    'crossesMidnight',
  );
  @override
  late final GeneratedColumn<int> crossesMidnight = GeneratedColumn<int>(
    'crosses_midnight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateDayId,
    startMin,
    endMin,
    crossesMidnight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_schedule_template_intervals';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftScheduleTemplateInterval> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_day_id')) {
      context.handle(
        _templateDayIdMeta,
        templateDayId.isAcceptableOrUnknown(
          data['template_day_id']!,
          _templateDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateDayIdMeta);
    }
    if (data.containsKey('start_min')) {
      context.handle(
        _startMinMeta,
        startMin.isAcceptableOrUnknown(data['start_min']!, _startMinMeta),
      );
    } else if (isInserting) {
      context.missing(_startMinMeta);
    }
    if (data.containsKey('end_min')) {
      context.handle(
        _endMinMeta,
        endMin.isAcceptableOrUnknown(data['end_min']!, _endMinMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinMeta);
    }
    if (data.containsKey('crosses_midnight')) {
      context.handle(
        _crossesMidnightMeta,
        crossesMidnight.isAcceptableOrUnknown(
          data['crosses_midnight']!,
          _crossesMidnightMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftScheduleTemplateInterval map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftScheduleTemplateInterval(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_day_id'],
      )!,
      startMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_min'],
      )!,
      endMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_min'],
      )!,
      crossesMidnight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crosses_midnight'],
      )!,
    );
  }

  @override
  $ShiftScheduleTemplateIntervalsTable createAlias(String alias) {
    return $ShiftScheduleTemplateIntervalsTable(attachedDatabase, alias);
  }
}

class ShiftScheduleTemplateInterval extends DataClass
    implements Insertable<ShiftScheduleTemplateInterval> {
  final int id;
  final int templateDayId;
  final int startMin;
  final int endMin;
  final int crossesMidnight;
  const ShiftScheduleTemplateInterval({
    required this.id,
    required this.templateDayId,
    required this.startMin,
    required this.endMin,
    required this.crossesMidnight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_day_id'] = Variable<int>(templateDayId);
    map['start_min'] = Variable<int>(startMin);
    map['end_min'] = Variable<int>(endMin);
    map['crosses_midnight'] = Variable<int>(crossesMidnight);
    return map;
  }

  ShiftScheduleTemplateIntervalsCompanion toCompanion(bool nullToAbsent) {
    return ShiftScheduleTemplateIntervalsCompanion(
      id: Value(id),
      templateDayId: Value(templateDayId),
      startMin: Value(startMin),
      endMin: Value(endMin),
      crossesMidnight: Value(crossesMidnight),
    );
  }

  factory ShiftScheduleTemplateInterval.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftScheduleTemplateInterval(
      id: serializer.fromJson<int>(json['id']),
      templateDayId: serializer.fromJson<int>(json['templateDayId']),
      startMin: serializer.fromJson<int>(json['startMin']),
      endMin: serializer.fromJson<int>(json['endMin']),
      crossesMidnight: serializer.fromJson<int>(json['crossesMidnight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateDayId': serializer.toJson<int>(templateDayId),
      'startMin': serializer.toJson<int>(startMin),
      'endMin': serializer.toJson<int>(endMin),
      'crossesMidnight': serializer.toJson<int>(crossesMidnight),
    };
  }

  ShiftScheduleTemplateInterval copyWith({
    int? id,
    int? templateDayId,
    int? startMin,
    int? endMin,
    int? crossesMidnight,
  }) => ShiftScheduleTemplateInterval(
    id: id ?? this.id,
    templateDayId: templateDayId ?? this.templateDayId,
    startMin: startMin ?? this.startMin,
    endMin: endMin ?? this.endMin,
    crossesMidnight: crossesMidnight ?? this.crossesMidnight,
  );
  ShiftScheduleTemplateInterval copyWithCompanion(
    ShiftScheduleTemplateIntervalsCompanion data,
  ) {
    return ShiftScheduleTemplateInterval(
      id: data.id.present ? data.id.value : this.id,
      templateDayId: data.templateDayId.present
          ? data.templateDayId.value
          : this.templateDayId,
      startMin: data.startMin.present ? data.startMin.value : this.startMin,
      endMin: data.endMin.present ? data.endMin.value : this.endMin,
      crossesMidnight: data.crossesMidnight.present
          ? data.crossesMidnight.value
          : this.crossesMidnight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftScheduleTemplateInterval(')
          ..write('id: $id, ')
          ..write('templateDayId: $templateDayId, ')
          ..write('startMin: $startMin, ')
          ..write('endMin: $endMin, ')
          ..write('crossesMidnight: $crossesMidnight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, templateDayId, startMin, endMin, crossesMidnight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftScheduleTemplateInterval &&
          other.id == this.id &&
          other.templateDayId == this.templateDayId &&
          other.startMin == this.startMin &&
          other.endMin == this.endMin &&
          other.crossesMidnight == this.crossesMidnight);
}

class ShiftScheduleTemplateIntervalsCompanion
    extends UpdateCompanion<ShiftScheduleTemplateInterval> {
  final Value<int> id;
  final Value<int> templateDayId;
  final Value<int> startMin;
  final Value<int> endMin;
  final Value<int> crossesMidnight;
  const ShiftScheduleTemplateIntervalsCompanion({
    this.id = const Value.absent(),
    this.templateDayId = const Value.absent(),
    this.startMin = const Value.absent(),
    this.endMin = const Value.absent(),
    this.crossesMidnight = const Value.absent(),
  });
  ShiftScheduleTemplateIntervalsCompanion.insert({
    this.id = const Value.absent(),
    required int templateDayId,
    required int startMin,
    required int endMin,
    this.crossesMidnight = const Value.absent(),
  }) : templateDayId = Value(templateDayId),
       startMin = Value(startMin),
       endMin = Value(endMin);
  static Insertable<ShiftScheduleTemplateInterval> custom({
    Expression<int>? id,
    Expression<int>? templateDayId,
    Expression<int>? startMin,
    Expression<int>? endMin,
    Expression<int>? crossesMidnight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateDayId != null) 'template_day_id': templateDayId,
      if (startMin != null) 'start_min': startMin,
      if (endMin != null) 'end_min': endMin,
      if (crossesMidnight != null) 'crosses_midnight': crossesMidnight,
    });
  }

  ShiftScheduleTemplateIntervalsCompanion copyWith({
    Value<int>? id,
    Value<int>? templateDayId,
    Value<int>? startMin,
    Value<int>? endMin,
    Value<int>? crossesMidnight,
  }) {
    return ShiftScheduleTemplateIntervalsCompanion(
      id: id ?? this.id,
      templateDayId: templateDayId ?? this.templateDayId,
      startMin: startMin ?? this.startMin,
      endMin: endMin ?? this.endMin,
      crossesMidnight: crossesMidnight ?? this.crossesMidnight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateDayId.present) {
      map['template_day_id'] = Variable<int>(templateDayId.value);
    }
    if (startMin.present) {
      map['start_min'] = Variable<int>(startMin.value);
    }
    if (endMin.present) {
      map['end_min'] = Variable<int>(endMin.value);
    }
    if (crossesMidnight.present) {
      map['crosses_midnight'] = Variable<int>(crossesMidnight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftScheduleTemplateIntervalsCompanion(')
          ..write('id: $id, ')
          ..write('templateDayId: $templateDayId, ')
          ..write('startMin: $startMin, ')
          ..write('endMin: $endMin, ')
          ..write('crossesMidnight: $crossesMidnight')
          ..write(')'))
        .toString();
  }
}

class $EmployeeScheduleAssignmentsTable extends EmployeeScheduleAssignments
    with
        TableInfo<
          $EmployeeScheduleAssignmentsTable,
          EmployeeScheduleAssignment
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeScheduleAssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_schedule_templates (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [employeeId, templateId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_schedule_assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeScheduleAssignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeeScheduleAssignment map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeScheduleAssignment(
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EmployeeScheduleAssignmentsTable createAlias(String alias) {
    return $EmployeeScheduleAssignmentsTable(attachedDatabase, alias);
  }
}

class EmployeeScheduleAssignment extends DataClass
    implements Insertable<EmployeeScheduleAssignment> {
  final int employeeId;
  final int templateId;
  final int createdAt;
  const EmployeeScheduleAssignment({
    required this.employeeId,
    required this.templateId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<int>(employeeId);
    map['template_id'] = Variable<int>(templateId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  EmployeeScheduleAssignmentsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeScheduleAssignmentsCompanion(
      employeeId: Value(employeeId),
      templateId: Value(templateId),
      createdAt: Value(createdAt),
    );
  }

  factory EmployeeScheduleAssignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeScheduleAssignment(
      employeeId: serializer.fromJson<int>(json['employeeId']),
      templateId: serializer.fromJson<int>(json['templateId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<int>(employeeId),
      'templateId': serializer.toJson<int>(templateId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  EmployeeScheduleAssignment copyWith({
    int? employeeId,
    int? templateId,
    int? createdAt,
  }) => EmployeeScheduleAssignment(
    employeeId: employeeId ?? this.employeeId,
    templateId: templateId ?? this.templateId,
    createdAt: createdAt ?? this.createdAt,
  );
  EmployeeScheduleAssignment copyWithCompanion(
    EmployeeScheduleAssignmentsCompanion data,
  ) {
    return EmployeeScheduleAssignment(
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeScheduleAssignment(')
          ..write('employeeId: $employeeId, ')
          ..write('templateId: $templateId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(employeeId, templateId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeScheduleAssignment &&
          other.employeeId == this.employeeId &&
          other.templateId == this.templateId &&
          other.createdAt == this.createdAt);
}

class EmployeeScheduleAssignmentsCompanion
    extends UpdateCompanion<EmployeeScheduleAssignment> {
  final Value<int> employeeId;
  final Value<int> templateId;
  final Value<int> createdAt;
  const EmployeeScheduleAssignmentsCompanion({
    this.employeeId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EmployeeScheduleAssignmentsCompanion.insert({
    this.employeeId = const Value.absent(),
    required int templateId,
    required int createdAt,
  }) : templateId = Value(templateId),
       createdAt = Value(createdAt);
  static Insertable<EmployeeScheduleAssignment> custom({
    Expression<int>? employeeId,
    Expression<int>? templateId,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (templateId != null) 'template_id': templateId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EmployeeScheduleAssignmentsCompanion copyWith({
    Value<int>? employeeId,
    Value<int>? templateId,
    Value<int>? createdAt,
  }) {
    return EmployeeScheduleAssignmentsCompanion(
      employeeId: employeeId ?? this.employeeId,
      templateId: templateId ?? this.templateId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeScheduleAssignmentsCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('templateId: $templateId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AbsencesTable extends Absences with TableInfo<$AbsencesTable, Absence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbsencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _dateFromMeta = const VerificationMeta(
    'dateFrom',
  );
  @override
  late final GeneratedColumn<String> dateFrom = GeneratedColumn<String>(
    'date_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  @override
  late final GeneratedColumn<String> dateTo = GeneratedColumn<String>(
    'date_to',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type IN (\'vacation\',\'sick_leave\',\'unpaid_leave\',\'parental_leave\',\'study_leave\',\'other\'))',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'PENDING\' CHECK (status IN (\'PENDING\',\'APPROVED\',\'REJECTED\'))',
    defaultValue: const CustomExpression('\'PENDING\''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByEmployeeIdMeta =
      const VerificationMeta('createdByEmployeeId');
  @override
  late final GeneratedColumn<int> createdByEmployeeId = GeneratedColumn<int>(
    'created_by_employee_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _approvedAtMeta = const VerificationMeta(
    'approvedAt',
  );
  @override
  late final GeneratedColumn<int> approvedAt = GeneratedColumn<int>(
    'approved_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approvedByMeta = const VerificationMeta(
    'approvedBy',
  );
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
    'approved_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rejectReasonMeta = const VerificationMeta(
    'rejectReason',
  );
  @override
  late final GeneratedColumn<String> rejectReason = GeneratedColumn<String>(
    'reject_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    dateFrom,
    dateTo,
    type,
    note,
    status,
    createdAt,
    createdByEmployeeId,
    approvedAt,
    approvedBy,
    rejectReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'absences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Absence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('date_from')) {
      context.handle(
        _dateFromMeta,
        dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta),
      );
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(
        _dateToMeta,
        dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta),
      );
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by_employee_id')) {
      context.handle(
        _createdByEmployeeIdMeta,
        createdByEmployeeId.isAcceptableOrUnknown(
          data['created_by_employee_id']!,
          _createdByEmployeeIdMeta,
        ),
      );
    }
    if (data.containsKey('approved_at')) {
      context.handle(
        _approvedAtMeta,
        approvedAt.isAcceptableOrUnknown(data['approved_at']!, _approvedAtMeta),
      );
    }
    if (data.containsKey('approved_by')) {
      context.handle(
        _approvedByMeta,
        approvedBy.isAcceptableOrUnknown(data['approved_by']!, _approvedByMeta),
      );
    }
    if (data.containsKey('reject_reason')) {
      context.handle(
        _rejectReasonMeta,
        rejectReason.isAcceptableOrUnknown(
          data['reject_reason']!,
          _rejectReasonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Absence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Absence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      dateFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_from'],
      )!,
      dateTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_to'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      createdByEmployeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by_employee_id'],
      ),
      approvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}approved_at'],
      ),
      approvedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approved_by'],
      ),
      rejectReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reject_reason'],
      ),
    );
  }

  @override
  $AbsencesTable createAlias(String alias) {
    return $AbsencesTable(attachedDatabase, alias);
  }
}

class Absence extends DataClass implements Insertable<Absence> {
  final int id;
  final int employeeId;
  final String dateFrom;
  final String dateTo;
  final String type;
  final String? note;
  final String status;
  final int createdAt;
  final int? createdByEmployeeId;
  final int? approvedAt;
  final String? approvedBy;
  final String? rejectReason;
  const Absence({
    required this.id,
    required this.employeeId,
    required this.dateFrom,
    required this.dateTo,
    required this.type,
    this.note,
    required this.status,
    required this.createdAt,
    this.createdByEmployeeId,
    this.approvedAt,
    this.approvedBy,
    this.rejectReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['date_from'] = Variable<String>(dateFrom);
    map['date_to'] = Variable<String>(dateTo);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || createdByEmployeeId != null) {
      map['created_by_employee_id'] = Variable<int>(createdByEmployeeId);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<int>(approvedAt);
    }
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || rejectReason != null) {
      map['reject_reason'] = Variable<String>(rejectReason);
    }
    return map;
  }

  AbsencesCompanion toCompanion(bool nullToAbsent) {
    return AbsencesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      createdAt: Value(createdAt),
      createdByEmployeeId: createdByEmployeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByEmployeeId),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      rejectReason: rejectReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectReason),
    );
  }

  factory Absence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Absence(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      dateFrom: serializer.fromJson<String>(json['dateFrom']),
      dateTo: serializer.fromJson<String>(json['dateTo']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      createdByEmployeeId: serializer.fromJson<int?>(
        json['createdByEmployeeId'],
      ),
      approvedAt: serializer.fromJson<int?>(json['approvedAt']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      rejectReason: serializer.fromJson<String?>(json['rejectReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'dateFrom': serializer.toJson<String>(dateFrom),
      'dateTo': serializer.toJson<String>(dateTo),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'createdByEmployeeId': serializer.toJson<int?>(createdByEmployeeId),
      'approvedAt': serializer.toJson<int?>(approvedAt),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'rejectReason': serializer.toJson<String?>(rejectReason),
    };
  }

  Absence copyWith({
    int? id,
    int? employeeId,
    String? dateFrom,
    String? dateTo,
    String? type,
    Value<String?> note = const Value.absent(),
    String? status,
    int? createdAt,
    Value<int?> createdByEmployeeId = const Value.absent(),
    Value<int?> approvedAt = const Value.absent(),
    Value<String?> approvedBy = const Value.absent(),
    Value<String?> rejectReason = const Value.absent(),
  }) => Absence(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    dateFrom: dateFrom ?? this.dateFrom,
    dateTo: dateTo ?? this.dateTo,
    type: type ?? this.type,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    createdByEmployeeId: createdByEmployeeId.present
        ? createdByEmployeeId.value
        : this.createdByEmployeeId,
    approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
    approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
    rejectReason: rejectReason.present ? rejectReason.value : this.rejectReason,
  );
  Absence copyWithCompanion(AbsencesCompanion data) {
    return Absence(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      dateFrom: data.dateFrom.present ? data.dateFrom.value : this.dateFrom,
      dateTo: data.dateTo.present ? data.dateTo.value : this.dateTo,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdByEmployeeId: data.createdByEmployeeId.present
          ? data.createdByEmployeeId.value
          : this.createdByEmployeeId,
      approvedAt: data.approvedAt.present
          ? data.approvedAt.value
          : this.approvedAt,
      approvedBy: data.approvedBy.present
          ? data.approvedBy.value
          : this.approvedBy,
      rejectReason: data.rejectReason.present
          ? data.rejectReason.value
          : this.rejectReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Absence(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByEmployeeId: $createdByEmployeeId, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('rejectReason: $rejectReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    dateFrom,
    dateTo,
    type,
    note,
    status,
    createdAt,
    createdByEmployeeId,
    approvedAt,
    approvedBy,
    rejectReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Absence &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo &&
          other.type == this.type &&
          other.note == this.note &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.createdByEmployeeId == this.createdByEmployeeId &&
          other.approvedAt == this.approvedAt &&
          other.approvedBy == this.approvedBy &&
          other.rejectReason == this.rejectReason);
}

class AbsencesCompanion extends UpdateCompanion<Absence> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<String> dateFrom;
  final Value<String> dateTo;
  final Value<String> type;
  final Value<String?> note;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int?> createdByEmployeeId;
  final Value<int?> approvedAt;
  final Value<String?> approvedBy;
  final Value<String?> rejectReason;
  const AbsencesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdByEmployeeId = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.rejectReason = const Value.absent(),
  });
  AbsencesCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    required String dateFrom,
    required String dateTo,
    required String type,
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    required int createdAt,
    this.createdByEmployeeId = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.rejectReason = const Value.absent(),
  }) : employeeId = Value(employeeId),
       dateFrom = Value(dateFrom),
       dateTo = Value(dateTo),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<Absence> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<String>? dateFrom,
    Expression<String>? dateTo,
    Expression<String>? type,
    Expression<String>? note,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? createdByEmployeeId,
    Expression<int>? approvedAt,
    Expression<String>? approvedBy,
    Expression<String>? rejectReason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (createdByEmployeeId != null)
        'created_by_employee_id': createdByEmployeeId,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (rejectReason != null) 'reject_reason': rejectReason,
    });
  }

  AbsencesCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<String>? dateFrom,
    Value<String>? dateTo,
    Value<String>? type,
    Value<String?>? note,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int?>? createdByEmployeeId,
    Value<int?>? approvedAt,
    Value<String?>? approvedBy,
    Value<String?>? rejectReason,
  }) {
    return AbsencesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      type: type ?? this.type,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdByEmployeeId: createdByEmployeeId ?? this.createdByEmployeeId,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectReason: rejectReason ?? this.rejectReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<String>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<String>(dateTo.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (createdByEmployeeId.present) {
      map['created_by_employee_id'] = Variable<int>(createdByEmployeeId.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<int>(approvedAt.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (rejectReason.present) {
      map['reject_reason'] = Variable<String>(rejectReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbsencesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByEmployeeId: $createdByEmployeeId, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('rejectReason: $rejectReason')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $EmployeeAuthsTable employeeAuths = $EmployeeAuthsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $WorkSessionsTable workSessions = $WorkSessionsTable(this);
  late final $ShiftScheduleTemplatesTable shiftScheduleTemplates =
      $ShiftScheduleTemplatesTable(this);
  late final $ShiftScheduleTemplateDaysTable shiftScheduleTemplateDays =
      $ShiftScheduleTemplateDaysTable(this);
  late final $ShiftScheduleTemplateIntervalsTable
  shiftScheduleTemplateIntervals = $ShiftScheduleTemplateIntervalsTable(this);
  late final $EmployeeScheduleAssignmentsTable employeeScheduleAssignments =
      $EmployeeScheduleAssignmentsTable(this);
  late final $AbsencesTable absences = $AbsencesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    employees,
    employeeAuths,
    users,
    devices,
    workSessions,
    shiftScheduleTemplates,
    shiftScheduleTemplateDays,
    shiftScheduleTemplateIntervals,
    employeeScheduleAssignments,
    absences,
    appSettings,
  ];
}

typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String code,
      required String firstName,
      required String lastName,
      Value<String> status,
      Value<int?> terminationDate,
      Value<int?> vacationDaysPerYear,
      Value<String?> secondaryPhone,
      Value<int?> hireDate,
      Value<String> employeeRole,
      Value<int> usePin,
      Value<int> useNfc,
      Value<String?> accessToken,
      Value<String?> accessNote,
      Value<String?> employmentType,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> department,
      Value<String?> jobTitle,
      Value<String?> internalComment,
      Value<int> policyAcknowledged,
      Value<int?> policyAcknowledgedAt,
      required int createdAt,
      Value<int?> updatedAt,
      Value<String?> createdBy,
      Value<String?> updatedBy,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> status,
      Value<int?> terminationDate,
      Value<int?> vacationDaysPerYear,
      Value<String?> secondaryPhone,
      Value<int?> hireDate,
      Value<String> employeeRole,
      Value<int> usePin,
      Value<int> useNfc,
      Value<String?> accessToken,
      Value<String?> accessNote,
      Value<String?> employmentType,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> department,
      Value<String?> jobTitle,
      Value<String?> internalComment,
      Value<int> policyAcknowledged,
      Value<int?> policyAcknowledgedAt,
      Value<int> createdAt,
      Value<int?> updatedAt,
      Value<String?> createdBy,
      Value<String?> updatedBy,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDb, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmployeeAuthsTable, List<EmployeeAuth>>
  _employeeAuthsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.employeeAuths,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.employeeAuths.employeeId,
    ),
  );

  $$EmployeeAuthsTableProcessedTableManager get employeeAuthsRefs {
    final manager = $$EmployeeAuthsTableTableManager(
      $_db,
      $_db.employeeAuths,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_employeeAuthsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkSessionsTable, List<WorkSession>>
  _workSessionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.workSessions,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.workSessions.employeeId,
    ),
  );

  $$WorkSessionsTableProcessedTableManager get workSessionsRefs {
    final manager = $$WorkSessionsTableTableManager(
      $_db,
      $_db.workSessions,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EmployeeScheduleAssignmentsTable,
    List<EmployeeScheduleAssignment>
  >
  _employeeScheduleAssignmentsRefsTable(_$AppDb db) =>
      MultiTypedResultKey.fromTable(
        db.employeeScheduleAssignments,
        aliasName: $_aliasNameGenerator(
          db.employees.id,
          db.employeeScheduleAssignments.employeeId,
        ),
      );

  $$EmployeeScheduleAssignmentsTableProcessedTableManager
  get employeeScheduleAssignmentsRefs {
    final manager = $$EmployeeScheduleAssignmentsTableTableManager(
      $_db,
      $_db.employeeScheduleAssignments,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _employeeScheduleAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDb, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get terminationDate => $composableBuilder(
    column: $table.terminationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vacationDaysPerYear => $composableBuilder(
    column: $table.vacationDaysPerYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryPhone => $composableBuilder(
    column: $table.secondaryPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeRole => $composableBuilder(
    column: $table.employeeRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usePin => $composableBuilder(
    column: $table.usePin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useNfc => $composableBuilder(
    column: $table.useNfc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessNote => $composableBuilder(
    column: $table.accessNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalComment => $composableBuilder(
    column: $table.internalComment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get policyAcknowledged => $composableBuilder(
    column: $table.policyAcknowledged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get policyAcknowledgedAt => $composableBuilder(
    column: $table.policyAcknowledgedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> employeeAuthsRefs(
    Expression<bool> Function($$EmployeeAuthsTableFilterComposer f) f,
  ) {
    final $$EmployeeAuthsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employeeAuths,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeeAuthsTableFilterComposer(
            $db: $db,
            $table: $db.employeeAuths,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workSessionsRefs(
    Expression<bool> Function($$WorkSessionsTableFilterComposer f) f,
  ) {
    final $$WorkSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workSessions,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> employeeScheduleAssignmentsRefs(
    Expression<bool> Function(
      $$EmployeeScheduleAssignmentsTableFilterComposer f,
    )
    f,
  ) {
    final $$EmployeeScheduleAssignmentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeScheduleAssignments,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeScheduleAssignmentsTableFilterComposer(
                $db: $db,
                $table: $db.employeeScheduleAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDb, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get terminationDate => $composableBuilder(
    column: $table.terminationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vacationDaysPerYear => $composableBuilder(
    column: $table.vacationDaysPerYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryPhone => $composableBuilder(
    column: $table.secondaryPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeRole => $composableBuilder(
    column: $table.employeeRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usePin => $composableBuilder(
    column: $table.usePin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useNfc => $composableBuilder(
    column: $table.useNfc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessNote => $composableBuilder(
    column: $table.accessNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalComment => $composableBuilder(
    column: $table.internalComment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get policyAcknowledged => $composableBuilder(
    column: $table.policyAcknowledged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get policyAcknowledgedAt => $composableBuilder(
    column: $table.policyAcknowledgedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDb, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get terminationDate => $composableBuilder(
    column: $table.terminationDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vacationDaysPerYear => $composableBuilder(
    column: $table.vacationDaysPerYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryPhone => $composableBuilder(
    column: $table.secondaryPhone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hireDate =>
      $composableBuilder(column: $table.hireDate, builder: (column) => column);

  GeneratedColumn<String> get employeeRole => $composableBuilder(
    column: $table.employeeRole,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usePin =>
      $composableBuilder(column: $table.usePin, builder: (column) => column);

  GeneratedColumn<int> get useNfc =>
      $composableBuilder(column: $table.useNfc, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accessNote => $composableBuilder(
    column: $table.accessNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<String> get internalComment => $composableBuilder(
    column: $table.internalComment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get policyAcknowledged => $composableBuilder(
    column: $table.policyAcknowledged,
    builder: (column) => column,
  );

  GeneratedColumn<int> get policyAcknowledgedAt => $composableBuilder(
    column: $table.policyAcknowledgedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  Expression<T> employeeAuthsRefs<T extends Object>(
    Expression<T> Function($$EmployeeAuthsTableAnnotationComposer a) f,
  ) {
    final $$EmployeeAuthsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.employeeAuths,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeeAuthsTableAnnotationComposer(
            $db: $db,
            $table: $db.employeeAuths,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workSessions,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> employeeScheduleAssignmentsRefs<T extends Object>(
    Expression<T> Function(
      $$EmployeeScheduleAssignmentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$EmployeeScheduleAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeScheduleAssignments,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeScheduleAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.employeeScheduleAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({
            bool employeeAuthsRefs,
            bool workSessionsRefs,
            bool employeeScheduleAssignmentsRefs,
          })
        > {
  $$EmployeesTableTableManager(_$AppDb db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> terminationDate = const Value.absent(),
                Value<int?> vacationDaysPerYear = const Value.absent(),
                Value<String?> secondaryPhone = const Value.absent(),
                Value<int?> hireDate = const Value.absent(),
                Value<String> employeeRole = const Value.absent(),
                Value<int> usePin = const Value.absent(),
                Value<int> useNfc = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> accessNote = const Value.absent(),
                Value<String?> employmentType = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<String?> internalComment = const Value.absent(),
                Value<int> policyAcknowledged = const Value.absent(),
                Value<int?> policyAcknowledgedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                code: code,
                firstName: firstName,
                lastName: lastName,
                status: status,
                terminationDate: terminationDate,
                vacationDaysPerYear: vacationDaysPerYear,
                secondaryPhone: secondaryPhone,
                hireDate: hireDate,
                employeeRole: employeeRole,
                usePin: usePin,
                useNfc: useNfc,
                accessToken: accessToken,
                accessNote: accessNote,
                employmentType: employmentType,
                email: email,
                phone: phone,
                department: department,
                jobTitle: jobTitle,
                internalComment: internalComment,
                policyAcknowledged: policyAcknowledged,
                policyAcknowledgedAt: policyAcknowledgedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String firstName,
                required String lastName,
                Value<String> status = const Value.absent(),
                Value<int?> terminationDate = const Value.absent(),
                Value<int?> vacationDaysPerYear = const Value.absent(),
                Value<String?> secondaryPhone = const Value.absent(),
                Value<int?> hireDate = const Value.absent(),
                Value<String> employeeRole = const Value.absent(),
                Value<int> usePin = const Value.absent(),
                Value<int> useNfc = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> accessNote = const Value.absent(),
                Value<String?> employmentType = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<String?> internalComment = const Value.absent(),
                Value<int> policyAcknowledged = const Value.absent(),
                Value<int?> policyAcknowledgedAt = const Value.absent(),
                required int createdAt,
                Value<int?> updatedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                code: code,
                firstName: firstName,
                lastName: lastName,
                status: status,
                terminationDate: terminationDate,
                vacationDaysPerYear: vacationDaysPerYear,
                secondaryPhone: secondaryPhone,
                hireDate: hireDate,
                employeeRole: employeeRole,
                usePin: usePin,
                useNfc: useNfc,
                accessToken: accessToken,
                accessNote: accessNote,
                employmentType: employmentType,
                email: email,
                phone: phone,
                department: department,
                jobTitle: jobTitle,
                internalComment: internalComment,
                policyAcknowledged: policyAcknowledged,
                policyAcknowledgedAt: policyAcknowledgedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                employeeAuthsRefs = false,
                workSessionsRefs = false,
                employeeScheduleAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (employeeAuthsRefs) db.employeeAuths,
                    if (workSessionsRefs) db.workSessions,
                    if (employeeScheduleAssignmentsRefs)
                      db.employeeScheduleAssignments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (employeeAuthsRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          EmployeeAuth
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._employeeAuthsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).employeeAuthsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workSessionsRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          WorkSession
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._workSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).workSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (employeeScheduleAssignmentsRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          EmployeeScheduleAssignment
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._employeeScheduleAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).employeeScheduleAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({
        bool employeeAuthsRefs,
        bool workSessionsRefs,
        bool employeeScheduleAssignmentsRefs,
      })
    >;
typedef $$EmployeeAuthsTableCreateCompanionBuilder =
    EmployeeAuthsCompanion Function({
      Value<int> employeeId,
      required String pinHash,
      required Uint8List pinSalt,
      required int pinUpdatedAt,
    });
typedef $$EmployeeAuthsTableUpdateCompanionBuilder =
    EmployeeAuthsCompanion Function({
      Value<int> employeeId,
      Value<String> pinHash,
      Value<Uint8List> pinSalt,
      Value<int> pinUpdatedAt,
    });

final class $$EmployeeAuthsTableReferences
    extends BaseReferences<_$AppDb, $EmployeeAuthsTable, EmployeeAuth> {
  $$EmployeeAuthsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$AppDb db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.employeeAuths.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmployeeAuthsTableFilterComposer
    extends Composer<_$AppDb, $EmployeeAuthsTable> {
  $$EmployeeAuthsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinUpdatedAt => $composableBuilder(
    column: $table.pinUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmployeeAuthsTableOrderingComposer
    extends Composer<_$AppDb, $EmployeeAuthsTable> {
  $$EmployeeAuthsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinUpdatedAt => $composableBuilder(
    column: $table.pinUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmployeeAuthsTableAnnotationComposer
    extends Composer<_$AppDb, $EmployeeAuthsTable> {
  $$EmployeeAuthsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<Uint8List> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<int> get pinUpdatedAt => $composableBuilder(
    column: $table.pinUpdatedAt,
    builder: (column) => column,
  );

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmployeeAuthsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $EmployeeAuthsTable,
          EmployeeAuth,
          $$EmployeeAuthsTableFilterComposer,
          $$EmployeeAuthsTableOrderingComposer,
          $$EmployeeAuthsTableAnnotationComposer,
          $$EmployeeAuthsTableCreateCompanionBuilder,
          $$EmployeeAuthsTableUpdateCompanionBuilder,
          (EmployeeAuth, $$EmployeeAuthsTableReferences),
          EmployeeAuth,
          PrefetchHooks Function({bool employeeId})
        > {
  $$EmployeeAuthsTableTableManager(_$AppDb db, $EmployeeAuthsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeAuthsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeAuthsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeAuthsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> employeeId = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<Uint8List> pinSalt = const Value.absent(),
                Value<int> pinUpdatedAt = const Value.absent(),
              }) => EmployeeAuthsCompanion(
                employeeId: employeeId,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinUpdatedAt: pinUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> employeeId = const Value.absent(),
                required String pinHash,
                required Uint8List pinSalt,
                required int pinUpdatedAt,
              }) => EmployeeAuthsCompanion.insert(
                employeeId: employeeId,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinUpdatedAt: pinUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeeAuthsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$EmployeeAuthsTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$EmployeeAuthsTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmployeeAuthsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $EmployeeAuthsTable,
      EmployeeAuth,
      $$EmployeeAuthsTableFilterComposer,
      $$EmployeeAuthsTableOrderingComposer,
      $$EmployeeAuthsTableAnnotationComposer,
      $$EmployeeAuthsTableCreateCompanionBuilder,
      $$EmployeeAuthsTableUpdateCompanionBuilder,
      (EmployeeAuth, $$EmployeeAuthsTableReferences),
      EmployeeAuth,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String username,
      required String passwordHash,
      required String role,
      Value<int> isActive,
      required int createdAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> passwordHash,
      Value<String> role,
      Value<int> isActive,
      Value<int> createdAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDb, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer extends Composer<_$AppDb, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer extends Composer<_$AppDb, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDb, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDb db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String passwordHash,
                required String role,
                Value<int> isActive = const Value.absent(),
                required int createdAt,
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDb, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$DevicesTableCreateCompanionBuilder =
    DevicesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> location,
      Value<int> isActive,
      required int createdAt,
    });
typedef $$DevicesTableUpdateCompanionBuilder =
    DevicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> location,
      Value<int> isActive,
      Value<int> createdAt,
    });

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDb, $DevicesTable, Device> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkSessionsTable, List<WorkSession>>
  _workSessionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.workSessions,
    aliasName: $_aliasNameGenerator(db.devices.id, db.workSessions.deviceId),
  );

  $$WorkSessionsTableProcessedTableManager get workSessionsRefs {
    final manager = $$WorkSessionsTableTableManager(
      $_db,
      $_db.workSessions,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DevicesTableFilterComposer extends Composer<_$AppDb, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workSessionsRefs(
    Expression<bool> Function($$WorkSessionsTableFilterComposer f) f,
  ) {
    final $$WorkSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workSessions,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DevicesTableOrderingComposer extends Composer<_$AppDb, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDb, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> workSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workSessions,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $DevicesTable,
          Device,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (Device, $$DevicesTableReferences),
          Device,
          PrefetchHooks Function({bool workSessionsRefs})
        > {
  $$DevicesTableTableManager(_$AppDb db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                name: name,
                location: location,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> location = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                required int createdAt,
              }) => DevicesCompanion.insert(
                id: id,
                name: name,
                location: location,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workSessionsRefs) db.workSessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workSessionsRefs)
                    await $_getPrefetchedData<
                      Device,
                      $DevicesTable,
                      WorkSession
                    >(
                      currentTable: table,
                      referencedTable: $$DevicesTableReferences
                          ._workSessionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$DevicesTableReferences(
                        db,
                        table,
                        p0,
                      ).workSessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deviceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $DevicesTable,
      Device,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (Device, $$DevicesTableReferences),
      Device,
      PrefetchHooks Function({bool workSessionsRefs})
    >;
typedef $$WorkSessionsTableCreateCompanionBuilder =
    WorkSessionsCompanion Function({
      Value<int> id,
      required int employeeId,
      Value<int?> deviceId,
      required int startTs,
      Value<int?> endTs,
      required String status,
      required String source,
      Value<String?> note,
      required int createdAt,
      Value<String?> createdBy,
      Value<int?> updatedAt,
      Value<String?> updatedBy,
      Value<String?> updateReason,
    });
typedef $$WorkSessionsTableUpdateCompanionBuilder =
    WorkSessionsCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<int?> deviceId,
      Value<int> startTs,
      Value<int?> endTs,
      Value<String> status,
      Value<String> source,
      Value<String?> note,
      Value<int> createdAt,
      Value<String?> createdBy,
      Value<int?> updatedAt,
      Value<String?> updatedBy,
      Value<String?> updateReason,
    });

final class $$WorkSessionsTableReferences
    extends BaseReferences<_$AppDb, $WorkSessionsTable, WorkSession> {
  $$WorkSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDb db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.workSessions.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DevicesTable _deviceIdTable(_$AppDb db) => db.devices.createAlias(
    $_aliasNameGenerator(db.workSessions.deviceId, db.devices.id),
  );

  $$DevicesTableProcessedTableManager? get deviceId {
    final $_column = $_itemColumn<int>('device_id');
    if ($_column == null) return null;
    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkSessionsTableFilterComposer
    extends Composer<_$AppDb, $WorkSessionsTable> {
  $$WorkSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTs => $composableBuilder(
    column: $table.startTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTs => $composableBuilder(
    column: $table.endTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updateReason => $composableBuilder(
    column: $table.updateReason,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkSessionsTableOrderingComposer
    extends Composer<_$AppDb, $WorkSessionsTable> {
  $$WorkSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTs => $composableBuilder(
    column: $table.startTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTs => $composableBuilder(
    column: $table.endTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updateReason => $composableBuilder(
    column: $table.updateReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkSessionsTableAnnotationComposer
    extends Composer<_$AppDb, $WorkSessionsTable> {
  $$WorkSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startTs =>
      $composableBuilder(column: $table.startTs, builder: (column) => column);

  GeneratedColumn<int> get endTs =>
      $composableBuilder(column: $table.endTs, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get updateReason => $composableBuilder(
    column: $table.updateReason,
    builder: (column) => column,
  );

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $WorkSessionsTable,
          WorkSession,
          $$WorkSessionsTableFilterComposer,
          $$WorkSessionsTableOrderingComposer,
          $$WorkSessionsTableAnnotationComposer,
          $$WorkSessionsTableCreateCompanionBuilder,
          $$WorkSessionsTableUpdateCompanionBuilder,
          (WorkSession, $$WorkSessionsTableReferences),
          WorkSession,
          PrefetchHooks Function({bool employeeId, bool deviceId})
        > {
  $$WorkSessionsTableTableManager(_$AppDb db, $WorkSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<int?> deviceId = const Value.absent(),
                Value<int> startTs = const Value.absent(),
                Value<int?> endTs = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<String?> updateReason = const Value.absent(),
              }) => WorkSessionsCompanion(
                id: id,
                employeeId: employeeId,
                deviceId: deviceId,
                startTs: startTs,
                endTs: endTs,
                status: status,
                source: source,
                note: note,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                updateReason: updateReason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                Value<int?> deviceId = const Value.absent(),
                required int startTs,
                Value<int?> endTs = const Value.absent(),
                required String status,
                required String source,
                Value<String?> note = const Value.absent(),
                required int createdAt,
                Value<String?> createdBy = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<String?> updateReason = const Value.absent(),
              }) => WorkSessionsCompanion.insert(
                id: id,
                employeeId: employeeId,
                deviceId: deviceId,
                startTs: startTs,
                endTs: endTs,
                status: status,
                source: source,
                note: note,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                updateReason: updateReason,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false, deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$WorkSessionsTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$WorkSessionsTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable: $$WorkSessionsTableReferences
                                    ._deviceIdTable(db),
                                referencedColumn: $$WorkSessionsTableReferences
                                    ._deviceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $WorkSessionsTable,
      WorkSession,
      $$WorkSessionsTableFilterComposer,
      $$WorkSessionsTableOrderingComposer,
      $$WorkSessionsTableAnnotationComposer,
      $$WorkSessionsTableCreateCompanionBuilder,
      $$WorkSessionsTableUpdateCompanionBuilder,
      (WorkSession, $$WorkSessionsTableReferences),
      WorkSession,
      PrefetchHooks Function({bool employeeId, bool deviceId})
    >;
typedef $$ShiftScheduleTemplatesTableCreateCompanionBuilder =
    ShiftScheduleTemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<int> isActive,
      required int createdAt,
    });
typedef $$ShiftScheduleTemplatesTableUpdateCompanionBuilder =
    ShiftScheduleTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> isActive,
      Value<int> createdAt,
    });

final class $$ShiftScheduleTemplatesTableReferences
    extends
        BaseReferences<
          _$AppDb,
          $ShiftScheduleTemplatesTable,
          ShiftScheduleTemplate
        > {
  $$ShiftScheduleTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ShiftScheduleTemplateDaysTable,
    List<ShiftScheduleTemplateDay>
  >
  _shiftScheduleTemplateDaysRefsTable(_$AppDb db) =>
      MultiTypedResultKey.fromTable(
        db.shiftScheduleTemplateDays,
        aliasName: $_aliasNameGenerator(
          db.shiftScheduleTemplates.id,
          db.shiftScheduleTemplateDays.templateId,
        ),
      );

  $$ShiftScheduleTemplateDaysTableProcessedTableManager
  get shiftScheduleTemplateDaysRefs {
    final manager = $$ShiftScheduleTemplateDaysTableTableManager(
      $_db,
      $_db.shiftScheduleTemplateDays,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftScheduleTemplateDaysRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EmployeeScheduleAssignmentsTable,
    List<EmployeeScheduleAssignment>
  >
  _employeeScheduleAssignmentsRefsTable(_$AppDb db) =>
      MultiTypedResultKey.fromTable(
        db.employeeScheduleAssignments,
        aliasName: $_aliasNameGenerator(
          db.shiftScheduleTemplates.id,
          db.employeeScheduleAssignments.templateId,
        ),
      );

  $$EmployeeScheduleAssignmentsTableProcessedTableManager
  get employeeScheduleAssignmentsRefs {
    final manager = $$EmployeeScheduleAssignmentsTableTableManager(
      $_db,
      $_db.employeeScheduleAssignments,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _employeeScheduleAssignmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftScheduleTemplatesTableFilterComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplatesTable> {
  $$ShiftScheduleTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shiftScheduleTemplateDaysRefs(
    Expression<bool> Function($$ShiftScheduleTemplateDaysTableFilterComposer f)
    f,
  ) {
    final $$ShiftScheduleTemplateDaysTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftScheduleTemplateDays,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateDaysTableFilterComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateDays,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> employeeScheduleAssignmentsRefs(
    Expression<bool> Function(
      $$EmployeeScheduleAssignmentsTableFilterComposer f,
    )
    f,
  ) {
    final $$EmployeeScheduleAssignmentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeScheduleAssignments,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeScheduleAssignmentsTableFilterComposer(
                $db: $db,
                $table: $db.employeeScheduleAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftScheduleTemplatesTableOrderingComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplatesTable> {
  $$ShiftScheduleTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftScheduleTemplatesTableAnnotationComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplatesTable> {
  $$ShiftScheduleTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> shiftScheduleTemplateDaysRefs<T extends Object>(
    Expression<T> Function($$ShiftScheduleTemplateDaysTableAnnotationComposer a)
    f,
  ) {
    final $$ShiftScheduleTemplateDaysTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftScheduleTemplateDays,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateDaysTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateDays,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> employeeScheduleAssignmentsRefs<T extends Object>(
    Expression<T> Function(
      $$EmployeeScheduleAssignmentsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$EmployeeScheduleAssignmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeScheduleAssignments,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeScheduleAssignmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.employeeScheduleAssignments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftScheduleTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ShiftScheduleTemplatesTable,
          ShiftScheduleTemplate,
          $$ShiftScheduleTemplatesTableFilterComposer,
          $$ShiftScheduleTemplatesTableOrderingComposer,
          $$ShiftScheduleTemplatesTableAnnotationComposer,
          $$ShiftScheduleTemplatesTableCreateCompanionBuilder,
          $$ShiftScheduleTemplatesTableUpdateCompanionBuilder,
          (ShiftScheduleTemplate, $$ShiftScheduleTemplatesTableReferences),
          ShiftScheduleTemplate,
          PrefetchHooks Function({
            bool shiftScheduleTemplateDaysRefs,
            bool employeeScheduleAssignmentsRefs,
          })
        > {
  $$ShiftScheduleTemplatesTableTableManager(
    _$AppDb db,
    $ShiftScheduleTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftScheduleTemplatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftScheduleTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftScheduleTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => ShiftScheduleTemplatesCompanion(
                id: id,
                name: name,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> isActive = const Value.absent(),
                required int createdAt,
              }) => ShiftScheduleTemplatesCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftScheduleTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shiftScheduleTemplateDaysRefs = false,
                employeeScheduleAssignmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shiftScheduleTemplateDaysRefs)
                      db.shiftScheduleTemplateDays,
                    if (employeeScheduleAssignmentsRefs)
                      db.employeeScheduleAssignments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shiftScheduleTemplateDaysRefs)
                        await $_getPrefetchedData<
                          ShiftScheduleTemplate,
                          $ShiftScheduleTemplatesTable,
                          ShiftScheduleTemplateDay
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ShiftScheduleTemplatesTableReferences
                                  ._shiftScheduleTemplateDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftScheduleTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftScheduleTemplateDaysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (employeeScheduleAssignmentsRefs)
                        await $_getPrefetchedData<
                          ShiftScheduleTemplate,
                          $ShiftScheduleTemplatesTable,
                          EmployeeScheduleAssignment
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ShiftScheduleTemplatesTableReferences
                                  ._employeeScheduleAssignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftScheduleTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).employeeScheduleAssignmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShiftScheduleTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ShiftScheduleTemplatesTable,
      ShiftScheduleTemplate,
      $$ShiftScheduleTemplatesTableFilterComposer,
      $$ShiftScheduleTemplatesTableOrderingComposer,
      $$ShiftScheduleTemplatesTableAnnotationComposer,
      $$ShiftScheduleTemplatesTableCreateCompanionBuilder,
      $$ShiftScheduleTemplatesTableUpdateCompanionBuilder,
      (ShiftScheduleTemplate, $$ShiftScheduleTemplatesTableReferences),
      ShiftScheduleTemplate,
      PrefetchHooks Function({
        bool shiftScheduleTemplateDaysRefs,
        bool employeeScheduleAssignmentsRefs,
      })
    >;
typedef $$ShiftScheduleTemplateDaysTableCreateCompanionBuilder =
    ShiftScheduleTemplateDaysCompanion Function({
      Value<int> id,
      required int templateId,
      required int weekday,
      Value<int> isDayOff,
    });
typedef $$ShiftScheduleTemplateDaysTableUpdateCompanionBuilder =
    ShiftScheduleTemplateDaysCompanion Function({
      Value<int> id,
      Value<int> templateId,
      Value<int> weekday,
      Value<int> isDayOff,
    });

final class $$ShiftScheduleTemplateDaysTableReferences
    extends
        BaseReferences<
          _$AppDb,
          $ShiftScheduleTemplateDaysTable,
          ShiftScheduleTemplateDay
        > {
  $$ShiftScheduleTemplateDaysTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftScheduleTemplatesTable _templateIdTable(_$AppDb db) =>
      db.shiftScheduleTemplates.createAlias(
        $_aliasNameGenerator(
          db.shiftScheduleTemplateDays.templateId,
          db.shiftScheduleTemplates.id,
        ),
      );

  $$ShiftScheduleTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$ShiftScheduleTemplatesTableTableManager(
      $_db,
      $_db.shiftScheduleTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ShiftScheduleTemplateIntervalsTable,
    List<ShiftScheduleTemplateInterval>
  >
  _shiftScheduleTemplateIntervalsRefsTable(_$AppDb db) =>
      MultiTypedResultKey.fromTable(
        db.shiftScheduleTemplateIntervals,
        aliasName: $_aliasNameGenerator(
          db.shiftScheduleTemplateDays.id,
          db.shiftScheduleTemplateIntervals.templateDayId,
        ),
      );

  $$ShiftScheduleTemplateIntervalsTableProcessedTableManager
  get shiftScheduleTemplateIntervalsRefs {
    final manager = $$ShiftScheduleTemplateIntervalsTableTableManager(
      $_db,
      $_db.shiftScheduleTemplateIntervals,
    ).filter((f) => f.templateDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftScheduleTemplateIntervalsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftScheduleTemplateDaysTableFilterComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplateDaysTable> {
  $$ShiftScheduleTemplateDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDayOff => $composableBuilder(
    column: $table.isDayOff,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftScheduleTemplatesTableFilterComposer get templateId {
    final $$ShiftScheduleTemplatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.shiftScheduleTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplatesTableFilterComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> shiftScheduleTemplateIntervalsRefs(
    Expression<bool> Function(
      $$ShiftScheduleTemplateIntervalsTableFilterComposer f,
    )
    f,
  ) {
    final $$ShiftScheduleTemplateIntervalsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftScheduleTemplateIntervals,
          getReferencedColumn: (t) => t.templateDayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateIntervalsTableFilterComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateIntervals,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftScheduleTemplateDaysTableOrderingComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplateDaysTable> {
  $$ShiftScheduleTemplateDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDayOff => $composableBuilder(
    column: $table.isDayOff,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftScheduleTemplatesTableOrderingComposer get templateId {
    final $$ShiftScheduleTemplatesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.shiftScheduleTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplatesTableOrderingComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftScheduleTemplateDaysTableAnnotationComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplateDaysTable> {
  $$ShiftScheduleTemplateDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get isDayOff =>
      $composableBuilder(column: $table.isDayOff, builder: (column) => column);

  $$ShiftScheduleTemplatesTableAnnotationComposer get templateId {
    final $$ShiftScheduleTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.shiftScheduleTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> shiftScheduleTemplateIntervalsRefs<T extends Object>(
    Expression<T> Function(
      $$ShiftScheduleTemplateIntervalsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ShiftScheduleTemplateIntervalsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftScheduleTemplateIntervals,
          getReferencedColumn: (t) => t.templateDayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateIntervalsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateIntervals,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftScheduleTemplateDaysTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ShiftScheduleTemplateDaysTable,
          ShiftScheduleTemplateDay,
          $$ShiftScheduleTemplateDaysTableFilterComposer,
          $$ShiftScheduleTemplateDaysTableOrderingComposer,
          $$ShiftScheduleTemplateDaysTableAnnotationComposer,
          $$ShiftScheduleTemplateDaysTableCreateCompanionBuilder,
          $$ShiftScheduleTemplateDaysTableUpdateCompanionBuilder,
          (
            ShiftScheduleTemplateDay,
            $$ShiftScheduleTemplateDaysTableReferences,
          ),
          ShiftScheduleTemplateDay,
          PrefetchHooks Function({
            bool templateId,
            bool shiftScheduleTemplateIntervalsRefs,
          })
        > {
  $$ShiftScheduleTemplateDaysTableTableManager(
    _$AppDb db,
    $ShiftScheduleTemplateDaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftScheduleTemplateDaysTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftScheduleTemplateDaysTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftScheduleTemplateDaysTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> isDayOff = const Value.absent(),
              }) => ShiftScheduleTemplateDaysCompanion(
                id: id,
                templateId: templateId,
                weekday: weekday,
                isDayOff: isDayOff,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateId,
                required int weekday,
                Value<int> isDayOff = const Value.absent(),
              }) => ShiftScheduleTemplateDaysCompanion.insert(
                id: id,
                templateId: templateId,
                weekday: weekday,
                isDayOff: isDayOff,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftScheduleTemplateDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                templateId = false,
                shiftScheduleTemplateIntervalsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shiftScheduleTemplateIntervalsRefs)
                      db.shiftScheduleTemplateIntervals,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (templateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.templateId,
                                    referencedTable:
                                        $$ShiftScheduleTemplateDaysTableReferences
                                            ._templateIdTable(db),
                                    referencedColumn:
                                        $$ShiftScheduleTemplateDaysTableReferences
                                            ._templateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shiftScheduleTemplateIntervalsRefs)
                        await $_getPrefetchedData<
                          ShiftScheduleTemplateDay,
                          $ShiftScheduleTemplateDaysTable,
                          ShiftScheduleTemplateInterval
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ShiftScheduleTemplateDaysTableReferences
                                  ._shiftScheduleTemplateIntervalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftScheduleTemplateDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftScheduleTemplateIntervalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShiftScheduleTemplateDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ShiftScheduleTemplateDaysTable,
      ShiftScheduleTemplateDay,
      $$ShiftScheduleTemplateDaysTableFilterComposer,
      $$ShiftScheduleTemplateDaysTableOrderingComposer,
      $$ShiftScheduleTemplateDaysTableAnnotationComposer,
      $$ShiftScheduleTemplateDaysTableCreateCompanionBuilder,
      $$ShiftScheduleTemplateDaysTableUpdateCompanionBuilder,
      (ShiftScheduleTemplateDay, $$ShiftScheduleTemplateDaysTableReferences),
      ShiftScheduleTemplateDay,
      PrefetchHooks Function({
        bool templateId,
        bool shiftScheduleTemplateIntervalsRefs,
      })
    >;
typedef $$ShiftScheduleTemplateIntervalsTableCreateCompanionBuilder =
    ShiftScheduleTemplateIntervalsCompanion Function({
      Value<int> id,
      required int templateDayId,
      required int startMin,
      required int endMin,
      Value<int> crossesMidnight,
    });
typedef $$ShiftScheduleTemplateIntervalsTableUpdateCompanionBuilder =
    ShiftScheduleTemplateIntervalsCompanion Function({
      Value<int> id,
      Value<int> templateDayId,
      Value<int> startMin,
      Value<int> endMin,
      Value<int> crossesMidnight,
    });

final class $$ShiftScheduleTemplateIntervalsTableReferences
    extends
        BaseReferences<
          _$AppDb,
          $ShiftScheduleTemplateIntervalsTable,
          ShiftScheduleTemplateInterval
        > {
  $$ShiftScheduleTemplateIntervalsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftScheduleTemplateDaysTable _templateDayIdTable(_$AppDb db) =>
      db.shiftScheduleTemplateDays.createAlias(
        $_aliasNameGenerator(
          db.shiftScheduleTemplateIntervals.templateDayId,
          db.shiftScheduleTemplateDays.id,
        ),
      );

  $$ShiftScheduleTemplateDaysTableProcessedTableManager get templateDayId {
    final $_column = $_itemColumn<int>('template_day_id')!;

    final manager = $$ShiftScheduleTemplateDaysTableTableManager(
      $_db,
      $_db.shiftScheduleTemplateDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftScheduleTemplateIntervalsTableFilterComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplateIntervalsTable> {
  $$ShiftScheduleTemplateIntervalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMin => $composableBuilder(
    column: $table.startMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMin => $composableBuilder(
    column: $table.endMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get crossesMidnight => $composableBuilder(
    column: $table.crossesMidnight,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftScheduleTemplateDaysTableFilterComposer get templateDayId {
    final $$ShiftScheduleTemplateDaysTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateDayId,
          referencedTable: $db.shiftScheduleTemplateDays,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateDaysTableFilterComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateDays,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftScheduleTemplateIntervalsTableOrderingComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplateIntervalsTable> {
  $$ShiftScheduleTemplateIntervalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMin => $composableBuilder(
    column: $table.startMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMin => $composableBuilder(
    column: $table.endMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get crossesMidnight => $composableBuilder(
    column: $table.crossesMidnight,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftScheduleTemplateDaysTableOrderingComposer get templateDayId {
    final $$ShiftScheduleTemplateDaysTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateDayId,
          referencedTable: $db.shiftScheduleTemplateDays,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateDaysTableOrderingComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateDays,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftScheduleTemplateIntervalsTableAnnotationComposer
    extends Composer<_$AppDb, $ShiftScheduleTemplateIntervalsTable> {
  $$ShiftScheduleTemplateIntervalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startMin =>
      $composableBuilder(column: $table.startMin, builder: (column) => column);

  GeneratedColumn<int> get endMin =>
      $composableBuilder(column: $table.endMin, builder: (column) => column);

  GeneratedColumn<int> get crossesMidnight => $composableBuilder(
    column: $table.crossesMidnight,
    builder: (column) => column,
  );

  $$ShiftScheduleTemplateDaysTableAnnotationComposer get templateDayId {
    final $$ShiftScheduleTemplateDaysTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateDayId,
          referencedTable: $db.shiftScheduleTemplateDays,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplateDaysTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplateDays,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftScheduleTemplateIntervalsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ShiftScheduleTemplateIntervalsTable,
          ShiftScheduleTemplateInterval,
          $$ShiftScheduleTemplateIntervalsTableFilterComposer,
          $$ShiftScheduleTemplateIntervalsTableOrderingComposer,
          $$ShiftScheduleTemplateIntervalsTableAnnotationComposer,
          $$ShiftScheduleTemplateIntervalsTableCreateCompanionBuilder,
          $$ShiftScheduleTemplateIntervalsTableUpdateCompanionBuilder,
          (
            ShiftScheduleTemplateInterval,
            $$ShiftScheduleTemplateIntervalsTableReferences,
          ),
          ShiftScheduleTemplateInterval,
          PrefetchHooks Function({bool templateDayId})
        > {
  $$ShiftScheduleTemplateIntervalsTableTableManager(
    _$AppDb db,
    $ShiftScheduleTemplateIntervalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftScheduleTemplateIntervalsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftScheduleTemplateIntervalsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftScheduleTemplateIntervalsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateDayId = const Value.absent(),
                Value<int> startMin = const Value.absent(),
                Value<int> endMin = const Value.absent(),
                Value<int> crossesMidnight = const Value.absent(),
              }) => ShiftScheduleTemplateIntervalsCompanion(
                id: id,
                templateDayId: templateDayId,
                startMin: startMin,
                endMin: endMin,
                crossesMidnight: crossesMidnight,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateDayId,
                required int startMin,
                required int endMin,
                Value<int> crossesMidnight = const Value.absent(),
              }) => ShiftScheduleTemplateIntervalsCompanion.insert(
                id: id,
                templateDayId: templateDayId,
                startMin: startMin,
                endMin: endMin,
                crossesMidnight: crossesMidnight,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftScheduleTemplateIntervalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateDayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateDayId,
                                referencedTable:
                                    $$ShiftScheduleTemplateIntervalsTableReferences
                                        ._templateDayIdTable(db),
                                referencedColumn:
                                    $$ShiftScheduleTemplateIntervalsTableReferences
                                        ._templateDayIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShiftScheduleTemplateIntervalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ShiftScheduleTemplateIntervalsTable,
      ShiftScheduleTemplateInterval,
      $$ShiftScheduleTemplateIntervalsTableFilterComposer,
      $$ShiftScheduleTemplateIntervalsTableOrderingComposer,
      $$ShiftScheduleTemplateIntervalsTableAnnotationComposer,
      $$ShiftScheduleTemplateIntervalsTableCreateCompanionBuilder,
      $$ShiftScheduleTemplateIntervalsTableUpdateCompanionBuilder,
      (
        ShiftScheduleTemplateInterval,
        $$ShiftScheduleTemplateIntervalsTableReferences,
      ),
      ShiftScheduleTemplateInterval,
      PrefetchHooks Function({bool templateDayId})
    >;
typedef $$EmployeeScheduleAssignmentsTableCreateCompanionBuilder =
    EmployeeScheduleAssignmentsCompanion Function({
      Value<int> employeeId,
      required int templateId,
      required int createdAt,
    });
typedef $$EmployeeScheduleAssignmentsTableUpdateCompanionBuilder =
    EmployeeScheduleAssignmentsCompanion Function({
      Value<int> employeeId,
      Value<int> templateId,
      Value<int> createdAt,
    });

final class $$EmployeeScheduleAssignmentsTableReferences
    extends
        BaseReferences<
          _$AppDb,
          $EmployeeScheduleAssignmentsTable,
          EmployeeScheduleAssignment
        > {
  $$EmployeeScheduleAssignmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$AppDb db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(
          db.employeeScheduleAssignments.employeeId,
          db.employees.id,
        ),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShiftScheduleTemplatesTable _templateIdTable(_$AppDb db) =>
      db.shiftScheduleTemplates.createAlias(
        $_aliasNameGenerator(
          db.employeeScheduleAssignments.templateId,
          db.shiftScheduleTemplates.id,
        ),
      );

  $$ShiftScheduleTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$ShiftScheduleTemplatesTableTableManager(
      $_db,
      $_db.shiftScheduleTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmployeeScheduleAssignmentsTableFilterComposer
    extends Composer<_$AppDb, $EmployeeScheduleAssignmentsTable> {
  $$EmployeeScheduleAssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftScheduleTemplatesTableFilterComposer get templateId {
    final $$ShiftScheduleTemplatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.shiftScheduleTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplatesTableFilterComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EmployeeScheduleAssignmentsTableOrderingComposer
    extends Composer<_$AppDb, $EmployeeScheduleAssignmentsTable> {
  $$EmployeeScheduleAssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftScheduleTemplatesTableOrderingComposer get templateId {
    final $$ShiftScheduleTemplatesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.shiftScheduleTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplatesTableOrderingComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EmployeeScheduleAssignmentsTableAnnotationComposer
    extends Composer<_$AppDb, $EmployeeScheduleAssignmentsTable> {
  $$EmployeeScheduleAssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShiftScheduleTemplatesTableAnnotationComposer get templateId {
    final $$ShiftScheduleTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.templateId,
          referencedTable: $db.shiftScheduleTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftScheduleTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftScheduleTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EmployeeScheduleAssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $EmployeeScheduleAssignmentsTable,
          EmployeeScheduleAssignment,
          $$EmployeeScheduleAssignmentsTableFilterComposer,
          $$EmployeeScheduleAssignmentsTableOrderingComposer,
          $$EmployeeScheduleAssignmentsTableAnnotationComposer,
          $$EmployeeScheduleAssignmentsTableCreateCompanionBuilder,
          $$EmployeeScheduleAssignmentsTableUpdateCompanionBuilder,
          (
            EmployeeScheduleAssignment,
            $$EmployeeScheduleAssignmentsTableReferences,
          ),
          EmployeeScheduleAssignment,
          PrefetchHooks Function({bool employeeId, bool templateId})
        > {
  $$EmployeeScheduleAssignmentsTableTableManager(
    _$AppDb db,
    $EmployeeScheduleAssignmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeScheduleAssignmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EmployeeScheduleAssignmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmployeeScheduleAssignmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> employeeId = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => EmployeeScheduleAssignmentsCompanion(
                employeeId: employeeId,
                templateId: templateId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> employeeId = const Value.absent(),
                required int templateId,
                required int createdAt,
              }) => EmployeeScheduleAssignmentsCompanion.insert(
                employeeId: employeeId,
                templateId: templateId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeeScheduleAssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false, templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable:
                                    $$EmployeeScheduleAssignmentsTableReferences
                                        ._employeeIdTable(db),
                                referencedColumn:
                                    $$EmployeeScheduleAssignmentsTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable:
                                    $$EmployeeScheduleAssignmentsTableReferences
                                        ._templateIdTable(db),
                                referencedColumn:
                                    $$EmployeeScheduleAssignmentsTableReferences
                                        ._templateIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmployeeScheduleAssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $EmployeeScheduleAssignmentsTable,
      EmployeeScheduleAssignment,
      $$EmployeeScheduleAssignmentsTableFilterComposer,
      $$EmployeeScheduleAssignmentsTableOrderingComposer,
      $$EmployeeScheduleAssignmentsTableAnnotationComposer,
      $$EmployeeScheduleAssignmentsTableCreateCompanionBuilder,
      $$EmployeeScheduleAssignmentsTableUpdateCompanionBuilder,
      (
        EmployeeScheduleAssignment,
        $$EmployeeScheduleAssignmentsTableReferences,
      ),
      EmployeeScheduleAssignment,
      PrefetchHooks Function({bool employeeId, bool templateId})
    >;
typedef $$AbsencesTableCreateCompanionBuilder =
    AbsencesCompanion Function({
      Value<int> id,
      required int employeeId,
      required String dateFrom,
      required String dateTo,
      required String type,
      Value<String?> note,
      Value<String> status,
      required int createdAt,
      Value<int?> createdByEmployeeId,
      Value<int?> approvedAt,
      Value<String?> approvedBy,
      Value<String?> rejectReason,
    });
typedef $$AbsencesTableUpdateCompanionBuilder =
    AbsencesCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<String> dateFrom,
      Value<String> dateTo,
      Value<String> type,
      Value<String?> note,
      Value<String> status,
      Value<int> createdAt,
      Value<int?> createdByEmployeeId,
      Value<int?> approvedAt,
      Value<String?> approvedBy,
      Value<String?> rejectReason,
    });

final class $$AbsencesTableReferences
    extends BaseReferences<_$AppDb, $AbsencesTable, Absence> {
  $$AbsencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDb db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.absences.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _createdByEmployeeIdTable(_$AppDb db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.absences.createdByEmployeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get createdByEmployeeId {
    final $_column = $_itemColumn<int>('created_by_employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByEmployeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AbsencesTableFilterComposer extends Composer<_$AppDb, $AbsencesTable> {
  $$AbsencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateFrom => $composableBuilder(
    column: $table.dateFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateTo => $composableBuilder(
    column: $table.dateTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectReason => $composableBuilder(
    column: $table.rejectReason,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get createdByEmployeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByEmployeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbsencesTableOrderingComposer
    extends Composer<_$AppDb, $AbsencesTable> {
  $$AbsencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateFrom => $composableBuilder(
    column: $table.dateFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateTo => $composableBuilder(
    column: $table.dateTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectReason => $composableBuilder(
    column: $table.rejectReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get createdByEmployeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByEmployeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbsencesTableAnnotationComposer
    extends Composer<_$AppDb, $AbsencesTable> {
  $$AbsencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateFrom =>
      $composableBuilder(column: $table.dateFrom, builder: (column) => column);

  GeneratedColumn<String> get dateTo =>
      $composableBuilder(column: $table.dateTo, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get approvedAt => $composableBuilder(
    column: $table.approvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvedBy => $composableBuilder(
    column: $table.approvedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectReason => $composableBuilder(
    column: $table.rejectReason,
    builder: (column) => column,
  );

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get createdByEmployeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdByEmployeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbsencesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AbsencesTable,
          Absence,
          $$AbsencesTableFilterComposer,
          $$AbsencesTableOrderingComposer,
          $$AbsencesTableAnnotationComposer,
          $$AbsencesTableCreateCompanionBuilder,
          $$AbsencesTableUpdateCompanionBuilder,
          (Absence, $$AbsencesTableReferences),
          Absence,
          PrefetchHooks Function({bool employeeId, bool createdByEmployeeId})
        > {
  $$AbsencesTableTableManager(_$AppDb db, $AbsencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbsencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbsencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbsencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String> dateFrom = const Value.absent(),
                Value<String> dateTo = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> createdByEmployeeId = const Value.absent(),
                Value<int?> approvedAt = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<String?> rejectReason = const Value.absent(),
              }) => AbsencesCompanion(
                id: id,
                employeeId: employeeId,
                dateFrom: dateFrom,
                dateTo: dateTo,
                type: type,
                note: note,
                status: status,
                createdAt: createdAt,
                createdByEmployeeId: createdByEmployeeId,
                approvedAt: approvedAt,
                approvedBy: approvedBy,
                rejectReason: rejectReason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                required String dateFrom,
                required String dateTo,
                required String type,
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int createdAt,
                Value<int?> createdByEmployeeId = const Value.absent(),
                Value<int?> approvedAt = const Value.absent(),
                Value<String?> approvedBy = const Value.absent(),
                Value<String?> rejectReason = const Value.absent(),
              }) => AbsencesCompanion.insert(
                id: id,
                employeeId: employeeId,
                dateFrom: dateFrom,
                dateTo: dateTo,
                type: type,
                note: note,
                status: status,
                createdAt: createdAt,
                createdByEmployeeId: createdByEmployeeId,
                approvedAt: approvedAt,
                approvedBy: approvedBy,
                rejectReason: rejectReason,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AbsencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({employeeId = false, createdByEmployeeId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable: $$AbsencesTableReferences
                                        ._employeeIdTable(db),
                                    referencedColumn: $$AbsencesTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (createdByEmployeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.createdByEmployeeId,
                                    referencedTable: $$AbsencesTableReferences
                                        ._createdByEmployeeIdTable(db),
                                    referencedColumn: $$AbsencesTableReferences
                                        ._createdByEmployeeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AbsencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AbsencesTable,
      Absence,
      $$AbsencesTableFilterComposer,
      $$AbsencesTableOrderingComposer,
      $$AbsencesTableAnnotationComposer,
      $$AbsencesTableCreateCompanionBuilder,
      $$AbsencesTableUpdateCompanionBuilder,
      (Absence, $$AbsencesTableReferences),
      Absence,
      PrefetchHooks Function({bool employeeId, bool createdByEmployeeId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDb, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDb, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDb, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (AppSetting, BaseReferences<_$AppDb, $AppSettingsTable, AppSetting>),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDb db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (AppSetting, BaseReferences<_$AppDb, $AppSettingsTable, AppSetting>),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$EmployeeAuthsTableTableManager get employeeAuths =>
      $$EmployeeAuthsTableTableManager(_db, _db.employeeAuths);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$WorkSessionsTableTableManager get workSessions =>
      $$WorkSessionsTableTableManager(_db, _db.workSessions);
  $$ShiftScheduleTemplatesTableTableManager get shiftScheduleTemplates =>
      $$ShiftScheduleTemplatesTableTableManager(
        _db,
        _db.shiftScheduleTemplates,
      );
  $$ShiftScheduleTemplateDaysTableTableManager get shiftScheduleTemplateDays =>
      $$ShiftScheduleTemplateDaysTableTableManager(
        _db,
        _db.shiftScheduleTemplateDays,
      );
  $$ShiftScheduleTemplateIntervalsTableTableManager
  get shiftScheduleTemplateIntervals =>
      $$ShiftScheduleTemplateIntervalsTableTableManager(
        _db,
        _db.shiftScheduleTemplateIntervals,
      );
  $$EmployeeScheduleAssignmentsTableTableManager
  get employeeScheduleAssignments =>
      $$EmployeeScheduleAssignmentsTableTableManager(
        _db,
        _db.employeeScheduleAssignments,
      );
  $$AbsencesTableTableManager get absences =>
      $$AbsencesTableTableManager(_db, _db.absences);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
