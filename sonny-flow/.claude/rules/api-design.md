---
paths:
  - "src/api/**"
  - "src/routes/**"
  - "src/handlers/**"
  - "src/controllers/**"
---

# API Design Rules

Rules for HTTP endpoints. Adapt to your framework (Express / Fastify / Hono / FastAPI / Gin / etc.).

## Routing

- Paths use kebab-case nouns: `/v1/user-sessions/:id` (not `userSessions`, not `user_sessions`)
- Versioning at the top: `/v1/...`, `/v2/...`. Never embed version in body.
- Resource-oriented: `GET /v1/users/:id`, `POST /v1/users`, not `GET /v1/getUser`
- Sub-resources nested: `GET /v1/users/:id/sessions` — but flatten if relationship isn't required for access

## Request/response shape

- All responses follow the project's standard envelope. Example: `{ data: ..., error: null }` for success / `{ data: null, error: { code, message } }` for failure.
- Validate the request body **at the boundary** with the project's validator (Zod / Pydantic / etc.). The handler receives a typed, validated object — not raw JSON.
- Return ISO 8601 strings for timestamps. Never raw `Date` objects, never Unix epochs unless the project explicitly uses them.

## Status codes

- `200` for successful GET/PUT/PATCH with body
- `201` for successful POST that created a resource (include `Location` header or the resource in body)
- `204` for successful DELETE or PUT with no body
- `400` for validation failures (with details about *which* field failed)
- `401` unauthenticated, `403` authenticated but not allowed
- `404` for missing resources — and for resources the user isn't allowed to see (avoid IDOR leakage)
- `409` for conflicts (duplicate, optimistic-locking failure)
- `422` for semantically invalid input (different from `400` malformed)
- `500` **only for unexpected server errors**. Known failure modes get specific 4xx codes.

## Errors

- Error response must include a machine-readable `code` (string enum) and a human-readable `message`.
- Never leak stack traces, SQL errors, or internal file paths.
- Log the full error server-side with a request ID; return the request ID to the client for support.

## Auth

- Authentication enforced by middleware, not per-handler. Don't roll your own check inside a handler.
- Authorization happens before *every* data access — not just at the route entrypoint. (Defense against IDOR.)

## Pagination

- Cursor-based for list endpoints when order matters and data changes. Offset-based only for static datasets.
- Cap `limit` server-side. Reject `limit > 100` (or your project's max).

## Gotchas

- CORS: setting `Access-Control-Allow-Origin: *` while also setting `Access-Control-Allow-Credentials: true` is a contradiction browsers will reject.
- Content negotiation: state `Content-Type: application/json` explicitly. Don't rely on framework defaults.
- Idempotency for POST: if the operation can be retried by the client, support an `Idempotency-Key` header.
