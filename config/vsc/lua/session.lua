-- ===================================================================
-- Minimal (vsc) - Seamless Workspace & Session Persistence
-- Automatically preserves open files, folders, and cursor positions
-- across restarts — exactly like VS Code and Zed!
-- ===================================================================

local M = {}

local sessions_dir = vim.fn.stdpath("state") .. "/sessions"
local last_session_file = vim.fn.stdpath("state") .. "/last_session.txt"
local auto_restore_file = vim.fn.stdpath("state") .. "/auto_restore.txt"

-- Ensure session storage directory exists
pcall(vim.fn.mkdir, sessions_dir, "p")

-- Returns a safe, deterministic filename for a workspace directory
local function get_session_file(dir)
  if not dir or dir == "" then return nil end
  dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p"):gsub("[/\\]+$", "")
  local hash = vim.fn.sha256(dir):sub(1, 16)
  local name = vim.fn.fnamemodify(dir, ":t")
  if name == "" or name == "/" then name = "root" end
  name = name:gsub("[^%w%-_]", "_")
  return sessions_dir .. "/" .. name .. "_" .. hash .. ".vim"
end

-- Checks if a directory is a valid workspace to persist (not root, home, or temp)
local function is_valid_workspace(dir)
  if not dir or dir == "" then return false end
  local p = vim.fn.fnamemodify(vim.fn.expand(dir), ":p"):gsub("[/\\]+$", "")
  if vim.fn.isdirectory(p) == 0 then return false end
  -- Exclude root filesystem, drive roots (C:\), home directly, or temp folders
  if p == "/" or p:match("^%a:[/\\]?$") or p == vim.fn.expand("~") or p:find("/tmp") or p:find("\\Temp") then
    return false
  end
  return true
end

-- Counts how many real, user-opened files are currently active in buffers
function M.count_valid_buffers()
  local count = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted then
      local ft = vim.bo[b].filetype or ""
      local bt = vim.bo[b].buftype or ""
      local name = vim.api.nvim_buf_get_name(b)
      if bt == "" and ft ~= "snacks_dashboard" and not ft:find("picker") and name ~= "" and vim.fn.filereadable(name) == 1 then
        count = count + 1
      end
    end
  end
  return count
end

-- Check if auto-restore is enabled (defaults to true)
function M.is_auto_restore_enabled()
  if vim.fn.filereadable(auto_restore_file) == 1 then
    local lines = vim.fn.readfile(auto_restore_file)
    if lines and lines[1] and lines[1]:match("%S") then
      local val = vim.trim(lines[1]):lower()
      return (val == "true" or val == "1" or val == "on")
    end
  end
  return true
end

-- Set auto-restore preference
function M.set_auto_restore(enabled, notify)
  pcall(vim.fn.writefile, { enabled and "true" or "false" }, auto_restore_file)
  if notify ~= false then
    local status = enabled and "Enabled (VS Code style auto-restore)" or "Disabled (Always start on Homescreen)"
    vim.notify("✓ Workspace Auto-Restore: " .. status, vim.log.levels.INFO, { title = "Minimal Session" })
  end
end

function M.toggle_auto_restore()
  M.set_auto_restore(not M.is_auto_restore_enabled(), true)
end

-- Save session for a specific directory or current workspace
function M.save_session(dir)
  dir = dir or vim.fn.getcwd()
  if not is_valid_workspace(dir) then return false end

  local count = M.count_valid_buffers()
  local session_path = get_session_file(dir)
  if not session_path then return false end

  if count == 0 then
    -- User closed all files or is on empty dashboard; clean up session
    if vim.fn.filereadable(session_path) == 1 then
      pcall(vim.fn.delete, session_path)
    end
    return false
  end

  local ok, err = pcall(function()
    local old_ss = vim.opt.sessionoptions:get()
    vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
    vim.opt.sessionoptions = old_ss
  end)

  if ok then
    pcall(vim.fn.writefile, { dir }, last_session_file)
    if _G.AddRecentFolder then _G.AddRecentFolder(dir) end
    return true
  end
  return false
end

-- Restore session for a specific directory
function M.restore_session(dir)
  dir = dir or vim.fn.getcwd()
  local session_path = get_session_file(dir)
  if not session_path or vim.fn.filereadable(session_path) == 0 then
    return false
  end

  local ok = pcall(function()
    if vim.fn.isdirectory(dir) == 1 then
      vim.fn.chdir(dir)
    end
    vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))
  end)

  if ok and M.count_valid_buffers() > 0 then
    vim.schedule(function()
      local cur_buf = vim.api.nvim_get_current_buf()
      if vim.api.nvim_buf_is_valid(cur_buf)
        and vim.bo[cur_buf].buftype == ""
        and vim.bo[cur_buf].modifiable
        and vim.bo[cur_buf].filetype ~= "snacks_dashboard"
      then
        pcall(vim.cmd, "startinsert")
      end
    end)
    return true
  end
  return false
