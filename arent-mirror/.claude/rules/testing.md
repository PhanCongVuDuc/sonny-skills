---
paths:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
  - "**/*.spec.tsx"
  - "**/*_test.py"
  - "**/test_*.py"
  - "**/*_test.go"
  - "tests/**"
  - "test/**"
  - "__tests__/**"
---

# Testing Rules

Rules for test code. Adapt to your framework (Vitest / Jest / pytest / Go testing / etc.).

## Test names

- Names describe **behavior**, not method names. Bad: `test_getUser`. Good: `"returns 404 when user does not exist"`.
- Use the project's convention consistently (`test(...)`, `it(...)`, `describe(...)`).

## Structure

- One logical assertion per test (grouped related asserts allowed).
- AAA: Arrange → Act → Assert. Keep them visually separated.
- No test should depend on the order of other tests. Each test sets up its own state.

## What to mock vs what to integrate

- **Prefer real over mock** for: pure functions, in-process modules, in-memory data stores.
- **Mock at the network/process boundary**: external HTTP APIs, message queues, third-party SDKs.
- **Mock time / randomness / IDs** when the test must be deterministic.
- **Do not mock the database in integration tests.** Use a test database or a transactional rollback fixture. Mocked DB tests pass while real migrations break — that's the worst kind of green.

## Coverage targets

- Every public function gets at least: one happy-path test, one error-path test, one boundary case.
- Bug fix = regression test. If a bug existed because no test caught it, add the test that would have.
- Don't chase coverage percentage. Cover the paths that can actually break, skip the trivially-correct.

## Fixtures and factories

- Use the project's fixture/factory pattern (e.g. `factory-bot` / `pytest fixtures` / `t.Helper()` builders).
- Inline a literal when it makes the test clearer; reach for a factory when defaults matter and the literal would obscure intent.

## Anti-patterns to flag in review

- Tests that assert on implementation details (private methods, internal state) — they break on refactor.
- Tests with `try { ... } catch { /* swallow */ }` — the test passes even when the code throws.
- `skip` / `xfail` / `it.todo` without an attached issue link and removal date.
- Sleep-based timing (`setTimeout 500`). Use deterministic fakes or wait-for-condition utilities.

## Gotchas

- **Floating-point equality**: use `toBeCloseTo` / `pytest.approx` / `math.isclose`, not `===`.
- **Async leaks**: every promise must be awaited or returned. Unawaited promises cause flaky tests.
- **Shared state**: module-level mutable state contaminates tests. Reset in `beforeEach`/`setup`.
- **Test parallelism**: if the suite runs in parallel, shared resources (DBs, ports, files) must be isolated per worker.
