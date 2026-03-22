# Data Persistence Guide

This document defines the **data and persistence rules** for the Timerevo Flutter codebase. It is the single source of truth for DB schema, migrations, repositories, transactions, and time/date handling. Local DB only—no cloud sync.

---

## Inspected Paths (Audit Basis)

The following paths/files were inspected to produce this guide (repo-specific, not theoretical):

- `lib/data/db/app_db.dart`
- `lib/data/db/tables.dart`
- `lib/data/db/migrations.dart`
- `lib/data/db/db_providers.dart`
- `lib/data/repositories/`
- `lib/data/services/backup_service.dart` (or equivalent BackupService location)
- `lib/data/errors/`
- `lib/domain/entities/`
- `lib/domain/ports/`
- `lib/core/` (time/clock/errors utils, if present)
- `lib/features/` (import boundaries verification)

> Note: If some of the paths differ in the repository, update this list to match the actual files.

---

## Current State

- **DB technology**: Drift + SQLite via `drift`, `drift_flutter`, `sqlite3_flutter_libs`
- **DB file**: Single file at `getApplicationSupportDirectory()/timerevo.sqlite`, opened via `LazyDatabase` + `NativeDatabase.createInBackground`
- **Schema version**: 14 (defined in `app_db.dart`)
- **Tables**: Core tables include Employees, EmployeeAuths, Users, Devices, WorkSessions, schedule templates, Absences, AppSettings (see lib/data/db/tables.dart for the full list).
- **Migrations**: `buildMigrationStrategy()` in `migrations.dart` with onCreate and onUpgrade; indexes created in `createIndexesAndConstraints()`
- **Repository pattern**: Port interfaces in `domain/ports/`, implementations in `data/repositories/`; `guardRepoCall` maps SqliteException/DataException to domain exceptions
- **Domain entities**: `EmployeeInfo`, `SessionRef`, `ScheduleInterval`, `DaySchedule`, `ResolvedSchedule` in `domain/entities/`
- **Timestamps**: Stored as UTC milliseconds (int)
- **Calendar dates**: Stored as YYYY-MM-DD strings (absences)
- **Schedule intervals**: Minutes since midnight (0-1439); start must be before end (same-day only)
- **Backup**: Copy DB file after `PRAGMA wal_checkpoint`; restore uses `.pending` file + next app start (avoids Windows file lock)
- **Restore schema check**: BackupService validates backup `userVersion >= _schemaVersion` before restore
- **Error handling**: `repo_guard.dart` centralizes exception mapping; DataException subclasses in `data/errors/`

---

## Target State (Rules)

### Layering

- **Domain entities** live in `domain/entities/`; no Drift imports in domain
- **DB models** come from Drift-generated code (`app_db.g.dart`)
- **Repositories** implement domain ports; expose domain types at API boundary where possible
- **UI** must not import `data/`; features and common must not import `data/repositories/`, `data/db/`, or Drift types. Use use cases/controllers; expose domain entities or DTOs at the API boundary.
- **Mappers**: When returning composite data, use domain types or repo-specific DTOs (e.g. `SessionWithEmployee`) in the data layer only

### Migrations

- Single source of truth: `schemaVersion` in `app_db.dart`
- One migration step per schema version in `buildMigrationStrategy`
- `createIndexesAndConstraints(db)` must be called on both `onCreate` and `onUpgrade` paths 
- Backup/restore schema constant (`_schemaVersion` in BackupService) must match `schemaVersion`

### Indexes

- Add indexes for **hot query paths** (tables that grow and are read frequently), especially:
  - Work sessions / attendance logs
  - Absences
  - Employees (lookup by code, sorting/filtering)
- Heuristic: index columns used in WHERE/JOIN/ORDER BY **only if** the table is expected to grow or the query is on the UI hot path.
- Naming: `idx_<table>_<cols>` for regular indexes; `uq_<table>_<cols>` for unique
- Use `CREATE INDEX IF NOT EXISTS` to tolerate re-runs

