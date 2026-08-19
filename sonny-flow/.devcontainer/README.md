# Dev Container

Reproducible development environment for the team. Every member gets the same Claude Code + LSP setup with one click.

## How LSP installation works

This DevContainer **doesn't hardcode which LSP servers to install**. Instead, it reads `.claude/settings.json` and installs only the LSP binaries the project actually uses.

The flow:

```
1. Project lead runs /setup-lsp inside Claude Code (once)
        ↓
   .claude/settings.json gets enabledPlugins entries like:
   "typescript-lsp@claude-plugins-official": true
   "pyright-lsp@claude-plugins-official": true
        ↓
2. Lead commits .claude/settings.json
        ↓
3. Team member clones repo → "Reopen in Container" in VS Code
        ↓
4. postCreateCommand runs ./scripts/install-enabled-lsps.sh
        ↓
   Script reads enabledPlugins → installs typescript-language-server + pyright
        ↓
5. Member starts Claude → official LSP plugins find their binaries → work
```

If `.claude/settings.json` doesn't exist yet (fresh project), the install script is a safe no-op.

## What you get

- Ubuntu base image with **Node.js LTS**, **Python 3.12**, **`gh` CLI**, **`jq`** preinstalled
- Anthropic's official `claude-code:1.0` devcontainer feature (installs `claude` CLI)
- LSP binaries auto-installed based on `.claude/settings.json`
- Named volume mount for `~/.claude` so login state, agent memory, and config survive container rebuilds
- Auto-updater disabled for reproducibility
- VS Code Claude Code extension auto-installed

## How to use

### VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open this project in VS Code
3. `F1` → "Dev Containers: Reopen in Container"
4. After build: `claude` is on PATH, plus whichever LSP binaries are listed in `.claude/settings.json`'s `enabledPlugins`.

### GitHub Codespaces

Click "Code → Codespaces → Create codespace". Same config, no local install needed.

### CLI

```bash
npm install -g @devcontainers/cli
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . claude --version
```

## Adding a new language later

Inside the container, the project lead runs:

```
/setup-lsp
```

…to add a new language to `enabledPlugins`. Commit the result. After the next container rebuild (or by re-running `./scripts/install-enabled-lsps.sh` directly), the new LSP binary appears on PATH.

## Languages outside the official 11

If your project uses Vue, Svelte, Astro, or another framework whose LSP isn't in the official marketplace, you'll need to:

1. Fork `examples/plugin-template/plugins/lsp-typescript/` and build a custom LSP plugin
2. Install its binary by extending `postCreateCommand` manually:
   ```jsonc
   "postCreateCommand": "... && ./scripts/install-enabled-lsps.sh && npm install -g @vue/language-server && ..."
   ```

The `install-enabled-lsps.sh` script only handles the 11 official plugins. Custom plugins need a manual install step.

## Reference

- https://code.claude.com/docs/en/devcontainer
- https://code.claude.com/docs/en/discover-plugins (official LSP plugin list)
- https://containers.dev/features
