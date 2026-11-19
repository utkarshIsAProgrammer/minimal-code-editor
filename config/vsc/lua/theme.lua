-- ===================================================================
-- Minimal (vsc) - Theme Manager & Persistence
-- Supports Dark Magic, Nerd Dark, Cyber Aurora, Catppuccin, etc.
-- ===================================================================

local M = {}

local theme_file = vim.fn.stdpath("state") .. "/active_theme.txt"

-- Curated list of bespoke themes
M.themes = {
  {
    name = "darkmagic",
    label = "Dark Magic",
    desc = "Neon Synthwave & Cyberpunk (#07070f)",
    icon = "🔮 ",
  },
  {
    name = "nerddark",
    label = "Nerd Dark",
    desc = "Old-school Hacker / Kanagawa & Gruvbox (#07070f)",
    icon = "🌿 ",
  },
  {
    name = "cyberaurora",
    label = "Cyber Aurora",
    desc = "High-contrast Electric Aurora on Deep Midnight",
    icon = "❄️ ",
  },
  {
    name = "catppuccin",
    label = "Catppuccin Mocha",
    desc = "Soothing pastel dark palette",
    icon = "🐱 ",
  },
  {
    name = "habamax",
    label = "Habamax",
    desc = "Clean minimalist high-contrast dark",
    icon = "🌙 ",
  },
  {
    name = "retrobox",
    label = "Retrobox",
    desc = "Warm retro dark theme",
    icon = "🪵 ",
  },
}

-- Load saved theme or fallback to darkmagic
function M.get_current_theme()
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if lines and lines[1] and lines[1]:match("%S") then
      local saved = vim.trim(lines[1])
      if vim.fn.empty(vim.fn.globpath(vim.o.runtimepath, "colors/" .. saved .. ".*")) == 0 then
        return saved
      end
    end
  end
  return "darkmagic"
end

-- Save theme to disk
function M.save_theme(theme_name)
  pcall(vim.fn.mkdir, vim.fn.fnamemodify(theme_file, ":p:h"), "p")
  vim.fn.writefile({ theme_name }, theme_file)
end

-- Apply theme cleanly
function M.set_theme(theme_name, notify)
  local ok, err = pcall(vim.cmd, "colorscheme " .. theme_name)
  if ok then
    M.save_theme(theme_name)
    pcall(function()
      local lualine = require("lualine")
      lualine.setup({ options = { theme = "auto" } })
    end)
    if notify ~= false then
      local label = theme_name
      for _, t in ipairs(M.themes) do
        if t.name == theme_name then
          label = t.icon .. t.label .. " — " .. t.desc
          break
        end
      end
      vim.notify("✓ Switched to " .. label, vim.log.levels.INFO, { title = "Minimal Theme" })
    end
    return true
  else
    vim.notify("Failed to apply theme '" .. theme_name .. "': " .. tostring(err), vim.log.levels.ERROR, { title = "Minimal Theme" })
    return false
  end
end

-- Cycle through the 3 primary handcrafted themes (Dark Magic -> Nerd Dark -> Cyber Aurora)
function M.toggle()
  local current = vim.g.colors_name or M.get_current_theme()
  local cycle = { "darkmagic", "nerddark", "cyberaurora" }
  local next_theme = cycle[1]
  for i, name in ipairs(cycle) do
    if name == current then
      next_theme = cycle[(i % #cycle) + 1]
      break
    end
  end
  M.set_theme(next_theme, true)
end

-- Interactive theme picker with live preview
function M.picker()
  local items = {}
  for _, t in ipairs(M.themes) do
    table.insert(items, {
      text = t.icon .. t.label .. "  -  " .. t.desc,
      name = t.name,
      label = t.label,
      desc = t.desc,
      icon = t.icon,
    })
  end

  local ok_snacks, snacks = pcall(require, "snacks")
  if ok_snacks and snacks.picker then
    snacks.picker({
      title = "🎨 Color Themes",
      items = items,
      format = function(item)
        return {
          { item.icon or " ", "Special" },
          { item.label .. "  ", "Bold" },
          { "(" .. item.desc .. ")", "Comment" },
        }
      end,
      confirm = function(picker, item)
        picker:close()
        if item and item.name then
          M.set_theme(item.name, true)
        end
      end,
    })
  else
    local options = {}
    for _, t in ipairs(M.themes) do
      table.insert(options, t.icon .. t.label .. " (" .. t.desc .. ")")
    end
    vim.ui.select(options, { prompt = "🎨 Select Color Theme: " }, function(choice, idx)
      if idx and M.themes[idx] then
        M.set_theme(M.themes[idx].name, true)
      end
    end)
  end
end

-- Listen to any external colorscheme changes and persist them
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    if args.match and args.match ~= "" then
      M.save_theme(args.match)
    end
  end,
  desc = "Persist colorscheme selection across restarts",
})

-- Global bridges
_G.ToggleTheme = M.toggle
_G.SelectThemePicker = M.picker
_G.SetTheme = M.set_theme

return M