**Typical indexes for hot paths (only if supported by real queries):**
- Employees: lookup by employee code/identifier (unique)
- WorkSessions: `(employeeId, startUtcMs)` and/or `(startUtcMs)` if listing by date range
- Absences: `(employeeId, date)` and/or `(date)` if listing by calendar day/week

### Transactions

- Wrap any operation that performs 2+ writes (insert/update/delete) in `db.transaction()`
- Wrap check-then-update flows in a transaction when integrity matters (e.g. close session)
- Use `guardRepoCall` around the whole operation when applicable
- If a flow must update **status** and write a **session/audit record** (when such tables exist), they must be in the same transaction to preserve invariants.

### Time/Date

- **Timestamps**: Always store as UTC milliseconds (int)
- **Calendar dates**: YYYY-MM-DD strings for absences
- **"Workday"**: Local calendar day (Europe/Berlin). Define day ranges as:
  - `[startOfDayLocal, nextStartOfDayLocal)` (start inclusive, next day start exclusive)
  - Avoid `23:59:59` style boundaries (DST-safe).
- **Day boundaries storage**:
  - Compute `startOfDayLocal = DateTime(year, month, day)` (local)
  - Compute `nextStartOfDayLocal = startOfDayLocal.add(Duration(days: 1))` (local)
  - Convert both to UTC ms via `.toUtc().millisecondsSinceEpoch` when needed for queries.
- **Parse user input**: Local time string → `DateTime` (interpret as local) → `.toUtc().millisecondsSinceEpoch`
- **Display**: Use `DateTime.fromMillisecondsSinceEpoch(utcMs, isUtc: true).toLocal()` then format

### DB Lifecycle

- Path: `getApplicationSupportDirectory()/timerevo.sqlite`
- Backup: Run `PRAGMA wal_checkpoint(TRUNCATE)` then copy the file
- Restore: Copy backup to `.pending`, set `restorePendingKey`; on next start, apply pending before DB open
- No automatic corruption recovery; user restores from backup

**Minimum recovery UX protocol (local-only):**
- If DB open/read fails (e.g., SqliteException, IO errors):
  - Show a clear message: "Database error. Restore from backup or reinitialize."
  - Offer actions (where applicable): `Restore backup` / `Open backup folder` / `Reinitialize (loses local data)`
  - Do not silently delete or recreate the DB without explicit user action.

---

## Folder Layout

```text
lib/data/
├── db/
│   ├── app_db.dart      # Drift database class
│   ├── app_db.g.dart    # Generated (do not edit)
│   ├── tables.dart      # Table definitions
│   ├── migrations.dart  # Migration strategy + createIndexesAndConstraints
│   ├── db_providers.dart
│   └── work_session_db_values.dart
├── repositories/        # Implements domain ports
├── services/            # BackupService, etc.
└── errors/              # DataException, etc.
```

---

## Examples

### Good: Multi-Write in Transaction + guardRepoCall

```dart
// lib/data/repositories/employees_repo.dart
Future<int> createEmployeeWithDefaultSchedule({
  required String firstName,
  required String lastName,
  required int? templateId,
}) async {
  return guardRepoCall(() async {
    return _db.transaction(() async {
      final now = UtcClock.nowMs();
      final code = await _generateEmployeeCode();
      final employeeId = await _db.into(_db.employees).insert(...);

      if (templateId != null) {
        await _db.into(_db.employeeScheduleAssignments).insert(...);
      }
      return employeeId;
    });
  });
}
```

- `guardRepoCall` ensures DB exceptions are mapped to domain
- `db.transaction` ensures employee + assignment are atomic

### Bad: Multi-Write Without Transaction

```dart
// BAD: lib/data/repositories/employees_repo.dart (createEmployeeFull - before fix)
return guardRepoCall(() async {
  final employeeId = await _db.into(_db.employees).insert(...);
  if (templateId != null) {
    await _db.into(_db.employeeScheduleAssignments).insert(...);
  }
  return employeeId;
});
```

**Problem**: If the assignment insert fails, the employee row is orphaned (no schedule). Refactor: wrap both in `db.transaction()`.

