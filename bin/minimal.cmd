@echo off
:: ===================================================================
:: Minimal Code Editor - Windows CMD Launcher
:: ===================================================================
setlocal
set "NVIM_APPNAME=vsc"

:: Locate nvim.exe across standard Windows installation paths
set "NVIM_EXE="
where nvim.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "NVIM_EXE=nvim.exe"
) else if exist "%ProgramFiles%\Neovim\bin\nvim.exe" (
    set "NVIM_EXE=%ProgramFiles%\Neovim\bin\nvim.exe"
) else if exist "%ProgramFiles(x86)%\Neovim\bin\nvim.exe" (
    set "NVIM_EXE=%ProgramFiles(x86)%\Neovim\bin\nvim.exe"
) else if exist "%LOCALAPPDATA%\Programs\Neovim\bin\nvim.exe" (
    set "NVIM_EXE=%LOCALAPPDATA%\Programs\Neovim\bin\nvim.exe"
) else if exist "%ChocolateyInstall%\bin\nvim.exe" (
    set "NVIM_EXE=%ChocolateyInstall%\bin\nvim.exe"
) else if exist "%USERPROFILE%\scoop\apps\neovim\current\bin\nvim.exe" (
    set "NVIM_EXE=%USERPROFILE%\scoop\apps\neovim\current\bin\nvim.exe"
)

if "%NVIM_EXE%"=="" (
    echo Error: 'nvim.exe' (Neovim) was not found in your PATH or standard install paths.
    echo Please install Neovim (>=0.9.0) from https://neovim.io
    echo If already installed, add its 'bin' directory to your Windows System/User PATH.
    echo.
    pause
    exit /b 1
)

:: If already inside Windows Terminal or an interactive console, run directly
if defined WT_SESSION (
    "%NVIM_EXE%" %*
) else (
    where wt.exe >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        start "" wt.exe --title "Minimal" "%NVIM_EXE%" %*
    ) else (
        "%NVIM_EXE%" %*
    )
)
endlocal
