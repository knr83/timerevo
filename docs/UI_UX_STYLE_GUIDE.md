# UI/UX Style Guide (Desktop, Flutter Material 3)

This document is the **single source of truth** for UI/UX and visual decisions in this project.

Scope:
- **Included**: typography, iconography, color, spacing/layout, component usage, feedback/messaging, accessibility, imagery.
- **Excluded (for now)**: **Reports** (leave as-is).

Baseline:
- Flutter **Material 3**.
- Seed-based color scheme (currently **blue**).
- System font (no custom font dependency).

---

## Principles (desktop-first)

- **Clarity over decoration**: if it does not improve comprehension or speed, remove it.
- **Predictable behavior**: one action → one outcome, consistent across screens.
- **Low cognitive load**: prefer fewer options and clear defaults.
- **Mouse + keyboard**: every actionable element must support hover + focus, and primary flows must work with keyboard.
- **No “magic UI”**: users should understand what happened and what to do next.

---

## Color system (Light / Dark / High Contrast)

### Source of truth

- Use Material 3 `ColorScheme.fromSeed(...)` as the base.
- **Do not hard-code random hex values** across widgets. If a color is needed repeatedly, it must be derived from the theme or defined once (e.g., via a small set of semantic constants).

### Semantic meaning (rules)

- **Primary**: main call-to-action and current navigation destination.
- **Surface**: cards, panels, dialogs.
- **Error**: invalid input, failed actions.
- **Warning**: needs attention but not an error (e.g., “will overwrite”, “missing optional data”).
- **Success**: action completed (use sparingly; avoid “green everywhere”).

### States (must be visible beyond color)

- **Disabled**: reduced opacity + no hover + no focus highlight.
- **Selected**: background change + (optional) leading icon; do not rely on color only.
- **Focus**: clearly visible focus ring/highlight.
- **Hover**: subtle background change (desktop affordance).

### High contrast guidance

- In High Contrast mode: increase border/outline thickness by +1, strengthen dividers, and ensure focus ring is always visible on interactive elements (buttons, inputs, table rows)
- Never encode meaning **only** by color. Add one of:
  - an icon (e.g., `error`, `warning`, `check_circle`)
  - a short label (“Error”, “Warning”)
  - shape/border change (focus ring, outline)
- Prefer **stronger outlines** and **stronger surface separation** (borders/dividers) than in normal themes.

---

## Typography

### Font

- Use the **system font** (Material default). Do not introduce custom fonts.

### Recommended scale (desktop readability)

Use these targets consistently:

- **Screen title**: 20–24, `w600`
- **Section / card title**: 16–18, `w600`
- **Body text**: 14–16, `w400`
- **Secondary text** (helper, subtitle): 12–13, `w400`, use `onSurfaceVariant`
- **Dense table/list rows**: keep body at 14 when possible (avoid 12 for primary content)

### Numbers and time

- For numeric/time columns: use fixed-width formatting (monospace digits if available) and right-align to prevent layout jumps while values update.
- Prefer **aligned columns** for times/durations (fixed widths or table layout).
- Do not let time strings “jump” horizontally between rows; keep consistent formatting.

---

## Iconography

### One icon family

- Use **Material icons / Material Symbols** consistently (prefer a rounded look for coherence).

### Sizes

- **18–20**: dense rows, secondary actions
- **24**: default (toolbars, primary icon buttons)

### Rules

- Icon-only actions must be **universally recognizable** (add/edit/delete/copy/close/arrow).
- Every `IconButton` must have a **tooltip** (desktop requirement).
- Destructive actions must not rely on color only:
  - use confirmation + explicit label (e.g., “Delete employee”)

---

## Imagery / illustrations

Images are optional. If used, use them only for **empty states** and onboarding hints.

- **No photos** or random stock imagery.
- Prefer simple monochrome/2-tone illustration style.
- Keep them subtle: smaller than the primary content, never competing with data.

Asset conventions:
- Put under `assets/illustrations/` (if/when introduced).
- Name files by intent: `empty_employees.png`, `empty_schedules.svg`, etc.

---

## Layout & spacing (8dp grid)

- Standard heights: toolbar 48dp, input 40dp, primary button 40dp, table row 40–44dp (keep consistent within a screen).
- Base spacing: **8dp**.
- Common paddings:
  - Cards/panels: 16dp
  - Dialog content padding: 16–24dp
  - Between form fields: 12–16dp
