# UI/UX Style Guide (Desktop, Flutter Material 3)

This document is the **single source of truth** for UI/UX and visual decisions in this project.

Scope:
- **Included**: typography, iconography, color, spacing/layout, component usage, feedback/messaging, accessibility, imagery.
- **Excluded (for now)**: **Reports** (leave as-is). Do not treat Reports-only visuals (e.g. one-off palette choices) as the reference for **new** work elsewhere—global color rules in this guide still apply to new code outside Reports.

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

### Repeated semantics, scrims, and numeric cues

- **Repeated UI semantics** (e.g. error surfaces, barrier scrims, positive/negative values): derive from `ColorScheme` or a **single** shared semantic helper—not scattered `Colors.*` shades.
- **Dialog / modal barrier (scrim):** fixed light/dark opacities are acceptable **if** they stay consistent app-wide (one pattern per brightness). When changing overlays, keep scrim behavior aligned rather than inventing new opacities per screen.
- **Signed numeric data** (e.g. balances): **negative** → `colorScheme.error` (or appropriate on-error / container roles). **Positive** → use a **theme role** (e.g. `tertiary` or neutral `onSurface` with clear labels)—not ad-hoc “success green” unless it maps to a **defined** semantic token.
- **Success** color usage stays **rare**, per semantic rules above; do not blanket the UI in green.

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

- **Screen title**: 20–24, `w600`. **Canonical default for new screens:** `textTheme.titleLarge` with `fontWeight: FontWeight.w600`. Legacy screens may use another token in the same band (e.g. `headlineSmall`) until updated; avoid **unweighted** `titleLarge` as the primary screen title on dense admin-style pages when peer screens use `w600`.
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

- Use **Material Symbols** (`Symbols.*` from `material_symbols_icons`) consistently. Prefer a rounded look for coherence.
- For new code, avoid `Icons.*`; use `Symbols.*` instead.

### Sizes

- **18–20**: dense rows, secondary actions
- **24**: default (toolbars, primary icon buttons)

### Rules

- Icon-only actions must be **universally recognizable** (add/edit/delete/copy/close/arrow).
- Every `IconButton` must have a **tooltip** (desktop requirement).
- In **grouped toolbar or pill** controls (e.g. prev/next inside one surface), **`IconButton.filledTonal`** or compact-styled icon buttons are acceptable. Elsewhere, prefer a standard **`IconButton`** unless the same grouping applies.
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

### Desktop density

- The shipped theme uses **`VisualDensity.compact`** for a **dense but readable** desktop layout. New UI should assume compact density (tighter defaults); still honor **~40dp** comfortable targets for **primary** actions where the accessibility section applies.
- **Toolbar and filter strips** may use **denser** controls (e.g. compact `VisualDensity`, `shrinkWrap` tap targets) when controls are **grouped** in one row (e.g. date navigator pills).

### Page chrome and insets

- **Admin-style pages:** prefer one **title row** (title + optional trailing actions) and an optional **divider** beneath for vertical rhythm. Reuse the project’s **shared page header** pattern/widget when it fits; avoid ad-hoc title `Row` layouts on **new** pages unless layout truly requires it.
- **Outer page inset** for dense admin content may be **12dp** for the main lane. **Card and panel interior** padding remains **16dp** unless a **dense toolbar** row explicitly needs tighter padding.

### Content width

- On very wide viewports, **cap content width** so headers, filters, and the main column stay **one lane** (project default on the order of **~1600dp**). **Narrower caps** for specific flows are allowed—implement with **one reusable max-width constraint** (parameterized), not copy-pasted `LayoutBuilder` variants.

---

## Component usage rules (Material 3)

### Buttons

- **Primary action**: `FilledButton`
- **Secondary**: `FilledTonalButton` or `OutlinedButton`. **Rule of thumb:** **`OutlinedButton`** beside a primary `FilledButton` for a clear outlined secondary. **`FilledTonalButton`** when a second filled weight is needed without competing with the primary (e.g. dense cluster of actions).
- **Primary with icon:** `FilledButton.icon` is fine when the icon reinforces meaning (e.g. add, export). It remains the **primary** action in the hierarchy.
- **Tertiary / inline**: `TextButton`
- **Destructive**: keep style consistent, but use `colorScheme.error` for text/icon and require confirmation.

