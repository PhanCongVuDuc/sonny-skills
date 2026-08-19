# Hooks

Hooks are shell commands the Claude Code harness runs automatically at specific lifecycle events. They are **NOT executed by Claude** — they are configured in `settings.json` and run by the harness itself. This means hooks can enforce rules that prompts or memory cannot.

## How to enable a hook

1. Make the script executable and adjust to your project:
   ```bash
   cp .claude/hooks/post-edit-format.sh.example .claude/hooks/post-edit-format.sh
   chmod +x .claude/hooks/post-edit-format.sh
   ```
2. Register it in `.claude/settings.json` under the `hooks` key. See the snippets below.
3. Restart Claude Code (or start a new session) for the hook to take effect.

## Files in this directory

| File | Event | Purpose |
|---|---|---|
| `post-edit-format.sh.example` | `PostToolUse` (Edit/Write) | Auto-format files after Claude edits them |
| `pre-bash-guard.sh.example` | `PreToolUse` (Bash) | Block dangerous shell commands before they run |

## Registering hooks in settings.json

### Auto-format after Edit/Write

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/post-edit-format.sh"
          }
        ]
      }
    ]
  }
}
```

### Guard against dangerous Bash commands

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/pre-bash-guard.sh"
          }
        ]
      }
    ]
  }
}
```

## Hook types

Each entry in the `hooks` array has a `type` field.

| type | What it does |
|---|---|
| `command` | Runs a local shell command / script (most common) |
| `http` | Sends an HTTP POST request to a webhook endpoint |
| `mcp_tool` | Calls an MCP tool (must be configured in `.mcp.json`) |
| `prompt` | Appends a prompt to Claude's next turn |
| `agent` | Spawns a subagent to handle the hook event (experimental) |

### Common hook fields

```json
{
  "type": "command",
  "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/script.sh",
  "args": [],
  "if": "Bash(git push *)",
  "timeout": 600,
  "statusMessage": "Validating...",
  "once": false,
  "async": false,
  "asyncRewake": false,
  "shell": "bash"
}
```

| Field | Description |
|---|---|
| `if` | Conditional filter (permission-rule syntax). Hook fires only when condition matches. |
| `timeout` | Seconds before hook is killed. Default: 600 (30 for `UserPromptSubmit`). |
| `statusMessage` | Text shown in spinner while hook runs. |
| `once` | `true` = run only once per session, not on every matching event. |
| `async` | `true` = run in background, don't block Claude's response. |
| `asyncRewake` | `true` = background + wake Claude if the hook exits with code 2. |
| `shell` | `"bash"` (default) or `"powershell"`. |

### Exec form vs shell form

**Exec form** — use `args` for safe argument passing (no shell interpolation):
```json
{
  "type": "command",
  "command": "node",
  "args": ["${CLAUDE_PLUGIN_ROOT}/scripts/format.js", "--fix"]
}
```

**Shell form** — omit `args`, write full shell string (pipes/redirects supported):
```json
{
  "type": "command",
  "command": "npx prettier --write \"${tool_input.file_path}\""
}
```

### Conditional hooks with `if:`

The `if` field restricts when a hook fires within a matched event. Uses the same permission-rule syntax as `permissions.allow`.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/pre-bash-guard.sh",
            "if": "Bash(git push *)"
          }
        ]
      }
    ]
  }
}
```

The hook above fires **only** when the Bash command starts with `git push`, not on every Bash call.

### Example: HTTP webhook hook

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "http",
            "url": "https://hooks.example.com/notify",
            "headers": { "Authorization": "Bearer $MY_TOKEN" },
            "allowedEnvVars": ["MY_TOKEN"]
          }
        ]
      }
    ]
  }
}
```

## Lifecycle events

### Session & turn events

| Event | When it fires | Can block |
|---|---|---|
| `SessionStart` | Session begins or resumes | No |
| `Setup` | `--init-only` / `--maintenance` flag used | No |
| `SessionEnd` | Session terminates | No |
| `UserPromptSubmit` | User sends a message | Yes |
| `UserPromptExpansion` | Slash command expands | Yes |
| `Stop` | Claude finishes a response turn | Yes |
| `StopFailure` | Turn ends due to API error | No |

### Tool execution events

| Event | When it fires | Can block |
|---|---|---|
| `PreToolUse` | Before any tool call | Yes |
| `PostToolUse` | After tool call succeeds | No |
| `PostToolUseFailure` | After tool call fails | No |
| `PostToolBatch` | After parallel batch resolves | Yes |
| `PermissionRequest` | Permission dialog appears | Yes |
| `PermissionDenied` | Tool call denied by auto-mode | No |

