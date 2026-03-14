# Coding Standards Guide

A practical, enforceable guide for the Timerevo Flutter codebase. Based on an audit of this repository and Flutter/Dart best practices (2026). See [ARCHITECTURE_BOUNDARIES_GUIDE.md](ARCHITECTURE_BOUNDARIES_GUIDE.md) for layering and boundaries.

---

## A. Principles

- **Readability** — Code should be understandable at a glance; prefer clarity over cleverness.
- **Consistency** — Follow existing patterns so developers can predict where things live.
- **Safety** — Prevent chaos: proper error handling, no raw exceptions to users, no leaked sensitive data.
- **Performance** — Use `const`, avoid unnecessary rebuilds, keep heavy work off the UI thread.
- **Maintainability** — Small, focused files; explicit dependencies; minimal coupling.

---

## B. Project Conventions

### Naming

| Item | Convention | Example |
|------|------------|---------|
| Files | snake_case | `employee_calendar_page.dart` |
| Folders | snake_case | `features/admin/` |
| Classes | PascalCase | `ClockInUseCase`, `TerminalPage` |
| Controllers | `*Controller` suffix | `AdminAuthController`, `TerminalController` |
| Pages | `*Page` suffix | `DashboardPage`, `AbsencesPage` |
| Dialogs | `*Dialog` suffix | `AbsenceRequestDialog`, `EmployeeCardDialog` |
| Methods / variables | camelCase | `onEmployeePressed`, `selectedEmployeeId` |

### File Structure Rules

| Type | Location |
|------|----------|
| Feature UI | `features/<feature_name>/` |
| Use cases | `domain/usecases.dart` (+ split when large) |
| Repo interfaces | `domain/ports/` |
| Repo implementations | `data/repositories/` |
| Domain entities | `domain/entities/` |
| Shared config / errors | `core/` |
| Shared widgets (no data) | `common/widgets/` |
| Pure utils | `common/utils/` |
| App-level state | `app/` (auth, theme, locale, working hours) |

### Imports

