import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'migrations.dart';
import 'tables.dart';

part 'app_db.g.dart';

@DriftDatabase(
  tables: [
    Employees,
    EmployeeAuths,
    Users,
    Devices,
    WorkSessions,
    ShiftScheduleTemplates,
    ShiftScheduleTemplateDays,
    ShiftScheduleTemplateIntervals,
    EmployeeScheduleAssignments,
    Absences,
    AppSettings,
  ],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(this);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await getDatabaseFile();
    return NativeDatabase.createInBackground(file);
  });
}

/// Returns the app's SQLite database file path. Used for backup/restore.
Future<File> getDatabaseFile() async {
  final dir = await getApplicationSupportDirectory();
  return File(p.join(dir.path, 'timerevo.sqlite'));
}

