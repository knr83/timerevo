# Observability & Diagnostics Guide

This document describes **logging, diagnostics, and observability** in the Timerevo Flutter/Dart project. It is grounded in the actual repository implementation and aligned with other project guides. In case of conflict, project guides take precedence.

---

## 1. Terminology (2026)

| Term | Purpose |
|------|----------|
| **Logging** | Writing structured events to a file or sink. In Timerevo: NDJSON to `timerevo_diagnostics.ndjson`. |
| **Diagnostics** | Collecting data for problem analysis: logs + metadata (version, OS), without PII/DB/PDF. Export: user-initiated ZIP. |
| **Observability** | The ability to infer the internal state of the application from external data. In this app: local structured NDJSON logs plus user-initiated diagnostics ZIP export; no background telemetry. |

The project does not use traces, metrics, or external APM. Focus: local logs and export for manual support.

---

## 2. NDJSON Logging

### Format and Contents

- **Format**: NDJSON (Newline Delimited JSON) — one JSON line per event.
- **File**: `timerevo_diagnostics.ndjson` in `getApplicationSupportDirectory()`.
- **Contents**: event codes and allowed technical data only (e.g. `errorType` = exception type). No PII (names, notes, PIN, raw error messages). See [SECURITY_PRIVACY_GUIDE.md](SECURITY_PRIVACY_GUIDE.md).

### Rotation and Storage

- **Limit**: 5 MB.
- **Backups**: up to 2 files (`timerevo_diagnostics.1.ndjson`, `timerevo_diagnostics.2.ndjson`).
- **Rotation trigger**: on append when file size exceeds limit.
- **Retention**: append-only; no explicit retention beyond rotation.

### Implementation References

| Element | File |
|---------|------|
| NDJSON sink, rotation | [../lib/core/diagnostic_log.dart](../lib/core/diagnostic_log.dart) |
| API: `append`, `readLastLines` | `DiagnosticLog.append()`, `DiagnosticLog.readLastLines(int n)` |
| Private functions | `_appendImpl`, `_rotateIfNeeded`, `_readLastLinesImpl` |

---

## 3. Diagnostic Export (ZIP)

### Purpose

The user (admin) initiates export for support. ZIP contains only sanitized logs and technical context.

### ZIP Contents

| File | Description |
|------|-------------|
| `meta.json` | `appVersion`, `platform`, `platformVersion`, `locale`, `timestamp` (UTC ISO8601) |
| `recent_logs.ndjson` | Last 1000 lines from NDJSON log |

### Exclusions (not included)

- Database (SQLite).
- PDF.
- Any PII.

**Exact contents:** only meta.json and recent_logs.ndjson; nothing else. If no log lines are available, recent_logs.ndjson may be empty (implementation-defined).

### UI Entry Point

- **Screen**: Settings in admin area.
- **Button**: "Export diagnostics" (l10n: `settingsExportDiagnostics`).
- **Access**: admin only (PIN-gated).
This is intentional (good enough): diagnostics export is treated as an admin-support action and is kept behind admin mode to reduce accidental sharing.

### Implementation References

| Element | File |
|---------|------|
| Export service | [../lib/data/services/diagnostic_export_service.dart](../lib/data/services/diagnostic_export_service.dart) |
| Export method | `DiagnosticExportService.exportToFile(context)` |
| Meta builder | `_buildMeta(locale)` — uses [../lib/core/app_info.dart](../lib/core/app_info.dart) for `appVersion` |
| Logs builder | `_buildRecentLogs()` — `DiagnosticLog.readLastLines(1000)` |
| UI button | [../lib/features/admin/settings/settings_page.dart](../lib/features/admin/settings/settings_page.dart) (lines 266–296) |

---

## 4. Global Error Capture

**Current state:** global handlers are configured in `main()`.

- `FlutterError.onError` — set; calls `FlutterError.presentError(details)` then appends `appFlutterError` with sanitized `errorType` only.
- `runZonedGuarded` — wraps `runApp`; zone error handler appends `appUnhandledError` with sanitized `errorType` only.
- Isolate error handler — not configured.

**Implementation reference:** [../lib/main.dart](../lib/main.dart). App init errors are also handled in `appInitProvider` ([../lib/app/app.dart](../lib/app/app.dart)); event `appInitFailed` with errorType is written to NDJSON.

**Privacy rule:** No exception messages or stack traces unless sanitized by a proven sanitizer; baseline is `errorType` and optionally `errorCode` (if introduced).

---

## 5. Logging Abstractions and Events

### DiagnosticLog and DiagnosticLogEntry

Structured logging via `DiagnosticLog.append(DiagnosticLogEntry(...))`.

**Entry fields:**

| Field | Type | Description |
|-------|------|-------------|
| `event` | `DiagnosticEvent` | Event code |
| `ts` | `String` | ISO8601 UTC |
| `errorType` | `String?` | Exception type only (e.g. `SqliteException`), no message |

### Event Codes (DiagnosticEvent)

