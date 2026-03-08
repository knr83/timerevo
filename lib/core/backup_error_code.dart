/// Stable error codes for backup/restore operations.
/// Used instead of raw exception messages to avoid leaking PII or file paths.
enum BackupErrorCode {
  permissionDenied,
  notFound,
  invalidArchive,
  ioFailure,
  dbFailure,
  unknown,
}
