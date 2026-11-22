-- ===================================================================
-- Minimal (vsc) - Live Server Manager
-- Instant local HTTP server with live reloading (VS Code muscle memory)
-- Handcrafted by indiedev
-- ===================================================================

local M = {}

M.job_id = nil
M.port = 5500
M.root_dir = nil
M.server_type = nil

-- Check if Live Server is currently running
function M.is_running()
  return M.job_id ~= nil
end

-- Determine best command available for live serving
local function get_server_command(root, port)
  -- 1. Bun live-server (fastest startup & live websocket reload)
  if vim.fn.executable("bun") == 1 then
    return "bun x live-server " .. vim.fn.shellescape(root) .. " --port=" .. port .. " --wait=100 --quiet", "bun"
  end
  -- 2. NPX live-server
  if vim.fn.executable("npx") == 1 then
    return "npx --yes live-server " .. vim.fn.shellescape(root) .. " --port=" .. port .. " --wait=100 --quiet", "npx"
  end
  -- 3. Standalone live-server in PATH
  if vim.fn.executable("live-server") == 1 then
    return "live-server " .. vim.fn.shellescape(root) .. " --port=" .. port .. " --wait=100 --quiet", "live-server"
  end
  -- 4. Python 3 built-in http.server (universal fallback)
  if vim.fn.executable("python3") == 1 then
    return "python3 -m http.server " .. port .. " --directory " .. vim.fn.shellescape(root), "python"
  end
  return nil, nil
end

-- Open URL in default system browser
local function open_browser(url)
  if vim.fn.executable("xdg-open") == 1 then
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  elseif vim.fn.executable("open") == 1 then
    vim.fn.jobstart({ "open", url }, { detach = true })
  end
end

-- Start Live Server
function M.start()
  if M.is_running() then
    vim.notify("Live Server is already running on port " .. M.port .. "!", vim.log.levels.WARN, { title = "Live Server" })
    return
  end

  -- Determine root: active file parent dir, or workspace cwd
  local current_buf = vim.api.nvim_buf_get_name(0)
  local root = vim.fn.getcwd()
  if current_buf ~= "" and vim.fn.filereadable(current_buf) == 1 then
    local dir = vim.fn.fnamemodify(current_buf, ":p:h")
    if vim.fn.isdirectory(dir) == 1 then
      root = dir
    end
  end

  local cmd, server_type = get_server_command(root, M.port)
  if not cmd then
    vim.notify("No server runtime found! Please install bun, node (npx), or python3.", vim.log.levels.ERROR, { title = "Live Server" })
    return
  end

  M.root_dir = root
  M.server_type = server_type
  local url = "http://127.0.0.1:" .. M.port

  M.job_id = vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      M.job_id = nil
      if exit_code ~= 0 and exit_code ~= 143 and exit_code ~= 130 then
        vim.notify("Live Server terminated with exit code " .. exit_code, vim.log.levels.WARN, { title = "Live Server" })
      end
    end,
  })

  if M.job_id and M.job_id > 0 then
    vim.defer_fn(function()
      open_browser(url)
    end, 600)
    vim.notify("⚡ Live Server active at " .. url .. "\nRoot: " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.INFO, { title = "Live Server" })
  else
    M.job_id = nil
    vim.notify("Failed to launch Live Server.", vim.log.levels.ERROR, { title = "Live Server" })
  end
end

-- Stop Live Server
function M.stop()
  if not M.is_running() then
    vim.notify("Live Server is not running.", vim.log.levels.INFO, { title = "Live Server" })
    return
  end

  pcall(vim.fn.jobstop, M.job_id)
  M.job_id = nil
  vim.notify("✓ Live Server stopped.", vim.log.levels.INFO, { title = "Live Server" })
end

-- Toggle Live Server
function M.toggle()
  if M.is_running() then
    M.stop()
  else
    M.start()
  end
end

-- User commands & global bridges
vim.api.nvim_create_user_command("LiveServer", function() M.toggle() end, { desc = "Toggle local Live Server" })
vim.api.nvim_create_user_command("LiveServerStart", function() M.start() end, { desc = "Start local Live Server" })
vim.api.nvim_create_user_command("LiveServerStop", function() M.stop() end, { desc = "Stop local Live Server" })

_G.LiveServerToggle = M.toggle
_G.LiveServerStart = M.start
_G.LiveServerStop = M.stop

return M
