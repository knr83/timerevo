# Timerevo

[![Release](https://img.shields.io/github/v/release/knr83/timerevo)](https://github.com/knr83/timerevo/releases)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-0078D6)
![Status](https://img.shields.io/badge/status-early%20release-orange)

**Privacy-first desktop time tracking for small teams — fully offline, local-first, and built for simple daily clock-in and clock-out.**

Timerevo is a desktop app (Windows, Linux, macOS) for employee time tracking. Employees use the terminal to clock in and out, while admins manage employees, schedules, absences, reports, and settings in the same application.

All data is stored locally in SQLite on the machine. No server. No cloud. No internet connection required for daily use.

## Why Timerevo

- **Fully offline** — no cloud dependency and no server setup
- **Local-first by design** — all records stay on the machine
- **Simple terminal workflow** — fast daily use for employees
- **Optional PIN protection** — additional access control for employee check-in
- **Built for small teams** — practical for single-workplace and small business setups
- **Backup and restore** — straightforward local data protection
- **Multilingual UI** — German, Russian, and English
- **Accessible themes** — light, dark, and high-contrast

## Project status

**Early release.** Core workflows are implemented and ready for everyday use.

Currently available and ready to use:

- employee clock-in / clock-out
- employee management
- schedule templates
- work session journal
- absence requests and approvals
- PDF reports
- backup and restore
- localization and theme settings
- attendance mode (flexible / fixed) and **tracking start date** (limits how far back data is included in analysis)

## Features

### Fast employee clock-in and clock-out
- use a shared terminal for daily check-in and check-out
- select an employee profile and enter a PIN if enabled
- keep the workflow simple and quick for everyday use

### Employee and schedule management
- create and edit employee profiles
- assign employee codes, roles, and schedule templates
- define working intervals per weekday, including shifts that cross midnight

### Work session control
- browse recorded work sessions in the journal
- filter by employee, date range, and status
- edit start and end times, add notes, and document update reasons

### Absence management
- employees submit requests from the **terminal** (My work calendar)
- admins review the same records in **admin** (filters, edit/delete while pending, approve/reject)
- keep planned and unplanned time off in one workflow

### Reports and exports
- generate summaries by employee and date range
- export reports to PDF
- export personal time reports from the terminal

### Settings and local data safety
- switch language and theme
- **Attendance mode** — flexible or fixed (with tolerance in fixed mode); see the [User Guide — Settings](USER_GUIDE_EN.md#settings)
- **Tracking start date** — optional; analysis and reports treat this as the earliest relevant date (see in-app help on Settings)
- create and restore backups
- export diagnostics for support
- keep all data stored locally on the machine

## Screenshots

### Terminal
Fast daily clock-in and clock-out from a shared workplace terminal.

![Terminal](assets/screenshots/01-terminal-page.png)

### Employees
Manage employee profiles, PIN access, and schedule templates.

![Employees](assets/screenshots/02-employees-page.png)

### Schedules
Define working intervals per weekday, including shifts that cross midnight.

![Schedules](assets/screenshots/03-schedule-management.png)

### Reports
View summaries by employee and period, then export them to PDF.

![Reports](assets/screenshots/04-reports-page.png)

### Settings
Configure language, theme, backup and restore, and other app preferences.

![Settings](assets/screenshots/05-settings-page.png)

## Supported platforms

Timerevo supports:

- **Windows 10 / 11 (64-bit)**
- **Linux (64-bit)**
- **macOS**

## Run from source

### Requirements

- Flutter SDK compatible with the project
- Platform-specific tools: Windows (Visual Studio), Linux (clang, cmake, ninja, pkg-config, libgtk-3-dev), macOS (Xcode)

### Start locally

    flutter pub get
    flutter run -d windows   # or linux, macos

## Build

To build the desktop application:

    flutter build windows   # Windows
    flutter build linux     # Linux
    flutter build macos    # macOS (on macOS only)

Build output:

- Windows: `build/windows/x64/runner/Release/`
- Linux: `build/linux/x64/release/bundle/`
- macOS: `build/macos/Build/Products/Release/timerevo.app`

## Distribution

Timerevo is distributed as standalone builds per platform via [GitHub Releases](https://github.com/knr83/timerevo/releases)

**Windows:** `timerevo-windows-<version>.zip` — unpack, run `timerevo.exe`

**Linux:** `timerevo-linux-<version>.tar.gz` — unpack, run `./timerevo`

**macOS:** `timerevo-macos-<version>.zip` — unpack, open `timerevo.app`

No installer is required.

## Tech stack

- **Flutter**
- **Material 3**
- **Riverpod**
- **Drift**
- **SQLite**

## Project structure

    lib/
    ├─ app/        # Bootstrap, router, theme, init
    ├─ common/     # Shared widgets and utils
    ├─ core/       # Domain errors, config, pure utils
    ├─ data/       # DB, repositories
    ├─ domain/     # Use cases, ports, entities
    ├─ features/   # UI and feature logic
    ├─ l10n/
    └─ ui/         # App-wide screens (legal, etc.)

## Data storage

Timerevo stores its local database on the machine using Flutter’s [`getApplicationSupportDirectory()`](https://pub.dev/documentation/path_provider/latest/path_provider/getApplicationSupportDirectory.html) with the filename `timerevo.sqlite` (companion `-wal` / `-shm` files may appear while the app runs).

Resolved paths (current branding / bundle IDs in this repo):

- **Windows:** `%APPDATA%\Timerevo\Timerevo\timerevo.sqlite`  
  (`path_provider` uses **Roaming** app data, not Local; the folder is `CompanyName\ProductName` from the app’s `VERSIONINFO` — both are `Timerevo` in [`windows/runner/Runner.rc`](windows/runner/Runner.rc).)
- **Linux:** `~/.local/share/com.example.timerevo/timerevo.sqlite`  
  (Application ID `com.example.timerevo` in [`linux/CMakeLists.txt`](linux/CMakeLists.txt).)
- **macOS:** `~/Library/Application Support/com.example.timerevo/timerevo.sqlite`  
  (Bundle identifier `com.example.timerevo` in [`macos/Runner/Configs/AppInfo.xcconfig`](macos/Runner/Configs/AppInfo.xcconfig); Application Support uses this as a subdirectory.)

This keeps the application self-contained and easy to back up or restore.

## Documentation

### User guides

- [English User Guide](USER_GUIDE_EN.md)
- [Russian User Guide](USER_GUIDE_RU.md)
- [German User Guide](USER_GUIDE_DE.md)

## Contributing

Contributions, bug reports, and improvement suggestions are welcome.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening an issue or submitting changes.

## License

This project is licensed under the terms of the license included in this repository. See the [LICENSE](LICENSE) file for details.
