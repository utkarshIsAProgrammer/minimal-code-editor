# ===================================================================
#  ⚡ Minimal Code Editor - Windows Native PowerShell Installer
#  Usage: irm https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.ps1 | iex
# ===================================================================

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/utkarshIsAProgrammer/minimal-code-editor.git"
$Branch  = "main"

Write-Host ""
Write-Host '  __  __ _       _                 _ ' -ForegroundColor Cyan
Write-Host ' |  \/  (_)_ __ (_)_ __ ___   __ _| |' -ForegroundColor Cyan
Write-Host ' | |\/| | | ''_ \| | ''_ ` _ \ / _` | |' -ForegroundColor Cyan
Write-Host ' | |  | | | | | | | | | | | | (_| | |' -ForegroundColor Cyan
Write-Host ' |_|  |_|_|_| |_|_|_| |_| |_|\__,_|_|' -ForegroundColor Cyan
Write-Host "  The Lightning-Fast Minimalist Code Editor" -ForegroundColor White
Write-Host "  Native Windows Setup" -ForegroundColor DarkCyan
Write-Host ""

# -------------------------------------------------------------------
# 1. Check Prerequisites
# -------------------------------------------------------------------
Write-Host "🔍 Checking prerequisites..." -ForegroundColor White

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "✘ Error: 'git' is not installed or not in PATH." -ForegroundColor Red
    Write-Host "  Install via winget: winget install Git.Git" -ForegroundColor Yellow
    exit 1
}

# Check Neovim
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host "⚠ Warning: 'nvim' (Neovim) was not found in PATH." -ForegroundColor Yellow
    Write-Host "  Attempting to install Neovim via winget..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Neovim.Neovim --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "  Please install Neovim from https://neovim.io and rerun this script." -ForegroundColor Yellow
    }
} else {
    $nvimVer = (nvim --version | Select-Object -First 1)
    Write-Host "  ✔ Found $nvimVer" -ForegroundColor Green
}

# -------------------------------------------------------------------
# 2. Download / Locate Files
# -------------------------------------------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path -ErrorAction SilentlyContinue

if ($ScriptDir -and (Test-Path "$ScriptDir\config\vsc\init.lua")) {
    $SrcDir = $ScriptDir
    Write-Host "📂 Installing from local directory: $SrcDir" -ForegroundColor Cyan
} else {
    Write-Host "🌐 Downloading Minimal from GitHub..." -ForegroundColor Cyan
    $TempDir = Join-Path $env:TEMP ("minimal-" + [System.Guid]::NewGuid().ToString().Substring(0, 8))
    git clone --depth=1 --branch $Branch $RepoUrl $TempDir | Out-Null
    $SrcDir = $TempDir
}

# -------------------------------------------------------------------
# 3. Setup Directories & Config
# -------------------------------------------------------------------
Write-Host "⚙️ Setting up configurations..." -ForegroundColor White

$NvimConfigDir = Join-Path $env:LOCALAPPDATA "vsc"
$BinDir        = Join-Path $env:USERPROFILE ".local\bin"
$AssetsDir     = Join-Path $env:LOCALAPPDATA "minimal\assets"

New-Item -ItemType Directory -Force -Path $NvimConfigDir | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
New-Item -ItemType Directory -Force -Path $AssetsDir | Out-Null

# Copy Neovim Config
Copy-Item -Path "$SrcDir\config\vsc\*" -Destination $NvimConfigDir -Recurse -Force
Write-Host "  ✔ Installed Neovim config to: $NvimConfigDir" -ForegroundColor Green

# Copy Assets (icon)
if (Test-Path "$SrcDir\assets\minimal.ico") {
    Copy-Item -Path "$SrcDir\assets\minimal.ico" -Destination $AssetsDir -Force
    Write-Host "  ✔ Installed application icon" -ForegroundColor Green
}

# Copy Windows Launcher
Copy-Item -Path "$SrcDir\bin\minimal.cmd" -Destination "$BinDir\minimal.cmd" -Force
Write-Host "  ✔ Installed command: $BinDir\minimal.cmd" -ForegroundColor Green

# -------------------------------------------------------------------
# 4. Create Start Menu & Desktop Shortcuts
# -------------------------------------------------------------------
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $StartMenuPath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Minimal.lnk")
    $Shortcut = $WshShell.CreateShortcut($StartMenuPath)
    $Shortcut.TargetPath = "$BinDir\minimal.cmd"
    $Shortcut.WorkingDirectory = $env:USERPROFILE
    if (Test-Path "$AssetsDir\minimal.ico") {
        $Shortcut.IconLocation = "$AssetsDir\minimal.ico"
    }
    $Shortcut.Description = "Minimal Code Editor"
    $Shortcut.Save()
    Write-Host "  ✔ Created Start Menu shortcut" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Notice: Could not create Start Menu shortcut." -ForegroundColor DarkGray
}

# -------------------------------------------------------------------
# 5. Ensure PATH includes ~/.local/bin
# -------------------------------------------------------------------
$UserPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($UserPath -notlike "*$BinDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$BinDir", [EnvironmentVariableTarget]::User)
    $env:Path = "$env:Path;$BinDir"
    Write-Host "  ✔ Added $BinDir to User PATH" -ForegroundColor Green
}

# -------------------------------------------------------------------
# 6. Clean up temp
# -------------------------------------------------------------------
if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}

# -------------------------------------------------------------------
# 7. Complete!
# -------------------------------------------------------------------
Write-Host ""
Write-Host "✨ Minimal installed successfully on Windows! ✨" -ForegroundColor Green
Write-Host ""
Write-Host "You can launch it anytime by:" -ForegroundColor White
Write-Host "  1. Typing 'minimal' or 'minimal .' in PowerShell or CMD" -ForegroundColor Cyan
Write-Host "  2. Searching for 'Minimal' in your Windows Start Menu" -ForegroundColor Cyan
Write-Host ""
