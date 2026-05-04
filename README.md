# Advanced GitHub Copilot CLI

A hands-on course for experienced developers who are ready to take GitHub Copilot CLI beyond the basics and use it for **real-world brownfield work** — building reusable AI infrastructure (custom instructions, agent skills, custom agents, and MCP integrations) on top of an existing legacy codebase.

> [!IMPORTANT]
> Because GitHub Copilot, and generative AI at large, is probabilistic rather than deterministic, the exact code, files changed, and outputs may vary between runs. You may notice slight differences between what's described here and what you see in your terminal. This is expected.

## Who this course is for

You're already comfortable with Copilot in an IDE and with the basics of Copilot CLI (running `copilot`, having a chat, accepting an edit). You want to:

- Use Copilot CLI as your primary agent surface, not as a fallback when you're away from your editor.
- Codify your team's conventions so Copilot follows them automatically.
- Build reusable skills and custom agents instead of re-prompting from scratch every session.
- Extend Copilot CLI with MCP servers and integrate it into a real end-to-end workflow (audit → backlog → fix → PR → review).

## The scenario

You've just inherited **AssetTrack** at **Contoso Industries** — an internal asset-tracking application built on Spring Boot 2.7, Java 11, jQuery, Bootstrap 3, SQLite, and a couple of crusty Python scripts. It's a realistic brownfield app: missing tests, an SQL-injection-flavored repository method, unenforced business rules, a buggy dashboard, and Python scripts written in a deliberately old-fashioned style.

You'll work the legacy app from [`geektrainer/legacy-app`][legacy-app] throughout the course, using Copilot CLI to understand it, modernize it, and add to it.

## What you'll learn

Across the nine sections of this course you will:

- Understand what an AI agent is and how the Copilot CLI harness works under the hood, including how to control models, permissions, and modes — and how bring-your-own-key fits in.
- Build an AI infrastructure for a brownfield repo: explore it, fill documentation gaps, generate `copilot-instructions.md` with `/init`, and add path-scoped `.instructions` files.
- Plan and execute multi-step changes with `/plan`, rubber-duck critique, custom agents, and `/fleet` parallel subagents — applied to an accessibility upgrade.
- Use `/delegate` and the Copilot cloud agent to offload well-bounded work, like fleshing out a thin test suite, while you keep working locally.
- Enforce team standards with agent skills — including importing the `make-repo-contribution` skill so every Copilot contribution flows through issues and PRs.
- Give Copilot better signal with LSP servers, custom MCP servers, and `/research` for citation-backed modernization planning.
- Bring everything together: use plugins to install your AI infrastructure in one shot and modernize AssetTrack to React + Bootstrap 5 + Spring 4 + Java 25.

## Course structure

Each section is a single markdown file under [`content/`](./content/). Sections build on each other but each section's exercises include a starting-state note so you can drop in if you need to.

1. [Prerequisites and environment setup][s00]
2. [Working with Copilot CLI][s01]
3. [Building an AI infrastructure][s02]
4. [Planning and performing accessibility updates][s03]
5. [Enhancing the test suite][s04]
6. [Ensuring agents follow established standards][s05]
7. [Planning out modernization strategies][s06]
8. [Bringing it all together to modernize AssetTrack][s07]
9. [Wrap-up and next steps][s08]

## Get started

Head to [Section 0: Prerequisites and environment setup][s00] to get your environment ready.

## Status

This repository contains the **skeleton** for the course. Each section README captures the structure, talking points, and exercise outlines. Full prose, screenshots, and step-by-step content will be filled in by the course authors.

[legacy-app]: https://github.com/geektrainer/legacy-app
[s00]: ./content/00-prerequisites.md
[s01]: ./content/01-working-with-copilot-cli.md
[s02]: ./content/02-building-ai-infrastructure.md
[s03]: ./content/03-planning-and-accessibility.md
[s04]: ./content/04-enhancing-test-suite.md
[s05]: ./content/05-agents-follow-standards.md
[s06]: ./content/06-modernization-strategies.md
[s07]: ./content/07-bringing-it-all-together.md
[s08]: ./content/08-wrap-up.md
