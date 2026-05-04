# Section 3 — Planning and performing accessibility updates

| [← Previous: Building an AI infrastructure][previous-lesson] | [Next: Enhancing the test suite →][next-lesson] |
|:--|--:|

The hard part of an agent-driven change isn't typing the prompt — it's bounding the work, getting the plan right, and parallelizing the parts that can run independently. This section uses an accessibility upgrade to AssetTrack as the forcing function for `/plan`, rubber-duck critique, a custom agent, and `/fleet`.

## What you will learn

- How to use `/plan` (and plan mode) to produce a written plan before any code changes.
- The rubber-duck pattern: have Copilot critique its own plan (or use a sub-agent to critique it) before execution.
- What custom agents are, how they differ from skills and instructions, and how to author one for a specific job.
- How `/fleet` runs subagents in parallel — when that helps, when it complicates review, and how to use it without losing track of the diff.

## Scenario

> [!NOTE]
> **Starting state**: clean fork of `legacy-app` with the docs and instructions from [Section 2][s02] in place. Both exercises **modify templates and JS** under a feature branch (e.g., `section-03-accessibility`). The legacy app should have realistic accessibility gaps for this section — if your fork doesn't, see the **author note** at the end before starting.

AssetTrack was built in 2016 on Bootstrap 3 + jQuery. It predates a lot of modern accessibility expectations: missing alt text, unlabeled inputs, weak landmarks, low-contrast badges, and inconsistent keyboard support. You'll plan and run the upgrade with Copilot, with tests authored alongside the changes.

## Tech overview: Planning and rubber-ducking a multi-step change

Talking points:

- **Why plan-first work matters for agents**: a written plan is the cheapest place to catch scope creep, missing files, or wrong assumptions. Once tools start running, course-correction gets expensive.
- **Two ways to get a plan**:
  - **Plan mode**: press `shift+tab` to toggle. Copilot asks clarifying questions and produces a plan without executing changes.
  - **`/plan` command**: explicitly invokes a planning agent for a specific task.
- **Anatomy of a good plan**: scope, file list, ordered steps, acceptance criteria, risks, rollback strategy. If the plan is vague or covers too much, that's a smell.
- **Rubber-duck critique**: have a second pass review the plan before you accept it. Two patterns:
  - Ask Copilot in the same session to critique the plan it just produced.
  - Spin up a separate agent (covered later in this section) whose job is critique.
- **When to iterate vs. start over**: when the plan keeps drifting, the prompt is wrong — start a fresh focused session rather than fighting with the existing one.

## Exercise: Use `/plan` to scope the AssetTrack accessibility upgrade

Talking points:

- **Goal**: produce a specific, bounded plan for the a11y upgrade before writing a line of code.
- **Files/areas touched**: none (planning only); the plan itself is captured as `docs/plans/accessibility.md` or the equivalent your project conventions prefer.
- **Steps**:
  - Toggle plan mode (or invoke `/plan`) and ask for an accessibility upgrade plan covering: dashboard, asset list, asset detail, asset create form, employee list.
  - Push back on vague plan items. Require: which files change, which selectors / templates are touched, what specific WCAG criteria are addressed (semantic landmarks, alt text, form labels, focus order, contrast, keyboard nav).
  - Have Copilot rubber-duck the plan: "what's missing?", "where is this likely to break the existing UI?", "what would you not change?"
  - Iterate until the plan is small enough to execute in a single review-able diff (or split into 2–3 clearly bounded waves).
- **How to verify**: the plan names specific files and specific changes per file; you could hand the plan to a teammate and they'd produce the same diff.

## Tech overview: Custom agents and `/fleet` for parallel subagents

Talking points:

- **What a custom agent is**: a configured persona of Copilot — a name, a description, an optional tool allowlist, and instructions that shape how it works on its scope. Lives in `.github/agents/` (repo-scoped) or `~/.copilot/agents/` (user-scoped). Invoked via `/agent`.
- **Custom agents vs. skills vs. instructions**:
  - Instructions = "what's true about this codebase."
  - Skills = "here's a deterministic capability the agent can call."
  - Custom agents = "here's a personality + scope + toolset for a recurring kind of work."
