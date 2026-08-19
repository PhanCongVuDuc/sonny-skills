# Reads .claude/settings.json from the project root, finds every enabled
# *-lsp@claude-plugins-official entry, and installs the corresponding binary.
#
# Usage:
#   ./scripts/install-enabled-lsps.ps1               # install based on settings
#   ./scripts/install-enabled-lsps.ps1 -DryRun       # just print what would be installed
#
# Pair this with /setup-lsp (which edits .claude/settings.json) — the project lead
# runs /setup-lsp once, commits, and every collaborator just runs this script
# to get the binaries that match the committed settings.

[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$projectDir = if ($env:CLAUDE_PROJECT_DIR) { $env:CLAUDE_PROJECT_DIR } else { (Get-Location).Path }
$settingsPath = Join-Path $projectDir '.claude/settings.json'

if (-not (Test-Path $settingsPath)) {
    # Fresh repo before /setup-lsp has run: no-op so DevContainer postCreate keeps working.
    Write-Host "(.claude/settings.json not found yet - run /setup-lsp inside Claude Code first. Skipping LSP install.)"
    exit 0
}

$settings = Get-Content $settingsPath -Raw -Encoding utf8 | ConvertFrom-Json
$enabled = @()
if ($settings.PSObject.Properties.Name -contains 'enabledPlugins') {
    foreach ($prop in $settings.enabledPlugins.PSObject.Properties) {
        if ($prop.Value -eq $true) { $enabled += $prop.Name }
    }
}

function Invoke-Cmd($description, $cmd) {
    if ($DryRun) {
        Write-Host "DRY-RUN: $cmd"
    } else {
        Write-Host "RUN: $cmd"
        # NOTE: install strings must stay SINGLE commands. Windows PowerShell 5.1's
        # Invoke-Expression cannot parse '&&'/'||' chains — do not add compound commands here.
        Invoke-Expression $cmd
    }
}

function Check-Or-Install($binary, $installCmd) {
    if (Get-Command $binary -ErrorAction SilentlyContinue) {
        Write-Host "[OK] $binary already on PATH - skipping"
        return
    }
    Write-Host "[INSTALL] $binary"
    Invoke-Cmd $binary $installCmd
}

if ($enabled.Count -eq 0) {
    Write-Host "(no enabled plugins found in $settingsPath - run /setup-lsp first)"
    exit 0
}

foreach ($pluginId in $enabled) {
    switch ($pluginId) {
        'typescript-lsp@claude-plugins-official'   { Check-Or-Install 'typescript-language-server' 'npm install -g typescript-language-server typescript' }
        'pyright-lsp@claude-plugins-official'      { Check-Or-Install 'pyright-langserver' 'npm install -g pyright' }
        'gopls-lsp@claude-plugins-official'        { Check-Or-Install 'gopls' 'go install golang.org/x/tools/gopls@latest' }
        'rust-analyzer-lsp@claude-plugins-official'{ Check-Or-Install 'rust-analyzer' 'rustup component add rust-analyzer' }
        'clangd-lsp@claude-plugins-official' {
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                Check-Or-Install 'clangd' 'winget install --id LLVM.LLVM -e --accept-source-agreements --accept-package-agreements'
            } else {
                Write-Warning "clangd-lsp: install LLVM manually (winget not available)"
            }
        }
        'csharp-lsp@claude-plugins-official'       { Check-Or-Install 'csharp-ls' 'dotnet tool install --global csharp-ls' }
        'jdtls-lsp@claude-plugins-official' {
            if (Get-Command jdtls -ErrorAction SilentlyContinue) {
                Write-Host "[OK] jdtls already on PATH - skipping"
            } else {
                Write-Warning "jdtls-lsp: install manually from https://github.com/eclipse-jdtls/eclipse.jdt.ls"
            }
        }
        'kotlin-lsp@claude-plugins-official' {
            if (Get-Command kotlin-language-server -ErrorAction SilentlyContinue) {
                Write-Host "[OK] kotlin-language-server already on PATH - skipping"
            } else {
                Write-Warning "kotlin-lsp: download from https://github.com/fwcd/kotlin-language-server/releases"
            }
        }
        'swift-lsp@claude-plugins-official' {
            Write-Warning "swift-lsp: Swift toolchain on Windows has limited support. Consider WSL or skip."
        }
        'php-lsp@claude-plugins-official'          { Check-Or-Install 'intelephense' 'npm install -g intelephense' }
        'lua-lsp@claude-plugins-official' {
            if (Get-Command lua-language-server -ErrorAction SilentlyContinue) {
                Write-Host "[OK] lua-language-server already on PATH - skipping"
            } else {
                Write-Warning "lua-lsp: download from https://github.com/LuaLS/lua-language-server/releases"
            }
        }
        default {
            if ($pluginId -like '*-lsp@*') {
                Write-Warning "$pluginId : no auto-install rule. Install its binary manually."
            }
        }
    }
}

Write-Host ""
Write-Host "Done. Restart Claude Code to pick up newly installed LSP servers."
