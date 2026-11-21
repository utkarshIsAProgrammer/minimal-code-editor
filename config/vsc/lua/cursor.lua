-- ===================================================================
-- Minimal (vsc) - Cursor Styles & Motion Physics Manager
-- Exclusively includes modern vertical beam and particle/trail styles.
-- Never uses block or underline cursors.
-- ===================================================================

local M = {}

local cursor_file = vim.fn.stdpath("state") .. "/active_cursor.txt"

-- Curated list of modern non-block, non-underline cursor styles
M.styles = {
  {
    id = "fluid",
    name = "Fluid Silk",
    desc = "LazyVim flowing jelly beam with physics trail",
    icon = "✨ ",
    guicursor = "n-v-c-i-ci-ve:ver25-blinkon500-blinkoff500",
    color = "#00e5ff",
    smear = {
      enabled = true,
      vertical_bar_cursor = true,
      vertical_bar_cursor_insert_mode = true,
      smear_insert_mode = true,
      smear_between_neighbor_lines = true,
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      particles_enabled = false,
    },
  },
  {
    id = "sparks",
    name = "Cyber Stardust",
    desc = "Vertical beam emitting glowing particle spark trails",
    icon = "⚡ ",
    guicursor = "n-v-c-i-ci-ve:ver25-blinkon500-blinkoff500",
    color = "#a6e3a1",
    smear = {
      enabled = true,
      vertical_bar_cursor = true,
      vertical_bar_cursor_insert_mode = true,
      smear_insert_mode = true,
      smear_between_neighbor_lines = true,
      stiffness = 0.75,
      trailing_stiffness = 0.45,
      distance_stop_animating = 0.5,
      particles_enabled = true,
      particle_max_num = 14,
      particle_spread = 2,
      particles_per_second = 50,
      particle_max_lifetime = 400,
    },
  },
  {
    id = "chisel",
    name = "Bold Chisel",
    desc = "High-visibility 50% thick vertical beam",
    icon = "💎 ",
    guicursor = "n-v-c-i-ci-ve:ver50-blinkon500-blinkoff500",
    color = "#ff79c6",
    smear = {
      enabled = true,
      vertical_bar_cursor = true,
      vertical_bar_cursor_insert_mode = true,
      smear_insert_mode = true,
      smear_between_neighbor_lines = true,
      stiffness = 0.85,
      trailing_stiffness = 0.6,
      distance_stop_animating = 0.5,
      particles_enabled = false,
    },
  },
  {
    id = "laser",
    name = "Electric Laser",
    desc = "Neon Cyan glowing beam with high-tension snappy spring",
    icon = "🔥 ",
    guicursor = "n-v-c-i-ci-ve:ver30-blinkon400-blinkoff400",
    color = "#00e5ff",
    smear = {
      enabled = true,
      vertical_bar_cursor = true,
      vertical_bar_cursor_insert_mode = true,
      smear_insert_mode = true,
      smear_between_neighbor_lines = true,
      stiffness = 0.9,
      trailing_stiffness = 0.7,
      distance_stop_animating = 0.4,
      particles_enabled = false,
    },
  },
  {
    id = "steady",
    name = "Zen Steady",
    desc = "Solid non-blinking vertical beam (zero distraction)",
    icon = "🧘 ",
    guicursor = "n-v-c-i-ci-ve:ver25-blinkon0",
    color = "#bbccee",
    smear = {
      enabled = false,
    },
  },
  {
    id = "minimal",
    name = "Classic VS Code",
    desc = "Standard crisp blinking beam with instant response",
    icon = "🖋️ ",
    guicursor = "n-v-c-i-ci-ve:ver25-blinkon500-blinkoff500",
    color = "#bbccee",
    smear = {
      enabled = false,
    },
  },
}

-- Load saved cursor style or fallback to fluid
function M.get_current_style()
  if vim.fn.filereadable(cursor_file) == 1 then
    local lines = vim.fn.readfile(cursor_file)
    if lines and lines[1] and lines[1]:match("%S") then
      local saved = vim.trim(lines[1])
      for _, s in ipairs(M.styles) do
        if s.id == saved then
          return saved
        end
      end
    end
  end
  return "fluid"
