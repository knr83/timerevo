import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/backup_error_code.dart';
import '../data/services/backup_service.dart';

/// App-layer boundary for backup/restore operations.
/// UI uses this instead of accessing BackupService directly.
class BackupRestoreUseCase {
  BackupRestoreUseCase(this._backupService);

  final BackupService _backupService;

  /// Creates a backup of the database to a user-selected location.
  /// Returns (path, null) on success, (null, errorCode) on failure, (null, null) if cancelled.
  Future<({String? path, BackupErrorCode? error})> createBackupToFolder() {
    return _backupService.createBackupToFolder();
  }

  /// Restores the database from a user-selected backup file.
  Future<({bool success, BackupErrorCode? error, bool needsRestart})> restoreFromBackup(
    BuildContext context,
    WidgetRef ref,
  ) {
    return _backupService.restoreFromBackup(context, ref);
  }
}
