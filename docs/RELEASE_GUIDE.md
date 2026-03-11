# Timerevo Release Guide

This guide defines the standard release workflow for Timerevo and the required format for GitHub Release notes.

## Goal

Each release must be:

- factually accurate
- based on real changes only
- consistent in structure and tone
- focused on user-visible improvements
- free of vague filler and speculative wording

## Source of truth

When preparing a release, use only:

- git diff between the previous tag and the new tag
- commit history between these refs
- actual code changes in the repository
- current project state and current product scope

Do not rely on outdated README text or assumptions.

## Versioning

Timerevo uses the following release version format:

    vYYYY.M.P

Example:

    v2026.3.0

Rules:
- `YYYY` = release year
- `M` = release month
- `P` = sequential release number within that month

Examples:
- `v2026.3.0` = first release in March 2026
- `v2026.3.1` = second release in March 2026
- `v2026.4.0` = first release in April 2026

When a new month starts, reset the last segment to `0`.

This format must be used consistently for:
- Git tags
- GitHub Releases
- release notes headings
- release artifact names

## Release artifact naming

Release artifacts must use the same version string as the tag and release.

Recommended naming pattern:

    timerevo-<version>-<platform>.<ext>

Examples:

    timerevo-v2026.3.0-win64.zip
    timerevo-v2026.3.0-linux-x64.tar.gz
    timerevo-v2026.3.0-macos-universal.zip

Rules:
- always include the full release version
- always include the platform identifier
- keep naming predictable and consistent across releases
- use the real packaging format produced by the build pipeline

## Release workflow

### 1. Confirm version
Read the current version from the project source of truth and ensure it matches the required format:

    vYYYY.M.P

### 2. Identify release scope
Compare:
- previous tag
- current release commit / HEAD

Review:
- changed files
- commit messages
- user-visible changes
- important technical changes worth mentioning publicly

### 3. Filter changes
Keep only changes that are relevant for release notes.

Prioritize:
- new user-visible functionality
- UX improvements
- fixes affecting real usage
- reporting/export changes
- stability improvements with visible user impact

Low-level internal refactors should usually be omitted unless they materially improve reliability or maintainability in a meaningful way.

### 4. Apply product constraints
Do not present unfinished or internal-only features as available.

Hard exclusions for Timerevo:
- do not describe NFC authentication as a working feature unless fully implemented and verified
- do not describe Dashboard/Home as available if it is not reachable in the UI
- do not present planned functionality as released

### 5. Write release notes
Use the exact release note structure defined below.

### 6. Create GitHub Release
Attach the release artifact(s) generated for the current release.

Artifact names must follow the naming rules defined above.

## Tone requirements

Release notes must be:

- concise
- factual
- product-focused
- professional
- clean and readable

Avoid:
- marketing fluff
- vague filler
- exaggerated claims
- internal commentary
- future plans
- placeholders

Do not write:
- various improvements
- minor fixes
- bug fixes and enhancements
- many small changes
- general cleanup

If the release is small, say so clearly and keep it short.

## Required release notes format

Use exactly this structure:

## Timerevo <version>

Desktop time tracking for small teams — fully offline, local-first, and built for simple daily clock-in and clock-out.

### Highlights
- ...
- ...
- ...

### Installation
1. Download the asset for your platform from this release
2. Extract it to any folder
3. Run Timerevo

### Notes
- Available for Windows, Linux, and macOS
- Release assets are platform-specific
- Data is stored locally on the machine

## Rules for "Highlights"

- 3 to 6 bullet points maximum
- prefer user-visible changes
- combine small related changes into one meaningful bullet
- mention technical changes only if they significantly affect usability, reliability, or release quality
- use polished release-quality wording, not raw commit style

Examples of acceptable wording:
- Improved employee management workflow and related form handling
- Added PDF export for ...
- Refined schedule configuration for ...
- Improved reliability of ...
- Updated ... behavior for ...

Examples of unacceptable wording:
- fixed stuff
- misc improvements
- refactor
- cleanup
- updated code
- bug fixes and enhancements

## Validation checklist before publishing

Before creating a GitHub Release, verify:

- version is correct and follows `vYYYY.M.P`
- release tag is correct
- release assets exist
- artifact names follow the naming convention
- release notes mention only real changes
- no unfinished features are presented as complete
- wording matches current product scope
- installation section is platform-neutral and accurate

## Optional working mode for Cursor

If asked to prepare release notes, Cursor should work in this sequence:

1. inspect git diff between previous and current refs
2. list the most release-worthy changes
3. filter out noise and internal-only details
4. write final release notes in the required format
5. output only the final Markdown unless asked otherwise