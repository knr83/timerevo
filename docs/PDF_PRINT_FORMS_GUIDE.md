
# PDF Print Forms Guide

This document defines the **PDF print forms rules** for the Timerevo Flutter codebase. It is the single source of truth for page structure, typography, tables, formatting, file naming, and privacy constraints for printable/exportable PDF documents.

---

## Scope

A print form in Timerevo is a **PDF document** that:

- is generated on user request
- is saved or printed by the user
- uses a consistent visual structure across document types
- is **not retained by the app** after export; the user chooses the save location

This guide defines the shared PDF rules only. It does **not** define the content of each specific form.

---

## Alignment with Other Guides

This guide must remain aligned with:

- [ARCHITECTURE_BOUNDARIES_GUIDE.md](ARCHITECTURE_BOUNDARIES_GUIDE.md) — PDF generation must respect project layering and boundaries
- [LOCALIZATION_GUIDE.md](LOCALIZATION_GUIDE.md) — all user-facing strings must use l10n
- [SECURITY_PRIVACY_GUIDE.md](SECURITY_PRIVACY_GUIDE.md) — PDF export may contain PII when justified by workflow, but privacy rules still apply
- [OBSERVABILITY_DIAGNOSTICS_GUIDE.md](OBSERVABILITY_DIAGNOSTICS_GUIDE.md) — PDF content must not be included in diagnostics or logs

If a conflict appears, project-wide security, privacy, and architecture rules take precedence.

---

## 1. Core Principles

- **Consistent frame** — all PDFs use the same page structure: header, title block, content area, footer
- **Minimal data** — do not include internal/technical/service data by default
- **DST-safe date boundaries** — day and period queries must use local day boundaries converted to UTC milliseconds, using the same persistence rules as the rest of the app
- **Layered design** — UI triggers export via domain/use cases; shared PDF generation lives in a reusable module under `lib/core/pdf/` (export orchestration may live in `lib/common/pdf/` or feature code where Flutter I/O is required)
- **Good enough over complexity** — optional PDF metadata is allowed only when it is easy and stable to support

---

## 2. Page Structure

### 2.1 Header

The header is a **page frame element**, not content.

Default header:

- left: app icon + `Timerevo`

Rules:

- do not place `Document ID`, `Generated`, timestamps, or similar technical metadata in the header
- do not treat the header as part of the document body
- keep header identical or near-identical across form types

### 2.2 Title Block

The title block appears at the top of the content area.

Structure:

- **Title** — one line, primary visual heading
- **Subtitle** — optional, one line, always directly below the title

Rules:

- subtitle is optional, but if present it must remain visually subordinate to the title
- do not overload the title block with extra metadata or decorative elements

### 2.3 Context Block

The context block is optional.

Use it only when the document would lose meaning without compact contextual data such as:

- selected period
- employee label
- department/team label
- report mode/type

Rules:

- default: absent
- render as compact `label: value` pairs
- use one or two columns depending on available width
- do not add a context block “for symmetry” if it does not add real value

### 2.4 Content Area

The content area contains the actual document payload:

- tables
- text sections
- summaries
- charts/diagrams, if explicitly needed

Rules:

- avoid empty decorative containers
- avoid filler sections with no business meaning
- prioritize readability and scan speed over ornament

### 2.5 Footer

Default footer:

- left: generation timestamp in `YYYY-MM-DD HH:mm` format, without label
- right: `Page X / Y`

Rules:

- do not repeat the Timerevo brand in the footer
- keep footer compact and page-frame oriented
- page numbering must remain visible on every page
- do not add extra footer metadata unless explicitly required by a specific form

---

## 3. Page Format, Typography, and Layout

### 3.1 Page Format

Default:

- **A4 Portrait**

Rules:

- margins: approximately **15 mm** on all sides
- landscape is allowed only when a specific document requires it
- landscape is an exception, not a default

### 3.2 Text Hierarchy

Use three visual hierarchy levels:

- **Title**
- **Subtitle / section headers**
- **Body / table text**

Rules:

- keep the hierarchy consistent across all forms
- avoid introducing extra heading levels unless a specific document genuinely needs them

### 3.3 Alignment

Rules:

- text values: left-aligned
- numbers, times, durations: right-aligned
- empty values: render as `—`

### 3.4 Long Values

Rules:

- in tables, use single-line ellipsis by default
- wrapping is allowed only for columns where it is explicitly needed for readability
- do not enable uncontrolled wrapping across the whole table

---

## 4. Tables

### 4.1 Table Styling

Default table rules:

- header row is always present
- horizontal separators only by default
- vertical lines only when the table becomes hard to read without them
- light zebra striping is allowed for scanability

### 4.2 Empty Values

Rules:

- never render empty cells as blank when a placeholder is expected
- use `—` consistently

### 4.3 Pagination

Rules:

- tables must continue correctly across pages
- the header row must repeat on each new page
- page footer numbering must remain intact on all pages
- avoid layouts that break rows unpredictably or lose column context after page breaks

### 4.4 Total Row

Rules:

- total rows are optional
- include them only when the document semantics justify them
- do not add totals as a universal pattern to every table

---

## 5. Data Formatting

### 5.1 Date and Time

Default formats:

- **Date**: `YYYY-MM-DD`
- **DateTime**: `YYYY-MM-DD HH:mm`

Examples:

- `2026-02-28`
- `2026-02-28 17:35`

Rules:

- use 24-hour time only
- keep formatting consistent within a single PDF
- date/time query boundaries must follow the project’s DST-safe local-day-to-UTC approach

### 5.2 Durations

Rules:

- durations must use the project l10n duration pattern
- do not format durations as if they were time-of-day values
- within one PDF, use one duration style consistently

### 5.3 Balance / Delta

If a document includes balance or delta values:

- do not show a plus sign for positive values
- negative values: show minus sign and red text
- zero: neutral text styling

---

## 6. Localization

The language of the PDF must match the **current app locale**.

Rules:

- all user-facing strings must go through l10n
- do not hard-code translatable user strings
- exception: `—` remains a fixed symbol
- fallback when a key is missing: **EN**
- do not build phrases via string concatenation; use full l10n keys and placeholders

This follows the same localization constraints as the rest of the app.

---

## 7. File Naming and PDF Metadata

### 7.1 File Naming

Default separator:

- `_`

Privacy rule:

- do **not** include employee name in the file name by default, to avoid unnecessary PII in the filesystem

Rules:

- timestamp is mandatory
- file names must be predictable and consistent

Recommended patterns:

For a single date:

- `timerevo_<document_type>_<yyyy-mm-dd>_<hhmm>.pdf`

For a date range:

- `timerevo_<document_type>_<from>_to_<to>_<yyyy-mm-dd>_<hhmm>.pdf`

### 7.2 PDF Metadata

Optional only if easy and stable to support with the chosen PDF library.

Recommended values:

- `Title` = localized document title
- `Author` = `Timerevo`
- `Subject` = localized document type

Rule:

- if metadata support is awkward, fragile, or library-dependent, skip it

---

## 8. Privacy and Access Rules

### 8.1 Content Minimization

Do not include the following in PDFs by default:

- internal identifiers such as `employeeId`, `sessionId`
- update reason / audit trail
- technical service data

Notes are **not** a universal rule. Whether they are included depends on the specific print form.

### 8.2 Role-Based Access

Access rules:

- **Admin** — may export any data the app exposes for export
- **Employee** — may export only their own data in self-service flows

Access enforcement must happen at the export entry point, not only in UI visibility.

### 8.3 Logging and Diagnostics

Rules:

- PDF content must never be written to logs
- diagnostics export must not include PDF files
- logs/diagnostics must not contain PDF content, names, notes, or reasons extracted from PDFs

---

## 9. Architecture and Reusable Components

PDF generation must respect project boundaries:

- UI triggers export via domain/use cases
- shared PDF rendering lives in reusable shared code
- do not couple PDF generation directly to UI widgets or data-layer internals

Recommended shared structure under `core/pdf/`:

- `PdfPageFrame` — header, footer, margins
- `PdfTitleBlock` — title + subtitle
- `PdfTextStyles` — shared text styles and font wiring
- `PdfTableBuilder` — header row, zebra rows, right alignment, empty placeholder, pagination-friendly table rendering

Recommended helpers:

- `formatDate`
- `formatDateTime`
- `formatDuration`
- `formatBalance`
- file naming helper for rules in section 7

Rules:

- keep PDF helpers reusable
- avoid copy-paste document-specific layout code when a shared component can cover the case
- do not introduce `data/` dependencies into UI-facing PDF code paths

---

## 10. Anti-Patterns

| Anti-Pattern | Why It's Bad | Preferred Alternative |
|-------------|--------------|------------------------|
| Putting generated timestamp or document ID into the header frame | Pollutes the global page frame and reduces consistency | Keep header minimal; place necessary context only in body/context block |
| Including employee name in file names by default | Unnecessary PII in filesystem | Use document type + date/range + timestamp |
| Rendering empty table values as blank | Creates ambiguity and inconsistent scanning | Use `—` |
| Treating durations as time-of-day | Semantically wrong and confusing | Use localized duration formatting |
| Hard-coding PDF strings | Breaks localization consistency | Use l10n keys and placeholders |
| UI directly building PDF from data-layer objects | Violates architecture boundaries | Export via domain/use case + shared `core/pdf/` module |
| Logging document content or PDF-derived PII | Violates privacy/diagnostics rules | Log event codes only, without content |
| Adding context blocks to every form by default | Creates visual noise | Add only when meaningfully required |
| Using vertical borders in every table | Makes tables visually heavy | Default to horizontal separators only |
| Using landscape as a default | Breaks consistency and print expectations | Use A4 portrait unless a specific form requires landscape |

---

## 11. PR Checklist

Before merging PDF print form changes:

- [ ] PDF generation follows project layering and does not introduce forbidden UI → data dependencies
- [ ] Shared PDF code lives in reusable `core/pdf/` components/helpers where applicable
- [ ] Header, title block, content area, and footer follow the standard page frame
- [ ] Footer uses `Page X / Y`
- [ ] A4 portrait is used by default; landscape is justified by document needs
- [ ] Tables repeat header rows on new pages
- [ ] Empty values render as `—`
- [ ] Dates/times/durations use the approved formatting rules
- [ ] All user-facing strings use l10n; no hard-coded translatable strings
- [ ] File naming follows the standard pattern and does not include employee name by default
- [ ] No internal IDs, audit trail, or service data are included by default
- [ ] Export access rules are enforced at the export entry point
- [ ] PDF content is not logged and is not included in diagnostics export
- [ ] `flutter analyze` passes