- **No global barrel files** — Import specific files by default. Allowed: a small feature-level public API file (e.g. features/<feature>/public_api.dart`) exporting only feature UI types. Never export `data/` from a barrel.`
- **Order** — Prefer: package imports first, then relative imports grouped.
- Prefer package imports within `lib/` (e.g. `package:timerevo/...`) to reduce deep relative paths, but keep it consistent per feature.
- **Avoid cyclic imports** — Keep layers: UI → Domain, Core; Data → Domain, Core; Domain → Core only.
- **Target state** — Features must NOT import `data/`; use use cases / controllers instead.

---

## C. Flutter / Dart Rules

### Widget Composition

- Use `const` where possible to reduce rebuilds.
- Keep `build()` pure: no side effects, no async, no `setState`.
- Use keys only when needed (list identity, state preservation).
- Prefer small, composable widgets over large monolithic ones.

### State Management (Riverpod)
Project standard: Riverpod. Follow these defaults unless there is a concrete reason to deviate (document it in the PR).

- **NotifierProvider** — For complex state (auth, terminal, theme, locale, working hours).
- **StateProvider** — For simple values (selected id, filter flags).
- **StreamProvider** — For reactive streams from repositories.
- **FutureProvider** — For async initialization (e.g. app init).
- **Provider** — For singletons (repos, use cases).

Business logic belongs in use cases, controllers, or repositories—not in widget `build()`.

#### Unsaved changes guard (required)

- Maintain a dirty flag in state (Riverpod/controller) for edit screens.
- Guard route pop / close and in-screen switching (e.g. dropdown selection) with a confirmation dialog when dirty.
- Do not silently discard or silently save changes on navigation.
- Keep UI free of data-layer imports; save operation must go through app/domain use cases.
- Ensure `flutter analyze` remains clean.

### Async Rules

- Avoid `async` in `initState`. If you must trigger async work, use `Future.microtask` / post-frame and keep it side-effect-safe; prefer `FutureProvider` for observable init flows.`
- After `await`, always check `context.mounted` before using `context` (e.g. `Navigator.of(context)`).
- In `Timer` or delayed callbacks, check `mounted` before `setState`.
- Dispose timers and subscriptions in `dispose()`.
- Riverpod cancels subscriptions on dispose; no explicit cancellation tokens for provider streams.

### Performance Hygiene

- Prefer `const` widgets to avoid unnecessary rebuilds.
- Use `ref.watch` only for what the widget needs; avoid watching broad providers.
- Offload expensive work from the UI thread (compute, isolates) when applicable.
- Keep build methods lean; extract complex logic to methods or separate widgets.

---

## D. DI Rules

- **Composition root** — Provider definitions in `data/db/db_providers.dart`, `data/repositories/repo_providers.dart`, `app/usecase_providers.dart`.
- **What to inject** — Repos (via ports), use cases, DB; controllers receive deps via `ref.watch`.
- **Lifetimes** — Repos and DB are singletons; Riverpod manages disposal via `ref.onDispose()`.
- **Avoid** — UI may read use-case providers / domain-facing providers only. UI must not access data-layer repo providers. Prefer use cases/controllers; keep orchestration in domain layer.

---

## E. Error Handling

- **Data → Domain** — Use `guardRepoCall()` in repositories to map `DataException` / `SqliteException` → `DomainException`.
- **Domain → UI** — Catch `DomainException` (or specific subclasses) in UI; never catch `DataException` in features.
- **User-visible** — Domain exceptions should expose a stable error key/code; UI maps it to l10n. Never show `e.toString()` or raw stack traces to users.
- **Debug detail** — Do not log raw exception messages or stack traces (they may contain PII). Log only errorType (runtimeType) and/or stable error codes. Keep user messages short and actionable.
- **Future** — Prefer Result-like types (e.g. `ClockActionResult`) for operations that can fail; extend this pattern where it simplifies flows.

---

## F. Logging Rules

- **Library** — Use `debugPrint` for now; consider a logging package (e.g. `logger`) for structured logs later.
- **Levels** — Until a structured logger is adopted, use lightweight levels via prefixes: \`[D]`, `[I]`, `[W]`, `[E]` in `debugPrint`. Keep logs actionable and not noisy.`
- **Format** — Prefer structured messages: event name + context (e.g. `Terminal clock-in: employeeId=1`).
- **Sensitive data** — Do not log PINs, passwords, tokens, PII, or user-entered text. **debugPrint must not contain user-entered text or PII.**
- **Errors** — When catching exceptions, log once at the boundary (controller/use case). Log only errorType (runtimeType) or stable error codes; never raw exception messages or stack traces (see [SECURITY_PRIVACY_GUIDE.md](SECURITY_PRIVACY_GUIDE.md), [OBSERVABILITY_DIAGNOSTICS_GUIDE.md](OBSERVABILITY_DIAGNOSTICS_GUIDE.md)). UI should not spam logs for the same failure.
- **Future** — Correlation IDs and log levels can be introduced when a logging strategy is adopted.

---

## G. Anti-Patterns (Top 10)

| # | Anti-Pattern | Preferred Alternative |
|---|--------------|------------------------|
| 1 | UI importing `data/` (repos, db, Drift types) | Use use cases; UI depends on domain only. |
| 2 | Showing `e.toString()` to users | Map `DomainException` to localized messages. |
| 3 | Drift entities (Employee, WorkSession, Absence) in UI | Use domain entities (e.g. `EmployeeDisplay`). |
| 4 | Empty `catch (_) {}` | Log or handle; document if intentionally ignoring. |
| 5 | Side effects in `build()` | Keep `build()` pure; move logic to callbacks or controllers. |
| 6 | Using `context` after `await` without `context.mounted` | Check `context.mounted` before Navigator, theme, etc. |
| 7 | Fire-and-forget async in `initState` | Use `FutureProvider`, microtask, or post-frame callback. |
| 8 | Missing `const` on immutable widgets | Add `const` where constructor is const. |
| 9 | Logging sensitive data (PIN, credentials) | Never log secrets; log non-sensitive identifiers. |
| 10 | Direct `ref.watch(repoProvider)` in UI when use case exists | Prefer use case providers; encapsulate orchestration. |

---

## H. PR Checklist

Before commit, run the same checks as the CI pipeline:

- [ ] `dart format --output=none --set-exit-if-changed .` passes (fix with `dart format .` if needed)
- [ ] `flutter analyze` passes

Other checks:

- [ ] No new imports from `lib/data/` in `lib/features/` or `lib/common/` (use use cases/controllers instead)
- [ ] No Drift entities in UI — use domain types where available
- [ ] No `DataException` in UI catch blocks — catch `DomainException` only
- [ ] Errors mapped to localized messages — never `e.toString()` to users
- [ ] `const` on widgets where possible
- [ ] `context.mounted` checked after `await` before using `context`
- [ ] `mounted` checked in Timer/delayed callbacks before `setState`
- [ ] No side effects in `build()`
- [ ] No empty catch blocks (or documented if intentional)
- [ ] No sensitive data in logs
- [ ] New repos implement domain ports; providers return interface type
- [ ] `flutter analyze` returns **No issues found** (do not introduce new infos/warnings/errors)

---

## Common Anti-Patterns (Do Not Do This)

- UI importing data-layer modules (`features/*` importing `lib/data/*`)
- Showing raw exception text to users: `Text(e.toString())` or `l10n.someError(e.toString())`
- Logging raw exception messages or stack traces
- Logging user-entered text, PIN, or PII

---

## Future Improvements

- Introduce use cases for all repository operations; phase out direct repo access from features.
- Define domain display models for `SessionWithEmployee`, `AbsenceWithEmployee` instead of data-layer DTOs in UI.
- Add a lightweight logging abstraction with levels and structured context.
- Gradually add `const` to eligible widgets across the codebase.
