# Section 7 — Bringing it all together to modernize AssetTrack

| [← Previous: Planning out modernization strategies][previous-lesson] | [Next: Wrap-up →][next-lesson] |
|:--|--:|

This is the capstone. You'll execute the modernization plan from [Section 6][s06], pulling in everything the course has taught: instructions files, custom agents, agent skills, MCP servers, plugins, `/plan`, and `/fleet`. The goal is not to ship a perfect production app — it's to prove you can run a real, multi-phase brownfield modernization with Copilot CLI as your primary surface.

## What you will learn

- What a Copilot **plugin** is and how it bundles skills, agents, instructions, and MCP servers for one-shot installation.
- How to orchestrate a phased modernization using `/plan` to scope waves and `/fleet` to parallelize independent ones.
- How custom skills act as deterministic primitives the agents can rely on (`run-tests`, `migrate-file`, etc.).
- How to validate UI behavior post-migration with the Playwright MCP server.

## Scenario

> [!NOTE]
> **Starting state**: the modernization research report from [Section 6][s06] is committed; LSP and docs MCP are configured; standards and `make-repo-contribution` skill from [Section 5][s05] are in place; instructions files from [Section 2][s02] are in place. This exercise **targets the learner's fork only**.

> [!IMPORTANT]
> **This capstone is intentionally large.** A full modernization to React + Bootstrap 5 + Spring 4 + Java 25 is a multi-week effort, not a single workshop session. The expectation is that the human author will scope the live-taught version of this section to **one feature end-to-end** (recommended: the asset list / asset detail flow) plus a written sketch of the rest of the plan. The section is structured so the same pattern scales to the full migration in a learner's own time.

You're now the modernization lead. AssetTrack has to go from jQuery + Bootstrap 3 + Spring 2.7 + Java 11 to React + Bootstrap 5 + Spring 4 + Java 25. The research is done; it's time to execute.

## Tech overview: Plugins for distributing the AI infrastructure

Talking points:

- **What a plugin bundles**: a curated set of skills, custom agents, instructions, and MCP server configurations — distributed as a unit. Solves the "everyone on the team needs the same setup" problem.
- **`/plugin` mechanics**: list, install, enable / disable, inspect what got loaded.
- **Where plugins live**: marketplaces (when available) and direct install from a repo or local path. Trust model is the same as skills and MCP — review before installing.
- **Authoring vs. consuming**: this section focuses on consuming. Authoring a plugin is a follow-on topic — the human author may add a brief sidebar.
- **The "modernization plugin" for AssetTrack**: either a real published plugin or a curated set of skills + agents + instructions + MCP configs the course bundles in its own repo. Either way, after install the learner has everything needed to run the migration.

## Exercise: Install the modernization plugin (or curated set) for AssetTrack

Talking points:

- **Goal**: with one command (or a small handful), bring in every piece of AI infrastructure the migration needs.
- **Files/areas touched**: depends on plugin distribution model — likely a `.copilot/` directory gains skill / agent / instructions files, and `mcp.json` gains the Playwright MCP server.
- **Steps**:
  - Run `/plugin` to see what's installable.
  - Install the modernization plugin (or apply the curated bundle).
  - Run `/env` to confirm: custom agents (e.g., `frontend-migrator`, `backend-migrator`, `test-author`), skills (`run-tests`, `migrate-file`, `make-repo-contribution` from [Section 5][s05]), instructions, and MCP servers (Playwright MCP plus the docs MCP from [Section 6][s06]) are all loaded.
- **How to verify**: `/env`, `/skills`, `/agents`, `/mcp` all reflect the expected components. A smoke prompt — "what migration tools do you have?" — surfaces them by name.

## Tech overview: Orchestrating the upgrade

Talking points:

