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
  {
    name = "medieval",
    label = "Medieval Scriptorium",
    desc = "Illuminated Manuscript, Dragon Gold & Castle Stone (#0e0d0b)",
    icon = "📜 ",
  },
  {
    name = "phosphor",
    label = "Phosphor Terminal",
    desc = "Amber Cathode CRT & Retro Telemetry (#0b0906)",
    icon = "🧪 ",
  },
  {
    name = "espressonoir",
    label = "Espresso Roast",
    desc = "Warm Lo-Fi Cafe Noir, Steamed Crema & Matcha (#120e0d)",
    icon = "☕ ",
  },
  {
    name = "frostbite",
    label = "Glacial Arctic",
    desc = "Sub-Zero Scandinavian Frost & Polar Cyan (#080c12)",
    icon = "❄️ ",
  },
  {
    name = "abyssal",
    label = "Abyssal Trench",
    desc = "Mariana Depths & Bioluminescent Electric Aqua (#05080f)",
    icon = "🪼 ",
  },
  {
    name = "nocturne",
    label = "Crimson Nocturne",
    desc = "Gothic Black Velvet, Mahogany & Dragon Ruby (#0b0709)",
    icon = "🩸 ",
  },
  {
    name = "industrial",
    label = "Cyberdeck Industrial",
    desc = "Hazard Caution Yellow & Matte Titanium (#101214)",
    icon = "⚠️ ",
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

-- Cycle through all handcrafted themes
function M.toggle()
  local current = vim.g.colors_name or M.get_current_theme()
  local cycle = {
    "darkmagic",
    "cyberaurora",
    "medieval",
    "phosphor",
    "espressonoir",
    "frostbite",
    "abyssal",
    "nocturne",
    "industrial",
  }
  local next_theme = cycle[1]
  for i, name in ipairs(cycle) do
    if name == current then
      next_theme = cycle[(i % #cycle) + 1]
      break
    end
  end
  M.set_theme(next_theme, true)
end

-- Interactive theme picker with active selection tracking & live preview
function M.picker()
  local current_theme = vim.g.colors_name or M.get_current_theme()
  local active_idx = 1
  local items = {}

  for idx, t in ipairs(M.themes) do
    local is_active = (t.name == current_theme)
    if is_active then
      active_idx = idx
    end
    table.insert(items, {
      text = t.name,
      name = t.name,
      label = t.label,
      desc = t.desc,
      icon = t.icon,
      is_active = is_active,
    })
  end

  local ok_snacks, snacks = pcall(require, "snacks")
  if ok_snacks and snacks.picker then
    snacks.picker({
      title = "🎨 Color Themes",
      items = items,
      preview = "colorscheme",
      preset = "vertical",
      format = function(item)
        if item.is_active then
          return {
            { item.icon or " ", "Special" },
            { item.label .. "  ", "Bold" },
            { "✓ Active  ", "DiagnosticOk" },
            { "(" .. item.desc .. ")", "Comment" },
          }
        else
          return {
            { item.icon or " ", "Special" },
            { item.label .. "  ", "Normal" },
            { "          ", "Normal" },
            { "(" .. item.desc .. ")", "Comment" },
          }
        end
      end,
      on_show = function(picker)
        if active_idx and active_idx > 1 then
          picker.list:set_target(active_idx)
          picker.list:view(active_idx, 1, true)
        end
      end,
      confirm = function(picker, item)
        picker:close()
        if item and (item.name or item.text) then
          if picker.preview and picker.preview.state then
            picker.preview.state.colorscheme = nil
          end
          local theme_name = item.name or item.text
          vim.schedule(function()
            M.set_theme(theme_name, true)
            if vim.bo.buftype == "" and vim.bo.modifiable then
              pcall(vim.cmd, "startinsert")
            end
          end)
        end
      end,
    })
  else
    local options = {}
    for _, t in ipairs(M.themes) do
      local tag = (t.name == current_theme) and " [Active ✓]" or ""
      table.insert(options, t.icon .. t.label .. tag .. " (" .. t.desc .. ")")
    end
    vim.ui.select(options, { prompt = "🎨 Select Color Theme: ", default = options[active_idx] }, function(choice, idx)
      if idx and M.themes[idx] then
        local chosen = M.themes[idx].name
        vim.schedule(function()
          M.set_theme(chosen, true)
          if vim.bo.buftype == "" and vim.bo.modifiable then
            pcall(vim.cmd, "startinsert")
          end
        end)
      end
    end)
  end
end

-- Apply indent rainbow highlights matching the active color scheme
function M.apply_indent_rainbow()
  vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#e06c75" }) -- Red / Coral
  vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#e5c07b" }) -- Gold / Yellow
  vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#98c379" }) -- Green
  vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#56b6c2" }) -- Cyan / Teal
  vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#61afef" }) -- Blue
  vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#c678dd" }) -- Purple
  -- Indent Scope (Signature LazyVim Glowing Emerald Green)
  vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#a6e3a1", bold = true }) -- Active scope line
  vim.api.nvim_set_hl(0, "SnacksIndentChunk", { fg = "#a6e3a1", bold = true })
  vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#a6e3a1", bold = true })
  vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#3b4252" })
end

-- Listen to any external colorscheme changes and persist them
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    if args.match and args.match ~= "" then
      M.save_theme(args.match)
    end
    M.apply_indent_rainbow()
  end,
  desc = "Persist colorscheme selection and refresh indent rainbow highlights",
})

-- Global bridges
_G.ToggleTheme = M.toggle
_G.SelectThemePicker = M.picker
_G.SetTheme = M.set_theme

return M
