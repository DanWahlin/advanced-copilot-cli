# Section 1 — Working with Copilot CLI

| [← Previous: Prerequisites and environment setup][previous-lesson] | [Next: Building an AI infrastructure →][next-lesson] |
|:--|--:|

Before you can drive Copilot CLI well, it helps to know what it actually is. This section grounds you in the agent model, walks through what's happening under the hood when Copilot is "thinking," and gets you comfortable with the basic mechanics — picking a model, granting permissions, and exercising plan mode.

## What you will learn

- What an AI agent is, conceptually, and how that differs from chat-in-IDE.
- How the Copilot CLI harness works under the hood: the agent loop, the tool surface, the approval gate, and the session lifecycle.
- The basic mechanics you'll use every day: `/model`, the trust prompt, per-tool approvals, modes, and `/context`.
- That **bring-your-own-key (BYOK)** is supported for Copilot CLI, when it matters, and how it's wired up — even though we won't run an exercise on it in this course.
- Where everything else (instructions, planning, custom agents, `/delegate`, skills, LSP, MCP, `/research`, plugins) lives in later sections.

## Scenario

> [!NOTE]
> **Starting state**: a clean fork of [`legacy-app`][legacy-app] open in a Codespace (or locally), with Copilot CLI installed per [Section 0][previous-lesson]. Both exercises are **read-only / configuration-only** — no source-code changes.

You're a developer who recently joined Contoso Industries and inherited **AssetTrack** — a Spring Boot 2.7 / Java 11 / Bootstrap 3 / jQuery internal asset-tracking app. Before changing anything, you want to understand what Copilot CLI is doing on your behalf, and get the muscle memory for steering it.

## Tech overview: Understanding AI agents

Talking points:

- What an "agent" is, in concrete terms: an LLM that runs in a loop, picks tools to call, observes the results, and keeps going until the task is done or it asks for input.
- How that differs from chat-in-IDE: the agent owns the *steps*, not just the suggestions. It edits files, runs commands, fetches from the network, and chooses what to do next based on what it just observed.
- What this changes about your job: you're reviewing decisions, not typing. The skills shift from "writing the code" to "scoping the task, gating the actions, and reviewing the diff."
- Trade-offs of running an agent locally: it sees your filesystem, can run shell commands, and can make changes you didn't explicitly ask for. That's why the approval surface exists.

## Tech overview: Copilot CLI under the hood

Talking points:

- **Same harness as the Copilot cloud coding agent.** The CLI is the local synchronous surface; the cloud agent (covered in [Section 4][s04]) is the async surface. Same loop, same tools, different runner.
- **The agent loop**:
  1. You enter a prompt.
  2. Copilot assembles context — your prompt plus combined instruction files (covered in [Section 2][s02]) plus prior conversation.
  3. The model proposes a tool call (read a file, edit a file, run a shell command, query an MCP server, invoke a skill or subagent).
  4. The CLI gates the tool call through the approval surface.
  5. The tool runs; the result becomes the next observation.
  6. Repeat until the task is done.
- **The tool surface** (named here, deep dives later): file read/write, shell, MCP servers (covered in [Section 6][s06] and [Section 7][s07]), skills (covered in [Section 5][s05]), custom agents and `/fleet` parallel subagents (covered in [Section 3][s03]), `/delegate` to the cloud (covered in [Section 4][s04]), LSP (covered in [Section 6][s06]), `/research` (covered in [Section 6][s06]), plugins (covered in [Section 7][s07]).
- **Approval surface and trust**:
  - The trust prompt at session start: "do you trust the files in this folder?" Heuristic — don't launch Copilot CLI from `$HOME` or anywhere with secrets.
  - Per-tool approval: yes / yes-for-session / no-with-feedback. Per-tool is the safe default for brownfield work.
  - `--allow-tool` and `--allow-all-tools` for programmatic / scripted use; `/reset-allowed-tools` to clear.
  - `/add-dir`, `/list-dirs`, `/cwd` for crossing folder boundaries safely.
- **Picking a model with `/model`**. Default is Claude Sonnet 4.5; you can switch to Claude Sonnet 4 or GPT-5. When picks matter (model strengths on different kinds of work; mention briefly that all consume the same approval/permission flow).
- **Modes**. Default ask/execute; **plan mode** (toggle with shift+tab) for plan-first work covered deeper in [Section 3][s03]; experimental autopilot for hands-off work — call out as experimental.
- **Context management**. `/context` to inspect the token window; auto-compaction kicks in around 95% of the limit; `/compact` to trigger manually.
- **Sessions**. `/session`, `/resume`, `/rename`, `/share`, `/new`. Sessions are first-class — you can pause, hand off, or resume.

