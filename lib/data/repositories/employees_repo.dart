import 'package:drift/drift.dart';

import '../../core/employee_pin_status.dart';
import '../../domain/entities/employee_details.dart';
import '../../domain/entities/employee_info.dart';
import '../../domain/entities/employee_status.dart';
import '../../domain/ports/employees_repo_port.dart';
import '../db/app_db.dart';
import '../../common/utils/pin_hash.dart';
import '../../common/utils/utc_clock.dart';
import 'repo_guard.dart';

String _statusToString(EmployeeStatus s) =>
    switch (s) {
      EmployeeStatus.active => 'active',
      EmployeeStatus.inactive => 'inactive',
      EmployeeStatus.archived => 'archived',
    };

class EmployeesRepo implements IEmployeesRepo {
  EmployeesRepo(this._db);

  final AppDb _db;

  @override
  Future<String> getSuggestedEmployeeCode() async {
    return _generateEmployeeCode();
  }

  Future<String> _generateEmployeeCode() async {
    final row = await _db
        .customSelect(
          'SELECT COALESCE(MAX(id), 0) AS max_id FROM employees;',
          readsFrom: {_db.employees},
        )
        .getSingle();
    final next = row.read<int>('max_id') + 1;
    return 'E${next.toString().padLeft(4, '0')}';
  }

  Future<void> ensureDemoEmployees() async {
    final existingCount = await _db
        .customSelect(
          'SELECT COUNT(*) AS c FROM employees;',
          readsFrom: {_db.employees},
        )
        .getSingle();

    final count = existingCount.read<int>('c');
    if (count > 0) return;

    final now = UtcClock.nowMs();
    final demo = <({String firstName, String lastName})>[
      (firstName: 'John', lastName: 'Smith'),
      (firstName: 'Jane', lastName: 'Doe'),
      (firstName: 'Alex', lastName: 'Johnson'),
    ];

    await _db.batch((b) {
      b.insertAll(_db.employees, [
        for (var idx = 0; idx < demo.length; idx++)
          EmployeesCompanion.insert(
            code: 'E${(idx + 1).toString().padLeft(4, '0')}',
            firstName: demo[idx].firstName,
            lastName: demo[idx].lastName,
            createdAt: now,
          ),
      ]);
    });
  }

  Stream<List<Employee>> watchActiveEmployees() {
    return (_db.select(_db.employees)
          ..where((e) => e.status.equals('active'))
          ..orderBy([
            (e) => OrderingTerm.asc(e.lastName),
            (e) => OrderingTerm.asc(e.firstName),
          ]))
        .watch();
  }

  Stream<List<Employee>> watchAllEmployees() {
    return (_db.select(_db.employees)..orderBy([
          (e) => OrderingTerm.asc(e.lastName),
          (e) => OrderingTerm.asc(e.firstName),
        ]))
        .watch();
  }

  @override
  Stream<List<EmployeeInfo>> streamActiveEmployees() {
    return watchActiveEmployees().map(
      (list) => list
          .map(
            (e) => EmployeeInfo(
              id: e.id,
              firstName: e.firstName,
              lastName: e.lastName,
              status: employeeStatusFromString(e.status),
              usePin: e.usePin == 1,
              policyAcknowledged: e.policyAcknowledged == 1,
            ),
          )
          .toList(),
    );
  }

  @override
  Stream<List<EmployeeInfo>> streamAllEmployees() {
    return watchAllEmployees().map(
      (list) => list
          .map(
            (e) => EmployeeInfo(
              id: e.id,
              firstName: e.firstName,
              lastName: e.lastName,
              status: employeeStatusFromString(e.status),
              usePin: e.usePin == 1,
              policyAcknowledged: e.policyAcknowledged == 1,
            ),
          )
          .toList(),
    );
  }

