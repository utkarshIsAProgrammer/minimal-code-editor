-- ===================================================================
-- Minimal (vsc) - Persistent Recent Workspaces & Files Tracker
-- (Strictly tracks user-opened projects & files - Zero System Clutter)
-- ===================================================================

local M = {}

local recents_path = vim.fn.stdpath("state") .. "/recents.json"

-- Helper to detect and filter out system paths, plugins, and temporary clutter
local function is_clutter(path)
  if not path or path == "" then return true end
  local normalized = path:gsub("\\", "/")
  local ignore_patterns = {
    "/%.git/",
    "/%.git$",
    "/node_modules/",
    "/%.local/",
    "/%.cache/",
    "/tmp/",
    "/usr/",
    "/etc/",
    "/opt/",
    "lazy%.nvim",
    "nvim%-web%-devicons",
    "snacks%.nvim",
    "blink%.cmp",
    "treesitter",
    "bufferline",
    "lualine",
    "conform",
    "mason",
    "%.shada",
    "%.undo",
    "%.swp",
    "%.tmp",
    "nvim%-config%-backup",
    "SilentSDDM",
  }
  for _, pat in ipairs(ignore_patterns) do
    if normalized:find(pat) then return true end
  end
  return false
end

-- Load persistent recents from disk
function M.load()
  if vim.fn.filereadable(recents_path) == 0 then
    return { folders = {}, files = {} }
  end
  local content = vim.fn.readfile(recents_path)
  if not content or #content == 0 then
    return { folders = {}, files = {} }
  end
  local ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
  if ok and type(data) == "table" then
    data.folders = data.folders or {}
    data.files = data.files or {}
    return data
  end
  return { folders = {}, files = {} }
end

-- Save persistent recents to disk
function M.save(data)
  pcall(vim.fn.mkdir, vim.fn.fnamemodify(recents_path, ":p:h"), "p")
  local json = vim.json.encode(data)
  vim.fn.writefile({ json }, recents_path)
end

-- Add a folder/workspace to recents
function M.add_folder(folder_path)
  if not folder_path or folder_path == "" then return end
  local p = vim.fn.fnamemodify(vim.fn.expand(folder_path), ":p"):gsub("/+$", "")
  if is_clutter(p) or vim.fn.isdirectory(p) == 0 then return end
  -- Do not track root or home itself as a standalone project
  if p == "/" or p:match("^%a:[/\\]?$") or p == vim.fn.expand("~") then return end

  local data = M.load()
  local new_folders = { p }
  for _, f in ipairs(data.folders) do
    if f ~= p and vim.fn.isdirectory(f) == 1 and not is_clutter(f) then
      table.insert(new_folders, f)
      if #new_folders >= 25 then break end
    end
  end
  data.folders = new_folders
  M.save(data)
end

-- Add a file to recents
function M.add_file(file_path)
  if not file_path or file_path == "" then return end
  local p = vim.fn.fnamemodify(vim.fn.expand(file_path), ":p")
  if is_clutter(p) or vim.fn.filereadable(p) == 0 then return end

  local data = M.load()
  local new_files = { p }
  for _, f in ipairs(data.files) do
    if f ~= p and vim.fn.filereadable(f) == 1 and not is_clutter(f) then
      table.insert(new_files, f)
      if #new_files >= 30 then break end
    end
  end
  data.files = new_files
  M.save(data)
end

-- Clean Recent Projects & Files Picker
function M.picker()
  local data = M.load()
  local items = {}

  -- 1. Add Recent Projects / Folders first
  for _, folder in ipairs(data.folders) do
    if vim.fn.isdirectory(folder) == 1 then
      local name = vim.fn.fnamemodify(folder, ":t")
      local display = vim.fn.fnamemodify(folder, ":~")
      table.insert(items, {
        file = folder,
        dir = true,
        text = "󰉎 " .. name .. "  " .. display,
        name = name,
        display = display,
        type = "folder",
      })
    end
  end

  -- 2. Add Recent Files
  for _, file in ipairs(data.files) do
    if vim.fn.filereadable(file) == 1 then
      local name = vim.fn.fnamemodify(file, ":t")
      local dir_display = vim.fn.fnamemodify(file, ":~:h")
      table.insert(items, {
        file = file,
        dir = false,
        text = " " .. name .. "  " .. dir_display,
        name = name,
        display = dir_display,
        type = "file",
      })
    end
  end

  if #items == 0 then
    vim.notify("No recent projects or files yet. Open any file or folder to start tracking!", vim.log.levels.INFO, { title = "Recent" })
    return
  end

  local ok_snacks, snacks = pcall(require, "snacks")
  if not ok_snacks or not snacks.picker then
    vim.notify("Snacks picker is not available", vim.log.levels.ERROR)
    return
  end

  snacks.picker({
    title = "Recent Projects & Files",
    items = items,
    format = function(item)
      local icon = item.type == "folder" and "󰉎 " or " "
      local icon_hl = item.type == "folder" and "Directory" or "Normal"
      return {
        { icon, icon_hl },
        { item.name .. "  ", "Bold" },
        { "(" .. item.display .. ")", "Comment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      if not item or not item.file then return end
      if item.dir or item.type == "folder" then
        vim.fn.chdir(item.file)
        M.add_folder(item.file)
        vim.notify("Workspace opened: " .. item.file, vim.log.levels.INFO, { title = "Open Project" })
        vim.schedule(function()
          snacks.explorer({ cwd = item.file })
        end)
      else
        M.add_file(item.file)
        M.add_folder(vim.fn.fnamemodify(item.file, ":p:h"))
        vim.cmd("edit " .. vim.fn.fnameescape(item.file))
        vim.schedule(function()
          if vim.bo.buftype == "" and vim.bo.modifiable then
            vim.cmd("startinsert")
          end
        end)
      end
    end,
  })
end

-- Global bridges
_G.ShowRecentPicker = M.picker
_G.AddRecentFolder = M.add_folder
_G.AddRecentFile = M.add_file

-- Automatically track files and folders opened on startup or during editing
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg and arg ~= "" then
      local expanded = vim.fn.expand(arg)
      if vim.fn.isdirectory(expanded) == 1 then
        M.add_folder(expanded)
      elseif vim.fn.filereadable(expanded) == 1 then
        M.add_file(expanded)
        M.add_folder(vim.fn.fnamemodify(expanded, ":p:h"))
      end
    else
      local cwd = vim.fn.getcwd()
      if cwd ~= vim.fn.expand("~") and cwd ~= "/" and not is_clutter(cwd) then
        M.add_folder(cwd)
      end
    end
  end,
  desc = "Track opened workspace or file on startup",
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function(args)
    local buf = args.buf
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      if name and name ~= "" and vim.fn.filereadable(name) == 1 and not is_clutter(name) then
        M.add_file(name)
        M.add_folder(vim.fn.fnamemodify(name, ":p:h"))
      end
    end
  end,
  desc = "Track user-opened and saved files in recents",
})

return M
