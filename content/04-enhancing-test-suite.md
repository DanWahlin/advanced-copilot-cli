# Section 4 — Enhancing the test suite

| [← Previous: Planning and performing accessibility updates][previous-lesson] | [Next: Ensuring agents follow established standards →][next-lesson] |
|:--|--:|

Some work has clearly defined success and bounded scope — perfect for delegation. Test authoring is the canonical example. This section uses `/delegate` to push test work to the Copilot cloud agent so you can keep moving locally while the tests fill out asynchronously.

## What you will learn

- The synchronous-vs-asynchronous trade-off between Copilot CLI and the Copilot cloud agent.
- What makes a delegation prompt actually work — and what makes it fail silently.
- How `/delegate` hands a session off to the cloud, what state travels with it, and what you get back.
- How to review and course-correct the resulting PR.

## Scenario

> [!NOTE]
> **Starting state**: your fork has the a11y changes from [Section 3][s03] on a feature branch (or merged), with the test scaffold present but incomplete. Both exercises **target the learner's fork only** — the cloud agent will open a PR there.

You shipped the a11y changes in Section 3 with a test scaffold that's not yet complete. Rather than spend a CLI session typing tests by hand, you'll author one good delegation brief and let the cloud agent fill out the suite while you move on to other work.

## Tech overview: When to delegate to the Copilot cloud agent

Talking points:

- **Same harness, different surface**: the cloud agent is the asynchronous version of what's running in your terminal. It runs on a hosted runner, opens a branch, makes commits, and opens a PR.
- **When delegation pays off**:
  - Scope is clearly bounded ("write tests for these N files").
  - Acceptance criteria are objective (CI passes, coverage exceeds X, specific behaviors are exercised).
  - You don't need to be in the loop turn-by-turn.
- **When delegation hurts**:
  - The work needs your judgment at each step (architecture decisions, ambiguous requirements).
  - The scope is fuzzy ("improve the codebase").
  - The agent needs context only available locally (un-committed changes, your shell history).
- **What good delegation prompts look like**:
  - Specific files / scope.
  - Explicit acceptance criteria.
  - "Do not" rules where they matter.
  - References to existing patterns (e.g., "match the test style in `AssetServiceTest.java`").
  - Output expectations (a PR title, a description format, label).
- **What bad delegation prompts look like**:
  - Vague verbs ("improve", "enhance", "modernize").
  - No success criteria.
  - No constraint on what *not* to touch.

## Exercise: Author a delegation prompt for the AssetTrack test backlog

Talking points:

- **Goal**: write a delegation brief specific enough that the cloud agent can succeed without further input.
- **Files/areas touched**: `docs/delegations/test-suite-enhancement.md` (or the equivalent your project conventions prefer) — the brief itself. Useful as both input to `/delegate` and as a reviewable artifact.
- **Steps**:
  - List the test gaps to close: the Playwright a11y tests scaffolded in Section 3, unit-test gaps in `AssetService` / `AssignmentService`, integration tests for controllers if missing.
  - For each gap, state the acceptance criteria: what behavior must be covered, what edge cases must be exercised, what coverage threshold (if any) the PR must hit.
  - Add "do not" rules: don't change production code; don't add new dependencies; don't change existing test conventions; if a test reveals a real bug, file a follow-up issue rather than fixing it inline.
  - Reference existing patterns: point at one or two existing test files that represent the style to match.
  - State the output expectations: PR title prefix, label (`tests`), one PR per logical chunk if the work splits naturally.
- **How to verify**: walk the brief against a checklist (scope, acceptance criteria, constraints, references, output) — every box should be checkable.

## Tech overview: `/delegate` mechanics and review

Talking points:

- **What `/delegate` does**: hands the current session (prompt, conversation, context) to the Copilot cloud agent, which runs on a hosted runner, makes a branch on the configured repo (your fork in this course), and opens a PR.
- **What state travels**: prompt, conversation history, references to repo state. Local uncommitted changes do not — make sure anything required is committed and pushed first.
- **While it runs**: you can keep working locally on a different branch / different scope.
- **Reviewing the PR**:
  - Use `/pr` from the CLI to inspect status and diffs.
  - Use the `/review` agent to walk the PR with Copilot help.
  - Or review the PR on github.com directly.
- **Course-correcting**: leave PR comments to redirect the agent. The cloud agent reads PR comments and iterates.
- **When to abandon a delegation**: if the agent has spun for two iterations and the work isn't converging, close the PR and either re-scope the brief or do the work locally.

## Exercise: Use `/delegate` to push the test work to the cloud and review the PR

Talking points:

- **Goal**: hand the test brief to the cloud agent, keep working locally, and merge the resulting PR after review.
- **Files/areas touched**: none locally during delegation; new test files created on the cloud agent's branch, integrated via PR merge to your fork only.
- **Steps**:
  - Confirm your fork has the latest committed state (the brief from the previous exercise; the Section 3 a11y changes and test scaffold).
  - Run `/delegate` with the brief from the previous exercise.
  - While the cloud agent works, do something else useful in the CLI — for example, start sketching the standards work in [Section 5][next-lesson].
  - When the PR opens, review with `/pr` + `/review`. If something's off, comment on the PR and let the cloud agent iterate.
  - Merge the PR once it's green and the diff matches your expectations.
- **How to verify**:
  - PR exists on the learner's fork (not upstream).
  - CI is green.
  - The new tests cover what the brief said they would.
  - No production code was changed (per the brief's "do not" rules).

## Summary

You've now:

- Authored a real delegation brief with explicit scope and acceptance criteria.
- Used `/delegate` to push work to the Copilot cloud agent.
- Reviewed and course-corrected a PR opened by an agent.
- Internalized the local-vs-cloud trade-off — you'll reach for `/delegate` again in [Section 7][s07].

Next, you'll **enforce standards** so future agent work flows through issues, branches, and PRs automatically — using agent skills and the `make-repo-contribution` skill in [Section 5][next-lesson].

## Resources

- [Using Copilot agents (overview)][copilot-agents]
- [About Copilot coding agent (cloud agent)][cloud-agent]
- [Best practices for writing prompts][copilot-prompting]
- [JUnit 5 documentation][junit-5]
- [Playwright test documentation][playwright]

---

| [← Previous: Planning and performing accessibility updates][previous-lesson] | [Next: Ensuring agents follow established standards →][next-lesson] |
|:--|--:|

[previous-lesson]: ./03-planning-and-accessibility.md
[next-lesson]: ./05-agents-follow-standards.md
[s03]: ./03-planning-and-accessibility.md
[s07]: ./07-bringing-it-all-together.md
[copilot-agents]: https://docs.github.com/en/copilot/concepts/agents
[cloud-agent]: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent
[copilot-prompting]: https://docs.github.com/en/copilot/get-started/best-practices
[junit-5]: https://junit.org/junit5/docs/current/user-guide/
[playwright]: https://playwright.dev/docs/intro
