# Repository conventions for AI agents

This file gives Copilot (and other agents) the conventions to follow when working in this repo.

## Markdown

- **Never hard-wrap paragraphs.** Keep each paragraph, list item, and blockquote on a single line. Let the editor soft-wrap. This applies to every `.md` file in the repo, including this one. Line breaks are reserved for actual structural breaks (between paragraphs, list items, headings, code fences, table rows, etc.).
- Use **reference-style links** throughout (`[text][ref]` with `[ref]: url` defined at the bottom of the file).
- Section README nav tables have **no header row** — a single two-cell row with `:--|--:` alignment so the back link is left-aligned and the forward link right-aligned.
- Preserve GitHub admonition syntax. The `[!NOTE]` / `[!IMPORTANT]` / `[!TIP]` / `[!WARNING]` / `[!CAUTION]` marker must be on its own `>`-prefixed line, with the body on subsequent `>`-prefixed lines.

## Course content

- This repo is a **skeleton**. Section READMEs contain talking points only — bullet outlines, not full prose. A human author fills in the actual content later. Don't expand talking points into full content unless asked.
- Each section README follows the same template: top nav table → H1 → intro → `## What you will learn` → `## Scenario` (with a "Starting state" callout) → one or more `## Tech overview` + `## Exercise` pairs → `## Summary` → `## Resources` → bottom nav table → reference-link footer.
- Every exercise's talking points include **Goal**, **Files/areas touched**, **Steps**, and **How to verify**.
- Tech overview and Exercise headings should have **bespoke titles** — never generic "Tech overview 1".

## Scope discipline

- The course is built around the legacy app at [`geektrainer/legacy-app`](https://github.com/geektrainer/legacy-app). Verify file paths and existing features against that repo before writing exercise instructions — don't assume.
- Keep the legacy app on Spring Boot 2.7 / Java 11 throughout the course. The Spring Boot 3 work is a **planning agent**, not a migration.
- Don't consume the same seeded bug in two different sections.
