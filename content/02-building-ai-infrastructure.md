# Section 2 — Building an AI infrastructure

| [← Previous: Working with Copilot CLI][previous-lesson] | [Next: Planning and performing accessibility updates →][next-lesson] |
|:--|--:|

A productive Copilot CLI session starts with the agent already knowing the basics about your project. That doesn't happen by accident — you build it. This section uses Copilot to explore AssetTrack, fill the documentation gaps, generate `copilot-instructions.md` with `/init`, and add path-scoped `.instructions` files for the messy areas.

## What you will learn

- How to use a Copilot CLI session as an exploration tool against a brownfield repo.
- How to turn that exploration into committed documentation that the agent (and humans) will use later.
- The full Copilot CLI instruction landscape and how the CLI combines instruction sources.
- How `/init` seeds `copilot-instructions.md` and when to re-run it.
- How to write path-scoped `.github/instructions/*.instructions.md` files for areas that need different rules than the rest of the repo.
- How **Copilot Memory** complements instructions files (concept only — auto-deduced, repo-scoped, time-bounded).

## Scenario

> [!NOTE]
> **Starting state**: clean fork of `legacy-app`. **Implementation exercises** — you'll add new docs and instructions files but won't change Java or Python source. Files added here are used by every later section.

You watched Copilot rediscover AssetTrack from scratch in [Section 1][previous-lesson]. That's wasteful. Now you'll write down what Copilot needs to know about AssetTrack — the stack, the conventions, the do/don't rules, the unenforced business invariants — so every future session starts from the right baseline.

## Tech overview: Exploring and documenting a brownfield project with Copilot

Talking points:

