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
# 1. Check Prerequisites & Auto-Install
# -------------------------------------------------------------------
Write-Host "🔍 Checking prerequisites..." -ForegroundColor White

# 1.1 Ensure Neovim
$nvimPath = Find-Neovim
if (-not $nvimPath) {
    Write-Host "  Installing Neovim..." -ForegroundColor Cyan
    $installed = $false

    # Try winget first
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            winget install Neovim.Neovim --accept-source-agreements --accept-package-agreements --silent
            Refresh-EnvPath
            $nvimPath = Find-Neovim
            if ($nvimPath) { $installed = $true }
        } catch {}
    }

    # Fallback to direct portable ZIP download from GitHub releases
    if (-not $installed) {
        try {
            Write-Host "  Downloading portable Neovim from GitHub..." -ForegroundColor DarkCyan
            $NvimZipUrl = "https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip"
            $NvimInstallDir = Join-Path $env:LOCALAPPDATA "Programs\Neovim"
            $NvimTempZip = Join-Path $env:TEMP "nvim-win64.zip"

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri $NvimZipUrl -OutFile $NvimTempZip -UseBasicParsing
            Expand-Archive -Path $NvimTempZip -DestinationPath (Join-Path $env:TEMP "nvim-extract") -Force

            $ExtractedNvim = Join-Path $env:TEMP "nvim-extract\nvim-win64"
            New-Item -ItemType Directory -Force -Path $NvimInstallDir | Out-Null
            Copy-Item -Path "$ExtractedNvim\*" -Destination $NvimInstallDir -Recurse -Force
            Remove-Item -Recurse -Force (Join-Path $env:TEMP "nvim-extract") -ErrorAction SilentlyContinue
            Remove-Item -Force $NvimTempZip -ErrorAction SilentlyContinue

            $nvimBinDir = Join-Path $NvimInstallDir "bin"
            $userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
            if ($userPath -notlike "*$nvimBinDir*") {
                [Environment]::SetEnvironmentVariable("Path", "$userPath;$nvimBinDir", [EnvironmentVariableTarget]::User)
            }
            $env:Path = "$env:Path;$nvimBinDir"
            $nvimPath = Join-Path $nvimBinDir "nvim.exe"
            $installed = $true
        } catch {
            Write-Host "  ⚠ Notice: Could not auto-download Neovim. Please install from https://neovim.io" -ForegroundColor Yellow
        }
    }
}

if ($nvimPath) {
    $nvimVer = (& $nvimPath --version | Select-Object -First 1)
    Write-Host "  ✔ Found $nvimVer" -ForegroundColor Green
}

# 1.2 Check Git (for plugin management)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "  Installing Git..." -ForegroundColor Cyan
        try {
            winget install Git.Git --accept-source-agreements --accept-package-agreements --silent
            Refresh-EnvPath
        } catch {}
    }
}
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "  ✔ Found Git" -ForegroundColor Green
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
$WinAppsDir    = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps"

New-Item -ItemType Directory -Force -Path $NvimConfigDir | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
New-Item -ItemType Directory -Force -Path $AssetsDir | Out-Null

# Copy Neovim Config
Copy-Item -Path "$SrcDir\config\vsc\*" -Destination $NvimConfigDir -Recurse -Force
Write-Host "  ✔ Installed Neovim config to: $NvimConfigDir" -ForegroundColor Green

# If no standard nvim config exists, mirror to LOCALAPPDATA\nvim for convenience
$StdNvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
if (-not (Test-Path $StdNvimConfig)) {
    Copy-Item -Path "$SrcDir\config\vsc\*" -Destination $StdNvimConfig -Recurse -Force
    Write-Host "  ✔ Mirrored to standard nvim path: $StdNvimConfig" -ForegroundColor DarkCyan
}

# Copy Assets (icon)
if (Test-Path "$SrcDir\assets\minimal.ico") {
    Copy-Item -Path "$SrcDir\assets\minimal.ico" -Destination $AssetsDir -Force
    Write-Host "  ✔ Installed application icon" -ForegroundColor Green
}

# Copy Windows Launchers (minimal.cmd and msc.cmd)
Copy-Item -Path "$SrcDir\bin\minimal.cmd" -Destination "$BinDir\minimal.cmd" -Force
Copy-Item -Path "$SrcDir\bin\minimal.cmd" -Destination "$BinDir\msc.cmd" -Force
if (Test-Path $WinAppsDir) {
    Copy-Item -Path "$SrcDir\bin\minimal.cmd" -Destination "$WinAppsDir\minimal.cmd" -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$SrcDir\bin\minimal.cmd" -Destination "$WinAppsDir\msc.cmd" -Force -ErrorAction SilentlyContinue
}
Write-Host "  ✔ Installed commands: minimal and msc" -ForegroundColor Green

