@echo off
setlocal
set "NVIM_APPNAME=vsc"

:: 1. Search PATH first
set "NVIM_EXE="
where nvim.exe >nul 2>&1
if not errorlevel 1 set "NVIM_EXE=nvim.exe" & goto :run

:: 2. Check standard Windows Neovim install paths
if exist "%LOCALAPPDATA%\Programs\Neovim\bin\nvim.exe" set "NVIM_EXE=%LOCALAPPDATA%\Programs\Neovim\bin\nvim.exe" & goto :run
if exist "%ProgramFiles%\Neovim\bin\nvim.exe" set "NVIM_EXE=%ProgramFiles%\Neovim\bin\nvim.exe" & goto :run
if exist "%ProgramFiles(x86)%\Neovim\bin\nvim.exe" set "NVIM_EXE=%ProgramFiles(x86)%\Neovim\bin\nvim.exe" & goto :run
if defined ChocolateyInstall if exist "%ChocolateyInstall%\bin\nvim.exe" set "NVIM_EXE=%ChocolateyInstall%\bin\nvim.exe" & goto :run
if exist "%USERPROFILE%\scoop\apps\neovim\current\bin\nvim.exe" set "NVIM_EXE=%USERPROFILE%\scoop\apps\neovim\current\bin\nvim.exe" & goto :run

:: 3. Neovim not found - show diagnostic message and pause
echo.
echo [Minimal Error] Neovim executable was not found.
echo Please install Neovim from https://neovim.io or run: winget install Neovim.Neovim
echo If Neovim is already installed, please add its bin folder to your Windows PATH.
echo.
pause
exit /b 1

:run
title Minimal
"%NVIM_EXE%" %*
endlocal
