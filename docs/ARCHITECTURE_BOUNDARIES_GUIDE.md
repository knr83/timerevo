# Architecture & Boundaries Guide

This document defines the **architecture rules and boundaries** for the Timerevo Flutter codebase. It is the single source of truth for layering, dependency rules, and where to place new code.

---

## Target State

### Layers

| Layer | Path | Allowed Imports |
|-------|------|-----------------|
| **UI** | `features/`, `common/widgets/` | domain, core, common, app (routing/theme only) |
| **Domain** | `domain/` | core only (no Flutter, no Drift) |
| **Data** | `data/` | domain (ports), core |
| **Core** | `core/` | none (pure Dart) |
| **App** | `app/` | all (bootstrap, DI wiring) |

### Dependency Rules

- **UI → Domain, Core, Common, (App routing/theme only)** — never import `data/`
- **Domain → Core only** — no Data, no Flutter
- **Data → Domain (ports), Core** — implements ports
- **App → all** — wire-up only
- **UI must not import app DI/bootstrap internals** — only app-level public API (router/theme).

### Folder Structure

```
lib/
├── app/           # Bootstrap, router, theme, locale, init
├── common/        # Reusable widgets + pure utils shared across features (no data)
├── core/          # Domain errors, config, clock, pure utils
├── data/          # DB, repositories (implement domain ports)
├── domain/        # Use cases, ports, entities/value objects
├── features/      # Feature modules (UI + controllers)
├── l10n/
└── ui/            # App-wide screens/pages (legal/about/debug) - not feature-specific
```

---

## Folder Templates for New Features

### New feature under `features/`

```
features/
└── my_feature/
    ├── my_feature_page.dart       # Main page widget
    ├── my_feature_controller.dart # State controller (optional)
    ├── my_feature_providers.dart  # Riverpod providers
    └── widgets/                   # Feature-specific widgets (optional)
```

**Rules:**
- Import only from `domain/`, `core/`, `common/`, and `app/` (routing/theme only)`
- Do NOT import `data/`
- Use use cases or controllers that depend on domain ports

### New use case

```
domain/
├── usecases.dart           # Add use case class (OK while small; if it grows, split into domain/usecases/)
├── usecase_providers.dart  # Add provider (wires to ports)
└── ports/
    └── my_repo_port.dart   # Define interface if new repo needed
```
Rule: start in usecases.dart; when it becomes crowded, move to domain/usecases/<name>_usecase.dart (same API, no behavior change).

### New repository

```
data/repositories/
├── my_repo.dart            # Implements IMyRepo from domain/ports/
└── repo_providers.dart     # Add provider, return interface type
```

---

## Anti-Patterns

1. **UI importing data** — features must not import `data/db/`, `data/repositories/`, `data/errors/`
2. **DTOs in UI** — Do not use Drift entities (Employee, WorkSession) in widgets; use domain entities or display models
3. **Cross-feature direct imports** — features must not import from other features; extract shared logic to `app/`, `core/`, or `domain/`
4. **Data exceptions in UI** — Catch domain exceptions only; map DataException in data layer
5. **Common depending on data** — `common/` must not import `data/`
6. **Domain depending on Flutter/Drift** — domain must be pure Dart
7. **Duplicated logic** — Use shared utils (`date_utils`, `time_format`) from common/core; avoid copy-pasting formatting helpers

---

## PR Checklist

- [ ] No new `import '../../data/...'` in `features/` or `common/`
- [ ] No Drift entities (Employee, WorkSession, Absence) in UI — use domain types
- [ ] No DataException/ValidationException in UI catch blocks — use domain exceptions
- [ ] New repos implement domain ports; providers return interface type
- [ ] New use cases depend on ports only, not concrete repos
- [ ] `flutter analyze` passes

---

## Where New Code Goes

| Type | Location |
|------|----------|
| New feature UI | `features/<feature_name>/` |
| New use case | `domain/usecases.dart` + `usecase_providers.dart` |
| New repo interface | `domain/ports/` |
| New repo implementation | `data/repositories/` |
| Domain entity/value object | `domain/entities/` |
| Shared config/errors | `core/` |
| Shared widget (no data) | `common/widgets/` |
| Pure util (no data) | `common/utils/` |
| Shared app-level state (e.g. auth) | `app/auth/` or similar under `app/` |
