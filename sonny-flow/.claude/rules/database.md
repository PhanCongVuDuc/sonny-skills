---
paths:
  - "src/db/**"
  - "src/models/**"
  - "prisma/**"
  - "migrations/**"
  - "**/*.sql"
---

# Database Rules & Gotchas

Rules that apply when working in DB-related code. Adapt to your stack (Prisma / Drizzle / SQLAlchemy / raw SQL / etc.).

## Access patterns

- **Always parameterized queries.** Never build SQL by string concatenation. If using a query builder, never bypass it with raw SQL containing user input.
- **One transaction per logical operation.** Don't span transactions across request boundaries or background jobs.
- **Read replicas** (if used) are read-only. Writes must go to primary explicitly.

## Migrations

- Migrations must be **reversible**. If irreversibility is required, document why in the migration file itself.
- Adding a `NOT NULL` column to a large table requires a 3-step migration: add nullable → backfill → enforce NOT NULL.
- Index creation on large tables should use `CONCURRENTLY` (Postgres) to avoid table locks.
- **Never edit a migration that has been applied to any shared environment.** Create a new migration that fixes the issue.

## Common gotchas

- **N+1 queries**: when fetching a list with related data, use `include` / `join` / eager loading. Don't iterate-then-fetch.
- **Default timezone**: server-side timestamps must be UTC. Convert to local TZ only at the display layer.
- **`null` vs `undefined`** (TS): the ORM may treat them differently. Be explicit.
- **String length on indexed columns**: many DBs limit index key length. Prefer hashed indexes or shorter prefixes for long text columns.
- **Cascading deletes**: confirm `ON DELETE` behavior matches intent. Default differs by ORM.

## When unsure

Stop and ask. Schema changes have long blast radius — a rollback after deploy is much more expensive than a 10-minute review beforehand.
