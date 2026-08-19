#!/usr/bin/env bash
# update-ai-docs.sh — AI生成ドキュメントを git diff に基づいて更新する
#
# 使い方:
#   update-ai-docs.sh dry-run   差分のみ表示（更新しない）
#   update-ai-docs.sh apply     実際に docs-keeper エージェントを呼び出して更新
#   update-ai-docs.sh force     差分なしでも強制的に全更新

set -euo pipefail

MODE="${1:-dry-run}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
GENERATED_DIR="${PROJECT_DIR}/docs/domain/generated"
HANDOFF_DIR="${PROJECT_DIR}/deliverables/handoff"

# 監視対象: この repo の実プロジェクト配下の C# ソース・プロジェクトファイル・XAML
SRC_PATTERN='^(Arent3d\.Architecture\.Routing[^/]*|Tests)/.*\.(cs|csproj|xaml)$'

# ─── ヘルパー ──────────────────────────────────────────────────

log() {
  echo "[arent-workflow/update-ai-docs] $*" >&2
  return 0
}

require_git() {
  if ! git -C "${PROJECT_DIR}" rev-parse --git-dir &>/dev/null; then
    log "git リポジトリが見つかりません。スキップします。"
    exit 0
  fi
  return 0
}

get_diff_range() {
  # ローカル実行: 作業ツリーが dirty なら HEAD との差分（ステージ済み＋未ステージ）。
  # CI 実行: checkout 直後は作業ツリーがクリーンなため、コミット済み範囲へフォールバック
  #          （PR は base ブランチとの差分、push は HEAD~1..HEAD。fetch-depth: 2 前提）。
  if [[ -n "$(git -C "${PROJECT_DIR}" status --porcelain 2>/dev/null)" ]]; then
    echo "HEAD"
  elif [[ -n "${GITHUB_BASE_REF:-}" ]] && git -C "${PROJECT_DIR}" rev-parse --verify --quiet "origin/${GITHUB_BASE_REF}" >/dev/null; then
    echo "origin/${GITHUB_BASE_REF}...HEAD"
  elif git -C "${PROJECT_DIR}" rev-parse --verify --quiet HEAD~1 >/dev/null; then
    echo "HEAD~1..HEAD"
  else
    echo "HEAD"
  fi
  return 0
}

get_changed_src_files() {
  git -C "${PROJECT_DIR}" diff --name-only "$(get_diff_range)" 2>/dev/null \
    | grep -E "${SRC_PATTERN}" \
    || true
  return 0
}

# ─── モード別処理 ────────────────────────────────────────────

case "${MODE}" in

  dry-run)
    require_git
    CHANGED=$(get_changed_src_files)
    if [[ -z "${CHANGED}" ]]; then
      log "変更対象ファイルなし。ドキュメント更新は不要です。"
      exit 0
    fi
    log "以下のファイルが変更されました（dry-run）:"
    echo "${CHANGED}" | while read -r f; do log "  ${f}"; done
    log "docs/domain/generated/ の更新が必要な可能性があります。"
    log "/handoff 実行時または手動で 'update-ai-docs.sh apply' を呼び出してください。"
    ;;

  apply)
    require_git
    CHANGED=$(get_changed_src_files)
    if [[ -z "${CHANGED}" ]]; then
      log "変更対象ファイルなし。スキップします。"
      exit 0
    fi

    log "docs-keeper エージェントを起動して generated/ ドキュメントを更新します..."

    DIFF_SUMMARY=$(git -C "${PROJECT_DIR}" diff --stat "$(get_diff_range)" 2>/dev/null | tail -1 || echo "不明")
    PROMPT="$(cat <<PROMPT
docs-keeper エージェントとして、以下の変更に基づいて docs/domain/generated/ のドキュメントを更新してください。

変更サマリ: ${DIFF_SUMMARY}

変更ファイル:
${CHANGED}

手順:
1. 変更されたファイルを読み込み、影響範囲を特定する
2. docs/domain/generated/code_map.md を更新（変更モジュールの記述）
3. docs/domain/generated/dependencies.md を更新（依存関係の変化）
4. docs/domain/generated/module_index.md を更新（エントリポイント・公開APIの変化）

注意: 既存の確認済み情報を消さないこと。変更された箇所のみ更新する。
PROMPT
)"

    if command -v claude &>/dev/null; then
      claude --agent docs-keeper -p "${PROMPT}" \
        --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" \
        --output-format text \
        2>&1 | while read -r line; do log "${line}"; done
    else
      log "ERROR: claude CLI が見つかりません。CI では Claude Code をインストールしてください（npm install -g @anthropic-ai/claude-code）。"
      log "手動で docs-keeper エージェントを起動する場合のプロンプト:"
      echo "${PROMPT}"
      exit 1
    fi
    ;;

  force)
    log "全ドキュメントを強制再生成します..."

    PROMPT="$(cat <<PROMPT
docs-keeper エージェントとして、プロジェクト全体のコードを走査して
docs/domain/generated/ の全ドキュメントを再生成してください。

1. docs/domain/generated/code_map.md — 全モジュール・クラス・関数の地図
2. docs/domain/generated/dependencies.md — 依存関係グラフ（内部・外部）
3. docs/domain/generated/module_index.md — エントリポイント・公開API一覧

注意: 既存ファイルが存在する場合は上書きする。
PROMPT
)"

    if command -v claude &>/dev/null; then
      claude --agent docs-keeper -p "${PROMPT}" \
        --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" \
        --output-format text \
        2>&1 | while read -r line; do log "${line}"; done
    else
      log "ERROR: claude CLI が見つかりません。CI では Claude Code をインストールしてください（npm install -g @anthropic-ai/claude-code）。"
      exit 1
    fi
    ;;

  *)
    echo "使い方: $0 [dry-run|apply|force]" >&2
    exit 1
    ;;
esac
