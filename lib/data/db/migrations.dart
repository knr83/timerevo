import 'package:drift/drift.dart';

import 'app_db.dart';

Future<void> createIndexesAndConstraints(AppDb db) async {
  // Basic indexes for filtering/reporting.
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_work_sessions_employee_start '
    'ON work_sessions(employee_id, start_ts);',
  );
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_work_sessions_employee_end '
    'ON work_sessions(employee_id, end_ts);',
  );
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_work_sessions_start_ts '
    'ON work_sessions(start_ts);',
  );
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_work_sessions_employee_status_end '
    'ON work_sessions(employee_id, status, end_ts);',
  );

  // Enforce a single open session per employee.
  await db.customStatement(
    'CREATE UNIQUE INDEX IF NOT EXISTS uq_open_session_employee '
    'ON work_sessions(employee_id) WHERE end_ts IS NULL;',
  );

  // Schedule and override hot paths.
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_template_days_template_weekday '
    'ON shift_schedule_template_days(template_id, weekday);',
  );
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_template_intervals_day '
    'ON shift_schedule_template_intervals(template_day_id);',
  );
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_assignments_employee '
    'ON employee_schedule_assignments(employee_id);',
  );

  // Absences.
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_absences_employee_dates '
    'ON absences(employee_id, date_from, date_to);',
  );
  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_absences_status ON absences(status);',
  );

  await db.customStatement(
    'CREATE INDEX IF NOT EXISTS idx_employees_is_active ON employees(is_active);',
  );
}