- Keep desktop density **comfortable but not mobile-wide** (avoid excessive whitespace).

---

## Component usage rules (Material 3)

### Buttons

- **Primary action**: `FilledButton`
- **Secondary**: `FilledTonalButton` or `OutlinedButton` (depending on emphasis)
- **Tertiary / inline**: `TextButton`
- **Destructive**: keep style consistent, but use `colorScheme.error` for text/icon and require confirmation.

### Cards & lists

- Prefer the pattern: **Title** + **secondary line** (subtitle) + trailing actions.
- Secondary info should use `onSurfaceVariant`.
- Keep row heights consistent; avoid mixing 1-line and 3-line rows in the same list unless necessary.

### Dialogs

- Title: short noun phrase (“Edit employee”, “Change PIN”).
- Actions:
  - Primary on the right (“Save”)
  - Secondary on the left (“Cancel”)
- Destructive dialogs must state the consequence clearly and require confirmation.

### Forms & validation

- **Forms with Save button:** Validation state must update reliably on value change (dirty/touched), and errors should appear next to the field after interaction (on blur or submit).
- Validate on:
  - submit, and
  - on field blur (optional) for obvious constraints
- Show errors **next to the field** (not only as snackbars).
- Keep messages short and actionable:
  - Bad: “Invalid.”
  - Good: “End time must be after start time.”

#### Unsaved changes confirmation

- Any screen/dialog that edits data and can navigate away must track a dirty state.
- On navigation attempt (back, close dialog, switching selection e.g. schedule dropdown): if dirty → show a confirmation dialog.
- Dialog actions: Save / Discard / Cancel (Save continues navigation after successful save).
- If not dirty → no prompt.
- Text must be localizable (use l10n keys).

---

## Feedback & messaging (desktop-safe)

### Defaults

- Prefer **inline status text** (within the card/dialog) for:
  - “Saved”
  - validation errors
  - copy results
- Avoid feedback UI that overlaps content in dense layouts.

### Microcopy (English patterns)

- For localization: keep wording consistent across all languages; do not invent new terminology—reuse existing translation keys and the established glossary inside the project.
- Success: “Saved.” / “Copied.” / “Updated.”
- Blocking error: “Could not save: <reason>”
- Validation: “<Field> is required.” / “End time must be after start time.”

---

## Accessibility & input

- Ensure visible **focus** state for keyboard users.
- Minimum comfortable hit target: ~40dp for buttons where possible.
- Provide tooltips for icon-only actions.
- Avoid color-only meaning; add icons/text.

Quick manual checks:
- Navigate with `Tab` through the screen.
- Check that the focused element is always obvious.
- Try with Windows High Contrast mode.

---

## Theme wiring snippets (Light / Dark / High Contrast)

These snippets show the intended approach. Keep the seed color consistent (currently blue).

### ThemeData building block

```dart
ThemeData themeFromSeed({
  required Color seed,
  required Brightness brightness,
  bool highContrast = false,
}) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    visualDensity: VisualDensity.standard,
    // High contrast: rely primarily on stronger contrast + outlines.
    // Keep the implementation minimal; prefer widget-level semantics over hacks.
  );
}
```

### MaterialApp recommended configuration

```dart
MaterialApp(
  theme: themeFromSeed(seed: Colors.blue, brightness: Brightness.light),
  darkTheme: themeFromSeed(seed: Colors.blue, brightness: Brightness.dark),
  highContrastTheme: themeFromSeed(
    seed: Colors.blue,
    brightness: Brightness.light,
    highContrast: true,
  ),
  highContrastDarkTheme: themeFromSeed(
    seed: Colors.blue,
    brightness: Brightness.dark,
    highContrast: true,
  ),
  themeMode: ThemeMode.system,
);
```

---

## Checklist for new screens

- Uses the correct button hierarchy (Filled/Tonal/Outlined/Text).
- No hard-coded colors for repeated semantics; uses theme colors.
- Icon-only actions have tooltips and are recognizable.
- Errors are shown inline and are actionable.
- Works with keyboard navigation (focus visible).
- Looks acceptable in Light, Dark, and High Contrast.

