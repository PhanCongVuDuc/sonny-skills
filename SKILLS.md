# SKILLS.md

> Sinh tự động bằng `node scripts/gen-skills.mjs` (hoặc `/setup-skills`). **Đừng sửa tay.**
> Đây là ảnh chụp **máy này**, không phải danh sách mong muốn — cái đó nằm ở `skills.json`.

Tổng **37 skill**: 35 từ 2 plugin, 2 skill rời.

| Plugin | Marketplace | Nguồn | Version | Skills |
|---|---|---|---|---|
| `sonny` | sonny-skills | **own** | `5ddd348604b7` | 0 |
| `mattpocock-skills` | mattpocock | bên thứ 3 | `1.2.3` | 35 |

## `sonny` — skill tự viết

_Chưa có skill nào._

## `mattpocock-skills` — bên thứ 3

| Skill | Mô tả |
|---|---|
| `mattpocock-skills:ask-matt` | Ask which skill or flow fits your situation. A router over the skills in this repo. |
| `mattpocock-skills:claude-handoff` | Hand the current conversation off to a fresh background agent that picks up the work immediately. |
| `mattpocock-skills:code-review` | Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X". |
| `mattpocock-skills:codebase-design` | Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary. |
| `mattpocock-skills:diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. |
| `mattpocock-skills:domain-modeling` | Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs to maintain the domain model. |
| `mattpocock-skills:git-guardrails-claude-code` | Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code. |
| `mattpocock-skills:grill-me` | A relentless interview to sharpen a plan or design. |
| `mattpocock-skills:grill-with-docs` | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| `mattpocock-skills:grilling` | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| `mattpocock-skills:handoff` | Compact the current conversation into a handoff document for another agent to pick up. |
| `mattpocock-skills:implement` | Implement a piece of work based on a spec or set of tickets. |
| `mattpocock-skills:improve-codebase-architecture` | Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. |
| `mattpocock-skills:loop-me` | Grill me about specs for the workflows I want to build, within this workspace. |
| `mattpocock-skills:migrate-to-shoehorn` | Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial test data. |
| `mattpocock-skills:prototype` | Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what a UI should look like. |
| `mattpocock-skills:research` | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. |
| `mattpocock-skills:resolving-merge-conflicts` | Use when you need to resolve an in-progress git merge/rebase conflict. |
| `mattpocock-skills:scaffold-exercises` | Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create exercise stubs, or set up a new course section. |
| `mattpocock-skills:setup-matt-pocock-skills` | Configure this repo for the engineering skills — set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills. |
| `mattpocock-skills:setup-pre-commit` | Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing. |
| `mattpocock-skills:setup-ts-deep-modules` | Wire dependency-cruiser into a TypeScript repo so each package is a deep module — implementation hidden in subfolders, reachable only through its entry-point files. User-invoked. |
| `mattpocock-skills:tdd` | Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. |
| `mattpocock-skills:teach` | Teach the user a new skill or concept, within this workspace. |
| `mattpocock-skills:to-questionnaire` | Turn a decision you can't fully answer into a questionnaire for someone else to fill in. |
| `mattpocock-skills:to-spec` | Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just synthesis of what you've already discussed. |
| `mattpocock-skills:to-tickets` | Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker — edges as text in one file per ticket locally, or native blocking links on a real tracker. |
| `mattpocock-skills:triage` | Move issues and external PRs through a state machine of triage roles — categorise, verify, grill if needed, and write agent-ready briefs. |
| `mattpocock-skills:wait-what` | Stop. That last message did not land — re-pitch it. |
| `mattpocock-skills:wayfinder` | Plan a huge chunk of work — more than one agent session can hold — as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear. |
| `mattpocock-skills:wizard` | Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover. Don't invoke this for steps the agent can perform itself. |
| `mattpocock-skills:writing-beats` | Writing, exploit — assemble raw material into a journey of beats, grounding each term before a beat leans on it. |
| `mattpocock-skills:writing-for-agents` | Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md. |
| `mattpocock-skills:writing-fragments` | Writing, explore — mine raw fragments, no structure yet. |
| `mattpocock-skills:writing-shape` | Writing, exploit — shape raw material into an article, paragraph by paragraph. |

## Skill rời trong `~/.claude/skills/`

Cài bằng `npx skills` hoặc `claude plugin init`. Không thuộc marketplace nào.

| Skill | Mô tả |
|---|---|
| `find-skills` | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. This skill should be used when the user is looking for functionality that might exist as an installable skill. |
| `officecli` | Create, analyze, proofread, and modify Office documents (.docx, .xlsx, .pptx) using the officecli CLI tool. Use when the user wants to create, inspect, check formatting, find issues, add charts, or modify Office documents. |