### Good: customSelect readsFrom

```dart
// Correct: tell Drift which tables the query reads
_db.customSelect(
  sql,
  variables: vars,
  readsFrom: {_db.absences},
)
```

**Anti-pattern**: `readsFrom: {}` when the query touches tables—Drift cannot invalidate streams correctly.

---

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Fix |
|-------------|--------------|-----|
| Multi-write without transaction | Partial writes on failure; orphaned rows | Wrap in `db.transaction()` |
| Check-then-update without transaction | TOCTOU race; two callers can both "succeed" | Wrap check + update in transaction |
| `readsFrom: {}` for customSelect that reads tables | Streams don't invalidate when data changes | Set `readsFrom: {_db.tableName}` |
| Stale schema constant in BackupService | Restore may reject valid backups | Keep `_schemaVersion == schemaVersion` |
| Parsing user input as UTC when it's local time | Wrong timestamp stored (timezone shift) | Parse as local then convert to UTC |
| Exposing Drift row types to UI | Violates layering; UI depends on data | Return domain entities or DTOs |
| Missing guardRepoCall on write operations | Raw SqliteException can leak to UI | Wrap in `guardRepoCall` |
| Storing local DateTime for timestamps | DST bugs; inconsistent across devices | Store UTC ms only |
| Adding indexes everywhere "just in case" | Slower writes, bigger DB, unclear intent | Add indexes only for hot paths / large tables |

---

## Migration Plan (Incremental Steps)

1. Keep `docs/DATA_PERSISTENCE_GUIDE.md` up to date when persistence code changes
2. Add/verify `Inspected Paths` section matches the real repo paths
3. Align backup schema constant with `schemaVersion`
4. Add transaction to `createEmployeeFull`
5. Fix `tryParseLocalToUtcMs` to parse as local then convert to UTC
6. Add `guardRepoCall` to SchedulesRepo write methods
7. Fix `hasOverlap` `readsFrom` in AbsencesRepo
8. Add transaction to `closeOpenSession` / `closeOpenSessionWithEnd`
9. Review hot queries and add the minimum required indexes (based on actual query patterns)
10. Run `flutter analyze` and fix issues
11. Update guide with "Applied Changes" section

---

## Applied Changes (Fix Plan 2025-02)

| Change | Files |
|--------|-------|
| guardRepoCall on AuthRepo | auth_repo.dart |
| guardRepoCall on AppSettingsRepo.set | app_settings_repo.dart |
| guardRepoCall on SchedulesRepo.createTemplate | schedules_repo.dart |
| readsFrom on app_init customSelect | app_init.dart |
| localDayRangeUtcMs helper, DST-safe day boundaries | date_utils.dart, sessions_repo.dart, dashboard_page.dart, employee_calendar_page.dart |
| usecase_providers moved to app | app/usecase_providers.dart, domain/usecase_providers.dart removed |
| Init error UX with Restore/Reinitialize | app.dart, backup_service.dart, l10n |
| idx_employees_is_active | migrations.dart |
| Layering note updated | DATA_PERSISTENCE_GUIDE.md |

---

## PR Checklist

- [ ] `flutter analyze` passes
- [ ] No direct `data/` or Drift imports in `features/` or `common/`; UI must depend on domain/core only (see [ARCHITECTURE_BOUNDARIES_GUIDE.md](ARCHITECTURE_BOUNDARIES_GUIDE.md))
- [ ] Multi-write operations use `db.transaction()`
- [ ] Write operations through repositories use `guardRepoCall` where applicable
- [ ] `customSelect` has correct `readsFrom` when querying tables
- [ ] Timestamps stored as UTC ms; dates as YYYY-MM-DD
- [ ] Day ranges use `[startOfDayLocal, nextStartOfDayLocal)` (DST-safe)
- [ ] Backup `_schemaVersion` matches `app_db.dart` schemaVersion
- [ ] Schema change: add migration step and bump schemaVersion; run `build_runner`
- [ ] New indexes are justified by a hot query path (document which query they support)