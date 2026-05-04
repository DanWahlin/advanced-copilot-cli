# Section 6 — Planning out modernization strategies

| [← Previous: Ensuring agents follow established standards][previous-lesson] | [Next: Bringing it all together to modernize AssetTrack →][next-lesson] |
|:--|--:|

Modernizing a brownfield app is a research problem before it's a coding problem. This section gives Copilot the signal it needs to help you decide *how* to modernize — by configuring an LSP for structured code intelligence, registering MCP servers as documentation surfaces, and using `/research` to produce a citation-backed plan that becomes the input to [Section 7][next-lesson].

## What you will learn

- What an LSP buys Copilot beyond text grep, and how to configure `/lsp` for AssetTrack's Java + Python codebase.
- How MCP servers extend Copilot's tool surface — including using MCP servers as documentation sources for unfamiliar frameworks.
- What `/research` does, what good research prompts look like, and how to consume the resulting report.
- How to produce a phased modernization plan you'll execute in the capstone.

## Scenario

> [!NOTE]
> **Starting state**: standards from [Section 5][s05] in place. This section is **research-and-configuration only** — no production code changes. The output is a research report + an LSP / MCP configuration that the next section will rely on.

End-of-life pressure is mounting on AssetTrack's stack. Before doing the modernization, you need to know what the modern targets look like, what the migration paths are, and where the risk lives.

## Tech overview: Giving the agent better signal — LSP and MCP

Talking points:

- **What an LSP buys you**: structured code intelligence — go-to-definition, find-references, hover types, diagnostics — instead of relying on text search. Copilot CLI consumes LSP output to ground its code claims.
- **`/lsp` and the configuration files**:
  - User-level: `~/.copilot/lsp-config.json` (applies across all projects).
  - Repo-level: `.github/lsp.json` (applies to a specific project; checkable into source control).
  - LSP servers are **not bundled** — install separately.
- **Recommended servers for AssetTrack**:
  - `jdtls` (Eclipse JDT Language Server) for Java.
  - `pyright` or `python-lsp-server` for Python.
