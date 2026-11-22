-- ===================================================================
-- Minimal (vsc) - Main Entry Point
-- Pure VS Code & Normal PC Feel (Zero Vim Modal Keys, Zero Errors)
-- Made by indiedev
-- ===================================================================

-- Prepend config bin to PATH so embedded terminals route 'nvim', 'minimal', 'msc', 'code' to active instance
local config_bin = vim.fn.stdpath("config") .. "/bin"
if vim.fn.isdirectory(config_bin) == 1 then
  local sep = vim.fn.has("win32") == 1 and ";" or ":"
  vim.env.PATH = config_bin .. sep .. vim.env.PATH
end

-- 1. Load modeless options (cursor, mouse, selection, clipboard)
require("options")

-- 2. Load theme manager and restore saved theme & transparency (defaults to darkmagic)
local theme_mgr = require("theme")
theme_mgr.init_transparency()
local saved_theme = theme_mgr.get_current_theme()
pcall(vim.cmd, "colorscheme " .. saved_theme)

-- 3. Pre-load keymaps, recents, terminal & liveserver bridges so globals exist
pcall(require, "recents")
pcall(require, "terminal")
pcall(require, "liveserver")
pcall(require, "keymaps")

-- 4. Bootstrap lazy.nvim in isolated data directory (~/.local/share/vsc)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 4. Setup lazy.nvim with our curated lightweight suite
require("lazy").setup({
  spec = require("plugins"),
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "darkmagic" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "logiPat",
        "rrhelper",
        "spellfile_plugin",
      },
    },
  },
})

-- 5. Load pure VS Code keymaps & modeless typing handlers
require("keymaps")

-- 6. Load persistent recent workspaces & files tracker
require("recents")
