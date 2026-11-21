-- ===================================================================
-- Minimal (vsc) - Theme Manager & Persistence
-- Exclusively includes Dark Magic and Cyber Aurora
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
    name = "cyberaurora",
    label = "Cyber Aurora",
    desc = "High-contrast Electric Aurora on Deep Midnight",
    icon = "🌌 ",
  },
}

-- Load saved theme or fallback to darkmagic
function M.get_current_theme()
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if lines and lines[1] and lines[1]:match("%S") then
      local saved = vim.trim(lines[1])
      for _, t in ipairs(M.themes) do
        if t.name == saved then
          return saved
        end
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

-- Toggle between Dark Magic and Cyber Aurora (F10)
function M.toggle()
  local current = vim.g.colors_name or M.get_current_theme()
  local next_theme = (current == "darkmagic") and "cyberaurora" or "darkmagic"
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