  Future<int> createEmployee({
    required String firstName,
    required String lastName,
  }) async {
    return guardRepoCall(() async {
      return _db.transaction(() async {
        final now = UtcClock.nowMs();
        final code = await _generateEmployeeCode();
        return _db
            .into(_db.employees)
            .insert(
              EmployeesCompanion.insert(
                code: code,
                firstName: firstName.trim(),
                lastName: lastName.trim(),
                createdAt: now,
              ),
            );
      });
    });
  }

  Future<int> createEmployeeWithDefaultSchedule({
    required String firstName,
    required String lastName,
    required int? templateId,
  }) async {
    return guardRepoCall(() async {
      return _db.transaction(() async {
        final now = UtcClock.nowMs();
        final code = await _generateEmployeeCode();
        final employeeId = await _db
            .into(_db.employees)
            .insert(
              EmployeesCompanion.insert(
                code: code,
                firstName: firstName.trim(),
                lastName: lastName.trim(),
                createdAt: now,
              ),
            );

        if (templateId != null) {
          await _db
              .into(_db.employeeScheduleAssignments)
              .insert(
                EmployeeScheduleAssignmentsCompanion(
                  employeeId: Value(employeeId),
                  templateId: Value(templateId),
                  createdAt: Value(now),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }

        return employeeId;
      });
    });
  }

  Future<void> updateEmployee({
    required int id,
    required String firstName,
    required String lastName,
    required EmployeeStatus status,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      await (_db.update(_db.employees)..where((e) => e.id.equals(id))).write(
        EmployeesCompanion(
          firstName: Value(firstName.trim()),
          lastName: Value(lastName.trim()),
          status: Value(_statusToString(status)),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> updateEmployeeWithDefaultSchedule({
    required int id,
    required String firstName,
    required String lastName,
    required EmployeeStatus status,
    required int? templateId,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      await _db.transaction(() async {
        await (_db.update(_db.employees)..where((e) => e.id.equals(id))).write(
          EmployeesCompanion(
            firstName: Value(firstName.trim()),
            lastName: Value(lastName.trim()),
            status: Value(_statusToString(status)),
            updatedAt: Value(now),
          ),
        );

        if (templateId == null) {
          await (_db.delete(
            _db.employeeScheduleAssignments,
          )..where((a) => a.employeeId.equals(id))).go();
          return;
        }

        await _db
            .into(_db.employeeScheduleAssignments)
            .insert(
              EmployeeScheduleAssignmentsCompanion(
                employeeId: Value(id),
                templateId: Value(templateId),
                createdAt: Value(now),
              ),
              mode: InsertMode.insertOrReplace,
            );
      });
    });
  }

  Future<void> setEmployeeActive({
    required int id,
    required bool isActive,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      final status =
          isActive ? EmployeeStatus.active : EmployeeStatus.inactive;
      await (_db.update(_db.employees)..where((e) => e.id.equals(id))).write(
        EmployeesCompanion(
          status: Value(_statusToString(status)),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<bool> checkCodeUnique(String code, {int? excludeEmployeeId}) async {
    final trimmed = code.trim().toUpperCase();
    if (trimmed.isEmpty) return false;
    final existing =
        await (_db.select(_db.employees)..where((e) {
              final match = e.code.equals(trimmed);
              if (excludeEmployeeId == null) return match;
              return match & e.id.equals(excludeEmployeeId).not();
            }))
            .getSingleOrNull();
    return existing == null;
  }

  @override
  Future<EmployeePinStatus> getPinStatus(int employeeId) async {
    final row = await (_db.select(
      _db.employeeAuths,
    )..where((a) => a.employeeId.equals(employeeId))).getSingleOrNull();
    return row != null ? EmployeePinStatus.set : EmployeePinStatus.notSet;
  }

  @override
  Future<void> setEmployeePin({
    required int employeeId,
    required String pin,
  }) async {
    return guardRepoCall(() async {
      final result = await PinHash.hashForEmployee(pin);
      final now = UtcClock.nowMs();
      await _db
          .into(_db.employeeAuths)
          .insert(
            EmployeeAuthsCompanion.insert(
              employeeId: Value(employeeId),
              pinHash: result.pinHash,
              pinSalt: result.pinSalt,
              pinUpdatedAt: now,
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
  }

  @override
  Future<EmployeeInfo?> getEmployee(int id) async {
    final row = await (_db.select(
      _db.employees,
    )..where((e) => e.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return EmployeeInfo(
      id: row.id,
      firstName: row.firstName,
      lastName: row.lastName,
      status: employeeStatusFromString(row.status),
    );
  }

  @override
  Future<EmployeeDetails?> getEmployeeDetails(int id) async {
    final row = await (_db.select(
      _db.employees,
    )..where((e) => e.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final assignment =
        await (_db.select(_db.employeeScheduleAssignments)
              ..where((a) => a.employeeId.equals(id))
              ..limit(1))
            .getSingleOrNull();
    return EmployeeDetails(
      id: row.id,
      code: row.code,
      firstName: row.firstName,
      lastName: row.lastName,
      status: employeeStatusFromString(row.status),
      usePin: row.usePin == 1,
      useNfc: row.useNfc == 1,
      accessToken: row.accessToken,
      accessNote: row.accessNote,
      employmentType: row.employmentType,
      weeklyHours: row.weeklyHours,
      email: row.email,
      phone: row.phone,
      secondaryPhone: row.secondaryPhone,
      department: row.department,
      jobTitle: row.jobTitle,
      internalComment: row.internalComment,
      policyAcknowledged: row.policyAcknowledged == 1,
      policyAcknowledgedAt: row.policyAcknowledgedAt,
      hireDate: row.hireDate,
      terminationDate: row.terminationDate,
      vacationDaysPerYear: row.vacationDaysPerYear,
      employeeRole: row.employeeRole,
      templateId: assignment?.templateId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<Employee?> getEmployeeRaw(int id) async {
    return (_db.select(
      _db.employees,
    )..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<int> createEmployeeFull({
    required String code,
    required String firstName,
    required String lastName,
    EmployeeStatus status = EmployeeStatus.active,
    int? hireDate,
    int? terminationDate,
    int? vacationDaysPerYear,
    String employeeRole = 'employee',
    bool usePin = false,
    bool useNfc = false,
    String? accessToken,
    String? accessNote,
    String? employmentType,
    double? weeklyHours,
    String? email,
    String? phone,
    String? secondaryPhone,
    String? department,
    String? jobTitle,
    String? internalComment,
    bool policyAcknowledged = false,
    int? policyAcknowledgedAt,
    required int? templateId,
    String? createdBy,
  }) async {
    return guardRepoCall(() async {
      return _db.transaction(() async {
        final now = UtcClock.nowMs();
        final employeeId = await _db
            .into(_db.employees)
            .insert(
              EmployeesCompanion.insert(
                code: code.trim().toUpperCase(),
                firstName: firstName.trim(),
                lastName: lastName.trim(),
                status: Value(_statusToString(status)),
                hireDate: Value(hireDate),
                terminationDate: Value(terminationDate),
                vacationDaysPerYear: Value(vacationDaysPerYear),
                employeeRole: Value(employeeRole),
                usePin: Value(usePin ? 1 : 0),
                useNfc: Value(useNfc ? 1 : 0),
                accessToken: Value(accessToken?.trim()),
                accessNote: Value(accessNote?.trim()),
                employmentType: Value(employmentType),
                weeklyHours: Value(weeklyHours),
                email: Value(email?.trim()),
                phone: Value(phone?.trim()),
                secondaryPhone: Value(secondaryPhone?.trim()),
                department: Value(department?.trim()),
                jobTitle: Value(jobTitle?.trim()),
                internalComment: Value(internalComment?.trim()),
                policyAcknowledged: Value(policyAcknowledged ? 1 : 0),
                policyAcknowledgedAt: Value(policyAcknowledgedAt),
                createdAt: now,
                updatedAt: Value(now),
                createdBy: Value(createdBy),
                updatedBy: Value(createdBy),
              ),
            );
        if (templateId != null) {
          await _db
              .into(_db.employeeScheduleAssignments)
              .insert(
                EmployeeScheduleAssignmentsCompanion(
                  employeeId: Value(employeeId),
                  templateId: Value(templateId),
                  createdAt: Value(now),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
        return employeeId;
      });
    });
  }

  @override
  Future<void> updateEmployeeFull({
    required int id,
    required String code,
    required String firstName,
    required String lastName,
    EmployeeStatus status = EmployeeStatus.active,
    int? hireDate,
    int? terminationDate,
    int? vacationDaysPerYear,
    String employeeRole = 'employee',
    bool usePin = false,
    bool useNfc = false,
    String? accessToken,
    String? accessNote,
    String? employmentType,
    double? weeklyHours,
    String? email,
    String? phone,
    String? secondaryPhone,
    String? department,
    String? jobTitle,
    String? internalComment,
    bool policyAcknowledged = false,
    int? policyAcknowledgedAt,
    int? templateId,
    String? updatedBy,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      await _db.transaction(() async {
        await (_db.update(_db.employees)..where((e) => e.id.equals(id))).write(
          EmployeesCompanion(
            code: Value(code.trim().toUpperCase()),
            firstName: Value(firstName.trim()),
            lastName: Value(lastName.trim()),
            status: Value(_statusToString(status)),
            hireDate: Value(hireDate),
            terminationDate: Value(terminationDate),
            vacationDaysPerYear: Value(vacationDaysPerYear),
            employeeRole: Value(employeeRole),
            usePin: Value(usePin ? 1 : 0),
            useNfc: Value(useNfc ? 1 : 0),
            accessToken: Value(accessToken?.trim()),
            accessNote: Value(accessNote?.trim()),
            employmentType: Value(employmentType),
            weeklyHours: Value(weeklyHours),
            email: Value(email?.trim()),
            phone: Value(phone?.trim()),
            secondaryPhone: Value(secondaryPhone?.trim()),
            department: Value(department?.trim()),
            jobTitle: Value(jobTitle?.trim()),
            internalComment: Value(internalComment?.trim()),
            policyAcknowledged: Value(policyAcknowledged ? 1 : 0),
            policyAcknowledgedAt: Value(policyAcknowledgedAt),
            updatedAt: Value(now),
            updatedBy: Value(updatedBy),
          ),
        );
        if (templateId == null) {
          await (_db.delete(
            _db.employeeScheduleAssignments,
          )..where((a) => a.employeeId.equals(id))).go();
        } else {
          await _db
              .into(_db.employeeScheduleAssignments)
              .insert(
                EmployeeScheduleAssignmentsCompanion(
                  employeeId: Value(id),
                  templateId: Value(templateId),
                  createdAt: Value(now),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      });
    });
  }

  @override
  Future<bool> verifyEmployeePin({
    required int employeeId,
    required String pin,
  }) async {
    final row = await (_db.select(
      _db.employeeAuths,
    )..where((a) => a.employeeId.equals(employeeId))).getSingleOrNull();
    if (row == null) return false;

    return PinHash.verifyForEmployee(
      pin: pin,
      pinHash: row.pinHash,
      pinSalt: row.pinSalt,
    );
  }

  @override
  Future<void> updateEmployeePolicyAcknowledged(
    int employeeId, {
    required bool acknowledged,
    required int? acknowledgedAt,
  }) async {
    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      await (_db.update(
        _db.employees,
      )..where((e) => e.id.equals(employeeId))).write(
        EmployeesCompanion(
          policyAcknowledged: Value(acknowledged ? 1 : 0),
          policyAcknowledgedAt: Value(acknowledgedAt),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> resetEmployeePin(int employeeId) async {
    return guardRepoCall(() async {
      await (_db.delete(
        _db.employeeAuths,
      )..where((a) => a.employeeId.equals(employeeId))).go();
    });
  }
}