- **Phasing with `/plan`**: break the migration into waves that each ship behind a PR. Suggested waves: (1) build / dependency / Java version baseline, (2) backend Spring upgrade per module, (3) frontend per page, (4) test backfill / Playwright validation, (5) cleanup. Each wave has clear acceptance criteria.
- **Parallelizing with `/fleet`**: independent waves (e.g., separate frontend pages, separate backend modules) run in parallel subagents. Dependent waves stay sequential.
- **Custom skills as deterministic primitives**: the agents shouldn't reinvent "run the tests" or "migrate this file's syntax" each time — those are skills with explicit inputs and outputs, called by the agents.
- **Playwright MCP for validation**: after each frontend wave, the agent drives a Playwright session via the MCP server to verify the page still works (load, key interactions, no console errors). This is the stand-in for a human smoke test.
- **Hygiene under load**: every wave goes through the `make-repo-contribution` skill from [Section 5][s05] — issue, branch, templated PR, link issue, review, merge. Even when `/fleet` is running multiple waves in parallel, each comes back as its own PR.

## Exercise (capstone): Modernize AssetTrack to React + Bootstrap 5 + Spring 4 + Java 25

Talking points:

- **Goal**: execute the modernization plan, end-to-end for one feature (live), with a written sketch of the rest. Test coverage materially higher at the end than the start.
- **Files/areas touched**: substantial — across `pom.xml`, Spring controllers / services / configuration, Thymeleaf templates → React components, static assets, scripts, tests. Scope down for the live demo.
- **Steps**:
  - Use `/plan` to break the migration into the waves described above; rubber-duck the plan.
  - **Wave 0 — baseline**: Java version, build, dependency baselines green on the fork.
  - **Wave 1 — backend**: Spring upgrade per module, executed by the `backend-migrator` agent. Tests added during the wave.
  - **Wave 2 — frontend**: jQuery + Thymeleaf → React + Bootstrap 5 per page, executed by the `frontend-migrator` agent. Use `/fleet` for independent pages.
  - **Wave 3 — validation**: Playwright MCP-driven validation of every migrated page. Failures feed back into the relevant agent for fix-ups.
  - **Wave 4 — cleanup**: remove dead code (jQuery, Bootstrap 3 assets, unused Spring 2.7 shims).
  - Every wave files an issue, opens a branch, opens a templated PR via `make-repo-contribution`, and is reviewed and merged before the next dependent wave starts.
- **How to verify**:
  - The modernized app boots on Java 25 and Spring 4.
  - The migrated feature(s) render in React and pass the Playwright suite via MCP.
  - Test coverage is materially higher than at the start of the course.
  - Every change merged through a templated PR linked to an issue.

## Summary

You've now:

- Installed the full AI infrastructure for the migration via `/plugin`.
- Planned and executed (at least one feature of) a real brownfield modernization using `/plan`, `/fleet`, custom agents, skills, MCP, and the contribution flow from [Section 5][s05].
- Validated UI behavior via the Playwright MCP server.
- Demonstrated the full course pattern end-to-end: instructions ground the agent, skills enforce hygiene, custom agents do the heavy lifting, MCP extends the tool surface, plugins distribute the whole setup, and plan + fleet orchestrate the work.

Wrap up the course in [Section 8][next-lesson].

## Resources

- [About plugins for Copilot CLI][copilot-plugins]
- [About agent skills][copilot-skills]
- [Custom agents in Copilot CLI][custom-agents]
- [Playwright MCP server][playwright-mcp]
- [GitHub MCP server][github-mcp-server]
- [Spring Framework 4 migration reference][spring-4]
- [Java 25 release notes][java-25]
- [React documentation][react]
- [Bootstrap 5 migration guide][bootstrap-5-migration]

---

| [← Previous: Planning out modernization strategies][previous-lesson] | [Next: Wrap-up →][next-lesson] |
|:--|--:|

[previous-lesson]: ./06-modernization-strategies.md
[next-lesson]: ./08-wrap-up.md
[s02]: ./02-building-ai-infrastructure.md
[s05]: ./05-agents-follow-standards.md
[s06]: ./06-modernization-strategies.md
[copilot-plugins]: https://docs.github.com/en/copilot/concepts/agents/about-copilot-plugins
[copilot-skills]: https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
[custom-agents]: https://docs.github.com/en/copilot/concepts/agents/about-custom-agents
[playwright-mcp]: https://github.com/microsoft/playwright-mcp
[github-mcp-server]: https://github.com/github/github-mcp-server
[spring-4]: https://docs.spring.io/spring-framework/reference/index.html
[java-25]: https://openjdk.org/projects/jdk/25/
[react]: https://react.dev/
[bootstrap-5-migration]: https://getbootstrap.com/docs/5.3/migration/
