import '../entities/absence_with_employee_info.dart';

/// Port for absence data access. Use cases depend on this; data layer implements.
abstract interface class IAbsencesRepo {
  Future<bool> hasApprovedAbsenceOnDate(int employeeId, String dateYmd);

  /// Returns APPROVED absence date ranges for [employeeId] overlapping [fromYmd]..[toYmd].
  /// Each range is a local date without time: DateTime(y, m, d).
  Future<List<({DateTime dateFrom, DateTime dateTo})>>
  getApprovedAbsenceRangesForEmployeeInPeriod(
    int employeeId,
    String fromYmd,
    String toYmd,
  );

  /// Stream of absences with employee info, optionally filtered.
  Stream<List<AbsenceWithEmployeeInfo>> streamAbsences({
    int? employeeId,
    String? fromDate,
    String? toDate,
    String? status,
  });

  /// Throws [DomainValidationException] if date restriction violated.
  void validateEmployeeDateRestriction(
    String type,
    String dateFrom,
    String dateTo,
  );

  Future<int> insertAbsence({
    required int employeeId,
    required String dateFrom,
    required String dateTo,
    required String type,
    String? note,
    int? createdByEmployeeId,
  });

  Future<void> updateAbsence({
    required int id,
    String? dateFrom,
    String? dateTo,
    String? type,
    String? note,
  });

  Future<void> deleteAbsence(int id);

  Future<void> updateAbsenceStatus({
    required int id,
    required String status,
    String? approvedBy,
    String? rejectReason,
  });
}
