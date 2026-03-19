# Timerevo — Time Tracking User Guide

## Installation

1. Extract the timerevo-*.zip archive to a folder of your choice
   (e.g. C:\Program Files\timerevo or C:\Users\<your_name>\timerevo).

2. Run timerevo.exe.

3. On first run, the app creates the database in the application data folder
   (typically: %LOCALAPPDATA%\timerevo\ or equivalent).

Requirements: Windows 10/11 (64-bit)

## Launch
Double-click `timerevo.exe`.

---

## Terminal (main screen)

1. Select an employee from the list.
2. Enter PIN if prompted (employees with PIN enabled).
3. On first access — **policy acknowledgment** (Privacy Policy and Terms; check the box to continue).
4. Tap **IN** to start a shift or **OUT** to end it.
5. **My work calendar** — calendar of sessions and absences; submit absence requests from here.
6. **Time report (PDF)** — export PDF by period (Today / Week / Month / Custom).
7. List of today's sessions; "Show N more" — expand all.
8. If a session is still open after the working day ends — closing block with date and time picker.
9. The **Administration** button (in the app bar) opens the admin panel.

---

## Administration

Enter the admin PIN to unlock. Press **Back** to exit — admin panel locks automatically.

> On first access, use the default admin PIN: `0000`.
> For security, change it after login in **Settings → Change PIN**.

**Help** menu: Privacy Policy, Terms of use, About.

### Employees
- **Add** (➕): create a new employee.
- Select an employee to view or edit their card.
- Required: Code, first name, last name.
- Optional: hire date, termination date, vacation days per year, role, employment type, department, job title, contact details.
- **Status**: active, inactive, or archived. Only **active** employees (within hire/termination dates) appear in the terminal.
- **Enable PIN**: require PIN for clock-in/out; set or reset PIN per employee.
- **Enable NFC**: alternative access via NFC token.
- Assign a **schedule template** (planned weekly hours follow the template, not a separate field on the card).
- **Export employee data (PDF)** — available from the card when editing an existing employee.

### Schedules
- Create and manage schedule templates (e.g. "Standard Week").
- Add templates with the ➕ button; use the ⋮ menu to rename or activate/deactivate.
- Define working intervals for each weekday (Mon–Sun).
- Set start/end times; use the night toggle for shifts crossing midnight.
- Assign templates to employees in the Employee card.
- **PDF** (toolbar icon): export a roster overview of employees and weekly templates.

### Journal
- Switch views: **Table**, **Timeline**, and **By intervals**.
- **Period bar**: scope **day** / **week** / **month** / **interval**; **Today** and previous/next controls; pick a custom range when **interval** is selected.
- **Table** view: columns Employee, Start, End, Duration, Status. **Status** filter: All / Open / **Not closed** / Closed; employee filter; **Search** (name or note).
- Edit row: start/end, note, update reason (required), "Set end now", "Clear end".

### Absences
- Filters: employee, status (All / Pending / Approved / Rejected), **period** (same period bar as elsewhere: scope, Today, navigation, optional custom range).
- Table: Employee, Type, From/To, Status, Approved by, When.
- Types: vacation, sick leave, unpaid leave, parental leave, study leave, other.
- **Add absence** — button to create an entry.
- For pending: Edit, Delete, Approve, Reject (reason required when rejecting).

### Reports
- View summary by employee and period. Only **closed** sessions are included in totals.
- Filter the **period bar** (day / week / month / interval, Today, navigation).
- Export PDF: full report or per selected employee from the details panel.

### Settings
- **Language**: System default, German, Russian, or English.
- **Theme**: System, Light, Dark, High contrast (light), High contrast (dark).
- **Attendance mode**: **Flexible** or **Fixed**; in **Fixed** mode, set **tolerance (minutes)** for end-of-shift evaluation.
- **Allowed working time**: start and end for the terminal (clock-in restrictions).
- **Change PIN** — change the admin PIN.
- **Export diagnostics** — save diagnostic data to a file (for support).
- **"Create backup"** — saves the database (timerevo.sqlite) to a folder of your choice.
- **"Restore from backup"** — select a .sqlite file and confirm.

---

## Data storage (for administrators)

**Database path:**
- Folder: `%LOCALAPPDATA%\timerevo\`
- File: `timerevo.sqlite`

**Complete data removal:**
1. Close the app.
2. Delete the folder `%LOCALAPPDATA%\timerevo\` (e.g. `C:\Users\<user>\AppData\Local\timerevo`).
