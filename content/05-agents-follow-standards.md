# Section 5 — Ensuring agents follow established standards

| [← Previous: Enhancing the test suite][previous-lesson] | [Next: Planning out modernization strategies →][next-lesson] |
|:--|--:|

Agent-driven development can produce code fast — and fast plus unstructured equals chaos. This section uses **agent skills**, plus issue and PR templates, to make sure every Copilot contribution follows the same hygiene a human contribution would: an issue, a branch, a templated PR, and a clean review surface.

## What you will learn

- Why standards (issues, PR templates, branch naming, PR descriptions) matter even more for agent-driven work than for human work.
- How to use Copilot to bootstrap your repo's `.github` standards files.
- What an agent skill is, how the CLI discovers skills with `/skills`, and how skills compose with instructions and custom agents.
- How to import the community `make-repo-contribution` skill so Copilot's contribution flow is enforced, not just suggested.

## Scenario

> [!NOTE]
> **Starting state**: your fork has the changes from [Sections 3–4][s03] merged or on a feature branch, with `.github/copilot-instructions.md` and scoped `.instructions` files from [Section 2][s02] in place. Both exercises **target the learner's fork only**.

You and the cloud agent have shipped real changes in the last two sections. Going forward, every change should flow through a tracked issue and a templated PR — even when Copilot is the one making the change.

## Tech overview: Why standards matter for agent work

Talking points:

- **Tracking**: issues are how teams reason about scope and progress. An agent that opens PRs without referencing issues is invisible to everyone except the person who launched it.
- **Reviewability**: PR templates force a description format that makes review fast. Without one, agent PRs tend to either over-describe ("here's everything I did") or under-describe ("updates").
- **Branch hygiene**: naming conventions (`fix/`, `feat/`, `chore/`) keep the branch list legible.
- **Where a skill helps**: skills can encode the "issue first → branch → PR → link issue → use template" sequence as a single deterministic capability, so the agent doesn't have to be re-prompted on hygiene every session.

## Exercise: Create issue and PR templates with Copilot

Talking points:

- **Goal**: bootstrap AssetTrack's `.github` standards so future contributions (agent or human) follow the same flow.
- **Files/areas touched**:
  - `.github/ISSUE_TEMPLATE/bug_report.yml`
  - `.github/ISSUE_TEMPLATE/feature_request.yml`
  - `.github/ISSUE_TEMPLATE/chore.yml`
  - `.github/PULL_REQUEST_TEMPLATE.md`
- **Steps**:
  - Have Copilot draft the issue templates as YAML forms with required fields (title prefix, summary, acceptance criteria, environment, repro steps where appropriate).
  - Have Copilot draft `PULL_REQUEST_TEMPLATE.md` with: linked issue, summary, change list, screenshots / before-after where UI is touched, test evidence, "do not merge" checklist.
  - Review and refine.
  - Commit locally (no push without your go-ahead).
- **How to verify**: file a test issue and a test PR on the fork (drafts are fine); the templates render correctly. Delete the test artifacts after.

## Tech overview: Agent skills and the `make-repo-contribution` pattern

Talking points:

- **What an agent skill is**: a packaged capability — a name, an instruction set, optional scripts and resources — that the agent can invoke when the task matches. Lives in `.copilot/skills/` (repo-scoped) or `~/.copilot/skills/` (user-scoped).
- **Skills vs. custom agents vs. instructions**:
  - Instructions = "what's true" (always loaded).
  - Skills = "what to do for this kind of task" (invoked when relevant).
  - Custom agents = "who I am for this kind of work" (persona + tool surface + scope).
- **Discovering skills**: `/skills` lists what's available; `/env` shows what's loaded.
- **Importing community skills**: like any dependency, review the source before adopting. Prefer first-party / well-known publishers; check what tools the skill calls and what files it reads/writes.
- **The `make-repo-contribution` skill**: encodes the standard contribution flow — file an issue, create a branch from main, make changes, push, open a PR with the right template, link the issue. When invoked, the agent walks this flow as a unit instead of improvising it each time.

## Exercise: Import `make-repo-contribution` and have Copilot make a contribution under the skill's rules

Talking points:

- **Goal**: prove the standards stick by running an end-to-end contribution that goes through issue → branch → templated PR, all enforced by the imported skill.
- **Files/areas touched**: `.copilot/skills/make-repo-contribution.md` (or wherever the skill is referenced from) — imported, not authored from scratch. The contribution itself touches one small piece of the codebase (any leftover doc gap from Section 2 is a good target).
- **Steps**:
  - Locate the `make-repo-contribution` skill and import it into the repo (or user-level — pick one and document the choice).
  - Run `/skills` and confirm it's listed.
  - Pick a small backlog item — a leftover doc gap from Section 2 is ideal because it doesn't require a behavior change.
  - Prompt Copilot to address it using the skill: "use `make-repo-contribution` to fix the README gap about the SQLite data path" (or similar).
  - Watch the agent: it should propose creating an issue first, then a branch, then a PR linked to the issue, using the templates from the previous exercise.
  - Approve each step; review the resulting PR.
- **How to verify**:
  - An issue exists on the fork referencing the gap.
  - A branch exists with a name matching the project convention.
  - A PR exists, links the issue, and uses the PR template.
  - The PR's diff is small and on-topic.

## Summary

You've now:

- Authored issue / PR templates with Copilot.
- Imported a community skill and confirmed it loaded.
- Run an end-to-end agent-driven contribution through the standards flow.
- Set the foundation for [Section 7][s07], where these standards get used at scale during the modernization capstone.

Next, you'll give Copilot **better signal** — LSP servers, MCP servers for documentation, and `/research` for citation-backed planning — in [Section 6][next-lesson].

## Resources

- [About agent skills][copilot-skills]
- [Configuring issue templates for your repository][issue-templates]
- [Creating a pull request template for your repository][pr-template]

---

| [← Previous: Enhancing the test suite][previous-lesson] | [Next: Planning out modernization strategies →][next-lesson] |
|:--|--:|

[previous-lesson]: ./04-enhancing-test-suite.md
[next-lesson]: ./06-modernization-strategies.md
[s02]: ./02-building-ai-infrastructure.md
[s03]: ./03-planning-and-accessibility.md
[s07]: ./07-bringing-it-all-together.md
[copilot-skills]: https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
[issue-templates]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository
[pr-template]: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository
