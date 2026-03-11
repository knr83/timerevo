import 'package:timerevo/core/backup_error_code.dart';
import 'package:timerevo/l10n/app_localizations.dart';

/// Maps BackupErrorCode to localized user-facing messages.
/// Never exposes raw exception text or file paths.
String messageForBackupError(BackupErrorCode code, AppLocalizations l10n) {
  return switch (code) {
    BackupErrorCode.permissionDenied =>
      l10n.settingsBackupErrorPermissionDenied,
    BackupErrorCode.notFound => l10n.settingsBackupErrorNotFound,
    BackupErrorCode.invalidArchive => l10n.settingsBackupErrorInvalidArchive,
    BackupErrorCode.ioFailure => l10n.settingsBackupErrorIoFailure,
    BackupErrorCode.dbFailure => l10n.settingsBackupErrorDbFailure,
    BackupErrorCode.unknown => l10n.settingsBackupErrorUnknown,
  };
}

/// Maps BackupErrorCode to localized user-facing messages for restore operations.
String messageForRestoreError(BackupErrorCode code, AppLocalizations l10n) {
  return switch (code) {
    BackupErrorCode.permissionDenied =>
      l10n.settingsRestoreErrorPermissionDenied,
    BackupErrorCode.notFound => l10n.settingsRestoreErrorNotFound,
    BackupErrorCode.invalidArchive => l10n.settingsRestoreErrorInvalidArchive,
    BackupErrorCode.ioFailure => l10n.settingsRestoreErrorIoFailure,
    BackupErrorCode.dbFailure => l10n.settingsRestoreErrorDbFailure,
    BackupErrorCode.unknown => l10n.settingsRestoreErrorUnknown,
  };
}
