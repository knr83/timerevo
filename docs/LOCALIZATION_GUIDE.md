# Localization Guide

This guide defines localization rules for the Time Tracker Flutter app.

---

## 1. Key Naming & Grouping

**Format:** `{feature}{Purpose}` in camelCase.

**Feature prefixes (current, non-exhaustive):**
- `common*` – shared UI (Add, Save, Cancel, OK)
- `terminal*` – terminal screen
- `admin*` – admin shell, PIN
- `employee*` – employee form/card
- `schedules*` – schedules
- `sessions*` – sessions
- `absence*` – absence requests
- `overrides*` – schedule overrides
- `settings*` – settings
- `init*` – startup errors
- `changePin*` – PIN change dialog
Rule: this list is not exhaustive. For new features/modules, introduce a new prefix that matches the feature name, keep it consistent, and update this list.
Rule: do not create overlapping prefixes (e.g., both "shift*" and "schedules*"). Pick one canonical prefix per feature.
Naming: use a short, stable noun that reflects the user-facing feature/module (e.g., "reports*", "devices*", "roles*"). Avoid abbreviations unless already established.

**Purpose suffixes:**
- `*Error*` – errors (e.g. `terminalErrorClockInBeforeStart`, `absenceErrorOverlap`)
- `*Failed` – failed operations (e.g. `employeeCreateFailed`, `schedulesFailedLoad`)
- `*Title` – screen/dialog titles
- `*Label` – labels (e.g. `employeeActiveLabel`)
- `*Hint` – hints (e.g. `employeesInactiveHiddenHint`)
- `*Prefix`, `*Suffix` – split strings for RichText (see §4)
- `*Link*` – link text in split strings (e.g. `employeePolicyLinkPrivacy`)

**Examples:** `terminalStatusOnShift`, `sessionsTableDuration`, `employeeFirstLastRequired`, `overridesEffectiveSchedule`.

---

## 2. Punctuation & Casing

| Type | Rule | Example |
|------|------|---------|
| **Labels** | Sentence case, no period | `"First name"`, `"Default schedule"` |
| **Buttons** | Sentence case, no period | `"Add"`, `"Save"`, `"Create template"` |
| **Toasts / success** | Sentence case, period | `"Saved."`, `"Exported."`, `"Absence request created."` |
| **Error messages** | Sentence case, period | `"Session is already open."`, `"Invalid PIN."` |
| **Empty states** | Sentence case, period | `"No sessions."`, `"No employees yet."` |
| **Hints** | Sentence case, period when full sentence | `"Inactive employees are hidden in the Terminal."` |

---

## 3. Placeholders

**Format:** ICU style in braces: `{name}`, `{count}`, `{error}`, `{time}`, `{start}`, `{end}`.
Note: braces {...} are used in ARB messages. In Dart, use the generated l10n methods/args (e.g., l10n.employeeCreateFailed(error)).

**Naming:** Use descriptive, short names: `name`, `count`, `error`, `time`, `path`, `value`, `hours`, `minutes`, `date`, `title`, `source`, `weekday`, `startTime`.

**Types in ARB:** Specify `"type"` for all placeholders:
- Strings: `"placeholders": { "error": { "type": "String" } }`
- Integers: `"placeholders": { "count": { "type": "int" } }`

**Examples:**
```
"terminalOnShiftSince": "since {time}"
"terminalShowMoreSessions": "Show {count} more"
"sessionsEmployeePrefix": "Employee: {name}"
"durationHm": "{hours}h {minutes}m"
"employeeCreateFailed": "Failed to create employee: {error}"
```

**Do:** Put whole messages in one string with placeholders.  
**Don't:** Concatenate localized strings like `'${l10n.a} ${l10n.b}'` (word order differs by language).

---

## 4. RichText / Links vs Concatenation

**Allowed: string splitting for RichText**

When you need inline links and custom spans, split the sentence into separate keys and compose them in `RichText`:

```
employeePolicyPrefix: "Employee has acknowledged the "
employeePolicyLinkPrivacy: "Privacy Policy"
employeePolicyMiddle: " and "
employeePolicyLinkTerms: "Terms"
```

Usage: `TextSpan(text: l10n.employeePolicyPrefix)` + `TextSpan(text: l10n.employeePolicyLinkPrivacy, recognizer: ...)` + etc.

Use this pattern only when links/formatting must be inside the sentence. Otherwise prefer a single string with placeholders.
Rule: do not split strings just to reuse fragments; split only for inline links/spans that cannot be expressed with placeholders.

**Forbidden: concatenation**

Do not concatenate localized strings in code:

```dart
// BAD
return '${l10n.terminalDurationHoursOnly(h)} ${l10n.terminalDurationMinutesOnly(m)}';
```

Use a single message with placeholders:

```dart
// GOOD – use durationHm
return l10n.durationHm(h, m);
```

Also avoid:
- Suffix concatenation where word order could change; for natural language, use placeholders.
- Building sentences from multiple keys (e.g. `l10n.label + ': ' + value`).

---

## 5. Future-Proofing for New Languages

- Do not hard-code word order. Use placeholders so each locale controls order.
- Avoid patterns like "Label: " + value; prefer "Label: {value}" when the phrase is user-facing or could change word order in other languages.
- Exception (acceptable): technical pairs like "PIN: 1234" / "ID: 42" may remain as label + separator + value if they are short, purely technical, and consistent across the app.
- Keep numbers, dates, and times as placeholders; format in code with `intl` (e.g. `DateFormat`) and pass formatted strings if needed.
- Do not concatenate translatable fragments. One logical phrase = one key with placeholders.
- For pluralization or gender, use ICU `plural` / `select` when Flutter l10n supports it; until then, rephrase to avoid complex variants where possible.

---

## 6. PR Checklist

Before merging l10n changes:

- [ ] All new keys use the naming pattern `{feature}{Purpose}`.
- [ ] If a new feature/module is introduced, add its prefix to “Feature prefixes (current, non-exhaustive)”.
- [ ] Placeholders have explicit `"type"` in the ARB.
- [ ] No hardcoded user-facing strings in Dart.
- [ ] Labels/buttons: no period; toasts/errors: period at end.
- [ ] No string concatenation of localized fragments; use placeholders or the allowed RichText split pattern.
- [ ] New keys added to `app_de.arb` and `app_ru.arb`.
- [ ] `flutter gen-l10n` runs without errors or new warnings.
- [ ] Spot-check affected screens in DE and RU locales.