| Code | Context |
|------|---------|
| `appStart` | Successful app launch |
| `appInitFailed` | Init failure (incl. DB) |
| `adminUnlockSuccess`, `adminUnlockFail` | Admin login via PIN |
| `backupStart`, `backupSuccess`, `backupFail` | Backup |
| `diagnosticExportStart`, `diagnosticExportSuccess`, `diagnosticExportFail` | Diagnostic export |
| `terminalClockIn`, `terminalClockOut`, `terminalClockInSuccess`, `terminalClockOutSuccess`, `terminalClockInFail`, `terminalClockOutFail` | Terminal clock-in/out flows |
| `appUnhandledError`, `appFlutterError` | Global error capture (uncaught async, Flutter framework errors) |

### debugPrint

For debugging, `debugPrint` is used with level prefixes `[D]`, `[I]`, `[W]`, `[E]` (per [CODING_STANDARDS_GUIDE.md](CODING_STANDARDS_GUIDE.md)). Output goes to console only; not written to NDJSON or diagnostic export. **Rule:** debugPrint must not contain user-entered text or PII.

### Implementation References

| Element | File |
|---------|------|
| Enum, entry, API | [../lib/core/diagnostic_log.dart](../lib/core/diagnostic_log.dart) |
| appStart | [../lib/app/app_init.dart](../lib/app/app_init.dart) |
| appInitFailed | [../lib/app/app.dart](../lib/app/app.dart) |
| adminUnlockSuccess/Fail | [../lib/app/auth/admin_auth_controller.dart](../lib/app/auth/admin_auth_controller.dart) |
| backup* | [../lib/data/services/backup_service.dart](../lib/data/services/backup_service.dart) |
| diagnosticExport* | [../lib/features/admin/settings/settings_page.dart](../lib/features/admin/settings/settings_page.dart) |
| terminalClock* | [../lib/features/terminal/terminal_page.dart](../lib/features/terminal/terminal_page.dart) |
| appUnhandledError, appFlutterError | [../lib/main.dart](../lib/main.dart) |

---

## 6. Rules and Constraints

### No PII

Do not log or export: names, notes, absence reasons, PIN, passwords, tokens. Numeric `employeeId` may be logged only when strictly needed for correlating terminal/clock flows (per [SECURITY_PRIVACY_GUIDE.md](SECURITY_PRIVACY_GUIDE.md)); never as a replacement for a name. It is not part of the current NDJSON schema unless explicitly implemented/approved.

### Alignment with Other Guides

- [ARCHITECTURE_BOUNDARIES_GUIDE.md](ARCHITECTURE_BOUNDARIES_GUIDE.md) — DiagnosticExportService in `data/services/`, DiagnosticLog in `core/`.
- [CODING_STANDARDS_GUIDE.md](CODING_STANDARDS_GUIDE.md) — structured messages, prefixes `[D]`/`[I]`/`[W]`/`[E]` for debugPrint.
- [SECURITY_PRIVACY_GUIDE.md](SECURITY_PRIVACY_GUIDE.md) — NDJSON, no PII, user-initiated export, no DB/PDF.

---

## 7. Gap Analysis

Minimal list of blockers that prevent useful diagnostics:

| Gap | Impact | Smallest Fix |
|-----|--------|--------------|
| debugPrint not in export | Debug context unavailable in export | Leave as-is (good enough) or add `DiagnosticLog.append` for critical errors alongside debugPrint |

---

## 8. Minimal API Extension Sketch (Optional)

If optional `employeeId` is needed in `DiagnosticLogEntry` (allowed by SECURITY_PRIVACY_GUIDE):

```dart
// lib/core/diagnostic_log.dart
class DiagnosticLogEntry {
  const DiagnosticLogEntry({
    required this.event,
    required this.ts,
    this.errorType,
    this.employeeId,  // optional, numeric only
  });

  final DiagnosticEvent event;
  final String ts;
  final String? errorType;
  final int? employeeId;  // numeric ID only, never name

  Map<String, Object?> toJson() {
    final m = <String, Object?>{
      'event': event.name,
      'ts': ts,
    };
    if (errorType != null) m['errorType'] = errorType;
    if (employeeId != null) m['employeeId'] = employeeId;
    return m;
  }
}
```

When extending the log or ZIP schema, consider adding `schemaVersion` for future-proofing; no code change required now. Sketch for reference only; implement only when explicitly requested.

---

## 9. PR Checklist

- [ ] No PII in logs or export (names, notes, PIN, raw error messages)
- [ ] Numeric `employeeId` may be added only when strictly needed and explicitly approved; not in current schema by default; name — never
- [ ] New `DiagnosticEvent` values carry no PII
- [ ] Diagnostic export excludes DB and PDF
- [ ] All doc links valid (docs → `../lib/` for lib paths)
- [ ] Diagnostics ZIP contains only `meta.json` + `recent_logs.ndjson` (no DB/PDF)
- [ ] `flutter analyze` passes