- Why exploration is a Copilot CLI sweet spot: the harness can read across the codebase, run quick shell commands (`grep`, `git log`), and synthesize a coherent picture much faster than you can do it manually.
- A repeatable exploration prompt: ask for the stack, the module map, the entry points, the data layer, the templates / UI, and the obvious tech-debt or risk areas. Then ask the agent to point out what's *not* documented anywhere.
- Turning exploration into committed docs: take the agent's findings and have it update / create `README.md`, `ARCHITECTURE.md`, or supplemental docs. Review carefully — agents can confidently invent things.
- Why these docs matter for later agent runs: well-written project docs become high-signal context for future sessions (and for the instructions files you'll author next).

## Exercise: Explore AssetTrack and fill in the documentation gaps

Talking points:

- **Goal**: produce a meaningfully better `README.md` (and any supplemental docs you decide are needed) for AssetTrack, written with Copilot's help.
- **Files/areas touched**: `README.md` at the repo root; optionally `docs/` or `ARCHITECTURE.md`.
- **Steps**:
  - Have Copilot tour the repo and produce a structured summary: stack, modules, entry points, data layer, templates, scripts, tech-debt areas, unenforced rules.
  - Identify what's missing or wrong in the current `README.md`.
  - Have Copilot draft updates. Review every claim against the actual code before accepting.
  - Commit the docs locally (no push without your explicit go-ahead).
- **How to verify**: a fresh session asked "what is this project?" should now reference the new docs and produce a more accurate, faster answer than it did in Section 1.

## Tech overview: Instructions files and `/init`

Talking points:

- **The instruction sources Copilot CLI loads** (combined, not priority-fallback):
  - `AGENTS.md` (git root and cwd)
  - `.github/instructions/**/*.instructions.md` (path-scoped via `applyTo` globs)
  - `.github/copilot-instructions.md`
  - `$HOME/.copilot/copilot-instructions.md` (user-level — applies across every repo on your machine)
  - Additional directories via `COPILOT_CUSTOM_INSTRUCTIONS_DIRS`
  - Sibling files like `CLAUDE.md` / `GEMINI.md` are also recognized.
- **What `/init` does**: scans the repo and seeds `copilot-instructions.md` with a starting set of conventions inferred from what's there — stack, structure, build/test commands, observed patterns. It's a starting point, not a finished artifact.
- **When to re-run `/init`**: after major repo restructures, after adopting a new framework, or when the existing instructions have drifted far from reality.
- **Inspecting what's loaded**: `/instructions`, `/env`. When Copilot seems to ignore your rules, this is where to look first.
- **Writing instructions that change behavior**: be specific, scoped, and enforceable. "Use parameterized SQL in Java repositories" is enforceable; "write good code" is not.
- **Copilot Memory (concept only)**: separate from instructions files. Memories are auto-deduced by Copilot during sessions, scoped per-repo, validated against code, and decay after 28 days unless reused. Available in public preview; enabled by default for Copilot Pro/Pro+. Not a CLI command — surfaces through the GitHub UI for review/deletion.

## Exercise: Generate `copilot-instructions.md` with `/init` and add scoped `.instructions` files

Talking points:

- **Goal**: produce a layered instructions setup for AssetTrack — a repo-wide baseline plus targeted rules for the messy areas.
- **Files/areas touched**: `.github/copilot-instructions.md` (new, via `/init`), and `.github/instructions/scripts.instructions.md` and `.github/instructions/repository.instructions.md` (new).
- **Steps**:
  - Run `/init` and review what Copilot generates. Refine the output to capture the AssetTrack specifics: the stack (Spring Boot 2.7, Java 11, Bootstrap 3, jQuery, SQLite, Python 3 in deliberately old style), repository / service / controller conventions, "do" rules (parameterized SQL, server-side validation), "don't" rules (don't change package names, don't auto-upgrade Spring Boot), and the unenforced business invariants from `legacy-app/plan.md` (active assignment uniqueness, inactive employees can't receive assets, lost/retired assets can't be assigned, `returned_date >= assigned_date`).
  - Add `.github/instructions/scripts.instructions.md` with `applyTo: "scripts/**"`. Codify the Python rules: prefer f-strings, prefer `pathlib`, type hints encouraged on new code, stdlib-only unless told otherwise.
  - Add `.github/instructions/repository.instructions.md` with `applyTo: "**/repository/**"`. Codify the SQL rules: never use string concatenation to build SQL; use `PreparedStatement` parameterization; flag any existing string-built queries when seen.
  - Run `/instructions` (or `/env`) to confirm all three files are loaded.
  - Commit locally (no push without your go-ahead).
- **How to verify**: in a fresh session, ask Copilot to add a small helper to `scripts/import_assets.py` and a query method to `AssetRepository`. Confirm the proposed code follows the scoped rules (modern Python; parameterized SQL).

## Summary

You should now have:

- Documentation that reflects what's actually in the AssetTrack repo, produced collaboratively with Copilot.
- A repo-baseline `.github/copilot-instructions.md` seeded by `/init` and refined by hand.
- Scoped instructions for `scripts/` and `repository/`.
- A clear understanding of where Copilot looks for instructions, and how Memory layers on top.

Next, you'll **plan a real change** — an accessibility upgrade — using `/plan`, rubber duck, a custom agent, and `/fleet` parallel subagents in [Section 3][next-lesson].

## Resources

- [Adding custom instructions for GitHub Copilot CLI][copilot-instructions]
- [`AGENTS.md` overview][agents-md]
- [About Copilot Memory][copilot-memory]
- [Legacy app implementation plan (business invariants)][legacy-app-plan]

---

| [← Previous: Working with Copilot CLI][previous-lesson] | [Next: Planning and performing accessibility updates →][next-lesson] |
|:--|--:|

[previous-lesson]: ./01-working-with-copilot-cli.md
[next-lesson]: ./03-planning-and-accessibility.md
[copilot-instructions]: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions
[agents-md]: https://agents.md
[copilot-memory]: https://docs.github.com/en/copilot/concepts/agents/copilot-memory
[legacy-app-plan]: https://github.com/geektrainer/legacy-app/blob/main/plan.md
