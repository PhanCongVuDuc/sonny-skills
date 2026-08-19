# update-ai-docs.ps1 — AI生成ドキュメントを git diff に基づいて更新する (Windows/PowerShell版)
#
# 使い方:
#   .\update-ai-docs.ps1 dry-run   差分のみ表示（更新しない）
#   .\update-ai-docs.ps1 apply     実際に docs-keeper エージェントを呼び出して更新
#   .\update-ai-docs.ps1 force     差分なしでも強制的に全更新

param(
    [ValidateSet("dry-run", "apply", "force")]
    [string]$Mode = "dry-run"
)

# native git は警告を stderr に出すため、Stop だと benign な警告でも中断してしまう。
# 終了判定は $LASTEXITCODE と空チェックで明示的に行うため Continue にする。
$ErrorActionPreference = "Continue"

$ProjectDir = $env:CLAUDE_PROJECT_DIR
if (-not $ProjectDir) {
    # native コマンドは非0終了でも throw しないため try/catch でなく $LASTEXITCODE で判定する（bash 版の `|| pwd` と等価）
    $ProjectDir = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $ProjectDir) { $ProjectDir = (Get-Location).Path }
}

# 監視対象: この repo の実プロジェクト配下の C# ソース・プロジェクトファイル・XAML（bash 版 SRC_PATTERN と同一）
$SrcPattern = '^(Arent3d\.Architecture\.Routing[^/]*|Tests)/.*\.(cs|csproj|xaml)$'

function Write-Log {
    param([string]$Message)
    # bash 版 log() と同じく stderr へ出す（stdout をデータ用に空けておく）
    [Console]::Error.WriteLine("[arent-workflow/update-ai-docs] $Message")
}

function Require-Git {
    git -C $ProjectDir rev-parse --git-dir 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Log "git リポジトリが見つかりません。スキップします。"
        exit 0
    }
}

function Get-DiffRange {
    # ローカル実行: 作業ツリーが dirty なら HEAD との差分。
    # CI 実行: checkout 直後はクリーンなためコミット済み範囲へフォールバック
    #          （PR は base ブランチとの差分、push は HEAD~1..HEAD。fetch-depth: 2 前提）。
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
            Write-Log "変更対象ファイルなし。ドキュメント更新は不要です。"
            exit 0
        }
        Write-Log "以下のファイルが変更されました（dry-run）:"
        $changed | ForEach-Object { Write-Log "  $_" }
        Write-Log "docs/domain/generated/ の更新が必要な可能性があります。"
        Write-Log "/handoff 実行時または手動で 'update-ai-docs.ps1 apply' を呼び出してください。"
    }

    "apply" {
        Require-Git
        $changed = Get-ChangedSrcFiles
        if (-not $changed) {
            Write-Log "変更対象ファイルなし。スキップします。"
            exit 0
        }

        Write-Log "docs-keeper エージェントを起動して generated/ ドキュメントを更新します..."

        $diffSummary = git -C $ProjectDir diff --stat (Get-DiffRange) 2>$null | Select-Object -Last 1
        if (-not $diffSummary) { $diffSummary = "不明" }

        $changedList = $changed -join "`n"
        $prompt = @"
docs-keeper エージェントとして、以下の変更に基づいて docs/domain/generated/ のドキュメントを更新してください。

変更サマリ: $diffSummary

変更ファイル:
$changedList

手順:
1. 変更されたファイルを読み込み、影響範囲を特定する
2. docs/domain/generated/code_map.md を更新（変更モジュールの記述）
3. docs/domain/generated/dependencies.md を更新（依存関係の変化）
4. docs/domain/generated/module_index.md を更新（エントリポイント・公開APIの変化）

注意: 既存の確認済み情報を消さないこと。変更された箇所のみ更新する。
"@

        if (Get-Command claude -ErrorAction SilentlyContinue) {
            claude --agent docs-keeper -p $prompt `
                --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" `
                --output-format text 2>&1 | ForEach-Object { Write-Log $_ }
        } else {
            Write-Log "ERROR: claude CLI が見つかりません。CI では Claude Code をインストールしてください（npm install -g @anthropic-ai/claude-code）。"
            Write-Log "手動で docs-keeper エージェントを起動する場合のプロンプト:"
            Write-Host $prompt
            exit 1
        }
    }

    "force" {
        Write-Log "全ドキュメントを強制再生成します..."

        $prompt = @"
docs-keeper エージェントとして、プロジェクト全体のコードを走査して
docs/domain/generated/ の全ドキュメントを再生成してください。

1. docs/domain/generated/code_map.md — 全モジュール・クラス・関数の地図
2. docs/domain/generated/dependencies.md — 依存関係グラフ（内部・外部）
3. docs/domain/generated/module_index.md — エントリポイント・公開API一覧

注意: 既存ファイルが存在する場合は上書きする。
"@

        if (Get-Command claude -ErrorAction SilentlyContinue) {
            claude --agent docs-keeper -p $prompt `
                --allowedTools "Read,Write,Edit,Grep,Glob,Bash(git*)" `
                --output-format text 2>&1 | ForEach-Object { Write-Log $_ }
        } else {
            Write-Log "ERROR: claude CLI が見つかりません。CI では Claude Code をインストールしてください（npm install -g @anthropic-ai/claude-code）。"
            exit 1
        }
    }
}