### Switches

- Use `Transform.scale(scale: 0.8)` for all Switch widgets.
- Prefer a **small shared wrapper** for new switches so scaling stays consistent as features grow.

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
- **Always prefer** showing errors next to the field (inline, near the relevant input). For other outcomes, follow **Feedback & messaging** (desktop priority below); use **`SnackBar`** only as a **fallback** when no appropriate surface exists or a global transient toast is truly least disruptive.
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

- On **desktop**, **`SnackBar` is a fallback, not the default** feedback pattern—it competes with dense layouts and reads mobile-first if overused.
- Prefer feedback **in this order**:
  1. **Inline** near the affected field, row, panel, or control.
  2. **Local status or message** inside the active card, dialog, or panel.
  3. **Banner / notice strip** for broader **non-blocking** messages still anchored to a visible region.
  4. **Confirmation or blocking dialog** when the user must decide or acknowledge an important outcome.
  5. **`SnackBar`** only when feedback **cannot** be placed in a relevant UI region **or** a **very short, global, transient** message is truly the least disruptive option.
- **Inline status text** (within the card/dialog) remains the right default for:
  - “Saved”
  - validation errors
  - copy results
- Avoid feedback UI that overlaps content in dense layouts.

### SnackBar (fallback only)

- When **`SnackBar`** is justified under the priority above, use the project’s **shared snackbar helper** so duration and colors stay consistent. **Early bootstrap** paths where messenger context is unreliable may use `SnackBar` directly—still use **theme-derived** colors, not one-off hard-coded snackbar colors.

### Loading, empty, and error states

- **Loading:** a centered **`CircularProgressIndicator`** (or equally minimal placeholder) is acceptable on desktop.
- **Error:** short explanation plus a **retry** (or equivalent) when the user can recover; avoid only a raw exception string with no next step.
- **Empty:** short hint plus **one primary action** when the obvious next step is to create something.

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

These snippets show the intended approach. Keep the seed color consistent (currently blue). **Authoritative wiring** (including divider and high-contrast input tweaks) lives in **`lib/app/theme/app_theme_builder.dart`**—if a snippet and that file disagree, **trust the implementation**.

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
    visualDensity: VisualDensity.compact, // dense desktop; matches production
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
- Feedback follows **desktop priority** (inline → local surface → banner → dialog); **`SnackBar`** only as a **fallback**; when `SnackBar` is used, prefer the **shared snackbar helper** for consistency.
- New **admin-style** pages follow **page chrome**, **inset**, and **content width** patterns above; reuse existing **shared header / filter / width** widgets when they fit the screen.

---

## Strict vs. flexible (for contributors)

**Stay strict**

- Theme-derived or centralized semantics for repeated colors; **tooltips** on icon-only actions; **button hierarchy**; **inline validation** preference; M3 + seed `ColorScheme` baseline; **canonical screen title** band and default mapping for new work.

**Explicitly flexible (for now)**

- Exact **corner radii** per surface until a small named scale exists in code.
- Specific **empty-state** illustration choice and exact copy.
- **Migration order** for legacy title rows or layouts that predate the chrome/width patterns.
- Fine-tuning **max content width** numbers as long as the single-lane, parameterized cap rule holds.

---

## Operational checklist (reviews and AI-assisted work)

**Subordinate summary only:** use this for **pre-flight** and **PR review**. **Normative detail** is in the sections above. **Theme implementation** is authoritative in **`lib/app/theme/app_theme_builder.dart`** if it differs from snippets here. Keep this subsection **brief** and **in sync** when rules above change. See also **Checklist for new screens** above.

### Quick gate

