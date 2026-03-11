import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/diagnostic_log.dart';
import '../data/db/app_db.dart';
import '../data/db/db_providers.dart';
import '../data/repositories/app_settings_repo.dart';
import '../data/repositories/repo_providers.dart';
import '../data/services/backup_service.dart';

Future<void> _migratePrefsToAppSettings(
  AppSettingsRepo appSettings,
  AppDb db,
) async {
  final count = await db
      .customSelect(
        'SELECT count(*) as c FROM app_settings',
        readsFrom: {db.appSettings},
      )
      .getSingle();
  if (count.read<int>('c') > 0) return;

  final prefs = await SharedPreferences.getInstance();

  final startMin = prefs.getInt('working_hours_start_min');
  if (startMin != null) {
    await appSettings.set('working_hours_start_min', startMin.toString());
  }

  final endMin = prefs.getInt('working_hours_end_min');
  if (endMin != null) {
    await appSettings.set('working_hours_end_min', endMin.toString());
  }

  final locale = prefs.getString('locale_override');
  if (locale != null && locale.trim().isNotEmpty) {
    await appSettings.set('locale_override', locale.trim().toLowerCase());
  }

  final theme = prefs.getString('theme_selection');
  if (theme != null && theme.trim().isNotEmpty) {
    await appSettings.set('theme_selection', theme.trim().toLowerCase());
  }

  if (prefs.getBool('legal_notice_seen') == true) {
    await appSettings.set('legal_notice_seen', '1');
  }
}

/// Runs before appInitProvider. Applies pending restore if scheduled (DB not open yet).
final _preInitProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(restorePendingKey) != true) return;

  final dbFile = await getDatabaseFile();
  final dbDir = dbFile.parent;
  final pendingFile = File(p.join(dbDir.path, 'timerevo.sqlite.pending'));
  if (!await pendingFile.exists()) {
    await prefs.remove(restorePendingKey);
    return;
  }

  await pendingFile.copy(dbFile.path);
  await pendingFile.delete();

  final wal = File(p.join(dbDir.path, 'timerevo.sqlite-wal'));
  final shm = File(p.join(dbDir.path, 'timerevo.sqlite-shm'));
  if (await wal.exists()) await wal.delete();
  if (await shm.exists()) await shm.delete();

  await prefs.remove(restorePendingKey);
  await prefs.setBool(restoreCompletedDialogKey, true);
});

final appInitProvider = FutureProvider<void>((ref) async {
  await ref.watch(_preInitProvider.future);

  // One-time migration: SharedPreferences → app_settings (when app_settings is empty).
  final db = ref.read(appDbProvider);
  final appSettings = ref.read(appSettingsRepoProvider);
  await _migratePrefsToAppSettings(appSettings, db);

  // Seed required data. All operations are idempotent.
  await ref.read(authRepoProvider).ensureDefaultAdmin();
  await ref.read(employeesRepoProvider).ensureDemoEmployees();

  unawaited(
    DiagnosticLog.append(
      DiagnosticLogEntry(
        event: DiagnosticEvent.appStart,
        ts: DateTime.now().toUtc().toIso8601String(),
      ),
    ),
  );
});
