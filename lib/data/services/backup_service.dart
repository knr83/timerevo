import 'dart:async';
import 'dart:io'
    show
        exit,
        File,
        FileSystemException,
        OSError,
        Platform,
        Process,
        ProcessStartMode;

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../core/backup_error_code.dart';
import '../../core/diagnostic_log.dart';
import '../../l10n/app_localizations.dart';
import '../db/app_db.dart';

/// Maps FileSystemException to a stable error code (no raw messages).
BackupErrorCode _mapFileSystemException(FileSystemException e) {
  final osError = e.osError;
  if (osError is OSError) {
    switch (osError.errorCode) {
      case 2: // ENOENT, FILE_NOT_FOUND
      case 3: // ERROR_PATH_NOT_FOUND (Windows)
        return BackupErrorCode.notFound;
      case 5: // ERROR_ACCESS_DENIED (Windows)
      case 13: // EACCES (Unix)
        return BackupErrorCode.permissionDenied;
    }
  }
  return BackupErrorCode.ioFailure;
}

const _schemaVersion = 14;

/// Shared with app_init for pending restore.
const restorePendingKey = 'restore_pending';

/// Set when restore was applied; show blocking dialog on next load.
const restoreCompletedDialogKey = 'restore_completed_dialog';

class BackupService {
  BackupService(this._db);

  final AppDb _db;

  /// Creates a backup of the database to a user-selected location.
  /// Returns (path, null) on success, (null, errorCode) on failure, (null, null) if cancelled.
  Future<({String? path, BackupErrorCode? error})>
  createBackupToFolder() async {
    final saveLocation = await getSaveLocation(
      suggestedName:
          'timerevo_backup_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.sqlite',
      acceptedTypeGroups: [
        const XTypeGroup(label: 'SQLite', extensions: ['sqlite']),
      ],
    );
    if (saveLocation == null) return (path: null, error: null);

    unawaited(
      DiagnosticLog.append(
        DiagnosticLogEntry(
          event: DiagnosticEvent.backupStart,
          ts: DateTime.now().toUtc().toIso8601String(),
        ),
      ),
    );
    try {
      await _db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
      final sourceFile = await getDatabaseFile();
      await sourceFile.copy(saveLocation.path);
      unawaited(
        DiagnosticLog.append(
          DiagnosticLogEntry(
            event: DiagnosticEvent.backupSuccess,
            ts: DateTime.now().toUtc().toIso8601String(),
          ),
        ),
      );
      return (path: saveLocation.path, error: null);
    } on FileSystemException catch (e) {
      final code = _mapFileSystemException(e);
      unawaited(
        DiagnosticLog.append(
          DiagnosticLogEntry(
            event: DiagnosticEvent.backupFail,
            ts: DateTime.now().toUtc().toIso8601String(),
            errorType: e.runtimeType.toString(),
          ),
        ),
      );
      return (path: null, error: code);
    }
  }

  /// Restores the database from a user-selected backup file.
  /// Copies backup to a .pending file and schedules restore for next app start
  /// (avoids Windows file lock when DB is open). Returns (success, errorCode, needsRestart).
  Future<({bool success, BackupErrorCode? error, bool needsRestart})>
  restoreFromBackup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsRestoreConfirmTitle),
        content: Text(l10n.settingsRestoreConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return (success: false, error: null, needsRestart: false);
    }

    final xFile = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(label: 'SQLite', extensions: ['sqlite']),
      ],
    );
    if (xFile == null) {
      return (success: false, error: null, needsRestart: false);
    }

    final backupPath = xFile.path;
    if (backupPath.isEmpty) {
      return (success: false, error: null, needsRestart: false);
    }

    try {
      final db = sqlite3.open(backupPath);
      final version = db.userVersion;
      db.close();
      if (version < _schemaVersion) {
        return (
          success: false,
          error: BackupErrorCode.invalidArchive,
          needsRestart: false,
        );
      }
    } on SqliteException {
      return (
        success: false,
        error: BackupErrorCode.invalidArchive,
        needsRestart: false,
      );
    }

    try {
      // Copy to .pending file (no overwrite of live DB; avoids Windows file lock).
      final destFile = await getDatabaseFile();
      final dbDir = destFile.parent;
      final pendingPath = p.join(dbDir.path, 'timerevo.sqlite.pending');
      await File(backupPath).copy(pendingPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(restorePendingKey, true);

      // Try to restart so restore applies immediately (works in release builds).
      final didRestart = await _tryRestartApp();
      return (success: true, error: null, needsRestart: !didRestart);
    } on FileSystemException catch (e) {
      return (
        success: false,
        error: _mapFileSystemException(e),
        needsRestart: false,
      );
    }
  }

  /// Restore from backup without needing an open DB. Use when init fails due to DB error.
  static Future<({bool success, BackupErrorCode? error, bool needsRestart})>
  performRestore(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsRestoreConfirmTitle),
        content: Text(l10n.settingsRestoreConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return (success: false, error: null, needsRestart: false);
    }

    final xFile = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(label: 'SQLite', extensions: ['sqlite']),
      ],
    );
    if (xFile == null) {
      return (success: false, error: null, needsRestart: false);
    }

    final backupPath = xFile.path;
    if (backupPath.isEmpty) {
      return (success: false, error: null, needsRestart: false);
    }

    try {
      final db = sqlite3.open(backupPath);
      final version = db.userVersion;
      db.close();
      if (version < _schemaVersion) {
        return (
          success: false,
          error: BackupErrorCode.invalidArchive,
          needsRestart: false,
        );
      }
    } on SqliteException {
      return (
        success: false,
        error: BackupErrorCode.invalidArchive,
        needsRestart: false,
      );
    }

    try {
      final destFile = await getDatabaseFile();
      final dbDir = destFile.parent;
      final pendingPath = p.join(dbDir.path, 'timerevo.sqlite.pending');
      await File(backupPath).copy(pendingPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(restorePendingKey, true);

      final didRestart = await _tryRestartApp();
      return (success: true, error: null, needsRestart: !didRestart);
    } on FileSystemException catch (e) {
      return (
        success: false,
        error: _mapFileSystemException(e),
        needsRestart: false,
      );
    }
  }

  /// Deletes the database files. Call when reinitializing after init failure.
  static Future<void> deleteDatabaseFiles() async {
    final dbFile = await getDatabaseFile();
    final dbDir = dbFile.parent;
    final wal = File(p.join(dbDir.path, 'timerevo.sqlite-wal'));
    final shm = File(p.join(dbDir.path, 'timerevo.sqlite-shm'));
    if (await dbFile.exists()) await dbFile.delete();
    if (await wal.exists()) await wal.delete();
    if (await shm.exists()) await shm.delete();
  }

  /// Attempts to restart the app. Returns true if restart was initiated (caller will exit).
  static Future<bool> _tryRestartApp() async {
    try {
      if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
        return false;
      }
      await Process.start(
        Platform.resolvedExecutable,
        List<String>.from(Platform.executableArguments),
        mode: ProcessStartMode.detached,
      );
      exit(0);
    } catch (_) {
      // Intentional: Process.start or exit may fail; return false to continue without restart.
      return false;
    }
  }
}
