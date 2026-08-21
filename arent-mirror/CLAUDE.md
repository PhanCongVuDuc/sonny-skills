# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Revit Add-in for Electrical Architecture Routing** — a C# WPF application that extends Autodesk Revit 2024 with automated electrical routing capabilities (pull-box placement, rack creation, symbol management, data validation, etc.).

## Build Commands

```bash
# Debug builds
dotnet build -c "Debug 2024"

# Release builds
dotnet build -c "Release 2024"
```

Build output goes to `bin\Debug\2024\` or `bin\Release\2024\`. The post-build event copies `.addin` files to `%ProgramData%\Autodesk\Revit\Addins\{VERSION}\` automatically.

## Code Formatting

```bash
dotnet format
```

Formatting is enforced via GitHub Actions (`.github/workflows/format.yml`). All PRs must pass formatting checks.

## Testing

- **Unit tests**: Located in `Tests/` directory (NSubstitute mocking)
- **Integration tests**: In `Arent3d.Architecture.Routing.RevitTest/` — requires Revit to be running
- Automated tests run via GitHub Actions on self-hosted runners on PR comment triggers (`.github/workflows/autotest.yml`)

## Architecture

The solution follows a **layered MVVM architecture**:

```
Arent3d.Architecture.Routing/              # Core routing engine + Revit integration
Arent3d.Architecture.Routing.AppBase/      # Shared UI, base commands, common ViewModels
Arent3d.Architecture.Routing.Electrical.App/  # Main add-in: electrical-specific commands & features
Arent3d.Architecture.Routing.Presentation/ # Shared WPF controls and resources
Arent3d.Architecture.Routing.Auth/         # Authentication/authorization
```

**Key architectural points:**
- **Command Pattern**: All Revit commands implement `IExternalCommand`. The `Execute()` method should only delegate to other functions — no logic directly in `Execute()`.
- **MVVM**: Explicit View/ViewModel/Model separation. WPF bindings use PropertyChanged.Fody for change notification.
- **Storable**: Revit element/document data is persisted via the `Storable/` pattern in the core project.
- **Revit version targeting**: Conditional compilation via `REVIT2023` / `REVIT2024` / `REVIT2023_OR_GREATER` defines. Family files are versioned under `Versions/` in the Electrical.App project.
- **Auth toggle**: `AUTH_DISABLED` define is set when the configuration name does not contain "Auth ".

## Coding Conventions

From `.editorconfig` and `.cursor/rules/dotnet-rule.mdc`:

- **Indentation**: 2 spaces, max 120 characters per line
- **Naming**: PascalCase for classes/methods/properties; `_camelCase` for private fields; PascalCase for constants
- **Methods**: Keep under 80 lines; extract regions into separate methods
- **Async**: Async methods must have the `Async` suffix
- **XML docs**: Required on public APIs
- **Dependency injection**: Constructor injection only
- **LINQ**: Prefer query syntax for complex queries; prefer method syntax for simple ones

## Revit-Specific Patterns

From `.cursor/rules/revit-rule.mdc`:

- Revit transactions must be opened and committed within the same function scope
- User confirmation dialogs are required before each destructive operation step
- `IExternalCommand.Execute()` should only dispatch to helper methods
- When running Revit for debugging, use PowerShell argument syntax (use `-` not `/` for flags)

## Git Workflow

- **Main branch**: `develop` (use for PRs)
- **Feature branches**: `yourname/featurename`
- PR template requires: Feature Overview, Technical Changes Summary, Impact Assessment, Specific Review Areas

## AI Development Harness (arent-workflow)

This repo has the arent-workflow AI harness applied (existing-first). Cross-tool conventions are shared via @AGENTS.md; this CLAUDE.md adds Claude Code–specific guidance on top.

**Phase workflow** (for non-trivial features): `/arent-workflow:req` → `/arent-workflow:spec` → `/arent-workflow:design` → `/arent-workflow:implement` → `/arent-workflow:test` → `/arent-workflow:review`. Each phase writes structured artifacts under `deliverables/`, gated per `.claude/rules/gates.md`.

**Existing Revit-specific skills remain primary and are unchanged** — prefer them when they fit:
- `/feature-design`, `/implementation` — Revit feature design / implementation (a `/spec-writer` skill for spec docs exists as a local-only tool and is not tracked in this repo)
- `/ai-review-and-fix`, `/impact-analysis`, `/sonarqube-auto-fix` — PR review+fix, impact analysis, static-analysis cleanup

The `/arent-workflow:*` commands are generic and complement these.

**Rules** (`.claude/rules/`) apply automatically by path. Active here: `security.md` (global, no path scope) and `domain-knowledge.md` (path-scoped to the `Arent3d.Architecture.Routing*` C# projects and `Tests/`). Contract rules `gates.md` / `output-formats.md` / `risk-categories.md` define the deliverables schemas and review vocabulary. `api-design.md` / `database.md` / `testing.md` / `lsp-navigation.md` are path-scoped to web/JS layouts and stay **dormant** for this .NET repo until adapted to C#/Revit paths.

**Agents** (`.claude/agents/`: legacy-analyzer, implementer, *-reviewer, devils-advocate, etc.) back the workflow commands.

**AI-facing docs**: `docs/domain/` (human-maintained domain knowledge), `docs/onboarding.md`, `docs/ai-docs.md`, `docs/agent-rules.md`. Refresh generated docs via `scripts/update-ai-docs.*` or the optional `.github/workflows/ai-docs.yml.example` (rename to `.yml` to enable — currently inactive).

**Not modified by the harness**: existing CI/CD (`.github/workflows/*.yml`) and the existing skills above.