end

-- Clear session for a specific directory or current workspace
function M.clear_session(dir)
  dir = dir or vim.fn.getcwd()
  local session_path = get_session_file(dir)
  if session_path and vim.fn.filereadable(session_path) == 1 then
    pcall(vim.fn.delete, session_path)
  end
  vim.notify("✓ Session cleared for: " .. vim.fn.fnamemodify(dir, ":t"), vim.log.levels.INFO, { title = "Minimal Session" })
end

-- Restore the most recent workspace session (used when Minimal opens with no args)
function M.restore_last_session()
  if not M.is_auto_restore_enabled() then
    return false
  end

  -- 1. Check if current directory itself already has a valid saved session
  local cur_dir = vim.fn.getcwd()
  if is_valid_workspace(cur_dir) then
    local cur_sess = get_session_file(cur_dir)
    if cur_sess and vim.fn.filereadable(cur_sess) == 1 then
      if M.restore_session(cur_dir) then
        local name = vim.fn.fnamemodify(cur_dir, ":t")
        vim.notify("⚡ Restored workspace: " .. name, vim.log.levels.INFO, { title = "Minimal Editor" })
        return true
      end
    end
  end

  -- 2. Otherwise check last_session_file
  if vim.fn.filereadable(last_session_file) == 1 then
    local lines = vim.fn.readfile(last_session_file)
    if lines and lines[1] and lines[1]:match("%S") then
      local last_dir = vim.trim(lines[1])
      if vim.fn.isdirectory(last_dir) == 1 and is_valid_workspace(last_dir) then
        if M.restore_session(last_dir) then
          local name = vim.fn.fnamemodify(last_dir, ":t")
          vim.notify("⚡ Restored workspace: " .. name, vim.log.levels.INFO, { title = "Minimal Editor" })
          return true
        end
      end
    end
  end

  return false
end

-- Auto-commands for automatic session persistence
local group = vim.api.nvim_create_augroup("MinimalSessionAuto", { clear = true })

-- Save session on editor exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    M.save_session()
  end,
  desc = "Automatically persist open workspace session on exit",
})

-- Save session whenever editor loses focus (prevents losing state on abrupt exit / crash)
vim.api.nvim_create_autocmd("FocusLost", {
  group = group,
  callback = function()
    if M.count_valid_buffers() > 0 then
      M.save_session()
    end
  end,
  desc = "Automatically persist open workspace session on focus lost",
})

-- Startup auto-restore logic
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  nested = true,
  callback = function()
    -- Only auto-restore if opened without file arguments
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        M.restore_last_session()
      end)
    elseif vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) == 1 then
        local full_dir = vim.fn.fnamemodify(arg, ":p"):gsub("[/\\]+$", "")
        vim.schedule(function()
          M.restore_session(full_dir)
        end)
      end
    end
  end,
  desc = "Automatically restore open files & workspace on launch",
})

-- User commands
vim.api.nvim_create_user_command("SessionSave", function()
  local ok = M.save_session()
  if ok then
    vim.notify("✓ Workspace session saved", vim.log.levels.INFO, { title = "Minimal Session" })
  else
    vim.notify("No active workspace or files to save", vim.log.levels.WARN, { title = "Minimal Session" })
  end
end, { desc = "Save open files and workspace session" })

vim.api.nvim_create_user_command("SessionRestore", function()
  local ok = M.restore_last_session()
  if not ok then
    vim.notify("No previous workspace session found to restore", vim.log.levels.WARN, { title = "Minimal Session" })
  end
end, { desc = "Restore previous workspace session" })

vim.api.nvim_create_user_command("SessionClear", function()
  M.clear_session()
end, { desc = "Clear saved session for current workspace" })

vim.api.nvim_create_user_command("SessionToggle", function()
  M.toggle_auto_restore()
end, { desc = "Toggle automatic workspace & session restore on/off" })

-- Global bridges
_G.SaveSession = M.save_session
_G.RestoreSession = M.restore_last_session
_G.ClearSession = M.clear_session
_G.ToggleAutoRestore = M.toggle_auto_restore

return M
