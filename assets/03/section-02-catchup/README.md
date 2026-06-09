# Section 02 catch-up assets for Section 03

Use these files only when you start Section 03 without completing Section 02. They provide the Section 02 AI infrastructure that Section 03 expects before you use the `accessibility-updater` custom agent or delegate work to Copilot cloud agent.

## What this copies

The catch-up scripts copy these Section 02 artifacts into your AssetTrack repository:

```text
.github/copilot-instructions.md
.github/agents/accessibility-updater.md
.github/instructions/astro.instructions.md
.github/instructions/dotnet.instructions.md
.github/instructions/flask.instructions.md
.github/instructions/java.instructions.md
.github/ISSUE_TEMPLATE/bug_report.yml
.github/ISSUE_TEMPLATE/chore.yml
.github/ISSUE_TEMPLATE/feature_request.yml
.github/PULL_REQUEST_TEMPLATE.md
.copilot/skills/make-repo-contribution/
```

## Apply the catch-up assets

From the root of your AssetTrack repository, run one of these commands and point it at this catch-up folder.

```bash
bash /path/to/assets/03/section-02-catchup/scripts/apply-section-02-catchup.sh
```

```powershell
pwsh -File /path/to/assets/03/section-02-catchup/scripts/apply-section-02-catchup.ps1
```

The scripts refuse to overwrite existing files unless you pass `--force` for Bash or `-Force` for PowerShell.

## Verify in Copilot CLI

After copying the files, start Copilot CLI from the AssetTrack repository root and run:

```text
/instructions
/agent
/skills
```

Confirm that the repository instructions and scoped instructions are loaded, `accessibility-updater` is listed, and `make-repo-contribution` is available.
