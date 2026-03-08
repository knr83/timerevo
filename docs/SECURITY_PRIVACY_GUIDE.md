# Security & Privacy Guide — Timerevo

**Scope:** Local-only desktop app. No cloud. This guide reflects project decisions and audit findings.

---

## 1. Scope & Decisions

- **Admin PIN:** Digits only, min 4; PBKDF2-HMAC-SHA256 (100k iterations), salt+hash; no legacy SHA256.
- **Admin mode:** PIN requested when entering Administration; admin access lasts only while inside admin area; leaving locks it.
- **Export:** User exports only their own worked-time report for a selected period; admin exports any data exposed by app functionality.
- **Backup/Restore:** Local file; user chooses save location; responsibility documented in TERMS.md; no mandatory warnings in UI.
- **Retention:** Out of scope (no retention policy designed).
- **Logging:** NDJSON format; no PII (no names, notes, absence reasons); numeric employeeId may be logged only when strictly needed (not in current NDJSON schema unless explicitly implemented); diagnostic export required (user-initiated), excluding DB/PDF, including sanitized logs + technical context.

---

## 2. Data Classification

| Class | Examples | Handling |
|-------|----------|----------|
| **Secrets** | Admin PIN hash, employee PIN hash/salt | Stored salted+hashed (PBKDF2); never logged |
| **PII** | Names, notes, absence reasons, email, phone | Not in logs; export only via role-based access and purpose |
| **Allowed technical** | Numeric employeeId, timestamps, status codes | OK in diagnostics if needed |

---

## 3. Access Control

**User (Employee):**
- Terminal: clock in/out, own calendar, own absences (create/edit/delete when PENDING)
- Own worked-time PDF export (period selector)
- No access to admin exports

**Admin (after PIN):**
- Dashboard, employees, schedules, sessions, absences, reports, settings
- PDF export (any exportable data)
- Backup/restore
- Change admin PIN
- Approve/reject absences; edit sessions
- Lock on leaving admin area

---

## 4. Logging & Diagnostics Policy

- **Format:** NDJSON
- **No PII:** Names, notes, absence reasons, PIN/pinStatus/usePin must not appear. Avoid raw exception messages if they may include PII; prefer errorCode + exceptionType when available. If a stable errorCode taxonomy is not implemented yet, log only errorType (runtimeType) per [OBSERVABILITY_DIAGNOSTICS_GUIDE.md](OBSERVABILITY_DIAGNOSTICS_GUIDE.md).
- **employeeId:** Numeric ID may be logged only when strictly needed for correlation; not part of current NDJSON schema unless explicitly implemented/approved (without name)
- **Diagnostic export:** User-initiated; must exclude DB/PDF; include only sanitized logs + technical context (app version, OS, etc.)

---

## 5. Export Handling

### 5.1 PDF Export (Intended Format)

- **Target state:** PDF is the intended export format for worked-time reports.
- **PII:** PDF content may include PII (e.g. employee name) as required for the workflow.
- **Access rules:**
  - **User (employee):** Export only own worked-time report for a selected period. Enforce at export entry point: caller must be the employee whose data is exported.
  - **Admin:** Export any data the app provides export for. Access gated by AdminShell (PIN).
- **Storage:** The app does not retain exports. User saves the file to a location they choose.
- **Implementation notes:** Enforce access checks at the export entry point. Log only event codes + numeric employeeId; never log report content or names.

### 5.2 Backup

- Backup = full DB copy; user chooses location.
- No retention policy; out of scope.
- TERMS.md defines Organization responsibility for backups and exports.

---

## 6. Minimal PR Checklist

- [ ] No new PII in logs (names, notes, absence reasons, PIN, raw exceptions); employeeId only when strictly needed (not in schema by default)
- [ ] Export/backup access matches role (user = own only, admin = any)
- [ ] Export entry point enforces access checks
- [ ] Export logs: event codes + employeeId only; no content/names
- [ ] Admin-only actions behind AdminShell
- [ ] PIN/auth changes reviewed
- [ ] Diagnostic export excludes DB/PDF and PII