- **MCP recap (depth in [Section 7][next-lesson] for plugins)**:
  - Built-in GitHub MCP ships out of the box.
  - Custom MCP servers via `/mcp`. Configuration is repo-checkable.
  - **MCP as a documentation surface**: a docs MCP (e.g., a Context7 server, a Microsoft Learn server, a project's own docs MCP) gives the agent first-party documentation as a tool, instead of relying on web search or stale training data.
  - Trust model: review MCP server source like any dependency; prefer first-party / well-known publishers; scope what the agent can call.

## Exercise: Configure `/lsp` and register a documentation MCP server for AssetTrack

Talking points:

- **Goal**: give Copilot structured code intelligence on AssetTrack and a documentation surface for the modernization research that follows.
- **Files/areas touched**:
  - `.github/lsp.json` (new, repo-level — preferred for a course / shared repo) **or** `~/.copilot/lsp-config.json` (user-level).
  - `.copilot/mcp.json` (or wherever the CLI expects MCP config — confirm with the docs in [Resources](#resources) for your CLI version).
- **Steps**:
  - Install `jdtls` and `pyright` (or `python-lsp-server`) per your platform.
  - Configure the LSP file with both servers, mapping `.java` → `java` (jdtls) and `.py` → `python` (pyright/pylsp).
  - Run `/lsp` to confirm both servers are registered and healthy.
  - Add a documentation-oriented MCP server. Pick one (the human author can finalize): a Context7-style server, a Microsoft Learn server, or another that matches the modernization targets (React, Spring 4, Java 25). Run `/mcp` to confirm.
  - Spot-check by asking Copilot to look up a Spring 4 / Java 25 / React API symbol via the new sources, then to find an AssetTrack symbol via the LSP rather than via grep.
- **How to verify**:
  - `/lsp` shows two servers; `/mcp` shows the new docs server (in addition to the built-in GitHub MCP).
  - Copilot reports symbol locations and types from the LSP, citing line numbers / files precisely.
  - Copilot's modern-framework answers cite the docs MCP, not just web search.

## Tech overview: `/research` for modernization planning

Talking points:

- **What `/research` is for**: deep, multi-source investigation that produces a citation-backed report. Use it for decisions you need to defend — modernization targets, framework comparisons, migration strategy.
- **Anatomy of a good research prompt**: a specific question, the decision criteria, the constraints (org policy, team skill, deadline tolerance), and the sources to prefer.
- **Anatomy of a bad research prompt**: "what's the best way to modernize this app?" — too vague, no constraints, no decision criteria, the agent will drift.
- **How to consume the report**: treat it as input to your own decision, not as the decision. Verify cited sources, push back on weak claims, ask follow-ups.

## Exercise: Use `/research` to evaluate AssetTrack's modernization path

Talking points:

- **Goal**: produce a research report you can defend, covering the four modernization decisions AssetTrack needs to make.
- **Files/areas touched**: `docs/research/modernization.md` (new) — the committed report.
- **Steps**:
  - Run `/research` with a prompt that names: (a) frontend (jQuery + Bootstrap 3 → React + Bootstrap 5), (b) backend (Spring 2.7 / Java 11 → Spring 4 / Java 25), (c) data layer migration plan (SQLite → ?, or staying), (d) test / CI strategy.
  - For each decision, require: options considered, recommendation with rationale, risks, migration phases, rough effort.
  - Iterate on the report; ask Copilot to deepen any section that's thin.
  - Commit the report locally (no push without your go-ahead).
- **How to verify**:
  - The report cites real, current sources for each recommendation.
  - Each section names the decision criteria and identifies the trade-offs.
  - The phased plan in the report is detailed enough that you could hand it to a teammate and they'd know where to start.
  - The report becomes the explicit input to [Section 7][next-lesson].

## Summary

You've now:

- Configured an LSP for Java + Python so Copilot has structured code intelligence on AssetTrack.
- Registered a documentation MCP server so Copilot has first-party docs as a tool, not just training data.
- Produced a citation-backed modernization research report.

Next, you'll **execute** the modernization — using plugins to install the AI infrastructure in one shot, then running the migration with custom agents, skills, MCP, plan, and `/fleet` — in [Section 7][next-lesson].

## Resources

- [Configuring LSP servers for Copilot CLI][lsp-config]
- [Model Context Protocol introduction][mcp-intro]
- [GitHub MCP server][github-mcp-server]
- [MCP registry][mcp-registry]
- [Eclipse JDT Language Server (`jdtls`)][jdtls]
- [Pyright][pyright]
- [Python LSP Server (`python-lsp-server`)][pylsp]
- [Spring Framework 4 reference][spring-4]
- [Java 25 release notes][java-25]
- [React documentation][react]

---

| [← Previous: Ensuring agents follow established standards][previous-lesson] | [Next: Bringing it all together to modernize AssetTrack →][next-lesson] |
|:--|--:|

[previous-lesson]: ./05-agents-follow-standards.md
[next-lesson]: ./07-bringing-it-all-together.md
[s05]: ./05-agents-follow-standards.md
[lsp-config]: https://github.com/github/copilot-cli#-configuring-lsp-servers
[mcp-intro]: https://modelcontextprotocol.io/introduction
[github-mcp-server]: https://github.com/github/github-mcp-server
[mcp-registry]: https://github.com/mcp
[jdtls]: https://github.com/eclipse-jdtls/eclipse.jdt.ls
[pyright]: https://github.com/microsoft/pyright
[pylsp]: https://github.com/python-lsp/python-lsp-server
[spring-4]: https://docs.spring.io/spring-framework/reference/index.html
[java-25]: https://openjdk.org/projects/jdk/25/
[react]: https://react.dev/