# -------------------------------------------------------------------
# 4. Pre-bootstrap lazy.nvim Engine
# -------------------------------------------------------------------
$LazyDataDir = Join-Path $env:LOCALAPPDATA "vsc-data\lazy\lazy.nvim"
if (-not (Test-Path $LazyDataDir)) {
    try {
        Write-Host "  Initializing lazy.nvim engine..." -ForegroundColor DarkCyan
        $LazyZipUrl = "https://github.com/folke/lazy.nvim/archive/refs/heads/stable.zip"
        $LazyTempZip = Join-Path $env:TEMP "lazy-stable.zip"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $LazyZipUrl -OutFile $LazyTempZip -UseBasicParsing
        New-Item -ItemType Directory -Force -Path (Join-Path $env:LOCALAPPDATA "vsc-data\lazy") | Out-Null
        Expand-Archive -Path $LazyTempZip -DestinationPath (Join-Path $env:LOCALAPPDATA "vsc-data\lazy") -Force
        $UnzippedLazy = Join-Path $env:LOCALAPPDATA "vsc-data\lazy\lazy.nvim-stable"
        if (Test-Path $UnzippedLazy) {
            Rename-Item -Path $UnzippedLazy -NewName "lazy.nvim" -Force
        }
        Remove-Item -Force $LazyTempZip -ErrorAction SilentlyContinue
        Write-Host "  ✔ Pre-bootstrapped lazy.nvim engine" -ForegroundColor Green
    } catch {}
}

# -------------------------------------------------------------------
# 5. Create Start Menu & Desktop Shortcuts
# -------------------------------------------------------------------
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $TargetExe = Join-Path $BinDir "minimal.cmd"

    # Start Menu Shortcut
    $StartMenuPath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Minimal.lnk")
    $Shortcut = $WshShell.CreateShortcut($StartMenuPath)
    $Shortcut.TargetPath = $TargetExe
    $Shortcut.WorkingDirectory = $env:USERPROFILE
    if (Test-Path "$AssetsDir\minimal.ico") {
        $Shortcut.IconLocation = "$AssetsDir\minimal.ico"
    }
    $Shortcut.Description = "Minimal Code Editor"
    $Shortcut.Save()
    Write-Host "  ✔ Created Start Menu shortcut" -ForegroundColor Green

    # Desktop Shortcut
    $DesktopDir = [Environment]::GetFolderPath([Environment+SpecialFolder]::Desktop)
    if ($DesktopDir -and (Test-Path $DesktopDir)) {
        $DesktopShortcut = $WshShell.CreateShortcut((Join-Path $DesktopDir "Minimal.lnk"))
        $DesktopShortcut.TargetPath = $TargetExe
        $DesktopShortcut.WorkingDirectory = $env:USERPROFILE
        if (Test-Path "$AssetsDir\minimal.ico") {
            $DesktopShortcut.IconLocation = "$AssetsDir\minimal.ico"
        }
        $DesktopShortcut.Description = "Minimal Code Editor"
        $DesktopShortcut.Save()
        Write-Host "  ✔ Created Desktop shortcut" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ Notice: Could not create desktop shortcut." -ForegroundColor DarkGray
}

# -------------------------------------------------------------------
# 6. Ensure PATH includes ~/.local/bin
# -------------------------------------------------------------------
$UserPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($UserPath -notlike "*$BinDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$BinDir", [EnvironmentVariableTarget]::User)
    $env:Path = "$env:Path;$BinDir"
    Write-Host "  ✔ Added $BinDir to User PATH" -ForegroundColor Green
}

# -------------------------------------------------------------------
# 7. Clean up temp
# -------------------------------------------------------------------
if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}

# -------------------------------------------------------------------
# 8. Complete!
# -------------------------------------------------------------------
Write-Host ""
Write-Host "✨ Minimal installed successfully on Windows! ✨" -ForegroundColor Green
Write-Host ""
Write-Host "Launch options:" -ForegroundColor White
Write-Host "  1. Type 'minimal' or 'msc' in any PowerShell / CMD terminal" -ForegroundColor Cyan
Write-Host "  2. Search for 'Minimal' in your Windows Start Menu" -ForegroundColor Cyan
Write-Host "  3. Double-click the 'Minimal' shortcut on your Desktop" -ForegroundColor Cyan
Write-Host ""
Write-Host "ℹ Note: If you have older terminal windows currently open, please open a new window to refresh your PATH." -ForegroundColor DarkCyan
Write-Host ""
