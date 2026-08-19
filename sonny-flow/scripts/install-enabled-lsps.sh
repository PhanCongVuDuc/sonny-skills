#!/usr/bin/env bash
# Reads .claude/settings.json from the project root, finds every enabled
# *-lsp@claude-plugins-official entry, and installs the corresponding binary.
#
# Usage:
#   ./scripts/install-enabled-lsps.sh             # install based on settings
#   ./scripts/install-enabled-lsps.sh --dry-run   # just print what would be installed
#
# Designed to be re-runnable: each install command is idempotent (or close to it).
# Skips silently if the binary is already on PATH.
#
# Pair this with /setup-lsp (which edits .claude/settings.json) — the project lead
# runs /setup-lsp once, commits, and every collaborator just runs this script
# to get the binaries that match the committed settings.

set -eu

DRY_RUN=0
if [[ "${1:-}" = "--dry-run" ]]; then
  DRY_RUN=1
fi

SETTINGS="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/settings.json"
if [[ ! -f "$SETTINGS" ]]; then
  # Fresh repo before /setup-lsp has run: no-op so DevContainer postCreate keeps working.
  echo "(.claude/settings.json not found yet — run /setup-lsp inside Claude Code first. Skipping LSP install.)"
  exit 0
fi

# Need jq for reliable JSON parsing.
if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required. Install it first (apt-get install jq / brew install jq)." >&2
  exit 1
fi

# Pull the list of enabled plugin keys.
enabled=$(jq -r '.enabledPlugins // {} | to_entries[] | select(.value == true) | .key' "$SETTINGS")

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "DRY-RUN: $*"
  else
    echo "RUN: $*"
    # NOTE: install strings must stay single commands (mirrors the PowerShell version,
    # whose Invoke-Expression cannot parse '&&'/'||'). Do not add compound commands here.
    eval "$@"
  fi
  return 0
}

check_or_install() {
  local binary="$1"; shift
  local install_cmd="$*"
  if command -v "$binary" >/dev/null 2>&1; then
    echo "✓ $binary already on PATH — skipping"
    return 0
  fi
  echo "→ installing $binary"
  run "$install_cmd"
}

# here-string で回す（`echo | while` のパイプはサブシェルになり count の加算が親に反映されない）
count=0
while IFS= read -r plugin_id; do
  [[ -z "$plugin_id" ]] && continue
  count=$((count + 1))
  case "$plugin_id" in
    typescript-lsp@claude-plugins-official)
      check_or_install typescript-language-server "npm install -g typescript-language-server typescript"
      ;;
    pyright-lsp@claude-plugins-official)
      check_or_install pyright-langserver "npm install -g pyright"
      ;;
    gopls-lsp@claude-plugins-official)
      check_or_install gopls "go install golang.org/x/tools/gopls@latest"
      ;;
    rust-analyzer-lsp@claude-plugins-official)
      check_or_install rust-analyzer "rustup component add rust-analyzer"
      ;;
    clangd-lsp@claude-plugins-official)
      if command -v apt-get >/dev/null 2>&1; then
        check_or_install clangd "sudo apt-get install -y clangd"
      elif command -v brew >/dev/null 2>&1; then
        check_or_install clangd "brew install llvm"
      else
        echo "⚠ clangd-lsp: no apt/brew detected. Install clangd manually." >&2
      fi
      ;;
    csharp-lsp@claude-plugins-official)
      check_or_install csharp-ls "dotnet tool install --global csharp-ls"
      ;;
    jdtls-lsp@claude-plugins-official)
      if command -v jdtls >/dev/null 2>&1; then
        echo "✓ jdtls already on PATH — skipping"
      else
        echo "⚠ jdtls-lsp: install manually from https://github.com/eclipse-jdtls/eclipse.jdt.ls" >&2
      fi
      ;;
    kotlin-lsp@claude-plugins-official)
      if command -v kotlin-language-server >/dev/null 2>&1; then
        echo "✓ kotlin-language-server already on PATH — skipping"
      else
        echo "⚠ kotlin-lsp: download from https://github.com/fwcd/kotlin-language-server/releases" >&2
      fi
      ;;
    swift-lsp@claude-plugins-official)
      if command -v sourcekit-lsp >/dev/null 2>&1; then
        echo "✓ sourcekit-lsp already on PATH — skipping"
      else
        echo "⚠ swift-lsp: install Swift toolchain / Xcode (sourcekit-lsp ships with it)" >&2
      fi
      ;;
    php-lsp@claude-plugins-official)
      check_or_install intelephense "npm install -g intelephense"
      ;;
    lua-lsp@claude-plugins-official)
      if command -v lua-language-server >/dev/null 2>&1; then
        echo "✓ lua-language-server already on PATH — skipping"
      else
        echo "⚠ lua-lsp: download from https://github.com/LuaLS/lua-language-server/releases" >&2
      fi
      ;;
    *-lsp@*)
      echo "⚠ $plugin_id: no auto-install rule for this LSP plugin. Install its binary manually." >&2
      ;;
    *)
      # not an LSP plugin — ignore
      ;;
  esac
done <<< "$enabled"

if [[ "$count" -eq 0 ]]; then
  echo "(no enabled plugins found in $SETTINGS — run /setup-lsp first)"
fi

echo ""
echo "Done. Restart Claude Code to pick up newly installed LSP servers."