end

-- Save cursor style to disk
function M.save_style(style_id)
  pcall(vim.fn.mkdir, vim.fn.fnamemodify(cursor_file, ":p:h"), "p")
  vim.fn.writefile({ style_id }, cursor_file)
end

-- Apply cursor style cleanly
function M.set_style(style_id, notify)
  local chosen = nil
  for _, s in ipairs(M.styles) do
    if s.id == style_id or s.name:lower() == tostring(style_id):lower() then
      chosen = s
      break
    end
  end
  if not chosen then
    chosen = M.styles[1]
  end

  -- Apply guicursor
  vim.opt.guicursor = chosen.guicursor

  -- Apply cursor color
  if chosen.color then
    vim.api.nvim_set_hl(0, "Cursor", { bg = chosen.color, fg = "#07070f" })
    vim.api.nvim_set_hl(0, "TermCursor", { bg = chosen.color, fg = "#07070f" })
  end

  -- Apply smear cursor physics
  local ok, sc = pcall(require, "smear_cursor")
  if ok and chosen.smear then
    pcall(sc.setup, chosen.smear)
  end

  M.save_style(chosen.id)

  if notify ~= false then
    vim.notify("✓ Cursor Style: " .. chosen.icon .. chosen.name .. " — " .. chosen.desc, vim.log.levels.INFO, { title = "Minimal Cursor" })
  end
  return true
end

-- Interactive cursor style picker with active tracking
function M.picker()
  local current = M.get_current_style()
  local active_idx = 1
  local items = {}

  for idx, s in ipairs(M.styles) do
    local is_active = (s.id == current)
    if is_active then
      active_idx = idx
    end
    table.insert(items, {
      text = s.name,
      id = s.id,
      label = s.name,
      desc = s.desc,
      icon = s.icon,
      is_active = is_active,
    })
  end

  local ok_snacks, snacks = pcall(require, "snacks")
  if ok_snacks and snacks.picker then
    snacks.picker({
      title = "🖱️ Cursor Styles",
      items = items,
      preset = "vscode",
      format = function(item)
        if item.is_active then
          return {
            { item.icon or "🖱️ ", "Special" },
            { item.label .. "  ", "Bold" },
            { "✓ Active  ", "DiagnosticOk" },
            { "(" .. item.desc .. ")", "Comment" },
          }
        else
          return {
            { item.icon or "🖱️ ", "Special" },
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
        if item and (item.id or item.text) then
          local chosen_id = item.id or item.text
          vim.schedule(function()
            M.set_style(chosen_id, true)
            if vim.bo.buftype == "" and vim.bo.modifiable then
              pcall(vim.cmd, "startinsert")
            end
          end)
        end
      end,
    })
  else
    local options = {}
    for _, s in ipairs(M.styles) do
      local tag = (s.id == current) and " [Active ✓]" or ""
      table.insert(options, s.icon .. s.name .. tag .. " (" .. s.desc .. ")")
    end
    vim.ui.select(options, { prompt = "🖱️ Select Cursor Style: ", default = options[active_idx] }, function(choice, idx)
      if idx and M.styles[idx] then
        local chosen_id = M.styles[idx].id
        vim.schedule(function()
          M.set_style(chosen_id, true)
          if vim.bo.buftype == "" and vim.bo.modifiable then
            pcall(vim.cmd, "startinsert")
          end
        end)
      end
    end)
  end
end

-- Cycle through available cursor styles
function M.cycle()
  local current = M.get_current_style()
  local next_style = M.styles[1].id
  for i, s in ipairs(M.styles) do
    if s.id == current then
      next_style = M.styles[(i % #M.styles) + 1].id
      break
    end
  end
  M.set_style(next_style, true)
end

-- Initialize on editor start
function M.setup()
  local saved = M.get_current_style()
  M.set_style(saved, false)
end

-- Global bridges
_G.SelectCursorPicker = M.picker
_G.CycleCursorStyle = M.cycle
_G.SetCursorStyle = M.set_style

return M
