# update-ai-docs.ps1 — cập nhật bộ docs do AI sinh, dựa trên git diff (bản Windows/PowerShell)
#
# Cách dùng:
#   .\update-ai-docs.ps1 dry-run   chỉ hiện diff (không cập nhật)
#   .\update-ai-docs.ps1 apply     thật sự gọi agent docs-keeper để cập nhật
#   .\update-ai-docs.ps1 force     cưỡng bức cập nhật toàn bộ kể cả khi không có diff

param(
    [ValidateSet("dry-run", "apply", "force")]
    [string]$Mode = "dry-run"
)

# git native đẩy warning ra stderr, nên để Stop thì cả warning vô hại cũng làm dừng script.
# Việc phán định kết thúc được làm tường minh bằng $LASTEXITCODE và kiểm tra rỗng, nên đặt Continue.
$ErrorActionPreference = "Continue"

$ProjectDir = $env:CLAUDE_PROJECT_DIR
if (-not $ProjectDir) {
    # Lệnh native không throw khi exit khác 0, nên phán định bằng $LASTEXITCODE chứ không dùng try/catch (tương đương `|| pwd` của bản bash)
    $ProjectDir = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $ProjectDir) { $ProjectDir = (Get-Location).Path }
}

# Đối tượng theo dõi: source C#, project file, và XAML nằm dưới các project thật của repo này (giống SRC_PATTERN của bản bash)
$SrcPattern = '^(Arent3d\.Architecture\.Routing[^/]*|Tests)/.*\.(cs|csproj|xaml)$'

function Write-Log {
    param([string]$Message)
    # Đẩy ra stderr giống log() của bản bash (để trống stdout dành cho dữ liệu)
    [Console]::Error.WriteLine("[arent-workflow/update-ai-docs] $Message")
}

function Require-Git {
    git -C $ProjectDir rev-parse --git-dir 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Không tìm thấy git repository. Bỏ qua."
        exit 0
    }
}

function Get-DiffRange {
    # Chạy ở máy local: nếu working tree dirty thì lấy diff so với HEAD.
    # Chạy trên CI: ngay sau checkout thì sạch nên fallback về khoảng đã commit
    #          (PR thì lấy diff so với base branch, push thì HEAD~1..HEAD. Tiền đề là fetch-depth: 2).
    $dirty = git -C $ProjectDir status --porcelain 2>$null
    if ($dirty) { return "HEAD" }
    if ($env:GITHUB_BASE_REF) {
        git -C $ProjectDir rev-parse --verify --quiet "origin/$($env:GITHUB_BASE_REF)" 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { return "origin/$($env:GITHUB_BASE_REF)...HEAD" }
    }
    git -C $ProjectDir rev-parse --verify --quiet "HEAD~1" 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { return "HEAD~1..HEAD" }
    return "HEAD"
}

function Get-ChangedSrcFiles {
    $range = Get-DiffRange
    $changed = git -C $ProjectDir diff --name-only $range 2>$null |
        Where-Object { $_ -match $SrcPattern }
    return $changed
}

switch ($Mode) {

    "dry-run" {
        Require-Git
        $changed = Get-ChangedSrcFiles
        if (-not $changed) {
            Write-Log "Không có file nào trong phạm vi bị thay đổi. Không cần cập nhật tài liệu."
            exit 0
        }
        Write-Log "Các file sau đã bị thay đổi (dry-run):"
        $changed | ForEach-Object { Write-Log "  $_" }
        Write-Log "Có khả năng cần cập nhật docs/domain/generated/."
        Write-Log "Hãy gọi 'update-ai-docs.ps1 apply' lúc chạy /handoff hoặc gọi tay."
    }

    "apply" {
        Require-Git
        $changed = Get-ChangedSrcFiles
        if (-not $changed) {
            Write-Log "Không có file nào trong phạm vi bị thay đổi. Bỏ qua."
            exit 0
        }

        Write-Log "Khởi động agent docs-keeper để cập nhật tài liệu trong generated/..."

        $diffSummary = git -C $ProjectDir diff --stat (Get-DiffRange) 2>$null | Select-Object -Last 1
        if (-not $diffSummary) { $diffSummary = "không rõ" }

        $changedList = $changed -join "`n"
        $prompt = @"
Với tư cách agent docs-keeper, hãy cập nhật tài liệu trong docs/domain/generated/ dựa trên các thay đổi sau.

Tóm tắt thay đổi: $diffSummary

File thay đổi:
$changedList

Thủ tục:
1. Đọc các file đã thay đổi, xác định phạm vi ảnh hưởng
2. Cập nhật docs/domain/generated/code_map.md (mô tả của module bị thay đổi)
3. Cập nhật docs/domain/generated/dependencies.md (thay đổi về quan hệ phụ thuộc)
4. Cập nhật docs/domain/generated/module_index.md (thay đổi về entry point và API công khai)

Lưu ý: không được xoá thông tin đã được xác nhận từ trước. Chỉ cập nhật đúng những chỗ bị thay đổi.
"@

        if (Get-Command claude -ErrorAction SilentlyContinue) {
            claude --agent docs-keeper -p $prompt `
                --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" `
                --output-format text 2>&1 | ForEach-Object { Write-Log $_ }
        } else {
            Write-Log "ERROR: không tìm thấy claude CLI. Trên CI hãy cài Claude Code (npm install -g @anthropic-ai/claude-code)."
            Write-Log "Prompt để khởi động agent docs-keeper bằng tay:"
            Write-Host $prompt
            exit 1
        }
    }

    "force" {
        Write-Log "Cưỡng bức sinh lại toàn bộ tài liệu..."

        $prompt = @"
Với tư cách agent docs-keeper, hãy quét toàn bộ code của project
và sinh lại toàn bộ tài liệu trong docs/domain/generated/.

1. docs/domain/generated/code_map.md — bản đồ toàn bộ module, class, hàm
2. docs/domain/generated/dependencies.md — đồ thị phụ thuộc (nội bộ và bên ngoài)
3. docs/domain/generated/module_index.md — danh sách entry point và API công khai

Lưu ý: nếu file đã tồn tại thì ghi đè.
"@

        if (Get-Command claude -ErrorAction SilentlyContinue) {
            claude --agent docs-keeper -p $prompt `
                --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" `
                --output-format text 2>&1 | ForEach-Object { Write-Log $_ }
        } else {
            Write-Log "ERROR: không tìm thấy claude CLI. Trên CI hãy cài Claude Code (npm install -g @anthropic-ai/claude-code)."
            exit 1
        }
    }
}