> [!IMPORTANT]
> **Bring-your-own-key (BYOK)** is supported for Copilot CLI in public preview. We won't run an exercise on it in this course, but it's important to know it exists.
>
> - **Why it matters**: enterprise governance, compliance constraints (data residency, contractual model use), custom or fine-tuned models, or local-only development with [Ollama][ollama].
> - **Supported providers**: OpenAI, Azure OpenAI, Anthropic, AWS Bedrock, Google AI Studio, xAI, Ollama, and any OpenAI-compatible endpoint.
> - **How it's wired up**: organization or enterprise admins add the keys under Copilot settings, then individuals select the resulting models. For local experimentation, the env-var pattern is `COPILOT_PROVIDER_BASE_URL`, `COPILOT_PROVIDER_API_KEY`, optionally `COPILOT_PROVIDER_TYPE` (e.g., `azure`), and `COPILOT_MODEL`.
> - **Constraints**: models need to support tool/function calling and streaming for the harness to work well. Quality varies by provider/model.
> - See [Using your own LLM models in GitHub Copilot CLI][byok-cli] and [Using your LLM provider API keys with Copilot][byok-admin].

## Exercise: First conversation with the AssetTrack codebase

Talking points:

- **Goal**: get an accurate, agent-produced picture of AssetTrack's architecture without opening any files yourself first. Watch the harness work.
- **Files/areas touched**: none (read-only).
- **Steps**:
  - Launch `copilot` inside the fork. Accept the trust prompt for this session only the first time through.
  - Ask Copilot to summarize the architecture: stack, modules, entry points.
  - Ask it to trace a request from `DashboardController` through the service layer to `AssetRepository`.
  - Ask it to call out tech-debt or risk areas it noticed.
  - When it asks for permission to read files / run shell commands, observe the prompt and approve per-call (don't allow-all-tools yet).
- **How to verify**: spot-check Copilot's claims against `src/main/java/com/contoso/assettracker/`. The summary should correctly identify Spring Boot 2.7, Thymeleaf, JDBC repositories, and the dashboard summary stats. No edits should have happened.

## Exercise: Tour the harness

Talking points:

- **Goal**: get hands-on with the basic mechanics — model picker, approval flow, modes, and context inspection — so you know what each lever does before you need it.
- **Files/areas touched**: none (configuration only).
- **Steps**:
  - Run `/model` and switch between the available models. Note what each is good at; pick one to keep for the rest of the course.
  - Trigger a tool-approval prompt by asking Copilot to run a read-only shell command (e.g., `mvn dependency:tree` or `git log --oneline -n 20`). Practice the **yes-for-session** option for that command.
  - Press `shift+tab` to cycle into **plan mode**. Ask a small question and observe how the response shape changes (it asks clarifying questions and produces a plan rather than running tools). Cycle back out.
  - Run `/context` to see how much of the token window you've used so far.
  - Run `/env` to see the loaded instructions, MCP servers, skills, agents, plugins, and LSPs (most will be empty for now — that's by design).
- **How to verify**: `/model` shows your chosen model; the tool you allow-for-session no longer prompts; plan mode toggled cleanly; `/context` and `/env` returned without error.

## Summary

You've now:

- Internalized the agent loop and the tool surface.
- Practiced the approval flow on a real read-only command.
- Picked a model, exercised plan mode, and seen what the harness loads on startup.
- Learned BYOK as a concept so you know where to reach when you need provider control.

Next, you'll **build the AI infrastructure** — explore AssetTrack with Copilot, fill the documentation gaps, and codify what you learn as instructions files in [Section 2][next-lesson].

## Resources

- [About GitHub Copilot CLI][copilot-cli-docs]
- [Using GitHub Copilot CLI][copilot-cli-howto]
- [Using your own LLM models in GitHub Copilot CLI (BYOK)][byok-cli]
- [Using your LLM provider API keys with Copilot (admin)][byok-admin]
- [Legacy app source: `geektrainer/legacy-app`][legacy-app]

---

| [← Previous: Prerequisites and environment setup][previous-lesson] | [Next: Building an AI infrastructure →][next-lesson] |
|:--|--:|

[previous-lesson]: ./00-prerequisites.md
[next-lesson]: ./02-building-ai-infrastructure.md
[s02]: ./02-building-ai-infrastructure.md
[s03]: ./03-planning-and-accessibility.md
[s04]: ./04-enhancing-test-suite.md
[s05]: ./05-agents-follow-standards.md
[s06]: ./06-modernization-strategies.md
[s07]: ./07-bringing-it-all-together.md
[copilot-cli-docs]: https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli
[copilot-cli-howto]: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli
[byok-cli]: https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models
[byok-admin]: https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-your-own-api-keys
[legacy-app]: https://github.com/geektrainer/legacy-app
[ollama]: https://ollama.com
