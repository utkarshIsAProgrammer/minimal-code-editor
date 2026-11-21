@echo off
if defined NVIM (
    if "%~1"=="" (
        nvim --server "%NVIM%" --remote-expr "v:lua._G.FocusEditorFromTerminal()" >nul 2>&1
        exit /b 0
    )
    for %%A in (%*) do (
        nvim --server "%NVIM%" --remote-expr "v:lua._G.OpenFileFromTerminal('%%~fA')" >nul 2>&1
    )
    exit /b 0
)
nvim %*
