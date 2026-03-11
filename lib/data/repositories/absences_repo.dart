import 'package:drift/drift.dart';

import '../../common/utils/date_utils.dart';
import '../../common/utils/utc_clock.dart';
import '../../core/domain_errors.dart';
import '../../domain/entities/absence_info.dart';
import '../../domain/entities/absence_with_employee_info.dart';
import '../../domain/entities/employee_info.dart';
import '../../domain/ports/absences_repo_port.dart';
import '../db/app_db.dart';
import 'repo_guard.dart';

class AbsenceWithEmployee {
  const AbsenceWithEmployee({required this.absence, required this.employee});

  final Absence absence;
  final Employee employee;
}

const _absenceTypes = [
  'vacation',
  'sick_leave',
  'unpaid_leave',
  'parental_leave',
  'study_leave',
  'other',
];

const _statusPending = 'PENDING';
const _statusApproved = 'APPROVED';
const _statusRejected = 'REJECTED';

class AbsencesRepo implements IAbsencesRepo {
  AbsencesRepo(this._db);

  final AppDb _db;

  static AbsenceInfo _toAbsenceInfo(Absence a) => AbsenceInfo(
    id: a.id,
    employeeId: a.employeeId,
    dateFrom: a.dateFrom,
    dateTo: a.dateTo,
    type: a.type,
    note: a.note,
    status: a.status,
    approvedAt: a.approvedAt,
    approvedBy: a.approvedBy,
    rejectReason: a.rejectReason,
    createdAt: a.createdAt,
    createdByEmployeeId: a.createdByEmployeeId,
  );

  static EmployeeInfo _toEmployeeInfo(Employee e) => EmployeeInfo(
    id: e.id,
    firstName: e.firstName,
    lastName: e.lastName,
    isActive: e.isActive == 1,
    usePin: e.usePin == 1,
    policyAcknowledged: e.policyAcknowledged == 1,
  );

  static AbsenceWithEmployeeInfo _toAbsenceWithEmployeeInfo(
    AbsenceWithEmployee row,
  ) => AbsenceWithEmployeeInfo(
    absence: _toAbsenceInfo(row.absence),
    employee: _toEmployeeInfo(row.employee),
  );

  @override
  Stream<List<AbsenceWithEmployeeInfo>> streamAbsences({
    int? employeeId,
    String? fromDate,
    String? toDate,
    String? status,
  }) {
    return watchAbsences(
      employeeId: employeeId,
      fromDate: fromDate,
      toDate: toDate,
      status: status,
    ).map((list) => list.map(_toAbsenceWithEmployeeInfo).toList());
  }

  /// Throws [DomainValidationException] if date restriction violated (employee context).
  @override
  void validateEmployeeDateRestriction(
    String type,
    String dateFrom,
    String dateTo,
  ) {
    final today = todayYmd();
    final threeDaysAgo = daysAgoYmd(3);

    switch (type) {
      case 'vacation':
        if (dateFrom.compareTo(today) < 0) {
          throw const DomainValidationException(
            'absenceErrorDateRestrictionVacation',
          );
        }
        break;
      case 'sick_leave':
        if (dateFrom.compareTo(threeDaysAgo) < 0) {
          throw const DomainValidationException(
            'absenceErrorDateRestrictionSickLeave',
          );
        }
        break;
      default:
        if (dateFrom.compareTo(today) < 0) {
          throw const DomainValidationException(
            'absenceErrorDateRestrictionVacation',
          );
        }
    }
  }

  Future<bool> hasOverlap(
    int employeeId,
    String dateFrom,
    String dateTo, {
    int? excludeId,
  }) async {
    final sql = excludeId != null
        ? '''
      SELECT 1 FROM absences
      WHERE employee_id = ? AND status IN (?, ?)
        AND date_to >= ? AND date_from <= ?
        AND id != ?
      LIMIT 1
      '''
        : '''
      SELECT 1 FROM absences
      WHERE employee_id = ? AND status IN (?, ?)
        AND date_to >= ? AND date_from <= ?
      LIMIT 1
      ''';
    final vars = [
      Variable.withInt(employeeId),
      Variable.withString(_statusPending),
      Variable.withString(_statusApproved),
      Variable.withString(dateFrom),
      Variable.withString(dateTo),
    ];
    if (excludeId != null) {
      vars.add(Variable.withInt(excludeId));
    }

    final q = await _db
        .customSelect(sql, variables: vars, readsFrom: {_db.absences})
        .get();

    return q.isNotEmpty;
  }

  static DateTime _ymdToDate(String ymd) {
    final parts = ymd.split('-');
    if (parts.length != 3) return DateTime(1970, 1, 1);
    final y = int.tryParse(parts[0]) ?? 1970;
    final m = int.tryParse(parts[1]) ?? 1;
    final d = int.tryParse(parts[2]) ?? 1;
    return DateTime(y, m, d);
  }

  @override
  Future<List<({DateTime dateFrom, DateTime dateTo})>>
  getApprovedAbsenceRangesForEmployeeInPeriod(
    int employeeId,
    String fromYmd,
    String toYmd,
  ) async {
    final rows =
        await (_db.select(_db.absences)..where(
              (a) =>
                  a.employeeId.equals(employeeId) &
                  a.status.equals(_statusApproved) &
                  a.dateTo.isBiggerOrEqualValue(fromYmd) &
                  a.dateFrom.isSmallerOrEqualValue(toYmd),
            ))
            .get();
    return rows
        .map(
          (a) =>
              (dateFrom: _ymdToDate(a.dateFrom), dateTo: _ymdToDate(a.dateTo)),
        )
        .toList();
  }

