@echo off
:: ===================================================================
:: Minimal Code Editor - Windows CMD Launcher
:: ===================================================================
setlocal
set "NVIM_APPNAME=vsc"

:: Check if Windows Terminal (wt.exe) is available for modern UI
where wt.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    wt.exe --title "Minimal" nvim.exe %*
) else (
    nvim.exe %*
)
endlocal