- **`/fleet` for parallel subagents**: spins up multiple agents at once on independent slices of work. Helpful when slices truly are independent; harmful when they aren't (the diffs will conflict and you'll fight merge issues).
- **Reviewing fleet output**: each subagent produces its own diff stream; review per-agent, then integrate.
- **When parallelism helps**: independent files, independent test files, or independent feature toggles. When it doesn't: cross-cutting refactors, shared template files, or anything where one agent's output is the other's input.

## Exercise: Build an `accessibility-updater` custom agent and run it under `/fleet` alongside test creation

Talking points:

- **Goal**: implement the a11y plan from the prior exercise using a custom agent, with tests authored in parallel via `/fleet`.
- **Files/areas touched**: a new agent definition in `.github/agents/accessibility-updater.md`; AssetTrack templates (`src/main/resources/templates/*.html`) and any shared JS (`src/main/resources/static/js/*.js`); new test files under `tests/playwright/accessibility/` and additional unit tests where appropriate.
- **Steps**:
  - Author `.github/agents/accessibility-updater.md` with: persona ("expert front-end accessibility engineer"), scope (only template + static JS + a11y test files), tool allowlist (file read/write, shell limited to test runners), and the rules to follow (WCAG-aligned changes only, keep current functionality, no styling rewrites beyond what a11y requires).
  - Run `/fleet` with two subagents:
    - **Subagent A**: the `accessibility-updater` agent applying the a11y plan to templates / JS.
    - **Subagent B**: a separate Copilot turn (or a second agent) authoring Playwright tests for the planned a11y behaviors and adding any missing unit tests for related controllers.
  - Review each subagent's diff independently before integrating.
- **How to verify**:
  - **A11y changes**: keyboard navigation works on dashboard, asset list, asset detail, asset create form; alt text present on images; form inputs have labels; landmarks (`main`, `nav`) present; contrast meets AA. Run `axe` (or equivalent) and check a Lighthouse a11y score.
  - **Tests**: new Playwright tests run; new unit tests run. They might fail at this point — that's fine; [Section 4][next-lesson] uses `/delegate` to flesh them out further.

## Summary

You've now:

- Used `/plan` to produce a written, bounded plan for a real cross-cutting change.
- Practiced rubber-duck critique before execution.
- Authored a custom agent and run a `/fleet` of subagents on independent slices of the work.
- Generated a diff that's small enough to review and a test scaffold ready to flesh out.

Next, you'll **delegate** the test work to the Copilot cloud agent in [Section 4][next-lesson] so you can keep working locally while the tests fill out asynchronously.

## Resources

- [Plan mode in Copilot CLI][copilot-plan]
- [About custom agents][copilot-agents]
- [WCAG 2.2 quick reference][wcag-quickref]
- [axe-core accessibility testing][axe-core]
- [Playwright accessibility testing guide][playwright-a11y]

## Author note: a11y gaps in `legacy-app`

This section's exercises assume `legacy-app` has realistic accessibility gaps for the agent to fix. If the upstream repo doesn't have them yet, file a small upstream PR (or a course-prep PR on the learner's fork) seeding gaps such as: missing alt text on the dashboard, unlabeled search inputs on the asset list, low-contrast Bootstrap badge variants, missing `<main>`/`<nav>` landmarks, and a non-keyboard-navigable asset create form. Document these gaps in `legacy-app/exercises.md` so the agent has discoverable context.

---

| [← Previous: Building an AI infrastructure][previous-lesson] | [Next: Enhancing the test suite →][next-lesson] |
|:--|--:|

[previous-lesson]: ./02-building-ai-infrastructure.md
[next-lesson]: ./04-enhancing-test-suite.md
[s02]: ./02-building-ai-infrastructure.md
[copilot-plan]: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli
[copilot-agents]: https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli
[wcag-quickref]: https://www.w3.org/WAI/WCAG22/quickref/
[axe-core]: https://github.com/dequelabs/axe-core
[playwright-a11y]: https://playwright.dev/docs/accessibility-testing