  @override
  Future<bool> hasApprovedAbsenceOnDate(int employeeId, String dateYmd) async {
    final rows =
        await (_db.select(_db.absences)..where(
              (a) =>
                  a.employeeId.equals(employeeId) &
                  a.status.equals(_statusApproved) &
                  a.dateFrom.isSmallerOrEqualValue(dateYmd) &
                  a.dateTo.isBiggerOrEqualValue(dateYmd),
            ))
            .get();
    return rows.isNotEmpty;
  }

  @override
  Future<int> insertAbsence({
    required int employeeId,
    required String dateFrom,
    required String dateTo,
    required String type,
    String? note,
    int? createdByEmployeeId,
  }) async {
    if (dateTo.compareTo(dateFrom) < 0) {
      throw const DomainValidationException('absenceErrorDateOrder');
    }
    if (!_absenceTypes.contains(type)) {
      throw DomainValidationException('Invalid type: $type');
    }

    final overlap = await hasOverlap(employeeId, dateFrom, dateTo);
    if (overlap) {
      throw const DomainValidationException('absenceErrorOverlap');
    }

    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      return _db
          .into(_db.absences)
          .insert(
            AbsencesCompanion.insert(
              employeeId: employeeId,
              dateFrom: dateFrom,
              dateTo: dateTo,
              type: type,
              note: Value(note),
              status: const Value(_statusPending),
              createdAt: now,
              createdByEmployeeId: Value(createdByEmployeeId),
              approvedAt: const Value.absent(),
              approvedBy: const Value.absent(),
              rejectReason: const Value.absent(),
            ),
          );
    });
  }

  @override
  Future<void> updateAbsence({
    required int id,
    String? dateFrom,
    String? dateTo,
    String? type,
    String? note,
  }) async {
    final existing = await (_db.select(
      _db.absences,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      throw const DomainNotFoundException('Absence not found');
    }
    if (existing.status != _statusPending) {
      throw const DomainValidationException('absenceErrorEditPendingOnly');
    }

    final df = dateFrom ?? existing.dateFrom;
    final dt = dateTo ?? existing.dateTo;
    if (dt.compareTo(df) < 0) {
      throw const DomainValidationException('absenceErrorDateOrder');
    }

    final overlap = await hasOverlap(
      existing.employeeId,
      df,
      dt,
      excludeId: id,
    );
    if (overlap) {
      throw const DomainValidationException('absenceErrorOverlap');
    }

    await guardRepoCall(() async {
      await (_db.update(_db.absences)..where((a) => a.id.equals(id))).write(
        AbsencesCompanion(
          dateFrom: Value(df),
          dateTo: Value(dt),
          type: Value(type ?? existing.type),
          note: Value(note ?? existing.note),
        ),
      );
    });
  }

  @override
  Future<void> deleteAbsence(int id) async {
    final existing = await (_db.select(
      _db.absences,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      throw const DomainNotFoundException('Absence not found');
    }
    if (existing.status != _statusPending) {
      throw const DomainValidationException('absenceErrorDeletePendingOnly');
    }

    await guardRepoCall(() async {
      await (_db.delete(_db.absences)..where((a) => a.id.equals(id))).go();
    });
  }

  @override
  Future<void> updateAbsenceStatus({
    required int id,
    required String status,
    String? approvedBy,
    String? rejectReason,
  }) async {
    if (status != _statusApproved && status != _statusRejected) {
      throw DomainValidationException('Invalid status: $status');
    }
    if (status == _statusRejected &&
        (rejectReason == null || rejectReason.trim().isEmpty)) {
      throw const DomainValidationException('absenceErrorRejectReasonRequired');
    }

    final existing = await (_db.select(
      _db.absences,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    if (existing == null) {
      throw const DomainNotFoundException('Absence not found');
    }
    if (existing.status != _statusPending) {
      throw const DomainValidationException(
        'absenceErrorApproveRejectPendingOnly',
      );
    }

    final now = UtcClock.nowMs();

    await guardRepoCall(() async {
      await (_db.update(_db.absences)..where((a) => a.id.equals(id))).write(
        AbsencesCompanion(
          status: Value(status),
          approvedAt: Value(now),
          approvedBy: Value(approvedBy),
          rejectReason: Value(rejectReason?.trim()),
        ),
      );
    });
  }

  Stream<List<AbsenceWithEmployee>> watchAbsences({
    int? employeeId,
    String? fromDate,
    String? toDate,
    String? status,
  }) {
    final select = _db.select(_db.absences).join([
      innerJoin(
        _db.employees,
        _db.employees.id.equalsExp(_db.absences.employeeId),
      ),
    ]);

    if (employeeId != null) {
      select.where(_db.absences.employeeId.equals(employeeId));
    }
    if (fromDate != null) {
      select.where(_db.absences.dateTo.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      select.where(_db.absences.dateFrom.isSmallerOrEqualValue(toDate));
    }
    if (status != null && status.isNotEmpty) {
      select.where(_db.absences.status.equals(status));
    }

    select.orderBy([OrderingTerm.desc(_db.absences.createdAt)]);

    return select.watch().map(
      (rows) => rows
          .map(
            (r) => AbsenceWithEmployee(
              absence: r.readTable(_db.absences),
              employee: r.readTable(_db.employees),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<Absence?> getAbsence(int id) async {
    return (_db.select(
      _db.absences,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
  }
}
