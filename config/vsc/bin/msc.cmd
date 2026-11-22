@echo off
chcp 65001 >nul
if /I "%~1"=="update" goto :self_update
if /I "%~1"=="--update" goto :self_update
"%~dp0nvim.cmd" %*
exit /b %ERRORLEVEL%

:self_update
echo.
echo [Minimal] Updating to the latest version from GitHub...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.ps1 | iex"
exit /b %ERRORLEVEL%
