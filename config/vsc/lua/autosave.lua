-- ===================================================================
-- Minimal (vsc) - Live Auto-Save Engine
-- Silently and reliably auto-saves modified files in the background
-- after typing pauses and on focus loss — exactly like VS Code & Zed!
-- ===================================================================

local M = {}

local autosave_file = vim.fn.stdpath("state") .. "/autosave.txt"
local timer = nil
local debounce_ms = 1000 -- 1 second typing pause

function M.is_enabled()
  if vim.fn.filereadable(autosave_file) == 1 then
    local lines = vim.fn.readfile(autosave_file)
    if lines and lines[1] and lines[1]:match("%S") then
      local val = vim.trim(lines[1]):lower()
      return (val == "true" or val == "1" or val == "on")
    end
  end
  return true -- Enabled by default like modern IDEs
end

function M.set_enabled(enabled, notify)
  pcall(vim.fn.mkdir, vim.fn.fnamemodify(autosave_file, ":p:h"), "p")
  pcall(vim.fn.writefile, { enabled and "true" or "false" }, autosave_file)
  if notify ~= false then
    local status = enabled and "Enabled (1s pause + window blur)" or "Disabled (Manual Ctrl+S)"
    vim.notify("✓ Live Auto-Save: " .. status, vim.log.levels.INFO, { title = "Minimal Editor" })
  end
end

function M.toggle()
  M.set_enabled(not M.is_enabled(), true)
end

-- Safely save the current buffer if it is a real file and modified
local function save_buffer(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if not vim.bo[buf].modified then return end
  if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then return end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" or vim.fn.filereadable(name) ~= 1 then return end

  -- Write silently without disrupting cursor or insert mode
  pcall(function()
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! noautocmd write")
    end)
  end)
end

function M.save_all_modified()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].modified then
      save_buffer(b)
    end
  end
end

-- Trigger debounced save on text changes
function M.on_text_changed()
  if not M.is_enabled() then return end
  local buf = vim.api.nvim_get_current_buf()
  if not vim.bo[buf].modified or vim.bo[buf].buftype ~= "" then return end

  if timer then
    timer:stop()
  else
    timer = vim.uv.new_timer()
  end

  timer:start(debounce_ms, 0, vim.schedule_wrap(function()
    if M.is_enabled() then
      save_buffer(buf)
    end
  end))
end

-- Setup autocmds
local group = vim.api.nvim_create_augroup("MinimalAutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = group,
  callback = function()
    M.on_text_changed()
  end,
  desc = "Debounced live auto-save on typing pause",
})

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = group,
  callback = function()
    if M.is_enabled() then
      if timer then timer:stop() end
      save_buffer()
    end
  end,
  desc = "Immediate auto-save on focus loss or tab switch",
})

vim.api.nvim_create_user_command("AutoSave", function(opts)
  local arg = opts.args and vim.trim(opts.args):lower() or ""
  if arg == "on" or arg == "1" or arg == "true" then
    M.set_enabled(true, true)
  elseif arg == "off" or arg == "0" or arg == "false" then
    M.set_enabled(false, true)
  else
    M.toggle()
  end
end, {
  nargs = "?",
  complete = function() return { "on", "off", "toggle" } end,
  desc = "Toggle or configure Live Auto-Save",
})

_G.ToggleAutoSave = M.toggle

return M
