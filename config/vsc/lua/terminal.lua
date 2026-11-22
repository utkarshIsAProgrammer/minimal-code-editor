-- ===================================================================
-- Minimal (vsc) - Supercharged Terminal Suite
-- Multi-instance, Multi-profile, Dynamic Layouts & Workspace Support
-- Handcrafted by indiedev
-- ===================================================================

local M = {}

M.active_id = 1
M.max_id = 1
M.layout = "bottom" -- "bottom", "right", "float"
M.height = 0.35
M.width = 0.45

-- Terminal Profiles with smart executable fallback
M.profiles = {
  {
    name = "shell",
    label = "Default Shell",
    desc = "System interactive shell (Zsh / Bash / Fish)",
    icon = "🐚 ",
    cmd = nil,
  },
  {
    name = "python",
    label = "Python REPL",
    desc = "Interactive Python interpreter",
    icon = "🐍 ",
    cmd = vim.fn.executable("ipython") == 1 and "ipython" or "python3",
  },
  {
    name = "node",
    label = "Node / Bun REPL",
    desc = "JavaScript / TypeScript interactive runtime",
    icon = "⚡ ",
    cmd = vim.fn.executable("bun") == 1 and "bun repl" or "node",
  },
  {
    name = "git",
    label = "Git / Lazygit",
    desc = "Visual terminal git client",
    icon = "🐙 ",
    cmd = vim.fn.executable("lazygit") == 1 and "lazygit" or "git status",
  },
  {
    name = "btop",
    label = "System Monitor",
    desc = "Real-time CPU, RAM, and GPU monitor",
    icon = "📊 ",
    cmd = vim.fn.executable("btop") == 1 and "btop" or (vim.fn.executable("htop") == 1 and "htop" or "top"),
  },
}

-- Resolve window layout options for Snacks.terminal
local function get_layout_opts()
  if M.layout == "right" then
    return {
      position = "right",
      width = M.width,
    }
  elseif M.layout == "float" then
    return {
      position = "float",
      border = "rounded",
      width = 0.88,
      height = 0.82,
      backdrop = 60,
    }
  else
    return {
      position = "bottom",
      height = M.height,
    }
  end
end

-- Helper: Close any floating dashboard or popups that might obscure the terminal
local function dismiss_covering_floats()
  -- Ensure cursor visibility is restored if hidden on dashboard
  io.write("\027[?25h")

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype or ""
      local cfg = vim.api.nvim_win_get_config(win)
      -- Close full-screen or floating dashboard/popup (preserving explorer sidebar)
      if cfg.relative ~= "" and (ft == "snacks_dashboard" or ft:find("dashboard")) then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end
end

-- Helper: Purge dead terminal buffers whose shell processes have exited
local function cleanup_dead_terminals()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and (vim.bo[buf].buftype == "terminal" or vim.bo[buf].filetype == "snacks_terminal") then
      local chan = vim.bo[buf].channel
      if not chan or chan <= 0 or vim.fn.jobwait({ chan }, 0)[1] ~= -1 then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end
end

-- Helper: Return focus smoothly to an active editable document buffer
local function focus_editor_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local bt = vim.bo[buf].buftype or ""
      local ft = vim.bo[buf].filetype or ""
      if bt == "" and ft ~= "snacks_dashboard" and not ft:find("explorer") and not ft:find("picker") then
        vim.api.nvim_set_current_win(win)
        if vim.bo[buf].modifiable then
          pcall(vim.cmd, "startinsert")
        end
        return
      end
    end
  end
end

-- Toggle or focus active terminal instance (VS Code Muscle Memory)
function M.toggle(count, cmd)
  local id = count or M.active_id or 1
  M.active_id = id
  if id > M.max_id then
    M.max_id = id
  end

  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_get_current_buf()

  -- 1. Check if any terminal window is currently visible on this tabpage
  local term_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" or vim.bo[buf].filetype == "snacks_terminal" then
        term_win = win
        break
      end
    end
  end

  local ok, snacks = pcall(require, "snacks")

  -- 2. If terminal is ALREADY VISIBLE:
  if term_win then
    if cur_win == term_win then
      -- User is ALREADY INSIDE the terminal -> hide it and return focus to editor
      if ok and snacks.terminal then
        local t = snacks.terminal.get(cmd, { count = id })
        if t and t:valid() then
          t:hide()
        else
          pcall(vim.api.nvim_win_close, term_win, true)
        end
      else
        pcall(vim.api.nvim_win_close, term_win, true)
      end
      focus_editor_window()
      return
    else
      -- Terminal is visible below, but focus is in editor/dashboard -> FOCUS TERMINAL!
      dismiss_covering_floats()
      vim.api.nvim_set_current_win(term_win)
      vim.schedule(function()
        pcall(vim.cmd, "startinsert")
      end)
      return
    end
  end

  -- 3. Terminal is not visible: dismiss covering floats (dashboard) & purge dead buffers
  dismiss_covering_floats()
  cleanup_dead_terminals()

  -- 4. Open fresh, active terminal instance and immediately enter terminal mode
  if ok and snacks.terminal then
    local t = snacks.terminal.open(cmd, {
      count = id,
      win = get_layout_opts(),
    })
    vim.schedule(function()
      if t and t:valid() then
        vim.api.nvim_set_current_win(t.win)
      end
      pcall(vim.cmd, "startinsert")
    end)
  else
    vim.cmd("split | terminal " .. (cmd or ""))
    pcall(vim.cmd, "startinsert")
  end
end

