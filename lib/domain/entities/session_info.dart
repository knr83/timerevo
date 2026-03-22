/// Minimal session info for domain use cases. Data layer maps from Drift WorkSession.
class SessionInfo {
  const SessionInfo({
    required this.id,
    required this.startTs,
    this.endTs,
    required this.status,
    this.note,
    this.canceledAt,
  });

  final int id;
  final int startTs;
  final int? endTs;
  final String status;
  final String? note;

  /// UTC ms when canceled; excluded from totals. Null if not canceled.
  final int? canceledAt;
}
