# Section 8 — Wrap-up and next steps

| [← Previous: Bringing it all together to modernize AssetTrack][previous-lesson] |  |
|:--|--:|

You've worked Copilot CLI through a brownfield Java + Python codebase, codified your team's conventions, built reusable skills and custom agents, registered LSP and MCP servers, distributed the whole setup as a plugin, and run a multi-phase modernization. This section is a quick recap and a pointer to where to go next.

## What you will learn

- A consolidated view of the AI infrastructure you built across the course.
- How the patterns generalize beyond AssetTrack.
- Where to go next with Copilot CLI.

## Recap

Talking points:

- **Working with Copilot CLI** ([Section 1][s01]) — the harness, agent loop, tool surface, permission model, `/model`, `/context`, BYOK as a concept.
- **Building AI infrastructure** ([Section 2][s02]) — exploring a brownfield project, filling doc gaps, generating `copilot-instructions.md` with `/init`, scoped `.instructions` files, memory.
- **Planning and accessibility** ([Section 3][s03]) — `/plan`, rubber-ducking, the `accessibility-updater` custom agent, parallelizing with `/fleet`.
- **Enhancing the test suite** ([Section 4][s04]) — authoring a delegation prompt, `/delegate` to the Copilot cloud agent, reviewing the resulting PR.
- **Agents follow standards** ([Section 5][s05]) — issue and PR templates, agent skills, the `make-repo-contribution` skill enforcing issue → branch → templated PR.
- **Modernization strategies** ([Section 6][s06]) — `/lsp` configuration for Java + Python, MCP servers as documentation surfaces, `/research` for citation-backed planning.
- **Bringing it all together** ([Section 7][s07]) — `/plugin` to install the AI infrastructure, custom agents + skills + MCP + plan + fleet orchestrating a phased modernization, Playwright MCP for validation.

## Generalizing beyond AssetTrack

Talking points:

- The same pattern (instructions → skills → custom agents → MCP / LSP → plugins → plan + fleet) applies to any brownfield repo. Walk the learner through how to bootstrap each piece on their own codebase.
- Common variations:
  - A team conventions `copilot-instructions.md` shared across many repos.
  - User-level skills for tasks that recur outside any one project (e.g., "rewrite this commit message in our team's house style").
  - Custom agents for compliance-sensitive areas (security review, license audit).
- Knowing when **not** to use any of this — for genuinely one-off, exploratory work, a plain CLI session is still the right tool.

## Suggested next steps

Talking points:

- Apply the instructions / skills / custom agents / MCP / plugin pattern to a real repo at work. Start with `copilot-instructions.md`.
- Share one skill or agent with your team. See how the conversation changes when everyone has the same one available.
- Explore the [MCP registry][mcp-registry] for a server that fits your team's external tools.
- Subscribe to the [GitHub Changelog][changelog] — Copilot CLI features evolve fast.

## Further reading

- [Copilot CLI documentation][copilot-cli-docs]
- [GitHub Copilot best practices][copilot-best-practices]
- [Model Context Protocol introduction][mcp-intro]
- [`github-samples/agents-in-sdlc` workshop][agents-in-sdlc] — the IDE-focused companion to this course; useful if your team is split between CLI and IDE workflows.
- [Legacy app: `geektrainer/legacy-app`][legacy-app]

## Resources

- [Copilot CLI documentation][copilot-cli-docs]
- [GitHub Copilot Changelog][changelog]
- [MCP registry][mcp-registry]
- [Course tracking issue (`github/devrel#5212`)][tracking-issue]

---

| [← Previous: Bringing it all together to modernize AssetTrack][previous-lesson] |  |
|:--|--:|

[previous-lesson]: ./07-bringing-it-all-together.md
[s01]: ./01-working-with-copilot-cli.md
[s02]: ./02-building-ai-infrastructure.md
[s03]: ./03-planning-and-accessibility.md
[s04]: ./04-enhancing-test-suite.md
[s05]: ./05-agents-follow-standards.md
[s06]: ./06-modernization-strategies.md
[s07]: ./07-bringing-it-all-together.md
[copilot-cli-docs]: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli
[copilot-best-practices]: https://docs.github.com/en/copilot/get-started/best-practices
[mcp-intro]: https://modelcontextprotocol.io/introduction
[mcp-registry]: https://github.com/mcp
[agents-in-sdlc]: https://github.com/github-samples/agents-in-sdlc
[legacy-app]: https://github.com/geektrainer/legacy-app
[changelog]: https://github.blog/changelog/label/copilot/
[tracking-issue]: https://github.com/github/devrel/issues/5212
