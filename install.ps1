# ===================================================================
#  ⚡ Minimal Code Editor - Windows Native PowerShell Installer
#  Usage: irm https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.ps1 | iex
# ===================================================================

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/utkarshIsAProgrammer/minimal-code-editor.git"
$Branch  = "main"

Write-Host ""
Write-Host "  __  __ _       _                 _ " -ForegroundColor Cyan
Write-Host " |  \/  (_)_ __ (_)_ __ ___   __ _| |" -ForegroundColor Cyan
Write-Host " | |\/| | | '_ \| | '_ `` _ \ / _` | |" -ForegroundColor Cyan
Write-Host " | |  | | | | | | | | | | | | (_| | |" -ForegroundColor Cyan
Write-Host " |_|  |_|_|_| |_|_|_| |_| |_|\__,_|_|" -ForegroundColor Cyan
Write-Host "  The Lightning-Fast Minimalist Code Editor" -ForegroundColor White
Write-Host "  Native Windows Setup" -ForegroundColor DarkCyan
Write-Host ""

# Helper: Refresh current session PATH from registry
function Refresh-EnvPath {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    $userPath    = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
    $env:Path    = "$machinePath;$userPath"
}

# Helper: Locate nvim executable across known Windows paths
function Find-Neovim {
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        return (Get-Command nvim).Source
    }
    $candidates = @(
        "$env:ProgramFiles\Neovim\bin\nvim.exe",
        "${env:ProgramFiles(x86)}\Neovim\bin\nvim.exe",
        "$env:LOCALAPPDATA\Programs\Neovim\bin\nvim.exe",
        "$env:ChocolateyInstall\bin\nvim.exe",
        "$env:USERPROFILE\scoop\apps\neovim\current\bin\nvim.exe"
    )
    foreach ($cand in $candidates) {
        if ($cand -and (Test-Path $cand)) {
            $nvimDir = Split-Path -Parent $cand
            $userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
            if ($userPath -notlike "*$nvimDir*") {
                [Environment]::SetEnvironmentVariable("Path", "$userPath;$nvimDir", [EnvironmentVariableTarget]::User)
            }
            $env:Path = "$env:Path;$nvimDir"
            return $cand
        }
    }
    return $null
}

# -------------------------------------------------------------------
# 1. Check Prerequisites
# -------------------------------------------------------------------
Write-Host "🔍 Checking prerequisites..." -ForegroundColor White

$nvimPath = Find-Neovim
if (-not $nvimPath) {
    Write-Host "⚠ Warning: 'nvim' (Neovim) was not found in PATH." -ForegroundColor Yellow
    Write-Host "  Attempting to install Neovim via winget..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Neovim.Neovim --accept-source-agreements --accept-package-agreements
        Refresh-EnvPath
        $nvimPath = Find-Neovim
    }
    if ($nvimPath) {
        $nvimVer = (& $nvimPath --version | Select-Object -First 1)
        Write-Host "  ✔ Installed & located: $nvimVer" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Note: Please install Neovim (>=0.9.0) from https://neovim.io if not installed." -ForegroundColor Yellow
    }
} else {
    $nvimVer = (& $nvimPath --version | Select-Object -First 1)
    Write-Host "  ✔ Found $nvimVer" -ForegroundColor Green
}

# -------------------------------------------------------------------
# 2. Download / Locate Files
# -------------------------------------------------------------------
$ScriptPath = if ($MyInvocation -and $MyInvocation.MyCommand -and $MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
$ScriptDir  = if ($ScriptPath) { Split-Path -Parent $ScriptPath } else { $null }

if ($ScriptDir -and (Test-Path (Join-Path $ScriptDir "config\vsc\init.lua"))) {
    $SrcDir = $ScriptDir
    Write-Host "📂 Installing from local directory: $SrcDir" -ForegroundColor Cyan
} else {
    Write-Host "🌐 Downloading Minimal from GitHub..." -ForegroundColor Cyan
    $TempDir = Join-Path $env:TEMP ("minimal-" + [System.Guid]::NewGuid().ToString().Substring(0, 8))
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

    $downloadSuccess = $false
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            git clone --depth=1 --branch $Branch $RepoUrl $TempDir 2>&1 | Out-Null
            if (Test-Path (Join-Path $TempDir "config\vsc\init.lua")) {
                $SrcDir = $TempDir
                $downloadSuccess = $true
            }
        } catch {}
    }

    if (-not $downloadSuccess) {
        # Fallback to direct ZIP download from GitHub (zero prerequisites needed!)
        $ZipUrl  = "https://github.com/utkarshIsAProgrammer/minimal-code-editor/archive/refs/heads/$Branch.zip"
        $ZipFile = Join-Path $TempDir "minimal.zip"
        Write-Host "  Downloading archive from GitHub..." -ForegroundColor DarkCyan
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipFile -UseBasicParsing
        Expand-Archive -Path $ZipFile -DestinationPath $TempDir -Force
        $ExtractedFolder = Join-Path $TempDir "minimal-code-editor-$Branch"
        if (Test-Path (Join-Path $ExtractedFolder "config\vsc\init.lua")) {
            $SrcDir = $ExtractedFolder
            $downloadSuccess = $true
        } else {
            Write-Host "✘ Error: Could not locate configuration files in downloaded archive." -ForegroundColor Red
            exit 1
        }
    }
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
# 4. Create Start Menu Shortcut
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
