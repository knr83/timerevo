import 'package:drift/drift.dart';

import '../db/app_db.dart';
import 'repo_guard.dart';

class AppSettingsRepo {
  AppSettingsRepo(this._db);

  final AppDb _db;

  Future<String?> get(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String? value) async {
    return guardRepoCall(() async {
      if (value == null) {
        await (_db.delete(
          _db.appSettings,
        )..where((t) => t.key.equals(key))).go();
        return;
      }
      await _db
          .into(_db.appSettings)
          .insert(
            AppSetting(key: key, value: value),
            mode: InsertMode.insertOrReplace,
          );
    });
  }
}
