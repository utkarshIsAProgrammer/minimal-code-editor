-- ===================================================================
-- Minimal (vsc) - Modeless Editor Options
-- Pure VS Code & Normal PC Feel (Zero Vim Modal Friction)
-- ===================================================================

local opt = vim.opt

-- Appearance & Theme
opt.termguicolors = true
opt.number = true
opt.relativenumber = false -- Normal absolute line numbers (1, 2, 3... like VS Code)
opt.signcolumn = "yes"    -- Persistent gutter for error lens icons and diagnostics
opt.cursorline = true
opt.wrap = false
opt.showmode = false      -- Hide default Neovim '-- INSERT --' / '-- NORMAL --'
opt.ruler = false         -- Lualine handles status indicators cleanly
opt.title = true
opt.titlestring = "Minimal - %t"
opt.updatetime = 300       -- Fast 300ms response for cursor hold, diagnostics & hover
opt.mousemoveevent = false  -- Disable mouse movement tracking to prevent floating window clipping

-- Programmer Font: CaskaydiaCove Nerd Font Mono (Cascadia Code with programming ligatures for nerds & geeks)
opt.guifont = "CaskaydiaCove Nerd Font Mono,BlexMono Nerd Font Mono,JetBrainsMono Nerd Font Mono:h11.5"

-- Cursor: Blinking vertical pipe cursor in ALL states (never a block cursor)
opt.guicursor = "n-v-c-i-ci-ve:ver25-blinkon500-blinkoff500"

-- Full Mouse Support (click to position, drag to select, scroll wheel)
opt.mouse = "a"

-- System Clipboard Integration (Ctrl+C / Ctrl+V interact directly with OS)
opt.clipboard = "unnamedplus"

-- VS Code Selection Model: Shift+Arrows and mouse drag select text,
-- typing immediately replaces the highlighted text!
-- Exclusive selection prevents selecting an extra letter or space at cursor
opt.keymodel = "startsel,stopsel"
opt.selectmode = "mouse,key"
opt.selection = "exclusive"

-- Clean commandline & message handling (Never halt on 'Press Enter or type a command to continue')
opt.cmdheight = 1
opt.shortmess:append("sIcFoOtTWA")

-- Cursor flexibility: allows cursor past line end & natural arrow line wrapping
opt.virtualedit = "onemore"
opt.whichwrap:append("<,>,[,],h,l")

-- Indentation (2 spaces default, smart auto-indent)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search behavior (live highlight, case-insensitive unless uppercase typed)
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Disable annoying swap files completely, full persistent undo history
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Integrated Terminal Shell
opt.shell = "/bin/bash"
opt.shellcmdflag = "-c"

-- Auto-write on buffer leave or tool run
opt.autowrite = true

-- Code Spell Checking everywhere (VS Code Code Spell Checker experience)
opt.spell = true
opt.spelllang = { "en" }
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- Backspace over indentation, line breaks, and start of insert
opt.backspace = { "indent", "eol", "start" }

-- Rich Path & Command Suggestions (Popup dropdown menus for all path and command autocompletion)
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"
opt.wildignore:append({ "*.o", "*.obj", "*.bin", "*.dll", "*.exe", "*/.git/*", "*/node_modules/*", "*/target/*", "*/build/*" })
