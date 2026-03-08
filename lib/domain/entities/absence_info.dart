/// Minimal absence info for domain use cases. Data layer maps from Drift Absence.
class AbsenceInfo {
  const AbsenceInfo({
    required this.id,
    required this.employeeId,
    required this.dateFrom,
    required this.dateTo,
    required this.type,
    this.note,
    required this.status,
    this.approvedAt,
    this.approvedBy,
    this.rejectReason,
    required this.createdAt,
    this.createdByEmployeeId,
  });

  final int id;
  final int employeeId;
  final String dateFrom;
  final String dateTo;
  final String type;
  final String? note;
  final String status;
  final int? approvedAt;
  final String? approvedBy;
  final String? rejectReason;
  final int createdAt;
  final int? createdByEmployeeId;
}
