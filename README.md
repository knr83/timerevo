# Timerevo

[![Release](https://img.shields.io/github/v/release/OWNER/REPO?display_name=tag)](https://github.com/knr83/timerevo/releases)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078D6)
![Status](https://img.shields.io/badge/status-early%20release-orange)

**Privacy-first desktop time tracking for small teams — fully offline, local-first, and built for simple daily clock-in and clock-out.**

Timerevo is a Windows desktop app for employee time tracking. Employees use the terminal to clock in and out, while admins manage employees, schedules, absences, reports, and settings in the same application.

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
- manage absence requests in one place
- support approval and rejection workflows
- keep planned and unplanned time off organized

### Reports and exports
- generate summaries by employee and date range
- export reports to PDF
- export personal time reports from the terminal

### Settings and local data safety
- switch language and theme
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

## Supported platform

Timerevo currently supports:

- **Windows 10 / 11 (64-bit)**

## Run from source

### Requirements

- Flutter SDK compatible with the project
- Windows development environment for Flutter Desktop

### Start locally

    flutter pub get
    flutter run -d windows

## Build

To build the Windows desktop application:

    flutter build windows

Build output:

    build/windows/x64/runner/Release/

## Distribution

Timerevo is distributed as a standalone Windows build.

1. Download the latest `timerevo-<version>-win64.zip` release
2. Unpack it to any folder
3. Run `timerevo.exe`

No installer is required.

To create a distributable package locally:

    .\tools\build_release.ps1

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

Timerevo stores its local database on the machine.

Typical database location on Windows:

    %LOCALAPPDATA%\timerevo\timerevo.sqlite

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