### Subagent & task events

| Event | When it fires | Can block |
|---|---|---|
| `SubagentStart` | Subagent starts | No |
| `SubagentStop` | Subagent finishes | No |
| `TaskCreated` | Task created | Yes |
| `TaskCompleted` | Task completed | Yes |
| `TeammateIdle` | Agent team teammate goes idle | Yes |

### Context & config events

| Event | When it fires | Can block |
|---|---|---|
| `PreCompact` | Before context compaction | Yes |
| `PostCompact` | After context compaction | No |
| `InstructionsLoaded` | CLAUDE.md / rules loaded (useful for debugging) | No |
| `ConfigChange` | Settings file changed | Yes |
| `CwdChanged` | Working directory changed | No |
| `FileChanged` | Watched file changed (set via `watchPaths` in SessionStart hook) | No |
| `WorktreeCreate` | Git worktree created | Yes |
| `WorktreeRemove` | Git worktree removed | No |

### Other events

| Event | When it fires | Can block |
|---|---|---|
| `Notification` | Claude Code notification emitted | No |
| `Elicitation` | MCP server requests user input | Yes |
| `ElicitationResult` | User responds to MCP input prompt | Yes |

## Matcher syntax

| Pattern | Evaluation |
|---|---|
| `"*"` or `""` | Match all occurrences |
| Letters/digits/`_`/`\|` | Exact string or pipe-separated list: `Edit\|Write` |
| Other characters | Regex: `^Notebook`, `mcp__memory__.*` |

**Event-specific match targets:**

| Event | Matches against |
|---|---|
| Tool events | Tool name: `Bash`, `Edit`, `mcp__memory__.*` |
| `SessionStart` | Session source: `startup`, `resume`, `clear`, `compact` |
| `Setup` | CLI trigger: `init`, `maintenance` |
| `SessionEnd` | Exit reason: `clear`, `resume`, `logout` |
| `SubagentStart`/`SubagentStop` | Agent type: `general-purpose`, `Explore`, custom names |
| `PreCompact`/`PostCompact` | Compaction trigger: `manual`, `auto` |
| `Notification` | Notification type: `permission_prompt`, `auth_success` |
| `ConfigChange` | Config source: `user_settings`, `project_settings` |
| `FileChanged` | Literal filenames: `.envrc\|.env` |
| `StopFailure` | Error type: `rate_limit`, `authentication_failed` |
| `InstructionsLoaded` | Load reason: `session_start`, `nested_traversal` |
| `UserPromptExpansion` | Command/skill name |

## Exit code semantics

| Code | Effect |
|---|---|
| `0` | Success. stdout may be parsed as JSON for richer control. |
| `2` | Blocking error. For `PreToolUse`/`UserPromptSubmit`/`PermissionRequest`/`Stop` etc., the action is blocked. stderr is shown to Claude. |
| other | Non-blocking error. stderr's first line is shown; Claude continues. |

### JSON output from hooks (exit 0)

Hooks can return JSON on stdout to control Claude's behavior:

```json
{
  "continue": true,
  "stopReason": "Build failed",
  "suppressOutput": false,
  "systemMessage": "Warning: linting failed"
}
```

For `PreToolUse` — allow/deny/ask decisions:
```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "additionalContext": "Branch: main — proceed with caution"
  }
}
```

## Useful environment variables in hooks

| Variable | Value |
|---|---|
| `CLAUDE_PROJECT_DIR` | Absolute path to project root |
| `CLAUDE_PLUGIN_ROOT` | Plugin install directory (inside plugins only) |
| `CLAUDE_PLUGIN_DATA` | Plugin persistent data directory (survives updates) |
| `CLAUDE_ENV_FILE` | File path for persisting env vars (write `export KEY=value` here in `SessionStart`/`CwdChanged`/`FileChanged` hooks) |
| `CLAUDE_CODE_REMOTE` | `"true"` in web environment, unset in CLI |
| `CLAUDE_EFFORT` | Current effort level: `low`, `medium`, `high`, `xhigh`, `max` |

Tool input is piped to stdin as JSON for `PreToolUse`/`PostToolUse`.

### Persisting environment variables via `CLAUDE_ENV_FILE`

Write `export KEY=value` lines to `$CLAUDE_ENV_FILE` in a `SessionStart` hook to inject variables into all subsequent Bash commands:

```bash
#!/usr/bin/env bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=development' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi
```

## Reference

https://code.claude.com/docs/en/hooks
