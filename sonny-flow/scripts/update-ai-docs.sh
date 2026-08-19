#!/usr/bin/env bash
# update-ai-docs.sh — cập nhật bộ docs do AI sinh, dựa trên git diff
#
# Cách dùng:
#   update-ai-docs.sh dry-run   chỉ hiện diff (không cập nhật)
#   update-ai-docs.sh apply     thật sự gọi agent docs-keeper để cập nhật
#   update-ai-docs.sh force     cưỡng bức cập nhật toàn bộ kể cả khi không có diff

set -euo pipefail

MODE="${1:-dry-run}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
GENERATED_DIR="${PROJECT_DIR}/docs/domain/generated"
HANDOFF_DIR="${PROJECT_DIR}/deliverables/handoff"

# Đối tượng theo dõi: source C#, project file, và XAML nằm dưới các project thật của repo này
SRC_PATTERN='^(Arent3d\.Architecture\.Routing[^/]*|Tests)/.*\.(cs|csproj|xaml)$'

# ─── Hàm phụ trợ ──────────────────────────────────────────────────

log() {
  echo "[arent-workflow/update-ai-docs] $*" >&2
  return 0
}

require_git() {
  if ! git -C "${PROJECT_DIR}" rev-parse --git-dir &>/dev/null; then
    log "Không tìm thấy git repository. Bỏ qua."
    exit 0
  fi
  return 0
}

get_diff_range() {
  # Chạy ở máy local: nếu working tree dirty thì lấy diff so với HEAD (đã stage + chưa stage).
  # Chạy trên CI: ngay sau checkout thì working tree sạch, nên fallback về khoảng đã commit
  #          (PR thì lấy diff so với base branch, push thì HEAD~1..HEAD. Tiền đề là fetch-depth: 2).
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

# ─── Xử lý theo từng chế độ ────────────────────────────────────────────

case "${MODE}" in

  dry-run)
    require_git
    CHANGED=$(get_changed_src_files)
    if [[ -z "${CHANGED}" ]]; then
      log "Không có file nào trong phạm vi bị thay đổi. Không cần cập nhật tài liệu."
      exit 0
    fi
    log "Các file sau đã bị thay đổi (dry-run):"
    echo "${CHANGED}" | while read -r f; do log "  ${f}"; done
    log "Có khả năng cần cập nhật docs/domain/generated/."
    log "Hãy gọi 'update-ai-docs.sh apply' lúc chạy /handoff hoặc gọi tay."
    ;;

  apply)
    require_git
    CHANGED=$(get_changed_src_files)
    if [[ -z "${CHANGED}" ]]; then
      log "Không có file nào trong phạm vi bị thay đổi. Bỏ qua."
      exit 0
    fi

    log "Khởi động agent docs-keeper để cập nhật tài liệu trong generated/..."

    DIFF_SUMMARY=$(git -C "${PROJECT_DIR}" diff --stat "$(get_diff_range)" 2>/dev/null | tail -1 || echo "không rõ")
    PROMPT="$(cat <<PROMPT
Với tư cách agent docs-keeper, hãy cập nhật tài liệu trong docs/domain/generated/ dựa trên các thay đổi sau.

Tóm tắt thay đổi: ${DIFF_SUMMARY}

File thay đổi:
${CHANGED}

Thủ tục:
1. Đọc các file đã thay đổi, xác định phạm vi ảnh hưởng
2. Cập nhật docs/domain/generated/code_map.md (mô tả của module bị thay đổi)
3. Cập nhật docs/domain/generated/dependencies.md (thay đổi về quan hệ phụ thuộc)
4. Cập nhật docs/domain/generated/module_index.md (thay đổi về entry point và API công khai)

Lưu ý: không được xoá thông tin đã được xác nhận từ trước. Chỉ cập nhật đúng những chỗ bị thay đổi.
PROMPT
)"

    if command -v claude &>/dev/null; then
      claude --agent docs-keeper -p "${PROMPT}" \
        --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" \
        --output-format text \
        2>&1 | while read -r line; do log "${line}"; done
    else
      log "ERROR: không tìm thấy claude CLI. Trên CI hãy cài Claude Code (npm install -g @anthropic-ai/claude-code)."
      log "Prompt để khởi động agent docs-keeper bằng tay:"
      echo "${PROMPT}"
      exit 1
    fi
    ;;

  force)
    log "Cưỡng bức sinh lại toàn bộ tài liệu..."

    PROMPT="$(cat <<PROMPT
Với tư cách agent docs-keeper, hãy quét toàn bộ code của project
và sinh lại toàn bộ tài liệu trong docs/domain/generated/.

1. docs/domain/generated/code_map.md — bản đồ toàn bộ module, class, hàm
2. docs/domain/generated/dependencies.md — đồ thị phụ thuộc (nội bộ và bên ngoài)
3. docs/domain/generated/module_index.md — danh sách entry point và API công khai

Lưu ý: nếu file đã tồn tại thì ghi đè.
PROMPT
)"

    if command -v claude &>/dev/null; then
      claude --agent docs-keeper -p "${PROMPT}" \
        --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" \
        --output-format text \
        2>&1 | while read -r line; do log "${line}"; done
    else
      log "ERROR: không tìm thấy claude CLI. Trên CI hãy cài Claude Code (npm install -g @anthropic-ai/claude-code)."
      exit 1
    fi
    ;;

  *)
    echo "Cách dùng: $0 [dry-run|apply|force]" >&2
    exit 1
    ;;
esac