| Topic | Verify |
|--------|--------|
| **Screen title** | New screens: **20–24, w600** via **`textTheme.titleLarge` + `FontWeight.w600`**. Avoid unweighted `titleLarge` where peer titles use **w600**. |
| **Desktop density** | Assume **`VisualDensity.compact`**. **~40dp** comfortable targets for **primary** actions per **Accessibility & input**; **grouped** toolbar/filter rows may be denser. |
| **Page chrome** | Title row + optional trailing + optional divider; prefer the project **shared page header** when it fits—no ad-hoc title **`Row`** on **new** pages without a clear layout reason. |
| **Insets** | **Outer** content lane **12dp** OK for dense pages; **card/panel interior** **16dp** unless a dense toolbar needs less. |
| **Content width** | **Cap** very wide viewports (~**1600dp** default); narrower caps only via **one parameterized** max-width pattern, not duplicated layout logic. |
| **Buttons** | **Primary** `FilledButton` (incl. **`FilledButton.icon`** when the icon reinforces meaning). **Secondary:** **`OutlinedButton`** beside primary; **`FilledTonalButton`** for a second filled weight. **Tertiary** `TextButton`. **Destructive:** `colorScheme.error` + confirmation. |
| **Icons** | **`Symbols.*`** for new code; **18–20** / **24** sizes. **Every `IconButton` has a `tooltip`.** **`IconButton.filledTonal`** / compact styling only inside **grouped pill or toolbar** surfaces. |
| **Feedback** | Order: **inline → local surface → banner → dialog → `SnackBar` last**. If **`SnackBar`**: **shared snackbar helper**; bootstrap-only exception with **theme-derived** colors. |
| **Loading / empty / error** | Loading: centered **progress** OK. Error: **short text + retry** when recoverable. Empty: **hint + one primary** when create is obvious. |
| **Colors** | **`ColorScheme.fromSeed`** baseline; repeated semantics from **theme** or **one shared helper**. **Signed numbers:** negative → **error** roles; positive → **theme role** / defined token—not ad-hoc success green. **Scrim:** one consistent pattern per brightness if using fixed opacities. |
| **Forms / unsaved** | Errors **inline**; validation per **Forms & validation**. **Unsaved changes** dialog + **l10n**. |
| **Accessibility** | Visible **focus**; **hover** affordance on desktop; no **color-only** meaning; spot-check **Tab** and **High Contrast**. |
| **Scope** | **Reports** excluded from redesign—do not copy Reports-only palette choices into **new** work elsewhere; global color rules still apply outside Reports. |

### Acceptable local exceptions

- **Legacy** screen title token in the **same 20–24 / w600 band** (e.g. `headlineSmall`) until that screen is updated.
- **`SnackBar`** only when **Feedback & messaging** fallback criteria apply; **raw `SnackBar`** only when scaffold/helper context is unreliable (e.g. early bootstrap), still **theme-derived** colors.
- **Narrower max width** for a flow via a **parameterized** constraint, not a one-off duplicate widget tree.
- **Dense** controls in a **single grouped** toolbar or filter row.

### Before approving a UI change

- The change **matches this document** (no rules invented only in PR text).
- No new **scattered** color semantics; **destructive** paths and **light / dark / HC** remain acceptable.
- **Feedback** is not **SnackBar-first** where **inline / local / banner / dialog** would fit.
- **`Symbols.*`**, **tooltips** on icon-only actions, recognizable icons.
- Primary flow **keyboard**-reachable with **visible focus** where it matters.
- User-visible strings **localizable** (reuse keys / glossary per **Microcopy** above).

### Optional prompt snippet (Cursor)

```text
Follow docs/UI_UX_STYLE_GUIDE.md as the only UI authority (including the Operational checklist at the end).
Assume VisualDensity.compact; feedback order inline → local → banner → dialog → SnackBar (fallback only); theme-derived colors; Symbols.* + tooltips on icon-only; titleLarge + w600 for new screen titles; page chrome, 12 vs 16 insets, and capped content width per this guide.
Do not use Reports-only visuals as reference for new work outside Reports.
Task: <describe UI change>
```

**Flexible items** not repeated here—see **Strict vs. flexible** above.

