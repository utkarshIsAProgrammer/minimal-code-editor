@echo off
if defined NVIM (
    if "%~1"=="" (
        nvim --server "%NVIM%" --remote-send "<Esc>:lua _G.FocusEditorFromTerminal()<CR>" >nul 2>&1
        exit /b 0
    )
    for %%A in (%*) do (
        nvim --server "%NVIM%" --remote-send "<Esc>:lua _G.OpenFileFromTerminal('%%~fA')<CR>" >nul 2>&1
    )
    exit /b 0
)
nvim %*