MigrationStrategy buildMigrationStrategy(AppDb db) {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await createIndexesAndConstraints(db);
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(db.shiftScheduleTemplates);
        await m.createTable(db.shiftScheduleTemplateDays);
        await m.createTable(db.shiftScheduleTemplateIntervals);
        await m.createTable(db.employeeScheduleAssignments);
      }

      if (from < 3) {
        // Split employees.full_name into first_name / last_name.
        // For new DBs (onCreate), the table already has these columns.
        try {
          await db.customStatement(
            "ALTER TABLE employees ADD COLUMN first_name TEXT NOT NULL DEFAULT '';",
          );
        } catch (_) {
          // Intentional: column may already exist on partial migration.
        }
        try {
          await db.customStatement(
            "ALTER TABLE employees ADD COLUMN last_name TEXT NOT NULL DEFAULT '';",
          );
        } catch (_) {
          // Intentional: column may already exist on partial migration.
        }

        // Best-effort backfill from legacy full_name.
        // If no space, store in first_name and leave last_name empty.
        await db.customStatement('''
UPDATE employees
SET
  first_name = TRIM(
    CASE
      WHEN instr(full_name, ' ') > 0 THEN substr(full_name, 1, instr(full_name, ' ') - 1)
      ELSE full_name
    END
  ),
  last_name = TRIM(
    CASE
      WHEN instr(full_name, ' ') > 0 THEN substr(full_name, instr(full_name, ' ') + 1)
      ELSE ''
    END
  )
WHERE (first_name = '' AND last_name = '') AND full_name IS NOT NULL;
''');
      }

      if (from < 4) {
        // Repair migration: older DBs may still have employees.full_name NOT NULL
        // even after upgrading to schema v3 before the rebuild logic existed.
        await db.transaction(() async {
          final cols = await db.customSelect('PRAGMA table_info(employees);').get();
          final names = cols.map((r) => r.read<String>('name')).toSet();
          final hasFullName = names.contains('full_name');

          if (!hasFullName) return;

          // Ensure first_name/last_name exist before rebuild.
          if (!names.contains('first_name')) {
            try {
              await db.customStatement(
                "ALTER TABLE employees ADD COLUMN first_name TEXT NOT NULL DEFAULT '';",
              );
            } catch (_) {
              // Intentional: column may already exist on partial migration.
            }
          }
          if (!names.contains('last_name')) {
            try {
              await db.customStatement(
                "ALTER TABLE employees ADD COLUMN last_name TEXT NOT NULL DEFAULT '';",
              );
            } catch (_) {
              // Intentional: column may already exist on partial migration.
            }
          }

          // Backfill from full_name if needed.
          await db.customStatement('''
UPDATE employees
SET
  first_name = TRIM(
    CASE
      WHEN instr(full_name, ' ') > 0 THEN substr(full_name, 1, instr(full_name, ' ') - 1)
      ELSE full_name
    END
  ),
  last_name = TRIM(
    CASE
      WHEN instr(full_name, ' ') > 0 THEN substr(full_name, instr(full_name, ' ') + 1)
      ELSE ''
    END
  )
WHERE (first_name = '' AND last_name = '') AND full_name IS NOT NULL;
''');

          // Rebuild the employees table to drop legacy full_name column and
          // remove its NOT NULL constraint.
          await db.customStatement('PRAGMA foreign_keys=OFF;');
          await db.customStatement('''
CREATE TABLE employees_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at INTEGER NOT NULL
);
''');
          await db.customStatement('''
INSERT INTO employees_new (id, code, first_name, last_name, is_active, created_at)
SELECT id, code, first_name, last_name, is_active, created_at
FROM employees;
''');
          await db.customStatement('DROP TABLE employees;');
          await db.customStatement('ALTER TABLE employees_new RENAME TO employees;');
          await db.customStatement('PRAGMA foreign_keys=ON;');

          // Sanity check: full_name must be gone after rebuild.
          final colsAfter =
              await db.customSelect('PRAGMA table_info(employees);').get();
          final namesAfter = colsAfter.map((r) => r.read<String>('name')).toSet();
          if (namesAfter.contains('full_name')) {
            // Keep it non-fatal but surface a clear message for troubleshooting.
            throw StateError('Migration failed: employees.full_name still exists.');
          }
        });
      }

      if (from < 6) {
        const newCols = [
          'ALTER TABLE employees ADD COLUMN hire_date INTEGER;',
          "ALTER TABLE employees ADD COLUMN employee_role TEXT NOT NULL DEFAULT 'employee';",
          'ALTER TABLE employees ADD COLUMN use_pin INTEGER NOT NULL DEFAULT 0;',
          'ALTER TABLE employees ADD COLUMN use_nfc INTEGER NOT NULL DEFAULT 0;',
          'ALTER TABLE employees ADD COLUMN access_token TEXT;',
          'ALTER TABLE employees ADD COLUMN access_note TEXT;',
          'ALTER TABLE employees ADD COLUMN employment_type TEXT;',
          'ALTER TABLE employees ADD COLUMN weekly_hours REAL;',
          'ALTER TABLE employees ADD COLUMN email TEXT;',
          'ALTER TABLE employees ADD COLUMN phone TEXT;',
          'ALTER TABLE employees ADD COLUMN department TEXT;',
          'ALTER TABLE employees ADD COLUMN job_title TEXT;',
          'ALTER TABLE employees ADD COLUMN internal_comment TEXT;',
          'ALTER TABLE employees ADD COLUMN policy_acknowledged INTEGER NOT NULL DEFAULT 0;',
          'ALTER TABLE employees ADD COLUMN policy_acknowledged_at INTEGER;',
          'ALTER TABLE employees ADD COLUMN updated_at INTEGER;',
          'ALTER TABLE employees ADD COLUMN created_by TEXT;',
          'ALTER TABLE employees ADD COLUMN updated_by TEXT;',
        ];
        for (final sql in newCols) {
          try {
            await db.customStatement(sql);
          } catch (_) {
            // Intentional: column may already exist on partial migration.
          }
        }
        await db.customStatement('''
CREATE TABLE IF NOT EXISTS employee_auths (
  employee_id INTEGER NOT NULL PRIMARY KEY REFERENCES employees(id) ON DELETE CASCADE,
  pin_hash TEXT NOT NULL,
  pin_salt BLOB NOT NULL,
  pin_updated_at INTEGER NOT NULL
);
''');
        await db.customStatement(
          'UPDATE employees SET updated_at = created_at WHERE updated_at IS NULL;',
        );
      }

      if (from < 7) {
        await db.customStatement('''
CREATE TABLE IF NOT EXISTS app_settings (
  key TEXT NOT NULL PRIMARY KEY,
  value TEXT NOT NULL
);
''');
      }

      if (from < 8) {
        await m.createTable(db.absences);
      }

      if (from < 9) {
        await db.customStatement(
          'DROP TABLE IF EXISTS employee_schedule_override_intervals;',
        );
        await db.customStatement(
          'DROP TABLE IF EXISTS employee_schedule_overrides;',
        );
      }

      await createIndexesAndConstraints(db);
    },
  );
}

