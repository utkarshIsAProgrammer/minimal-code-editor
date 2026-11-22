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

-- Session Persistence (Buffers, Working Directory, Windows, Tabs)
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }

-- Fast key timeout: Esc responds instantly without modal waiting/lag
opt.timeout = true
opt.timeoutlen = 1000 -- 1s comfortable window for VS Code multi-key chords (Ctrl+K Ctrl+T / Ctrl+K Ctrl+S)
opt.ttimeout = true
opt.ttimeoutlen = 10  -- 10ms instantaneous escape sequence resolution

-- Programmer Font: CaskaydiaCove Nerd Font Mono with universal fallbacks
opt.guifont = "CaskaydiaCove Nerd Font Mono,JetBrainsMono Nerd Font,Cascadia Code,Consolas,Courier New:h11.5"

-- Modeless Cursor: Blinking vertical pipe cursor in ALL states (pure VS Code feel, never a block cursor)
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

-- ===================================================================
-- Inline Diagnostics & Error Lens (Pure VS Code Experience)
-- Shows error & warning messages directly at the end of the line in real-time!
-- ===================================================================
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = function(diagnostic)
      local icons = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }
      return icons[diagnostic.severity] or "● "
    end,
    source = "if_many",
    severity_sort = true,
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})