-- Open a brand new terminal instance
function M.new(cmd)
  M.max_id = M.max_id + 1
  M.active_id = M.max_id
  M.toggle(M.active_id, cmd)
  vim.notify("✓ Opened Terminal #" .. M.active_id, vim.log.levels.INFO, { title = "Minimal Terminal" })
end

-- Cycle layout (Bottom -> Right -> Float -> Bottom)
function M.cycle_layout()
  local order = { "bottom", "right", "float" }
  local next_layout = order[1]
  for i, name in ipairs(order) do
    if name == M.layout then
      next_layout = order[(i % #order) + 1]
      break
    end
  end
  M.layout = next_layout
  vim.notify("Terminal layout switched to: " .. next_layout:upper(), vim.log.levels.INFO, { title = "Minimal Terminal" })
  -- Re-apply to active terminal if open
  M.toggle(M.active_id)
end

-- Set layout explicitly
function M.set_layout(layout_name)
  layout_name = layout_name:lower()
  if layout_name == "bottom" or layout_name == "right" or layout_name == "float" then
    M.layout = layout_name
    vim.notify("Terminal layout: " .. layout_name:upper(), vim.log.levels.INFO, { title = "Minimal Terminal" })
    M.toggle(M.active_id)
  else
    vim.notify("Unknown layout '" .. layout_name .. "'. Valid: bottom, right, float", vim.log.levels.WARN, { title = "Minimal Terminal" })
  end
end

-- Resize active terminal drawer (Only height for bottom layout, width for right layout)
function M.resize(delta)
  local term_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" or vim.bo[buf].filetype == "snacks_terminal" then
        term_win = win
        break
      end
    end
  end

  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_call(term_win, function()
      if M.layout == "right" then
        vim.cmd(string.format("vertical resize %+d", delta))
      else
        vim.cmd(string.format("resize %+d", delta))
      end
    end)
  else
    if M.layout == "right" then
      vim.cmd(string.format("vertical resize %+d", delta))
    else
      vim.cmd(string.format("resize %+d", delta))
    end
  end
end

-- Interactive Profile Picker
function M.select_profile()
  local ok, snacks = pcall(require, "snacks")
  local items = {}
  for _, p in ipairs(M.profiles) do
    table.insert(items, {
      text = p.name .. " " .. p.label .. " " .. p.desc,
      name = p.name,
      label = p.label,
      desc = p.desc,
      icon = p.icon,
      cmd = p.cmd,
    })
  end

  if ok and snacks.picker then
    snacks.picker({
      title = "⚡ Terminal Profiles",
      items = items,
      format = function(item)
        return {
          { item.icon or " ", "Special" },
          { item.label .. "  ", "Bold" },
          { "(" .. item.desc .. ")", "Comment" },
        }
      end,
      confirm = function(picker, item)
        picker:close()
        if item then
          vim.schedule(function()
            M.new(item.cmd)
          end)
        end
      end,
    })
  else
    local options = {}
    for _, p in ipairs(M.profiles) do
      table.insert(options, p.icon .. p.label .. " (" .. p.desc .. ")")
    end
    vim.ui.select(options, { prompt = "⚡ Select Terminal Profile: " }, function(_, idx)
      if idx and M.profiles[idx] then
        M.new(M.profiles[idx].cmd)
      end
    end)
  end
end

-- Interactive Terminal Instance Switcher
function M.select_instance()
  local ok, snacks = pcall(require, "snacks")
  local items = {}
  for i = 1, M.max_id do
    local is_active = (i == M.active_id)
    table.insert(items, {
      text = "Terminal #" .. i,
      id = i,
      is_active = is_active,
    })
  end

  if ok and snacks.picker then
    snacks.picker({
      title = "🖥️ Active Terminals",
      items = items,
      format = function(item)
        local tag = item.is_active and " [Active ✓]" or ""
        return {
          { " ", "Special" },
          { "Terminal #" .. item.id, item.is_active and "Bold" or "Normal" },
          { tag, "DiagnosticOk" },
        }
      end,
      confirm = function(picker, item)
        picker:close()
        if item and item.id then
          vim.schedule(function()
            M.toggle(item.id)
          end)
        end
      end,
    })
  else
    local options = {}
    for i = 1, M.max_id do
      table.insert(options, "Terminal #" .. i .. (i == M.active_id and " [Active]" or ""))
    end
    vim.ui.select(options, { prompt = "🖥️ Select Terminal: " }, function(_, idx)
      if idx then
        M.toggle(idx)
      end
    end)
  end
end

-- Commands
vim.api.nvim_create_user_command("TerminalNew", function() M.new() end, { desc = "Open a new terminal instance" })
vim.api.nvim_create_user_command("TerminalLayout", function(opts)
  if opts.args ~= "" then
    M.set_layout(opts.args)
  else
    M.cycle_layout()
  end
end, { nargs = "?", complete = function() return { "bottom", "right", "float" } end, desc = "Change or cycle terminal layout" })
vim.api.nvim_create_user_command("TerminalProfiles", function() M.select_profile() end, { desc = "Select terminal profile" })
vim.api.nvim_create_user_command("TerminalList", function() M.select_instance() end, { desc = "List and switch terminal instances" })

-- Global bridges
_G.TerminalToggle = M.toggle
_G.TerminalNew = M.new
_G.TerminalCycleLayout = M.cycle_layout
_G.TerminalSelectProfile = M.select_profile
_G.TerminalSelectInstance = M.select_instance
_G.TerminalResize = M.resize

return M
