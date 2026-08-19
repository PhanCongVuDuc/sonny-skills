# Security Rules (project-wide)

No `paths:` frontmatter — these rules apply across the entire codebase.
Adapted for this repo: a Revit desktop add-in (C#/WPF). There is no HTTP server, SQL
database, or web frontend here — the trust boundaries are imported files, inter-process
calls, and data persisted in the Revit model.

## Secrets

- **Never** commit secrets, API keys, tokens, or credentials. Even temporarily.
- Secrets come from environment variables or user-level config outside the repo — never
  hardcoded in source, `.addin` files, or test data.
- Logs must not contain secrets, tokens, or PII. If you're not sure whether a field is
  sensitive, redact it.
- Never write customer names, property/project names, or real drawing file names into
  committed docs, samples, or test data — anonymize them (repo rule).

## Input handling (trust boundaries)

- Trust boundaries here are **file imports and external data**, not HTTP: CSV/Excel
  master data, DWG/DXF, JSON settings, zip assets, and linked Revit models.
- Validate **type, length, range, and format** at the boundary. A malformed or oversized
  input must fail with a clear error dialog — not corrupt the model mid-transaction.
- Treat data read from ExtensibleStorage / shared parameters written by other tools or
  older add-in versions as untrusted: check schema versions and handle missing/renamed
  fields.

## Process execution & injection

- Don't build command lines by concatenating user-controlled strings. Use
  `ProcessStartInfo` with explicit arguments.
- When piping JSON to child processes, use `new UTF8Encoding(false)` explicitly
  (`Encoding.UTF8` adds a BOM that breaks parsers).
- SQL / LDAP / template engines are not used in this add-in today. If a future feature
  adds them: parameterized queries only — never concatenate input into a query string.

## Authentication

- Login/authorization lives in `Arent3d.Architecture.Routing.Auth` (`LoginChecker`).
  Changes there, or to the `AUTH_DISABLED` conditional-compilation behavior, always get
  a security-focused review.
- Don't cache or persist credentials/tokens beyond what the Auth layer already does.

## Crypto

- Use vetted .NET libraries. No custom crypto, no DIY hashing for passwords/tokens.
- Never disable TLS certificate validation in production code.

## Dependencies

- Pin NuGet package versions. Review new packages before adding (maintenance, license,
  provenance).
- Internal `Arent3d.*` / `Architecture.Routing.Core` DLLs come from the repo's `lib/`
  tree — never substitute unverified binaries.

## Logging & telemetry

- No PII, customer data, or file paths that reveal customer names in logs.
- Log errors with enough context to diagnose without dumping raw user data.

## When in doubt

Delegate to the `design-reviewer` subagent (security perspective; model: opus) — or run
`/arent-workflow:review security`. Especially for changes that touch:
- The Auth project / login flow / `AUTH_DISABLED` behavior
- External file import (CSV, Excel, DWG, zip) or process execution
- ExtensibleStorage schema changes
- Anything that handles untrusted external input
