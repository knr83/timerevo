# Timerevo

> Desktop time tracking for employees. Fully offline, local data storage.

**Timerevo** is a Flutter desktop application for recording work clock-in/clock-out. Designed for small teams and single-computer workplaces — no server, no cloud, no internet required.

## Features

- **Terminal** — quick employee check-in/out with optional PIN
- **Employees** — manage profiles, PIN/NFC access, schedule templates
- **Schedules** — define working intervals per weekday
- **Journal, Absences, Reports** — sessions, absence requests, summaries by period
- **Multilingual** — German, Russian, English
- **Accessibility** — light, dark, high-contrast themes

## Requirements

- **Windows 10/11** (64-bit)

## Quick Start

### Run from source

```bash
flutter pub get
flutter run -d windows
```

### Install from build

1. Unpack the `timerevo-*-win64.zip` into a folder
2. Run `timerevo.exe`
3. On first launch, a local SQLite DB is created (e.g. `%LOCALAPPDATA%\timerevo`)

**Default admin PIN:** `0000` — change it in Administration → Settings.

### Data storage (for administrators)
- Database: `%LOCALAPPDATA%\timerevo\timerevo.sqlite`
- To remove all data: close the app and delete the folder `%LOCALAPPDATA%\timerevo\`

## Tech Stack

| Layer | Technology |
|-------|------------|
| UI | Flutter, Material Design 3 |
| State | Riverpod |
| Persistence | Drift ORM, SQLite |
| Localization | Flutter l10n (de, ru, en) |

## Project Layout

```
lib/
├── app/           # App shell, theme, locale, init
├── common/        # Shared widgets, utils
├── data/          # DB schema, repositories
├── domain/        # Use cases
├── features/      # Terminal, Admin (Employees, Schedules, Journal, Absences, Reports, Settings, About)
├── l10n/          # Localization strings
└── ui/legal/      # Legal doc viewer (LegalDocPage, LegalLinks)
```

## Legal Documents

`PRIVACY_POLICY.md` and `TERMS.md` in the repo root are the source of truth. Copies in `assets/legal/` are bundled with the app. After editing the root files, sync:

```bash
dart run tools/sync_legal_docs.dart
```

## Documentation

- [User Guide (EN)](USER_GUIDE_EN.md)
- [Руководство пользователя (RU)](USER_GUIDE_RU.md)
- [Benutzerhandbuch (DE)](USER_GUIDE_DE.md)
- [UI/UX Style Guide](docs/UI_UX_STYLE_GUIDE.md)

## Build

```bash
flutter build windows
```

Release output: `build/windows/x64/runner/Release/`

## Preparing a delivery package

To create a distributable zip for end users:

```powershell
.\tools\build_release.ps1
```

This will:
1. Run `flutter build windows`
2. Copy the build output and user guides (USER_GUIDE_*.md) into `dist/timerevo-<version>-win64/`
3. Create `dist/timerevo-<version>-win64.zip`

Send the zip to the user. They unpack it anywhere and run `timerevo.exe` — no installer needed.

## Version

0.1.0
