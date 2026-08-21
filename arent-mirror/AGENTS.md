# AGENTS.md — Shared conventions for AI coding agents

This file documents conventions that apply to **any** AI coding assistant working in this repo (Claude Code, Cursor, Aider, GitHub Copilot, etc.). Tool-specific guidance lives in each tool's own file (`CLAUDE.md`, `.cursorrules`, etc.) and references this one.

> **Why this file exists**: AGENTS.md is an emerging cross-tool standard. Keeping shared conventions here once — and importing it from tool-specific files — avoids drift between agents.

## Project context

A Revit Add-in for **Electrical Architecture Routing** — a C# WPF application that extends Autodesk Revit (primary target 2024; multi-version 2023–2027) with automated electrical routing: pull-box placement, cable-rack creation, symbol management, table generation, and data validation. Used by electrical/architectural engineers to lay out and verify routing inside Revit models.

## Tech stack

- **Language(s)**: C# (.NET), Revit API. Multi-version targeting via conditional compilation (`REVIT2023` / `REVIT2024` / `REVIT2023_OR_GREATER`).
- **Framework(s)**: WPF (MVVM, change notification via PropertyChanged.Fody); Autodesk Revit API; `IExternalCommand` command pattern.
- **Database / storage**: No external DB. Revit element/document data is persisted via ExtensibleStorage behind the `Storable/` pattern in the core project.
- **Build tool**: dotnet / MSBuild. Configurations are version-suffixed, e.g. `Debug 2024` / `Release 2024`.
- **Test framework**: NSubstitute for unit tests (`Tests/`); ricaun.RevitTest for Revit-dependent integration tests (`Arent3d.Architecture.Routing.RevitTest/`, requires a running Revit).
- **Package manager**: NuGet (use this one — do not switch). This is a .NET solution; ignore any npm/pip-oriented defaults.

## Working agreements

### Verify before claiming done
- Build (`dotnet build -c "Debug 2024"`) and run the relevant tests before reporting work as complete.
- For Revit UI changes: confirm behavior in a running Revit instance (or via the RevitBridge E2E path) — do not claim success from a build alone.
- If you can't verify something (no running Revit, integration runner unavailable, etc.), say so explicitly — do not claim success.

### Scope discipline
- Stay within the scope of the requested change.
- No incidental refactors, renames, or "while I was here" cleanup unless asked.
- If you spot a separate issue, note it for the human — don't fix it inline.

### Don't invent — reuse
- Before adding a new utility, search the codebase for an existing one.
- Match existing patterns. If the codebase uses NSubstitute, don't introduce Moq. If a concern already lives in `RevitApiCompat`, extend it rather than branching inline.
- New abstractions need at least three concrete call sites to justify themselves.

### Errors are signals, not noise
- Never silence errors with empty `catch`.
- Never weaken a test to make it pass — fix the code or fix the test, but understand which is broken first.
- Exceptions should propagate with context, not be swallowed.

### Secrets and config
- Never commit real secrets, API keys, or tokens.
- Read secrets from environment variables, never hardcode.
- `.env` files are gitignored — copy `.env.example` for local values.

## Style & formatting

Defer to the project's formatter and linter. Do not introduce new style on your own:

- Format: `dotnet format` (2-space indentation, max 120 chars per line). Enforced via `.github/workflows/format.yml`. Avoid repo-wide reformatting — match existing style by hand for incidental edits.
- Lint / static analysis: `.editorconfig` rules + SonarQube (`sonar.arent3d.com`) + the workflow static-analysis checks.

If a generated file doesn't match the formatter's output, run the formatter — don't argue with it.

## Git workflow

- Branch from `develop` (the default/integration branch). Name feature branches by the change following the repo convention (e.g. `<author>/<feature>`).
- Style-only changes (e.g. `.editorconfig`) and functional changes go in **separate PRs**.
- Commit messages: imperative subject, focused on *why* — not *what*. The diff shows *what*.
- One logical change per commit. Reviewable independently.
- No force-pushes to `develop`, `release/*`, or any shared branch. Never push directly to `develop` — always feature branch + PR.
- PRs reference an issue when one exists: `Fixes #123`.

## Testing approach

- Unit tests live under `Tests/` (NSubstitute mocking, UI mocked). Revit-dependent integration tests live under `Arent3d.Architecture.Routing.RevitTest/` and require a running Revit; they run on self-hosted runners via the autotest workflows (PR-comment / manual triggers).
- Naming describes behavior, not implementation.
- Prefer integration over mocks where feasible. Mock only at true external boundaries (e.g. Revit UI).
- Bug fix = regression test.

## Code review expectations

Before requesting human review, confirm:

- [ ] Build passes locally (`dotnet build` for the relevant configuration).
- [ ] Relevant tests pass (full suite for cross-module changes; relevant subset otherwise).
- [ ] `dotnet format` clean, no new analyzer/SonarQube warnings introduced.
- [ ] No secrets, debug dialogs, or stray logging left in the diff (no `MessageBox`/`TaskDialog` inside `Run()`).
- [ ] PR description explains the *why* and links to the issue. PR template sections filled (Feature Overview, Technical Changes Summary, Impact Assessment, Specific Review Areas).

## What's specific to which tool

| Tool | Tool-specific file |
|---|---|
| Claude Code | `CLAUDE.md` (imports this file with `@AGENTS.md`) |
| Cursor | `.cursor/rules/*.mdc` |
| Aider | `.aider.conf.yml` |
| GitHub Copilot | (no per-repo config — relies on this file) |

Update the tool-specific file when adding guidance that only matters for that agent (e.g. Claude Code subagent invocations, Cursor `@`-mentions).
