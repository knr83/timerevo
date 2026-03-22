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
    'CREATE INDEX IF NOT EXISTS idx_employees_status ON employees(status);',
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
          final cols = await db
              .customSelect('PRAGMA table_info(employees);')
              .get();
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
          await db.customStatement(
            'ALTER TABLE employees_new RENAME TO employees;',
          );
          await db.customStatement('PRAGMA foreign_keys=ON;');

          // Sanity check: full_name must be gone after rebuild.
          final colsAfter = await db
              .customSelect('PRAGMA table_info(employees);')
              .get();
          final namesAfter = colsAfter
              .map((r) => r.read<String>('name'))
              .toSet();
          if (namesAfter.contains('full_name')) {
            // Keep it non-fatal but surface a clear message for troubleshooting.
            throw StateError(
              'Migration failed: employees.full_name still exists.',
            );
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

      if (from < 10) {
        // Replace is_active with status enum; add termination_date,
        // vacation_days_per_year, secondary_phone.
        await db.transaction(() async {
          final cols = await db
              .customSelect('PRAGMA table_info(employees);')
              .get();
          final names = cols.map((r) => r.read<String>('name')).toSet();

          if (names.contains('status')) {
            // Already migrated (e.g. fresh install with new schema).
            return;
          }

          // Add new columns.
          const alterStatements = [
            "ALTER TABLE employees ADD COLUMN status TEXT NOT NULL DEFAULT 'active';",
            'ALTER TABLE employees ADD COLUMN termination_date INTEGER;',
            'ALTER TABLE employees ADD COLUMN vacation_days_per_year INTEGER;',
            'ALTER TABLE employees ADD COLUMN secondary_phone TEXT;',
          ];
          for (final sql in alterStatements) {
            try {
              await db.customStatement(sql);
            } catch (_) {
              // Column may already exist.
            }
          }

          // Migrate is_active -> status (only if is_active still exists).
          if (names.contains('is_active')) {
            await db.customStatement('''
UPDATE employees
SET status = CASE WHEN is_active = 1 THEN 'active' ELSE 'inactive' END;
''');
          }

          // Rebuild table to drop is_active.
          if (names.contains('is_active')) {
            await db.customStatement('PRAGMA foreign_keys=OFF;');
            await db.customStatement('''
CREATE TABLE employees_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','archived')),
  termination_date INTEGER,
  vacation_days_per_year INTEGER,
  secondary_phone TEXT,
  hire_date INTEGER,
  employee_role TEXT NOT NULL DEFAULT 'employee',
  use_pin INTEGER NOT NULL DEFAULT 0,
  use_nfc INTEGER NOT NULL DEFAULT 0,
  access_token TEXT,
  access_note TEXT,
  employment_type TEXT,
  email TEXT,
  phone TEXT,
  department TEXT,
  job_title TEXT,
  internal_comment TEXT,
  policy_acknowledged INTEGER NOT NULL DEFAULT 0,
  policy_acknowledged_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER,
  created_by TEXT,
  updated_by TEXT
);
''');
            await db.customStatement('''
INSERT INTO employees_new (
  id, code, first_name, last_name, status,
  termination_date, vacation_days_per_year, secondary_phone,
  hire_date, employee_role, use_pin, use_nfc,
  access_token, access_note, employment_type,
  email, phone, department, job_title, internal_comment,
  policy_acknowledged, policy_acknowledged_at,
  created_at, updated_at, created_by, updated_by
)
SELECT
  id, code, first_name, last_name, status,
  termination_date, vacation_days_per_year, secondary_phone,
  hire_date, employee_role, use_pin, use_nfc,
  access_token, access_note, employment_type,
  email, phone, department, job_title, internal_comment,
  policy_acknowledged, policy_acknowledged_at,
  created_at, updated_at, created_by, updated_by
FROM employees;
''');
            await db.customStatement('DROP TABLE employees;');
            await db.customStatement(
              'ALTER TABLE employees_new RENAME TO employees;',
            );
            await db.customStatement('PRAGMA foreign_keys=ON;');
          }
        });
      }

      if (from < 11) {
        // Drop legacy employees.weekly_hours (planned hours come from schedule templates).
        await db.transaction(() async {
          final cols = await db
              .customSelect('PRAGMA table_info(employees);')
              .get();
          final names = cols.map((r) => r.read<String>('name')).toSet();
          if (!names.contains('weekly_hours')) {
            return;
          }

          await db.customStatement('PRAGMA foreign_keys=OFF;');
          await db.customStatement('''
CREATE TABLE employees_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','archived')),
  termination_date INTEGER,
  vacation_days_per_year INTEGER,
  secondary_phone TEXT,
  hire_date INTEGER,
  employee_role TEXT NOT NULL DEFAULT 'employee',
  use_pin INTEGER NOT NULL DEFAULT 0,
  use_nfc INTEGER NOT NULL DEFAULT 0,
  access_token TEXT,
  access_note TEXT,
  employment_type TEXT,
  email TEXT,
  phone TEXT,
  department TEXT,
  job_title TEXT,
  internal_comment TEXT,
  policy_acknowledged INTEGER NOT NULL DEFAULT 0,
  policy_acknowledged_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER,
  created_by TEXT,
  updated_by TEXT
);
''');
          await db.customStatement('''
INSERT INTO employees_new (
  id, code, first_name, last_name, status,
  termination_date, vacation_days_per_year, secondary_phone,
  hire_date, employee_role, use_pin, use_nfc,
  access_token, access_note, employment_type,
  email, phone, department, job_title, internal_comment,
  policy_acknowledged, policy_acknowledged_at,
  created_at, updated_at, created_by, updated_by
)
SELECT
  id, code, first_name, last_name, status,
  termination_date, vacation_days_per_year, secondary_phone,
  hire_date, employee_role, use_pin, use_nfc,
  access_token, access_note, employment_type,
  email, phone, department, job_title, internal_comment,
  policy_acknowledged, policy_acknowledged_at,
  created_at, updated_at, created_by, updated_by
FROM employees;
''');
          await db.customStatement('DROP TABLE employees;');
          await db.customStatement(
            'ALTER TABLE employees_new RENAME TO employees;',
          );
          await db.customStatement('PRAGMA foreign_keys=ON;');
        });
      }

      if (from < 12) {
        try {
          await db.customStatement(
            'ALTER TABLE employees ADD COLUMN deleted_at INTEGER;',
          );
        } catch (_) {
          // Column may already exist on partial migration.
        }
      }

      if (from < 13) {
        try {
          await db.customStatement(
            'ALTER TABLE work_sessions ADD COLUMN canceled_at INTEGER;',
          );
        } catch (_) {
          // Column may already exist on partial migration.
        }
      }

      if (from < 14) {
        const cols = [
          'ALTER TABLE employees ADD COLUMN starting_balance_tenths INTEGER;',
          'ALTER TABLE employees ADD COLUMN starting_balance_updated_at INTEGER;',
          'ALTER TABLE employees ADD COLUMN starting_balance_updated_by TEXT;',
        ];
        for (final sql in cols) {
          try {
            await db.customStatement(sql);
          } catch (_) {
            // Column may already exist on partial migration.
          }
        }
      }

      await createIndexesAndConstraints(db);
    },
  );
}
