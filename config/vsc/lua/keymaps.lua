-- ===================================================================
-- Terminal VS Code (vsc) - Pure VS Code & Normal PC Keymaps
-- (Zero Vim Modal Keys - Typing & Shortcuts feel 100% like VS Code)
-- ===================================================================

local map = vim.keymap.set

-- ===================================================================
-- USER CUSTOM KEYBINDINGS
-- Add your own custom shortcuts here! Examples:
-- map({ "n", "i" }, "<C-k><C-c>", function() ... end, { desc = "My Keybind" })
-- ===================================================================

-- -------------------------------------------------------------------
-- 1. 100% Modeless Typing: Pure Non-Modal Editor (Zero Normal Mode)
-- -------------------------------------------------------------------
_G.skip_insert_autocmd = false

local function ensure_insert_mode(buf)
  if _G.skip_insert_autocmd then return end
  buf = buf or vim.api.nvim_get_current_buf()
  if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" and vim.bo[buf].modifiable) then
    return
  end
  local ft = vim.bo[buf].filetype
  if ft == "snacks_dashboard" or ft:find("dashboard") or ft:find("picker") or ft:find("snacks") then
    return
  end
  -- Only suppress insert mode on initial startup before VimEnter when opening Snacks dashboard
  if vim.v.vim_did_enter == 0 and vim.fn.argc() == 0 then
    local name = vim.api.nvim_buf_get_name(buf)
    if (name == "" or name == nil) and vim.api.nvim_buf_line_count(buf) <= 1 then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
      if #lines == 0 or lines[1] == "" then
        return
      end
    end
  end
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buftype == ""
      and vim.bo[buf].modifiable
      and vim.bo[buf].filetype ~= "snacks_dashboard"
      and not vim.bo[buf].filetype:find("picker")
    then
      vim.cmd("startinsert")
    end
  end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "InsertLeave", "FocusGained", "VimEnter", "ModeChanged" }, {
  callback = function(args)
    if args.event == "ModeChanged" and not args.match:find(":n") then
      return
    end
    ensure_insert_mode(args.buf)
  end,
  desc = "Maintain 100% Modeless Typing in all editable documents",
})

-- -------------------------------------------------------------------
-- 1b. Neutralize Normal Mode: Typing & Clicking in Editable Buffers
-- Any keystroke in an editable document types the character and ensures
-- Insert mode. Zero Vim modal commands can execute in document buffers.
-- -------------------------------------------------------------------
map("n", "<LeftMouse>", "<LeftMouse><cmd>startinsert<cr>", { desc = "Click to focus and type (Modeless)" })

local function bind_normal_mode_typing()
  for code = 32, 126 do
    local char = string.char(code)
    local key_repr = char
    if char == " " then
      key_repr = "<Space>"
    elseif char == "|" then
      key_repr = "<Bar>"
    elseif char == "\\" then
      key_repr = "<Bslash>"
    end
    map("n", key_repr, function()
      local cur_buf = vim.api.nvim_get_current_buf()
      if vim.bo[cur_buf].buftype == ""
        and vim.bo[cur_buf].modifiable
        and vim.bo[cur_buf].filetype ~= "snacks_dashboard"
        and not vim.bo[cur_buf].filetype:find("picker")
        and not vim.bo[cur_buf].filetype:find("explorer")
      then
        return "i" .. char
      end
      return char
    end, { expr = true, silent = true, desc = "Type " .. char .. " (100% Modeless)" })
  end
end
bind_normal_mode_typing()

-- -------------------------------------------------------------------
-- 2. Modeless Entry: Files start in Insert mode; Esc switches to Normal mode
-- -------------------------------------------------------------------

-- Direct :q interception on Enter: typing :q, :qa, :q!, :wq, :x, :w and hitting Enter quits/saves immediately!
local function handle_quit_or_newline(is_insert)
  local line = vim.api.nvim_get_current_line()
  local trimmed = vim.trim(line)
  if trimmed == ":q" or trimmed == ":qa" or trimmed == ":q!" or trimmed == ":wq" or trimmed == ":x" or trimmed == ":exit" or trimmed == ":quit" or trimmed == ":w" or trimmed == ":wa" then
    vim.api.nvim_set_current_line("")
    if trimmed == ":q!" then
      vim.cmd("qa!")
    elseif trimmed == ":wq" or trimmed == ":x" then
      vim.cmd("wa")
      vim.cmd("qa")
    elseif trimmed == ":w" or trimmed == ":wa" then
      _G.SmartSave(false)
    else
      _G.SmartQuit()
    end
    return ""
  end
  return is_insert and "<CR>" or "o"
end

map("n", "<CR>", function()
  if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.filetype ~= "snacks_dashboard" then
    return handle_quit_or_newline(false)
  end
  return "<CR>"
end, { expr = true, silent = true })

map("i", "<CR>", function()
  if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.filetype ~= "snacks_dashboard" then
    return handle_quit_or_newline(true)
  end
  return "<CR>"
end, { expr = true, silent = true })

map("n", "<BS>", function()
  if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.filetype ~= "snacks_dashboard" then
    return "i<BS>"
  end
  return "<BS>"
end, { expr = true, silent = true })

map("n", "<Del>", function()
  if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.filetype ~= "snacks_dashboard" then
    return '"_x'
  end
  return "<Del>"
end, { expr = true, silent = true })

-- -------------------------------------------------------------------
-- 3. Escape Key: Closes pickers, popups & suggestions (100% Modeless)
-- -------------------------------------------------------------------
local function handle_escape()
  vim.cmd("nohlsearch")

  -- Close mouse hover popup if open
  if _G.close_mouse_hover then
    pcall(_G.close_mouse_hover)
  end

  -- Close code suggestion popup (blink.cmp) or native popup immediately & synchronously
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink then
    pcall(blink.cancel)
    pcall(blink.hide)
    pcall(function()
      local trigger = require("blink.cmp.completion.trigger")
      if trigger and trigger.hide then trigger.hide() end
    end)
    pcall(function()
      local menu = require("blink.cmp.completion.windows.menu")
      if menu then
        if menu.close then menu.close() end
        if menu.win and menu.win:is_open() then menu.win:close() end
      end
      local docs = require("blink.cmp.completion.windows.documentation")
      if docs and docs.win and docs.win:is_open() then docs.win:close() end
      local sig = require("blink.cmp.signature.window")
      if sig and sig.win and sig.win:is_open() then sig.win:close() end
    end)
  end

  if vim.fn.pumvisible() == 1 then
    pcall(vim.fn.feedkeys, vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n")
  end

  -- Close Snacks picker if open
  local ok_snacks, snacks = pcall(require, "snacks")
  if ok_snacks and snacks.picker then
    local pickers = snacks.picker.get()
    if #pickers > 0 then
      for _, p in ipairs(pickers) do
        pcall(function() p:close() end)
      end
      return
    end
  end

  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[cur_buf].filetype
  local bt = vim.bo[cur_buf].buftype
  local win_cfg = vim.api.nvim_win_get_config(cur_win)

  -- On dashboard: keep dashboard intact
  if ft == "snacks_dashboard" or ft:find("dashboard") then
    return
  end

  -- If inside snacks explorer sidebar, close it
  if ft == "snacks_explorer" or ft:find("explorer") or ft:find("snacks_picker") then
    if ok_snacks and snacks.explorer then
      pcall(function() snacks.explorer() end)
    else
      pcall(vim.cmd, "close")
    end
    return
  end

  -- If inside snacks terminal, hide it
  if ft == "snacks_terminal" or bt == "terminal" then
    if ok_snacks and snacks.terminal then
      pcall(function() snacks.terminal.toggle() end)
    end
    return
  end

  -- If inside a floating window (dialogs, popups, inputs, hover docs), close it
  if win_cfg.relative ~= "" then
    pcall(vim.api.nvim_win_close, cur_win, true)
    return
  end

  -- Close any open floating windows across the tabpage (problem details, hover docs, popups)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= cur_win and vim.api.nvim_win_is_valid(win) then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= "" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end

  -- If in selection mode (visual/select), cancel selection and stay in typing mode
  local m = vim.fn.mode()
  if m == "s" or m == "x" or m == "v" or m == "V" or m == "\22" then
    vim.cmd("normal! \x1b")
    vim.cmd("startinsert")
    return
  end

  -- Pure Modeless: ALWAYS remain in Insert/Typing mode (Zero Normal Mode)
  vim.cmd("startinsert")
end

map({ "n", "i", "s", "x" }, "<Esc>", handle_escape, { desc = "Close Menus & Popups (100% Modeless Esc)" })
map({ "n", "i", "s", "x" }, "<S-Esc>", handle_escape, { desc = "Close Menus & Popups (100% Modeless Shift+Esc)" })
_G.handle_escape = handle_escape


-- -------------------------------------------------------------------
-- 4. Modeless Clipboard Operations (Ctrl+C, Ctrl+V, Ctrl+X)
-- -------------------------------------------------------------------
local function copy_selection()
  vim.cmd('normal! \x1bgv"+y')
  local content = vim.fn.getreg('+')
  vim.fn.setreg('*', content)
  vim.fn.setreg('"', content)
  vim.cmd('normal! gv')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-g>', true, false, true), 'n', false)
  vim.notify("Selection copied to clipboard", vim.log.levels.INFO)
end

local function copy_line()
  local line = vim.api.nvim_get_current_line()
  vim.fn.setreg('+', line .. '\n', 'l')
  vim.fn.setreg('*', line .. '\n', 'l')
  vim.fn.setreg('"', line .. '\n', 'l')
  vim.notify("Line copied to clipboard", vim.log.levels.INFO)
end

local function cut_selection()
  vim.cmd('normal! \x1bgv"+d')
  local content = vim.fn.getreg('+')
  vim.fn.setreg('*', content)
  vim.fn.setreg('"', content)
  vim.cmd('startinsert')
end

local function cut_line_insert()
  local line = vim.api.nvim_get_current_line()
  vim.fn.setreg('+', line .. '\n', 'l')
  vim.fn.setreg('*', line .. '\n', 'l')
  vim.fn.setreg('"', line .. '\n', 'l')
  vim.cmd('normal! "_dd')
  vim.cmd('startinsert')
end

local function paste_selection()
  vim.cmd('normal! \x1bgv"_d')
  vim.cmd('startinsert')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r><C-o>+', true, false, true), 'n', false)
end

local function delete_selection()
  vim.cmd('normal! \x1bgv"_d')
  vim.cmd('startinsert')
end

-- Ctrl+C: Copy to system clipboard (NEVER kills the editor!)
map({ "x", "s" }, "<C-c>", copy_selection, { desc = "Copy Selection (VS Code Ctrl+C)" })
map("n", "<C-c>", copy_line, { desc = "Copy Current Line (VS Code Ctrl+C)" })
map("i", "<C-c>", copy_line, { desc = "Copy Current Line (VS Code Ctrl+C)" })

-- Ctrl+V: Paste from system clipboard
map("n", "<C-v>", '"+p', { desc = "Paste (VS Code Ctrl+V)" })
map({ "x", "s" }, "<C-v>", paste_selection, { desc = "Paste Over Selection (VS Code Ctrl+V)" })
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Paste from Clipboard (safe indent)" })

-- Ctrl+X: Cut to system clipboard
map({ "x", "s" }, "<C-x>", cut_selection, { desc = "Cut Selection (VS Code Ctrl+X)" })
map("n", "<C-x>", cut_line_insert, { desc = "Cut Current Line (VS Code Ctrl+X)" })
map("i", "<C-x>", cut_line_insert, { desc = "Cut Current Line (VS Code Ctrl+X)" })

-- Smart Quit: Checks unsaved changes, presents friendly UI or quits cleanly
function _G.SmartQuit()
  local modified_named = {}
  local modified_untitled = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].modified then
      local b_name = vim.api.nvim_buf_get_name(b)
      if b_name ~= "" then
        table.insert(modified_named, vim.fn.fnamemodify(b_name, ":t"))
      else
        table.insert(modified_untitled, b)
      end
    end
  end

  local total_modified = #modified_named + #modified_untitled
  if total_modified == 0 then
    vim.cmd("qa")
    return
  end

  local display_list = {}
  for _, name in ipairs(modified_named) do
    table.insert(display_list, name)
  end
  if #modified_untitled > 0 then
    table.insert(display_list, string.format("%d Untitled file(s)", #modified_untitled))
  end

  local msg = string.format("Save changes to %d file(s) before quitting? (%s)", total_modified, table.concat(display_list, ", "))
  vim.ui.select({
    "Save All and Quit",
    "Discard Changes and Quit (Force)",
    "Cancel",
  }, {
    prompt = msg,
  }, function(choice)
    if choice == "Save All and Quit" then
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(b) and vim.bo[b].modified and vim.api.nvim_buf_get_name(b) ~= "" then
          pcall(vim.api.nvim_buf_call, b, function() vim.cmd("w") end)
        end
      end
      if #modified_untitled > 0 then
        local next_untitled = modified_untitled[1]
        vim.api.nvim_set_current_buf(next_untitled)
        _G.SmartSave(false, function(success)
          if success then
            _G.SmartQuit()
          end
        end)
        return
      end
      vim.cmd("qa")
    elseif choice == "Discard Changes and Quit (Force)" then
      vim.cmd("qa!")
    end
  end)
end

-- Ctrl+Q, Alt+Q, Alt+F4: Quit application cleanly from any mode
map({ "n", "i", "s", "x", "t" }, "<C-q>", function() _G.SmartQuit() end, { desc = "Quit Minimal (Ctrl+Q)" })
map({ "n", "i", "s", "x", "t" }, "<C-Q>", function() _G.SmartQuit() end, { desc = "Quit Minimal (Ctrl+Q)" })
map({ "n", "i", "s", "x", "t" }, "<M-q>", function() _G.SmartQuit() end, { desc = "Quit Minimal (Alt+Q)" })
map({ "n", "i", "s", "x", "t" }, "<A-q>", function() _G.SmartQuit() end, { desc = "Quit Minimal (Alt+Q)" })
map({ "n", "i", "s", "x", "t" }, "<M-F4>", function() _G.SmartQuit() end, { desc = "Quit Minimal (Alt+F4)" })

vim.api.nvim_create_user_command("Quit", function() _G.SmartQuit() end, { desc = "Quit Minimal Editor" })
vim.api.nvim_create_user_command("Q", function() _G.SmartQuit() end, { desc = "Quit Minimal Editor" })
vim.api.nvim_create_user_command("QA", function() _G.SmartQuit() end, { desc = "Quit Minimal Editor" })
vim.api.nvim_create_user_command("Exit", function() _G.SmartQuit() end, { desc = "Quit Minimal Editor" })

-- Safe Ex command aliases so typing :q, :q!, :wq behaves predictably
vim.cmd([[
  cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() == 'q') ? 'Quit' : 'q'
  cnoreabbrev <expr> q! (getcmdtype() == ':' && getcmdline() == 'q!') ? 'qa!' : 'q!'
  cnoreabbrev <expr> wq (getcmdtype() == ':' && getcmdline() == 'wq') ? 'wqa' : 'wq'
]])

-- Backspace & Delete over selection (Never overwrites clipboard)
map({ "x", "s" }, "<BS>", delete_selection, { desc = "Delete Selection (Backspace)" })
map({ "x", "s" }, "<Del>", delete_selection, { desc = "Delete Selection (Delete)" })

-- -------------------------------------------------------------------
-- 5. Auto-Surround Selection with Quotes or Brackets (VS Code style)
-- Selecting text and typing a quote or bracket wraps the text inside it!
-- -------------------------------------------------------------------
local function wrap_selection(left, right)
  return function()
    local reg_save = vim.fn.getreg('"')
    local regtype_save = vim.fn.getregtype('"')
    vim.cmd('normal! \x1bgv""y')
    local text = vim.fn.getreg('"')
    if not text or text == "" then
      vim.fn.setreg('"', reg_save, regtype_save)
      vim.cmd("startinsert")
      return
    end

    -- Intelligent Whitespace Handling:
    -- If text was selected with leading or trailing whitespace (e.g. from mouse drag,
    -- word selection, or double click), keep the whitespace OUTSIDE the quotes/brackets!
    local leading_ws = text:match("^(%s*)") or ""
    local trailing_ws = text:match("(%s*)$") or ""
    local trimmed = text:sub(#leading_ws + 1, #text - #trailing_ws)

    local wrapped
    if trimmed == "" then
      wrapped = left .. text .. right
    else
      wrapped = leading_ws .. left .. trimmed .. right .. trailing_ws
    end

    vim.fn.setreg('"', wrapped)
    vim.cmd('normal! gv""p')
    vim.fn.setreg('"', reg_save, regtype_save)

    -- Place cursor right after the closing quote/bracket in insert mode
    local cur = vim.api.nvim_win_get_cursor(0)
    local line_len = #vim.api.nvim_get_current_line()
    local target_col = math.min(cur[2] + 1, line_len)
    vim.api.nvim_win_set_cursor(0, { cur[1], target_col })
    vim.cmd("startinsert")
  end
end

map({ "x", "s" }, '"', wrap_selection('"', '"'), { desc = "Wrap in Double Quotes" })
map({ "x", "s" }, "'", wrap_selection("'", "'"), { desc = "Wrap in Single Quotes" })
map({ "x", "s" }, "`", wrap_selection("`", "`"), { desc = "Wrap in Backticks" })
map({ "x", "s" }, "(", wrap_selection("(", ")"), { desc = "Wrap in Parentheses" })
map({ "x", "s" }, ")", wrap_selection("(", ")"), { desc = "Wrap in Parentheses" })
map({ "x", "s" }, "[", wrap_selection("[", "]"), { desc = "Wrap in Square Brackets" })
map({ "x", "s" }, "]", wrap_selection("[", "]"), { desc = "Wrap in Square Brackets" })
map({ "x", "s" }, "{", wrap_selection("{", "}"), { desc = "Wrap in Curly Braces" })
map({ "x", "s" }, "}", wrap_selection("{", "}"), { desc = "Wrap in Curly Braces" })
map({ "x", "s" }, "<", wrap_selection("<", ">"), { desc = "Wrap in Angle Brackets" })
map({ "x", "s" }, ">", wrap_selection("<", ">"), { desc = "Wrap in Angle Brackets" })

-- -------------------------------------------------------------------
-- 6. Undo & Redo (Ctrl+Z, Ctrl+Y, Ctrl+Shift+Z)
-- -------------------------------------------------------------------
map("n", "<C-z>", "u", { desc = "Undo (VS Code Ctrl+Z)" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo (VS Code Ctrl+Z)" })
map({ "x", "s" }, "<C-z>", "<Esc>u<cmd>startinsert<cr>", { desc = "Undo (VS Code Ctrl+Z)" })

map("n", "<C-y>", "<C-r>", { desc = "Redo (VS Code Ctrl+Y)" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo (VS Code Ctrl+Y)" })
map({ "x", "s" }, "<C-y>", "<Esc><C-r><cmd>startinsert<cr>", { desc = "Redo (VS Code Ctrl+Y)" })
map({ "n", "i", "x", "s" }, "<C-S-z>", "<Esc><C-r><cmd>startinsert<cr>", { desc = "Redo (VS Code Ctrl+Shift+Z)" })
map({ "n", "i", "x", "s" }, "<C-S-Z>", "<Esc><C-r><cmd>startinsert<cr>", { desc = "Redo (VS Code Ctrl+Shift+Z)" })

-- -------------------------------------------------------------------
-- 7. Select All (Ctrl+A)
-- Enters Select mode so typing immediately replaces all text
-- -------------------------------------------------------------------
map({ "n", "i", "x", "s" }, "<C-a>", "<Esc>ggVG<C-g>", { desc = "Select All (VS Code Ctrl+A)" })

-- -------------------------------------------------------------------
-- 8. File Operations (Smart Save, Save As, Close Tab)
-- -------------------------------------------------------------------
function _G.SmartSave(force_prompt, callback)
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local is_unnamed = (buf_name == "")

  -- If file already exists and user pressed normal Ctrl+S: save immediately
  if not is_unnamed and not force_prompt then
    local ok, err = pcall(function() vim.cmd("write") end)
    if ok then
      local fname = vim.fn.fnamemodify(buf_name, ":t")
      vim.notify("✓ Saved: " .. fname, vim.log.levels.INFO, { title = "Minimal Editor" })
      if _G.AddRecentFile then
        _G.AddRecentFile(buf_name)
      end
      if callback then callback(true) end
    else
      vim.notify("Failed to save: " .. tostring(err), vim.log.levels.ERROR, { title = "Minimal Editor" })
      if callback then callback(false) end
    end
    return
  end

  -- Buffer is untitled or user requested Save As (Ctrl+Shift+S): prompt for name/path
  local default_path = ""
  if not is_unnamed then
    default_path = buf_name
  else
    default_path = vim.fn.getcwd() .. "/"
  end

  vim.ui.input({
    prompt = "💾 Save File As (name or path): ",
    default = default_path,
    completion = "file",
  }, function(input)
    if not input or input:match("^%s*$") then
      vim.notify("Save cancelled", vim.log.levels.WARN, { title = "Minimal Editor" })
      if callback then callback(false) end
      return
    end

    input = vim.trim(input)
    local full_path = vim.fn.fnamemodify(input, ":p")
    local dir = vim.fn.fnamemodify(full_path, ":h")

    if vim.fn.isdirectory(dir) == 0 then
      local ok_dir, err_dir = pcall(vim.fn.mkdir, dir, "p")
      if not ok_dir then
        vim.notify("Failed to create folder: " .. tostring(err_dir), vim.log.levels.ERROR, { title = "Minimal Editor" })
        if callback then callback(false) end
        return
      end
    end

    local ok, err = pcall(function()
      vim.cmd("write! " .. vim.fn.fnameescape(full_path))
      vim.cmd("edit! " .. vim.fn.fnameescape(full_path))
    end)

    if ok then
      vim.notify("✓ Saved as: " .. full_path, vim.log.levels.INFO, { title = "Minimal Editor" })
      if _G.AddRecentFile then
        _G.AddRecentFile(full_path)
      end
      if _G.AddRecentFolder then
        _G.AddRecentFolder(dir)
      end
      vim.schedule(function()
        if vim.bo.buftype == "" and vim.bo.modifiable then
          vim.cmd("startinsert")
        end
      end)
      if callback then callback(true) end
    else
      vim.notify("Failed to save file: " .. tostring(err), vim.log.levels.ERROR, { title = "Minimal Editor" })
      if callback then callback(false) end
    end
  end)
end

map({ "n", "i", "x", "s" }, "<C-s>", function() _G.SmartSave(false) end, { desc = "Save File (VS Code Ctrl+S)" })
map({ "n", "i", "x", "s" }, "<C-S>", function() _G.SmartSave(false) end, { desc = "Save File (VS Code Ctrl+S)" })
map({ "n", "i", "x", "s" }, "<C-S-s>", function() _G.SmartSave(true) end, { desc = "Save As (VS Code Ctrl+Shift+S)" })
map({ "n", "i", "x", "s" }, "<C-S-S>", function() _G.SmartSave(true) end, { desc = "Save As (VS Code Ctrl+Shift+S)" })

vim.api.nvim_create_user_command("Save", function() _G.SmartSave(false) end, { desc = "Save current file" })
vim.api.nvim_create_user_command("SaveAs", function() _G.SmartSave(true) end, { desc = "Save file with new name/path" })

-- Expand :w on untitled buffers to run SmartSave instead of E32 error
vim.cmd([[
  cnoreabbrev <expr> w (getcmdtype() == ':' && getcmdline() == 'w' && expand('%') == '') ? 'Save' : 'w'
  cnoreabbrev <expr> W (getcmdtype() == ':' && getcmdline() == 'W' && expand('%') == '') ? 'Save' : 'w'
]])
local function close_current_buffer()
  local ok_snacks, snacks = pcall(require, "snacks")
  local cur = vim.api.nvim_get_current_buf()

  local remaining = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].filetype ~= "snacks_dashboard" and vim.api.nvim_buf_get_name(b) ~= "" then
      remaining = remaining + 1
    end
  end

  if remaining == 0 and ok_snacks and snacks.dashboard then
    snacks.dashboard.open()
    pcall(vim.api.nvim_buf_delete, cur, { force = true })
  else
    if ok_snacks and snacks.bufdelete then
      snacks.bufdelete({ buf = cur })
    else
      pcall(vim.cmd, "bdelete")
    end
  end
end

function _G.GoToHomescreen()
  if package.loaded["snacks"] and Snacks.dashboard then
    Snacks.dashboard.open()
  end
end
vim.api.nvim_create_user_command("Home", _G.GoToHomescreen, { desc = "Go to Homescreen / Dashboard" })
vim.api.nvim_create_user_command("Dashboard", _G.GoToHomescreen, { desc = "Go to Homescreen / Dashboard" })

-- ===================================================================
-- Homescreen GUI Polish & Bulletproof Controls
-- 1. Hide the blinking writing cursor so it looks like a clean GUI launcher
-- 2. Lock cursor into interactive actions (no roaming outside or left/right wandering)
-- 3. Disable all text selection and copying (clean app experience)
-- 4. Direct action key mappings (f, n, d, o, g, r, c, k, t, q) with ZERO modifiable errors
-- ===================================================================
local function setup_dashboard_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end

  -- 1. Always force clean Normal mode on homescreen
  vim.cmd("stopinsert")

  -- 2. Hide writing beam cursor completely on homescreen
  io.write("\027[?25l")
  io.flush()
  pcall(function() vim.opt_local.guicursor = "n:block-blinkoff" end)

  -- 3. Direct dashboard action key bindings (work in both Normal & Insert mode)
  local dash_actions = {
    ["f"] = function()
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.picker then snacks.picker.files() end
    end,
    ["n"] = function()
      vim.cmd("enew")
      vim.cmd("startinsert")
    end,
    ["d"] = function() _G.CreateNewDirectory() end,
    ["o"] = function() _G.OpenFolderPicker() end,
    ["r"] = function() _G.ShowRecentPicker() end,
    ["c"] = function()
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.picker then snacks.picker.commands() end
    end,
    ["p"] = function() _G.SelectThemePicker() end,
    ["k"] = function() _G.EditKeybindings() end,
    ["t"] = function()
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.terminal then snacks.terminal() end
    end,
    ["q"] = function() _G.SmartQuit() end,
    ["i"] = function()
      vim.cmd("enew")
      vim.cmd("startinsert")
    end,
    ["a"] = function()
      vim.cmd("enew")
      vim.cmd("startinsert")
    end,
  }

  for key, action in pairs(dash_actions) do
    vim.keymap.set({ "n", "i" }, key, action, { buffer = buf, nowait = true, silent = true })
    vim.keymap.set({ "n", "i" }, key:upper(), action, { buffer = buf, nowait = true, silent = true })
  end

  -- 4. Enter key runs the selected item under cursor
  vim.keymap.set({ "n", "i" }, "<CR>", function()
    local ok_snacks, snacks = pcall(require, "snacks")
    if ok_snacks and snacks.dashboard then
      local d = snacks.dashboard.get and snacks.dashboard.get()
      if d and d.find then
        local item = d:find(vim.api.nvim_win_get_cursor(0))
        if item and item.action then
          return d:action(item.action)
        end
      end
    end
  end, { buffer = buf, nowait = true, silent = true })

  -- 5. Disable text selection/copying on homescreen
  for _, mode in ipairs({ "n", "x", "s", "v" }) do
    vim.keymap.set(mode, "v", "<Nop>", { buffer = buf, silent = true })
    vim.keymap.set(mode, "V", "<Nop>", { buffer = buf, silent = true })
    vim.keymap.set(mode, "<C-v>", "<Nop>", { buffer = buf, silent = true })
    vim.keymap.set(mode, "<C-c>", "<Nop>", { buffer = buf, silent = true })
    vim.keymap.set(mode, "<C-x>", "<Nop>", { buffer = buf, silent = true })
  end

  -- 6. Disable horizontal cursor wandering outside the box
  vim.keymap.set({ "n", "i" }, "<Left>", "<Nop>", { buffer = buf, silent = true })
  vim.keymap.set({ "n", "i" }, "<Right>", "<Nop>", { buffer = buf, silent = true })
  vim.keymap.set({ "n", "i" }, "h", "<Nop>", { buffer = buf, silent = true })
  vim.keymap.set({ "n", "i" }, "l", "<Nop>", { buffer = buf, silent = true })

  -- 7. Safe no-ops for all unused keys in normal mode
  for i = 32, 126 do
    local c = string.char(i)
    if not dash_actions[c:lower()] and c ~= ":" and c ~= "j" and c ~= "k" then
      vim.keymap.set("n", c, "<Nop>", { buffer = buf, nowait = true, silent = true })
    end
  end

  vim.keymap.set({ "n", "i" }, "<Esc>", function()
    vim.cmd("stopinsert")
    vim.cmd("nohlsearch")
  end, { buffer = buf, nowait = true, silent = true })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_dashboard",
  callback = function(ev)
    setup_dashboard_buffer(ev.buf)
  end,
  desc = "Configure interactive homescreen controls on FileType",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "snacks_dashboard" then
      setup_dashboard_buffer(ev.buf)
    end
  end,
  desc = "Configure interactive homescreen controls on BufEnter",
})

-- Apply immediately if dashboard is already open
local _init_buf = vim.api.nvim_get_current_buf()
if vim.bo[_init_buf].filetype == "snacks_dashboard" then
  setup_dashboard_buffer(_init_buf)
end

vim.api.nvim_create_autocmd({ "BufLeave", "VimLeavePre" }, {
  callback = function()
    io.write("\027[?25h")
    io.flush()
    pcall(function()
      vim.opt.guicursor = "n-c-sm:block-blinkon500-blinkoff500,i-ci-ve:ver25-blinkon500-blinkoff500,v:block,r-cr:hor20-blinkon500-blinkoff500"
    end)
  end,
  desc = "Restore text editing cursor when leaving homescreen",
})

map({ "n", "i" }, "<C-n>", "<cmd>enew<cr><cmd>startinsert<cr>", { desc = "New File (VS Code Ctrl+N)" })
map("n", "<C-w>", close_current_buffer, { desc = "Close Editor Tab (VS Code Ctrl+W)" })
map({ "n", "i" }, "<C-F4>", close_current_buffer, { desc = "Close Editor Tab (Ctrl+F4)" })
map({ "n", "i" }, "<C-S-w>", function() _G.SmartQuit() end, { desc = "Close Window / Quit (VS Code Ctrl+Shift+W)" })
map({ "n", "i" }, "<C-S-W>", function() _G.SmartQuit() end, { desc = "Close Window / Quit (VS Code Ctrl+Shift+W)" })

-- -------------------------------------------------------------------
-- 9. Open Any Folder & Create Directory
-- -------------------------------------------------------------------
function _G.CreateNewDirectory()
  vim.ui.input({ prompt = "󰉍 Enter directory name or path: ", completion = "dir" }, function(input)
    if not input or input:match("^%s*$") then
      return
    end
    input = vim.trim(input)
    local full_path = vim.fn.fnamemodify(input, ":p")
    local ok, err = pcall(vim.fn.mkdir, full_path, "p")
    if not ok then
      vim.notify("Failed to create directory: " .. tostring(err), vim.log.levels.ERROR, { title = "Directory Creator" })
      return
    end
    vim.fn.chdir(full_path)
    if _G.AddRecentFolder then
      _G.AddRecentFolder(full_path)
    end
    vim.notify("Created & switched workspace to: " .. full_path, vim.log.levels.INFO, { title = "New Directory" })
    vim.schedule(function()
      Snacks.explorer({ cwd = full_path })
    end)
  end)
end

-- -------------------------------------------------------------------
-- Terminal Client Integration (Zero Nested Instances)
-- -------------------------------------------------------------------
function _G.FocusEditorFromTerminal()
  pcall(function()
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.terminal then
      for _, t in ipairs(snacks.terminal.list()) do
        if t:win_valid() then t:hide() end
      end
      local ft = vim.bo.filetype
      local bt = vim.bo.buftype
      if ft == "snacks_terminal" or bt == "terminal" then
        snacks.terminal.toggle()
      end
    end
  end)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.bo[buf].buftype
    local ft = vim.bo[buf].filetype
    if bt == "" and ft ~= "snacks_explorer" and not ft:find("snacks_picker") then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      break
    end
  end
  return "OK"
end

function _G.OpenFileFromTerminal(target_path)
  if not target_path or target_path == "" then
    return _G.FocusEditorFromTerminal()
  end
  local full = vim.fn.fnamemodify(vim.fn.expand(target_path), ":p")

  -- If target is a directory, change workspace
  if vim.fn.isdirectory(full) == 1 then
    vim.fn.chdir(full)
    if _G.AddRecentFolder then _G.AddRecentFolder(full) end
    pcall(function()
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.terminal then
        for _, t in ipairs(snacks.terminal.list()) do
          if t:win_valid() then t:hide() end
        end
      end
      if ok and snacks.explorer then
        snacks.explorer({ cwd = full })
      end
    end)
    vim.notify("✓ Switched workspace: " .. full, vim.log.levels.INFO, { title = "Terminal Workspace" })
    return "OK"
  end

  -- Target is a file: track in recents
  local parent = vim.fn.fnamemodify(full, ":h")
  if vim.fn.isdirectory(parent) == 1 and _G.AddRecentFolder then
    _G.AddRecentFolder(parent)
  end
  if _G.AddRecentFile then _G.AddRecentFile(full) end

  -- If terminal overlay is visible, hide it to reveal editor
  pcall(function()
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.terminal then
      for _, t in ipairs(snacks.terminal.list()) do
        if t:win_valid() then t:hide() end
      end
      local ft = vim.bo.filetype
      local bt = vim.bo.buftype
      if ft == "snacks_terminal" or bt == "terminal" then
        snacks.terminal.toggle()
      end
    end
  end)

  -- Switch focus to a regular editable window
  local target_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.bo[buf].buftype
    local ft = vim.bo[buf].filetype
    if bt == "" and ft ~= "snacks_explorer" and not ft:find("snacks_picker") then
      target_win = win
      break
    end
  end

  if target_win then
    vim.api.nvim_set_current_win(target_win)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(full))
  vim.cmd("startinsert")
  vim.notify("✓ Opened: " .. vim.fn.fnamemodify(full, ":t"), vim.log.levels.INFO, { title = "Editor" })
  return "OK"
end

function _G.OpenFolderPicker(target_dir)
  local ok_snacks, snacks = pcall(require, "snacks")

  local function do_open_dir(dir_path)
    if not dir_path or dir_path == "" then return end
    dir_path = vim.fn.expand(dir_path)
    local full = vim.fn.fnamemodify(dir_path, ":p")

    if vim.fn.isdirectory(full) == 1 then
      vim.fn.chdir(full)
      if _G.AddRecentFolder then _G.AddRecentFolder(full) end
      vim.notify("✓ Workspace opened: " .. full, vim.log.levels.INFO, { title = "Open Folder" })
      vim.schedule(function()
        if ok_snacks and snacks.explorer then
          snacks.explorer({ cwd = full })
        end
      end)
    elseif vim.fn.filereadable(full) == 1 then
      local parent = vim.fn.fnamemodify(full, ":h")
      vim.fn.chdir(parent)
      if _G.AddRecentFolder then _G.AddRecentFolder(parent) end
      if _G.AddRecentFile then _G.AddRecentFile(full) end
      vim.cmd("edit " .. vim.fn.fnameescape(full))
      vim.notify("✓ Opened: " .. vim.fn.fnamemodify(full, ":t"), vim.log.levels.INFO, { title = "Open File" })
    else
      vim.notify("Directory does not exist: " .. dir_path, vim.log.levels.WARN, { title = "Open Folder" })
    end
  end

  if target_dir and target_dir ~= "" then
    do_open_dir(target_dir)
    return
  end

  if not ok_snacks or not snacks.picker then
    vim.ui.input({ prompt = "󰉎 Open Folder Path: ", default = vim.fn.getcwd() .. "/", completion = "dir" }, function(input)
      if input and input ~= "" then
        do_open_dir(input)
      end
    end)
    return
  end

  local uv = vim.uv or vim.loop
  local home = vim.env.HOME or vim.env.USERPROFILE or "."
  local has_fd = vim.fn.executable("fd") == 1

  -- Resolves user input into base directory, search prefix for matching, and filter pattern
  local function resolve_path_and_pattern(raw_query)
    local q = vim.trim(raw_query or "")
    if q == "" then
      return vim.fn.getcwd(), "", ""
    end

    local expanded = q
    if expanded:sub(1, 1) == "~" then
      expanded = home .. expanded:sub(2)
    end

    -- If ends with slash or is a valid directory
    if q:match("/$") or vim.fn.isdirectory(expanded) == 1 then
      local full = vim.fn.fnamemodify(expanded, ":p"):gsub("/+$", "")
      if vim.fn.isdirectory(full) == 1 then
        local prefix = q:match("/$") and q or (q .. "/")
        return full, prefix, ""
      end
    end

    -- If contains a slash, split into parent directory and leaf pattern
    if q:match("/") then
      local dir_part = vim.fn.fnamemodify(q, ":h")
      local leaf_part = vim.fn.fnamemodify(q, ":t")
      local exp_dir = dir_part
      if exp_dir:sub(1, 1) == "~" then
        exp_dir = home .. exp_dir:sub(2)
      end
      local full_dir = vim.fn.fnamemodify(exp_dir, ":p"):gsub("/+$", "")
      if vim.fn.isdirectory(full_dir) == 1 then
        return full_dir, dir_part .. "/", leaf_part:lower()
      end
    end

    -- No valid directory found in query: search relative to cwd with pattern
    return vim.fn.getcwd(), "", q:lower()
  end

  local function scan_directory(base_dir, prefix, pattern)
    local items = {}
    local seen = {}

    -- Parent directory navigation
    local parent_dir = vim.fn.fnamemodify(base_dir, ":h")
    if parent_dir and parent_dir ~= "" and parent_dir ~= base_dir then
      table.insert(items, {
        text = prefix .. "..",
        name = ".. (Parent Directory: " .. vim.fn.fnamemodify(parent_dir, ":~") .. ")",
        file = parent_dir,
        dir = true,
        is_parent = true,
      })
      seen[parent_dir] = true
    end

    local dirs = {}
    local files = {}

    local handle = uv.fs_scandir(base_dir)
    if handle then
      while true do
        local name, type = uv.fs_scandir_next(handle)
        if not name then break end

        local is_dot = name:sub(1, 1) == "."
        local allow = true
        if is_dot and (not pattern or pattern:sub(1, 1) ~= ".") then
          allow = false
        end
        if name == "node_modules" or name == ".git" or name == ".cache" or name == ".local" then
          allow = false
        end

        if allow then
          local full_path = base_dir .. "/" .. name
          local is_dir = (type == "directory")
          local match = true
          if pattern and pattern ~= "" then
            match = name:lower():find(pattern, 1, true) ~= nil
          end
          if match then
            seen[full_path] = true
            local item = {
              text = prefix .. name .. (is_dir and "/" or ""),
              name = name .. (is_dir and "/" or ""),
              file = full_path,
              dir = is_dir,
            }
            if is_dir then
              table.insert(dirs, item)
            else
              table.insert(files, item)
            end
          end
        end
      end
    end

    table.sort(dirs, function(a, b) return a.name:lower() < b.name:lower() end)
    table.sort(files, function(a, b) return a.name:lower() < b.name:lower() end)

    for _, d in ipairs(dirs) do table.insert(items, d) end
    for _, f in ipairs(files) do table.insert(items, f) end

    -- Fallback recursive search via fd if pattern was given and no direct matches found
    if pattern and pattern ~= "" and #dirs == 0 and #files == 0 and has_fd then
      local fd_cmd = string.format("fd --max-depth 4 --color never -E .git -E node_modules -E .cache %s %s 2>/dev/null", vim.fn.shellescape(pattern), vim.fn.shellescape(base_dir))
      local p_handle = io.popen(fd_cmd)
      if p_handle then
        for line in p_handle:lines() do
          local trimmed = vim.trim(line)
          if trimmed ~= "" and not seen[trimmed] then
            seen[trimmed] = true
            local is_d = vim.fn.isdirectory(trimmed) == 1
            local rel = vim.fn.fnamemodify(trimmed, ":~:.")
            if is_d and not rel:match("/$") then rel = rel .. "/" end
            table.insert(items, {
              text = prefix .. rel,
              name = vim.fn.fnamemodify(trimmed, ":t") .. (is_d and "/" or ""),
              file = trimmed,
              dir = is_d,
            })
          end
        end
        p_handle:close()
      end
    end

    return items
  end

  local function drill_into(picker, path)
    if not path or path == "" then return end
    path = vim.fn.expand(path)
    if not path:match("/$") then path = path .. "/" end
    local rel = vim.fn.fnamemodify(path, ":~:.")
    if not rel:match("/$") then rel = rel .. "/" end
    if rel == "./" or rel == "." then rel = "" end
    picker.input:set(rel, rel)
    picker:find({ refresh = false })
    if picker.input and picker.input.win and picker.input.win:valid() then
      picker.input.win:focus()
      vim.cmd("startinsert!")
    end
  end

  snacks.picker({
    title = "Open Project / Folder / File (Tab/Right to browse, Enter to open)",
    live = true,
    format = function(item, picker)
      if item.is_parent then
        return {
          { "󰉍 ", "Special" },
          { item.name or item.text, "Comment" },
        }
      end
      local icon = item.dir and "󰉋 " or "󰈙 "
      local hl = item.dir and "Directory" or "Normal"
      return {
        { icon, hl },
        { item.name or item.text, hl },
      }
    end,
    finder = function(opts, ctx)
      local raw_query = ""
      if ctx.filter then
        if ctx.filter.search and ctx.filter.search ~= "" then
          raw_query = ctx.filter.search
        elseif ctx.filter.pattern and ctx.filter.pattern ~= "" then
          raw_query = ctx.filter.pattern
        end
      end
      if raw_query == "" and ctx.picker and ctx.picker.input then
        pcall(function()
          local text = ctx.picker.input:get()
          if text and text ~= "" then raw_query = text end
        end)
      end
      local base_dir, prefix, pattern = resolve_path_and_pattern(raw_query)

      return function(cb)
        local items = scan_directory(base_dir, prefix, pattern)

        -- At initial root query, also append recent workspaces and standard folders
        if vim.trim(raw_query) == "" then
          if _G.RecentWorkspaces and #_G.RecentWorkspaces > 0 then
            for _, rw in ipairs(_G.RecentWorkspaces) do
              if vim.fn.isdirectory(rw) == 1 and rw ~= base_dir then
                local display_name = "Recent: " .. vim.fn.fnamemodify(rw, ":~") .. "/"
                table.insert(items, {
                  text = vim.fn.fnamemodify(rw, ":~:.") .. "/",
                  name = display_name,
                  file = rw,
                  dir = true,
                })
              end
            end
          end

          local common = { home .. "/Projects", home .. "/Documents", home .. "/Desktop", home .. "/Downloads" }
          for _, c in ipairs(common) do
            if vim.fn.isdirectory(c) == 1 and c ~= base_dir then
              local display_name = vim.fn.fnamemodify(c, ":~") .. "/"
              table.insert(items, {
                text = vim.fn.fnamemodify(c, ":~:.") .. "/",
                name = display_name,
                file = c,
                dir = true,
              })
            end
          end
        end

        for _, it in ipairs(items) do
          cb(it)
        end
      end
    end,
    actions = {
      open_or_drill = function(picker, item)
        item = item or picker:current()
        if not item then
          local text = picker.input:get()
          picker:close()
          do_open_dir(text)
          return
        end

        if item.is_parent then
          drill_into(picker, item.file)
          return
        end

        if item.dir or (item.file and vim.fn.isdirectory(item.file) == 1) then
          picker:close()
          do_open_dir(item.file)
        else
          -- File selected: open directly in editor
          picker:close()
          local full = item.file
          local parent = vim.fn.fnamemodify(full, ":h")
          if vim.fn.isdirectory(parent) == 1 and _G.AddRecentFolder then
            _G.AddRecentFolder(parent)
          end
          if _G.AddRecentFile then _G.AddRecentFile(full) end
          vim.cmd("edit " .. vim.fn.fnameescape(full))
          vim.notify("✓ Opened: " .. vim.fn.fnamemodify(full, ":t"), vim.log.levels.INFO, { title = "Open File" })
        end
      end,
      drill_down = function(picker, item)
        item = item or picker:current()
        if item and (item.dir or item.is_parent or (item.file and vim.fn.isdirectory(item.file) == 1)) then
          drill_into(picker, item.file)
        elseif item and item.file then
          picker.input:set(item.file, item.file)
          picker:find({ refresh = false })
        end
      end,
      go_up = function(picker)
        local text = picker.input:get()
        if text and text ~= "" then
          local clean = text:gsub("/+$", "")
          local parent = vim.fn.fnamemodify(clean, ":h")
          if parent and parent ~= "" and parent ~= "." then
            if not parent:match("/$") then parent = parent .. "/" end
            local rel = vim.fn.fnamemodify(parent, ":~:.")
            if not rel:match("/$") then rel = rel .. "/" end
            if rel == "./" or rel == "." then rel = "" end
            picker.input:set(rel, rel)
          else
            picker.input:set("", "")
          end
          picker:find({ refresh = false })
        end
      end,
    },
    confirm = "open_or_drill",
    win = {
      input = {
        keys = {
          ["<Tab>"] = { "drill_down", mode = { "i", "n" } },
          ["<Right>"] = { "drill_down", mode = { "i", "n" } },
          ["<Left>"] = { "go_up", mode = { "i", "n" } },
        },
      },
      list = {
        keys = {
          ["<Tab>"] = { "drill_down", mode = { "n", "i", "x" } },
          ["<Right>"] = { "drill_down", mode = { "n", "i", "x" } },
          ["<Left>"] = { "go_up", mode = { "n", "i", "x" } },
          ["<CR>"] = { "open_or_drill", mode = { "n", "i", "x" } },
        },
      },
    },
  })
end
_G.OpenProject = _G.OpenFolderPicker

-- Recent Projects & Files (Ctrl+R, Alt+R, :Recent)
map({ "n", "i" }, "<C-r>", function() _G.ShowRecentPicker() end, { desc = "Recent Projects & Files (Ctrl+R)" })
map({ "n", "i" }, "<C-R>", function() _G.ShowRecentPicker() end, { desc = "Recent Projects & Files (Ctrl+R)" })
map({ "n", "i" }, "<M-r>", function() _G.ShowRecentPicker() end, { desc = "Recent Projects & Files (Alt+R)" })
vim.api.nvim_create_user_command("Recent", function() _G.ShowRecentPicker() end, { desc = "Recent Projects & Files" })
vim.api.nvim_create_user_command("Recents", function() _G.ShowRecentPicker() end, { desc = "Recent Projects & Files" })

-- CLI Directory Support: Automatically open directory when passing `vsc /path/to/folder` or `vsc .`
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg and arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      local dir = vim.fn.fnamemodify(arg, ":p")
      vim.fn.chdir(dir)
      vim.schedule(function()
        Snacks.explorer({ cwd = dir })
      end)
    end
  end,
  desc = "Automatically open directory in file explorer",
})

vim.api.nvim_create_user_command("NewDirectory", _G.CreateNewDirectory, { desc = "Create a new directory and switch to it" })
vim.api.nvim_create_user_command("NewFolder", _G.CreateNewDirectory, { desc = "Create a new directory and switch to it" })
vim.api.nvim_create_user_command("OpenFolder", function(opts)
  _G.OpenFolderPicker(opts.args)
end, { nargs = "?", complete = "dir", desc = "Open any folder or project" })
vim.api.nvim_create_user_command("OpenProject", function(opts)
  _G.OpenFolderPicker(opts.args)
end, { nargs = "?", complete = "dir", desc = "Open any folder or project" })

map({ "n", "i" }, "<C-S-n>", _G.CreateNewDirectory, { desc = "New Directory (Ctrl+Shift+N)" })
map({ "n", "i" }, "<C-S-N>", _G.CreateNewDirectory, { desc = "New Directory (Ctrl+Shift+N)" })
map({ "n", "i" }, "<C-M-n>", _G.CreateNewDirectory, { desc = "New Directory (Ctrl+Alt+N)" })

map({ "n", "i" }, "<C-o>", function() _G.OpenFolderPicker() end, { desc = "Open Any Folder (Ctrl+O)" })
map({ "n", "i" }, "<C-S-o>", function() _G.OpenFolderPicker() end, { desc = "Open Any Folder (Ctrl+Shift+O)" })
map({ "n", "i" }, "<C-S-O>", function() _G.OpenFolderPicker() end, { desc = "Open Any Folder (Ctrl+Shift+O)" })

-- -------------------------------------------------------------------
-- 10. Direct Focus Switching: Sidebar, Editor, and Terminal
-- -------------------------------------------------------------------
local function focus_sidebar()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft:match("snacks_picker") or ft == "snacks_explorer" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  Snacks.explorer()
end

local function focus_editor()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.bo[buf].buftype
    local ft = vim.bo[buf].filetype
    if bt == "" and not ft:match("snacks") then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return
    end
  end
end

local function focus_terminal()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return
    end
  end
  Snacks.terminal()
end

map({ "n", "i", "t", "x", "s" }, "<C-0>", focus_sidebar, { desc = "Focus Sidebar (VS Code Ctrl+0)" })
map({ "n", "i", "t", "x", "s" }, "<C-1>", focus_editor, { desc = "Focus Editor (VS Code Ctrl+1)" })

-- -------------------------------------------------------------------
-- 11. Tab Navigation (Ctrl+Tab, Ctrl+Shift+Tab, Ctrl+PageDown/Up)
-- -------------------------------------------------------------------
map({ "n", "i" }, "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next Tab (VS Code Ctrl+Tab)" })
map({ "n", "i" }, "<C-S-Tab>", "<cmd>bprev<cr>", { desc = "Previous Tab (VS Code Ctrl+Shift+Tab)" })
map({ "n", "i" }, "<C-PageDown>", "<cmd>bnext<cr>", { desc = "Next Tab (Ctrl+PageDown)" })
map({ "n", "i" }, "<C-PageUp>", "<cmd>bprev<cr>", { desc = "Previous Tab (Ctrl+PageUp)" })

-- -------------------------------------------------------------------
-- 12. Robust Line & Word Deletion (Shift+Delete, Ctrl+Backspace, Ctrl+Delete)
-- -------------------------------------------------------------------
-- Shift+Delete: Deletes entire line (or selection) into black hole register!
local function delete_current_line()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
    vim.cmd('normal! "_d')
  else
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count <= 1 then
      vim.api.nvim_set_current_line("")
    else
      vim.cmd('normal! "_dd')
    end
  end
  vim.cmd("startinsert")
end

map({ "n", "i", "x", "s" }, "<S-Del>", delete_current_line, { desc = "Delete Line (Shift+Delete)" })
map({ "n", "i", "x", "s" }, "<S-Delete>", delete_current_line, { desc = "Delete Line (Shift+Delete)" })
map({ "n", "i", "x", "s" }, "<S-kDel>", delete_current_line, { desc = "Delete Line (Shift+Delete)" })

map({ "n", "i", "x", "s" }, "<C-S-k>", function()
  vim.cmd('normal! "_dd')
  vim.cmd("startinsert")
end, { desc = "Delete Line (Ctrl+Shift+K)" })
map({ "n", "i", "x", "s" }, "<C-S-K>", function()
  vim.cmd('normal! "_dd')
  vim.cmd("startinsert")
end, { desc = "Delete Line (Ctrl+Shift+K)" })

local function delete_word_left()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()
  if col == 0 then
    if row > 1 then
      local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] or ""
      local new_cursor_col = #prev_line
      vim.api.nvim_buf_set_lines(0, row - 2, row, false, { prev_line .. line })
      vim.api.nvim_win_set_cursor(0, { row - 1, new_cursor_col })
    end
    return
  end
  local before = line:sub(1, col)
  local s = before:reverse()
  local _, space_end = s:find("^%s+")
  local len = space_end or 0
  local rem = s:sub(len + 1)
  if #rem > 0 then
    local _, w_end = rem:find("^[%w_]+")
    if not w_end then
      _, w_end = rem:find("^[^%w_%s]+")
    end
    if w_end then
      len = len + w_end
    end
  end
  if len <= 0 then len = 1 end
  local new_col = math.max(0, col - len)
  local new_line = line:sub(1, new_col) .. line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end

local function delete_word_right()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()
  if col >= #line then
    local total_rows = vim.api.nvim_buf_line_count(0)
    if row < total_rows then
      local next_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
      vim.api.nvim_buf_set_lines(0, row - 1, row + 1, false, { line .. next_line })
    end
    return
  end
  local after = line:sub(col + 1)
  local _, space_end = after:find("^%s+")
  local len = space_end or 0
  local rem = after:sub(len + 1)
  if #rem > 0 then
    local _, w_end = rem:find("^[%w_]+")
    if not w_end then
      _, w_end = rem:find("^[^%w_%s]+")
    end
    if w_end then
      len = len + w_end
    end
  end
  if len <= 0 then len = 1 end
  local new_line = line:sub(1, col) .. line:sub(col + len + 1)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col })
end

-- Direct buffer word deletion (100% safe, never closes files or touches normal mode)
local function delete_word_left()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  if col == 0 then
    if row > 1 then
      local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1]
      local cur_line = vim.api.nvim_get_current_line()
      vim.api.nvim_buf_set_lines(0, row - 2, row, false, { prev_line .. cur_line })
      vim.api.nvim_win_set_cursor(0, { row - 1, #prev_line })
    end
    vim.cmd("startinsert")
    return
  end
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local new_before = before:gsub("%s*[%w_]+$", "")
  if new_before == before then
    new_before = before:gsub("%s*[^%w%s_]+$", "")
  end
  if new_before == before then
    new_before = before:gsub("%s+$", "")
  end
  if new_before == before and #before > 0 then
    new_before = before:sub(1, #before - 1)
  end
  local new_line = new_before .. line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, #new_before })
  vim.cmd("startinsert")
end

local function delete_word_right()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()
  if col >= #line then
    local total_rows = vim.api.nvim_buf_line_count(0)
    if row < total_rows then
      local next_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
      vim.api.nvim_buf_set_lines(0, row - 1, row + 1, false, { line .. next_line })
    end
    vim.cmd("startinsert")
    return
  end
  local after = line:sub(col + 1)
  local new_after = after:gsub("^%s*[%w_]+", "")
  if new_after == after then
    new_after = after:gsub("^%s*[^%w%s_]+", "")
  end
  if new_after == after then
    new_after = after:gsub("^%s+", "")
  end
  if new_after == after and #after > 0 then
    new_after = after:sub(2)
  end
  local new_line = line:sub(1, col) .. new_after
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col })
  vim.cmd("startinsert")
end

map({ "i", "n", "x", "s" }, "<C-BS>", delete_word_left, { desc = "Delete Word Left (Ctrl+Backspace)" })
map({ "i", "n", "x", "s" }, "<M-BS>", delete_word_left, { desc = "Delete Word Left (Alt+Backspace)" })
map({ "i", "n", "x", "s" }, "<Esc>[127;5u", delete_word_left, { desc = "Delete Word Left (Ctrl+Backspace CSI u)" })
map({ "i", "n", "x", "s" }, "\x1b[127;5u", delete_word_left, { desc = "Delete Word Left (Ctrl+Backspace CSI u raw)" })

map({ "i", "n", "x", "s" }, "<C-Del>", delete_word_right, { desc = "Delete Word Right (Ctrl+Delete)" })
map({ "i", "n", "x", "s" }, "<C-Delete>", delete_word_right, { desc = "Delete Word Right (Ctrl+Delete)" })
map({ "i", "n", "x", "s" }, "<Esc>[3;5~", delete_word_right, { desc = "Delete Word Right (Ctrl+Delete CSI u)" })
map({ "i", "n", "x", "s" }, "\x1b[3;5~", delete_word_right, { desc = "Delete Word Right (Ctrl+Delete CSI u raw)" })
map({ "i", "n", "x", "s" }, "<M-Del>", delete_word_right, { desc = "Delete Word Right (Alt+Delete)" })
map({ "i", "n", "x", "s" }, "<M-Delete>", delete_word_right, { desc = "Delete Word Right (Alt+Delete)" })
map({ "i", "n", "x", "s" }, "<M-d>", delete_word_right, { desc = "Delete Word Right (Alt+D / Ctrl+Delete)" })

-- -------------------------------------------------------------------
-- 13. Line Manipulation (Alt+Up/Down, Shift+Alt+Down, Enter lines)
-- -------------------------------------------------------------------
map("n", "<M-Down>", "<cmd>m .+1<cr>==", { desc = "Move Line Down (VS Code Alt+Down)" })
map("n", "<M-Up>", "<cmd>m .-2<cr>==", { desc = "Move Line Up (VS Code Alt+Up)" })
map("i", "<M-Down>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down (VS Code Alt+Down)" })
map("i", "<M-Up>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up (VS Code Alt+Up)" })
map("x", "<M-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down (VS Code Alt+Down)" })
map("x", "<M-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up (VS Code Alt+Up)" })

-- -------------------------------------------------------------------
-- Copy Line Above & Line Duplication (VS Code Shift+Alt+Up/Down & Ctrl+Shift+D)
-- -------------------------------------------------------------------
function _G.CopyLineAbove()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  if row <= 1 then
    vim.notify("Already at top line", vim.log.levels.WARN, { title = "Minimal Editor" })
    return
  end
  local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] or ""
  local cur_line = vim.api.nvim_get_current_line()

  if cur_line:match("^%s*$") then
    -- Current line is empty/whitespace: fill current line with previous line content
    vim.api.nvim_set_current_line(prev_line)
    vim.api.nvim_win_set_cursor(0, { row, #prev_line })
  else
    -- Current line has text: insert line above at current line position
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { prev_line })
    vim.api.nvim_win_set_cursor(0, { row, #prev_line })
  end
  vim.cmd("startinsert!")
end

vim.api.nvim_create_user_command("CopyLineAbove", _G.CopyLineAbove, { desc = "Copy line above into current position" })
vim.api.nvim_create_user_command("DuplicateLine", function() vim.cmd("t.") end, { desc = "Duplicate current line down" })

-- Copy Line Above: Ctrl+Shift+D (VS Code duplicate / copy line above)
map({ "n", "i" }, "<C-S-d>", _G.CopyLineAbove, { desc = "Copy Line Above (Ctrl+Shift+D)" })
map({ "n", "i" }, "<C-S-D>", _G.CopyLineAbove, { desc = "Copy Line Above (Ctrl+Shift+D)" })

-- Shift+Alt+Up: Copy / Duplicate Line Up (VS Code Shift+Alt+Up)
map({ "n", "i" }, "<M-S-Up>", "<cmd>t -1<cr>", { desc = "Copy Line Up (VS Code Shift+Alt+Up)" })
map({ "n", "i" }, "<A-S-Up>", "<cmd>t -1<cr>", { desc = "Copy Line Up (VS Code Shift+Alt+Up)" })
map("x", "<M-S-Up>", ":t '<-1<cr>gv", { desc = "Copy Selection Up (VS Code Shift+Alt+Up)" })
map("x", "<A-S-Up>", ":t '<-1<cr>gv", { desc = "Copy Selection Up (VS Code Shift+Alt+Up)" })

-- Shift+Alt+Down: Duplicate Line Down (VS Code Shift+Alt+Down)
map({ "n", "i" }, "<M-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate Line Down (VS Code Shift+Alt+Down)" })
map({ "n", "i" }, "<A-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate Line Down (VS Code Shift+Alt+Down)" })
map("x", "<M-S-Down>", ":t '><cr>gv", { desc = "Duplicate Selection Down (VS Code Shift+Alt+Down)" })
map("x", "<A-S-Down>", ":t '><cr>gv", { desc = "Duplicate Selection Down (VS Code Shift+Alt+Down)" })

local function insert_line_below()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local cur_line = vim.api.nvim_get_current_line()
  local indent = cur_line:match("^%s*") or ""
  vim.api.nvim_buf_set_lines(0, row, row, false, { indent })
  vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
  vim.cmd("startinsert!")
end

local function insert_line_above()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local cur_line = vim.api.nvim_get_current_line()
  local indent = cur_line:match("^%s*") or ""
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { indent })
  vim.api.nvim_win_set_cursor(0, { row, #indent })
  vim.cmd("startinsert!")
end

map({ "n", "i" }, "<C-CR>", insert_line_below, { desc = "Insert Line Below (Ctrl+Enter)" })
map({ "n", "i" }, "<C-Enter>", insert_line_below, { desc = "Insert Line Below (Ctrl+Enter)" })
map({ "n", "i" }, "<Esc>[13;5u", insert_line_below, { desc = "Insert Line Below (Ctrl+Enter CSI u)" })
map({ "n", "i" }, "\x1b[13;5u", insert_line_below, { desc = "Insert Line Below (Ctrl+Enter CSI u raw)" })
map({ "n", "i" }, "<M-o>", insert_line_below, { desc = "Insert Line Below (Alt+o)" })
map({ "n", "i" }, "<A-o>", insert_line_below, { desc = "Insert Line Below (Alt+o)" })

map({ "n", "i" }, "<C-S-CR>", insert_line_above, { desc = "Insert Line Above (Ctrl+Shift+Enter)" })
map({ "n", "i" }, "<C-S-Enter>", insert_line_above, { desc = "Insert Line Above (Ctrl+Shift+Enter)" })
map({ "n", "i" }, "<Esc>[13;6u", insert_line_above, { desc = "Insert Line Above (Ctrl+Shift+Enter CSI u)" })
map({ "n", "i" }, "\x1b[13;6u", insert_line_above, { desc = "Insert Line Above (Ctrl+Shift+Enter CSI u raw)" })
map({ "n", "i" }, "<M-CR>", insert_line_above, { desc = "Insert Line Above (Alt+Enter)" })
map({ "n", "i" }, "<A-CR>", insert_line_above, { desc = "Insert Line Above (Alt+Enter)" })
map({ "n", "i" }, "<M-S-CR>", insert_line_above, { desc = "Insert Line Above (Alt+Shift+Enter)" })
map({ "n", "i" }, "<A-S-CR>", insert_line_above, { desc = "Insert Line Above (Alt+Shift+Enter)" })
map({ "n", "i" }, "<M-O>", insert_line_above, { desc = "Insert Line Above (Alt+Shift+O)" })
map({ "n", "i" }, "<A-O>", insert_line_above, { desc = "Insert Line Above (Alt+Shift+O)" })

map({ "x", "s" }, "<Tab>", function()
  vim.cmd("normal! \x1bgv>gv")
end, { desc = "Indent Selection (Tab)" })

map({ "x", "s" }, "<S-Tab>", function()
  vim.cmd("normal! \x1bgv<gv")
end, { desc = "Unindent Selection (Shift+Tab)" })

-- -------------------------------------------------------------------
-- 14. Word-by-Word Navigation (Ctrl+Arrows & Shift+Arrows)
-- -------------------------------------------------------------------
local function move_word_right(mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]
  local cur_line = vim.api.nvim_get_current_line()
  local line_len = #cur_line
  local max_col = (mode == "i" or vim.o.virtualedit == "onemore") and line_len or math.max(0, line_len - 1)

  if col >= max_col then
    if row < vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
    end
    return
  end

  local text = cur_line:sub(col + 1)
  local first_char = text:sub(1, 1)
  local match_len = 0

  if first_char:match("%s") then
    local _, s_end = text:find("^%s+")
    match_len = s_end or 1
  elseif first_char:match("[%w_]") then
    local _, w_end = text:find("^[%w_]+")
    match_len = w_end or 1
  else
    local _, p_end = text:find("^[^%w_%s]+")
    match_len = p_end or 1
  end

  if not match_len or match_len <= 0 then match_len = 1 end
  local new_col = math.min(col + match_len, max_col)
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end

local function move_word_left(mode)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]
  local cur_line = vim.api.nvim_get_current_line()

  if col <= 0 then
    if row > 1 then
      local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] or ""
      local prev_len = #prev_line
      local max_col = (mode == "i" or vim.o.virtualedit == "onemore") and prev_len or math.max(0, prev_len - 1)
      vim.api.nvim_win_set_cursor(0, { row - 1, max_col })
    end
    return
  end

  local text = cur_line:sub(1, col)
  local rev_text = text:reverse()
  local first_char = rev_text:sub(1, 1)
  local back_len = 0

  if first_char:match("%s") then
    local _, s_end = rev_text:find("^%s+")
    back_len = s_end or 1
  elseif first_char:match("[%w_]") then
    local _, w_end = rev_text:find("^[%w_]+")
    back_len = w_end or 1
  else
    local _, p_end = rev_text:find("^[^%w_%s]+")
    back_len = p_end or 1
  end

  if not back_len or back_len <= 0 then back_len = 1 end
  local new_col = math.max(0, col - back_len)
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end

local function select_word_right(mode)
  if mode == "i" then
    vim.cmd("stopinsert")
    vim.cmd("normal! v")
  elseif mode == "n" then
    vim.cmd("normal! v")
  elseif mode == "s" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
  end
  move_word_right("v")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
end

local function select_word_left(mode)
  if mode == "i" then
    vim.cmd("stopinsert")
    vim.cmd("normal! v")
  elseif mode == "n" then
    vim.cmd("normal! v")
  elseif mode == "s" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
  end
  move_word_left("v")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
end

map("n", "<C-Left>", function() move_word_left("n") end, { desc = "Move Word Left (VS Code Ctrl+Left)" })
map("n", "<C-Right>", function() move_word_right("n") end, { desc = "Move Word Right (VS Code Ctrl+Right)" })
map("i", "<C-Left>", function() move_word_left("i") end, { desc = "Move Word Left (VS Code Ctrl+Left)" })
map("i", "<C-Right>", function() move_word_right("i") end, { desc = "Move Word Right (VS Code Ctrl+Right)" })
map({ "x", "s" }, "<C-Left>", function() move_word_left("x") end, { desc = "Move Word Left (VS Code Ctrl+Left)" })
map({ "x", "s" }, "<C-Right>", function() move_word_right("x") end, { desc = "Move Word Right (VS Code Ctrl+Right)" })

map("n", "<C-S-Right>", function() select_word_right("n") end, { desc = "Select Word Right (Ctrl+Shift+Right)" })
map("n", "<C-S-Left>", function() select_word_left("n") end, { desc = "Select Word Left (Ctrl+Shift+Left)" })
map("i", "<C-S-Right>", function() select_word_right("i") end, { desc = "Select Word Right (Ctrl+Shift+Right)" })
map("i", "<C-S-Left>", function() select_word_left("i") end, { desc = "Select Word Left (Ctrl+Shift+Left)" })
map({ "x", "s" }, "<C-S-Right>", function() select_word_right("x") end, { desc = "Select Word Right (Ctrl+Shift+Right)" })
map({ "x", "s" }, "<C-S-Left>", function() select_word_left("x") end, { desc = "Select Word Left (Ctrl+Shift+Left)" })

map("s", "<Left>", "<Esc><cmd>startinsert<cr><Left>", { desc = "Deselect Left (Modeless)" })
map("s", "<Right>", "<Esc><cmd>startinsert<cr><Right>", { desc = "Deselect Right (Modeless)" })
map("s", "<Up>", "<Esc><cmd>startinsert<cr><Up>", { desc = "Deselect Up (Modeless)" })
map("s", "<Down>", "<Esc><cmd>startinsert<cr><Down>", { desc = "Deselect Down (Modeless)" })

map({ "n", "x" }, "<Home>", "^", { desc = "Start of Line Text" })
map("s", "<Home>", "<Esc><cmd>startinsert<cr><C-o>^", { desc = "Start of Line Text" })
map("i", "<Home>", "<C-o>^", { desc = "Start of Line Text" })
map({ "n", "x" }, "<End>", "$", { desc = "End of Line" })
map("s", "<End>", "<Esc><cmd>startinsert<cr><C-o>$", { desc = "End of Line" })
map("i", "<End>", "<C-o>$", { desc = "End of Line" })

map({ "n", "x" }, "<C-Home>", "gg", { desc = "Start of File" })
map("s", "<C-Home>", "<Esc><cmd>startinsert<cr>gg", { desc = "Start of File" })
map("i", "<C-Home>", "<C-o>gg", { desc = "Start of File" })
map({ "n", "x" }, "<C-End>", "G", { desc = "End of File" })
map("s", "<C-End>", "<Esc><cmd>startinsert<cr>G", { desc = "End of File" })
map("i", "<C-End>", "<C-o>G", { desc = "End of File" })

map({ "n", "x" }, "<S-Home>", "^", { desc = "Select to Start of Line" })
map({ "n", "x" }, "<S-End>", "$", { desc = "Select to End of Line" })

-- -------------------------------------------------------------------
-- Page Navigation (PageDown & PageUp - VS Code Model)
-- 1. PageDown never scrolls off top lines into empty space if file fits on screen!
-- 2. PageUp at top or near top always moves cursor straight to Line 1, Column 0!
-- -------------------------------------------------------------------
local function page_down(is_insert)
  local cur_buf = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(cur_buf)
  local win = vim.api.nvim_get_current_win()
  local win_height = vim.api.nvim_win_get_height(win)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row, col = cursor[1], cursor[2]

  if total_lines <= win_height then
    local last_line = vim.api.nvim_buf_get_lines(cur_buf, total_lines - 1, total_lines, false)[1] or ""
    local target_col = math.min(col, #last_line)
    vim.api.nvim_win_set_cursor(win, { total_lines, target_col })
    vim.fn.winrestview({ topline = 1 })
  else
    local step = math.max(1, win_height - 2)
    local target_row = math.min(total_lines, row + step)
    local target_line_text = vim.api.nvim_buf_get_lines(cur_buf, target_row - 1, target_row, false)[1] or ""
    local target_col = math.min(col, #target_line_text)
    vim.api.nvim_win_set_cursor(win, { target_row, target_col })
    local current_top = vim.fn.line("w0")
    local max_top = math.max(1, total_lines - win_height + 1)
    if current_top > max_top then
      vim.fn.winrestview({ topline = max_top })
    end
  end

  if is_insert and vim.bo[cur_buf].buftype == "" and vim.bo[cur_buf].modifiable then
    vim.cmd("startinsert")
  end
end

local function page_up(is_insert)
  local cur_buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local win_height = vim.api.nvim_win_get_height(win)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row, col = cursor[1], cursor[2]

  local step = math.max(1, win_height - 2)
  local target_row = row - step

  if target_row <= 1 or row <= win_height then
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
    vim.fn.winrestview({ topline = 1 })
  else
    local target_line_text = vim.api.nvim_buf_get_lines(cur_buf, target_row - 1, target_row, false)[1] or ""
    local target_col = math.min(col, #target_line_text)
    vim.api.nvim_win_set_cursor(win, { target_row, target_col })
  end

  if is_insert and vim.bo[cur_buf].buftype == "" and vim.bo[cur_buf].modifiable then
    vim.cmd("startinsert")
  end
end

local function select_page_down(mode)
  if mode == "i" then
    vim.cmd("stopinsert")
    vim.cmd("normal! v")
  elseif mode == "n" then
    vim.cmd("normal! v")
  elseif mode == "s" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
  end
  page_down(false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
end

local function select_page_up(mode)
  if mode == "i" then
    vim.cmd("stopinsert")
    vim.cmd("normal! v")
  elseif mode == "n" then
    vim.cmd("normal! v")
  elseif mode == "s" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
  end
  page_up(false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
end

-- PageDown mappings
map("n", "<PageDown>", function() page_down(false) end, { desc = "Page Down (VS Code PageDown)" })
map("i", "<PageDown>", function() page_down(true) end, { desc = "Page Down (VS Code PageDown)" })
map({ "x", "s" }, "<PageDown>", function() select_page_down("x") end, { desc = "Select Page Down" })
map("n", "<S-PageDown>", function() select_page_down("n") end, { desc = "Select Page Down" })
map("i", "<S-PageDown>", function() select_page_down("i") end, { desc = "Select Page Down" })

-- PageUp mappings
map("n", "<PageUp>", function() page_up(false) end, { desc = "Page Up (VS Code PageUp)" })
map("i", "<PageUp>", function() page_up(true) end, { desc = "Page Up (VS Code PageUp)" })
map({ "x", "s" }, "<PageUp>", function() select_page_up("x") end, { desc = "Select Page Up" })
map("n", "<S-PageUp>", function() select_page_up("n") end, { desc = "Select Page Up" })
map("i", "<S-PageUp>", function() select_page_up("i") end, { desc = "Select Page Up" })

-- -------------------------------------------------------------------
-- 15. Go To Line & Search in File (Ctrl+G, Ctrl+F)
-- -------------------------------------------------------------------
local function go_to_line()
  local cur_buf = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(cur_buf)
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]

  vim.ui.input({
    prompt = string.format("Go to line (1-%d, e.g. 45 or 45:10, Enter empty for search): ", total_lines),
    default = "",
  }, function(input)
    if not input then return end
    if input == "" then
      local ok_snacks, snacks = pcall(require, "snacks")
      if ok_snacks and snacks.picker then
        snacks.picker.lines({ title = "Search Lines in File" })
      end
      return
    end

    local l_str, c_str = input:match("(%d+)[%s:]*(%d*)")
    if l_str then
      local target_line = math.max(1, math.min(tonumber(l_str), total_lines))
      local target_col = (c_str and c_str ~= "") and math.max(0, tonumber(c_str) - 1) or 0
      vim.api.nvim_win_set_cursor(0, { target_line, target_col })
      vim.cmd("normal! zz")
      vim.notify(string.format("Moved to line %d, column %d", target_line, target_col + 1), vim.log.levels.INFO, { title = "Go to Line" })
    else
      local ok_snacks, snacks = pcall(require, "snacks")
      if ok_snacks and snacks.picker then
        snacks.picker.lines({ pattern = input, title = "Search: " .. input })
      end
    end

    vim.schedule(function()
      if vim.bo[cur_buf].buftype == "" and vim.bo[cur_buf].modifiable then
        vim.cmd("startinsert")
      end
    end)
  end)
end

map({ "n", "i" }, "<C-g>", go_to_line, { desc = "Go to Line (Ctrl+G)" })

vim.api.nvim_create_user_command("GoToLine", function(opts)
  if opts.args and opts.args ~= "" then
    local l_str, c_str = opts.args:match("(%d+)[%s:]*(%d*)")
    if l_str then
      local total_lines = vim.api.nvim_buf_line_count(0)
      local target_line = math.max(1, math.min(tonumber(l_str), total_lines))
      local target_col = (c_str and c_str ~= "") and math.max(0, tonumber(c_str) - 1) or 0
      vim.api.nvim_win_set_cursor(0, { target_line, target_col })
      vim.cmd("normal! zz")
    end
  else
    go_to_line()
  end
end, { nargs = "?", desc = "Go to Line" })

vim.api.nvim_create_user_command("Line", function(opts)
  vim.cmd("GoToLine " .. (opts.args or ""))
end, { nargs = "?", desc = "Go to Line" })

-- Replace in File (VS Code Ctrl+H) & Replace in Files (VS Code Ctrl+Shift+H)
function _G.ReplaceInFile()
  local default_search = ""
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "x" or mode == "\22" then
    vim.cmd('normal! \x1bgv"+y')
    default_search = vim.fn.getreg('+')
  else
    default_search = vim.fn.expand("<cword>")
  end

  vim.ui.input({
    prompt = "🔍 Replace in File (Find): ",
    default = default_search,
  }, function(search)
    if not search or search == "" then return end
    vim.ui.input({
      prompt = "✏️  Replace '" .. search .. "' with: ",
      default = "",
    }, function(replace)
      if replace == nil then return end
      local escaped_search = vim.fn.escape(search, "/\\")
      local escaped_replace = vim.fn.escape(replace, "/\\&")
      local ok, res = pcall(vim.cmd, string.format("%%s/%s/%s/g", escaped_search, escaped_replace))
      if ok then
        vim.notify("✓ Replaced occurrences of '" .. search .. "' with '" .. replace .. "'", vim.log.levels.INFO, { title = "Replace in File" })
      else
        vim.notify("Pattern not found: '" .. search .. "'", vim.log.levels.WARN, { title = "Replace in File" })
      end
    end)
  end)
end

function _G.ReplaceInFiles()
  local default_search = vim.fn.expand("<cword>")
  vim.ui.input({
    prompt = "🔍 Replace across Files (Find): ",
    default = default_search,
  }, function(search)
    if not search or search == "" then return end
    vim.ui.input({
      prompt = "✏️  Replace project-wide '" .. search .. "' with: ",
      default = "",
    }, function(replace)
      if replace == nil then return end
      local escaped_search = vim.fn.escape(search, "/\\")
      local escaped_replace = vim.fn.escape(replace, "/\\&")
      pcall(function()
        vim.cmd("silent! vimgrep /" .. escaped_search .. "/gj **/*")
        local qflist = vim.fn.getqflist()
        if #qflist == 0 then
          vim.notify("No occurrences of '" .. search .. "' found across project", vim.log.levels.WARN, { title = "Replace in Files" })
          return
        end
        vim.cmd(string.format("silent! cdo %%s/%s/%s/ge | update", escaped_search, escaped_replace))
        vim.notify(string.format("✓ Replaced in %d location(s) across project", #qflist), vim.log.levels.INFO, { title = "Replace in Files" })
      end)
    end)
  end)
end

map({ "n", "i", "x", "s" }, "<C-h>", function() _G.ReplaceInFile() end, { desc = "Replace in File (VS Code Ctrl+H)" })
map({ "n", "i" }, "<C-S-h>", function() _G.ReplaceInFiles() end, { desc = "Replace in Files (VS Code Ctrl+Shift+H)" })
map({ "n", "i" }, "<C-S-H>", function() _G.ReplaceInFiles() end, { desc = "Replace in Files (VS Code Ctrl+Shift+H)" })

vim.api.nvim_create_user_command("Replace", function() _G.ReplaceInFile() end, { desc = "Replace in current file" })
vim.api.nvim_create_user_command("ReplaceInFiles", function() _G.ReplaceInFiles() end, { desc = "Replace in project files" })

-- -------------------------------------------------------------------
-- 16. Edit Keybindings Directly (Ctrl+K Ctrl+S)
-- -------------------------------------------------------------------
function _G.EditKeybindings()
  local keymaps_file = vim.fn.stdpath("config") .. "/lua/keymaps.lua"
  vim.cmd("edit " .. vim.fn.fnameescape(keymaps_file))
  vim.notify("Opened keymaps configuration: edit and save with Ctrl+S", vim.log.levels.INFO, { title = "Keybindings" })
end

map({ "n", "i" }, "<C-k><C-s>", _G.EditKeybindings, { desc = "Edit Keybindings (Ctrl+K Ctrl+S)" })
map({ "n", "i" }, "<C-k><C-S>", _G.EditKeybindings, { desc = "Edit Keybindings (Ctrl+K Ctrl+S)" })
vim.api.nvim_create_user_command("Keybinds", _G.EditKeybindings, { desc = "Edit keybindings file" })
vim.api.nvim_create_user_command("Shortcuts", _G.EditKeybindings, { desc = "Edit keybindings file" })
vim.api.nvim_create_user_command("EditKeybinds", _G.EditKeybindings, { desc = "Edit keybindings file" })

-- -------------------------------------------------------------------
-- 17. VS Code Sidebar, Pickers, Search & Terminal (Snacks.nvim)
-- -------------------------------------------------------------------
map({ "n", "i" }, "<C-b>", function() Snacks.explorer() end, { desc = "Toggle Explorer Sidebar (VS Code Ctrl+B)" })
map({ "n", "i" }, "<C-S-e>", function() Snacks.explorer() end, { desc = "Focus Explorer (VS Code Ctrl+Shift+E)" })
map({ "n", "i" }, "<C-S-E>", function() Snacks.explorer() end, { desc = "Focus Explorer (VS Code Ctrl+Shift+E)" })

map({ "n", "i" }, "<C-p>", function() Snacks.picker.files() end, { desc = "Quick Open File (VS Code Ctrl+P)" })

map({ "n", "i" }, "<C-S-p>", function() Snacks.picker.commands() end, { desc = "Command Palette (VS Code Ctrl+Shift+P)" })
map({ "n", "i" }, "<C-S-P>", function() Snacks.picker.commands() end, { desc = "Command Palette (VS Code Ctrl+Shift+P)" })
map({ "n", "i" }, "<F1>", function() Snacks.picker.commands() end, { desc = "Command Palette (VS Code F1)" })

map({ "n", "i", "x", "s" }, "<C-f>", function() Snacks.picker.lines() end, { desc = "Find in File (VS Code Ctrl+F)" })

map({ "n", "i" }, "<C-S-f>", function() Snacks.picker.grep() end, { desc = "Find in Files (VS Code Ctrl+Shift+F)" })
map({ "n", "i" }, "<C-S-F>", function() Snacks.picker.grep() end, { desc = "Find in Files (VS Code Ctrl+Shift+F)" })

map({ "n", "i" }, "<C-S-m>", function() Snacks.picker.diagnostics() end, { desc = "Show Problems (VS Code Ctrl+Shift+M)" })
map({ "n", "i" }, "<C-S-M>", function() Snacks.picker.diagnostics() end, { desc = "Show Problems (VS Code Ctrl+Shift+M)" })

map({ "n", "i" }, "<C-S-g>", function() Snacks.lazygit() end, { desc = "Git / Source Control (VS Code Ctrl+Shift+G)" })
map({ "n", "i" }, "<C-S-G>", function() Snacks.lazygit() end, { desc = "Git / Source Control (VS Code Ctrl+Shift+G)" })

local function toggle_terminal()
  Snacks.terminal(nil, {
    win = { position = "bottom", height = 0.35 },
  })
end
map({ "n", "i", "t" }, "<C-`>", toggle_terminal, { desc = "Toggle Terminal (VS Code Ctrl+`)" })
map({ "n", "i", "t" }, "<C-~>", toggle_terminal, { desc = "Toggle Terminal (VS Code Ctrl+~)" })

-- -------------------------------------------------------------------
-- 18. HTML Boilerplate Snippet (! + Tab / Enter via blink.cmp & friendly-snippets)
-- -------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "htmldjango", "typescriptreact", "javascriptreact" },
  callback = function(args)
    local buf = args.buf
    vim.opt_local.iskeyword:append("!,#,-")
  end,
  desc = "Enable HTML ! boilerplate and iskeyword",
})

-- -------------------------------------------------------------------
-- 19. One-Click Code Runner (Ctrl+' and F5)
-- -------------------------------------------------------------------
local function run_current_file()
  vim.cmd("silent! write")
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local cmd = nil

  if ft == "python" then
    cmd = "python3 " .. vim.fn.shellescape(file)
  elseif ft == "go" then
    cmd = "go run " .. vim.fn.shellescape(file)
  elseif ft == "javascript" then
    cmd = "node " .. vim.fn.shellescape(file)
  elseif ft == "typescript" then
    cmd = "npx tsx " .. vim.fn.shellescape(file) .. " || node " .. vim.fn.shellescape(file)
  elseif ft == "c" then
    cmd = "gcc -Wall -Wextra -O2 " .. vim.fn.shellescape(file) .. " -o /tmp/c_runner && /tmp/c_runner"
  elseif ft == "cpp" then
    cmd = "g++ -std=c++20 -Wall -Wextra -O2 " .. vim.fn.shellescape(file) .. " -o /tmp/cpp_runner && /tmp/cpp_runner"
  elseif ft == "sh" or ft == "bash" then
    cmd = "bash " .. vim.fn.shellescape(file)
  elseif ft == "lua" then
    cmd = "nvim -l " .. vim.fn.shellescape(file) .. " || lua " .. vim.fn.shellescape(file)
  elseif ft == "rust" then
    cmd = "cargo run 2>/dev/null || (rustc " .. vim.fn.shellescape(file) .. " -o /tmp/rust_runner && /tmp/rust_runner)"
  else
    vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN, { title = "Code Runner" })
    return
  end

  Snacks.terminal(cmd, { cwd = dir })
end

map({ "n", "i" }, "<F5>", run_current_file, { desc = "Run Current File (VS Code F5)" })

-- -------------------------------------------------------------------
-- 20. Live Server (F6, :LiveServerStart, :LiveServerStop)
-- -------------------------------------------------------------------
local live_server_job = nil
local function start_live_server()
  if live_server_job then
    vim.notify("Live Server is already running on port 5500", vim.log.levels.WARN, { title = "Live Server" })
    return
  end
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.getcwd()
  end
  live_server_job = vim.fn.jobstart({ "python3", "-m", "http.server", "5500", "--directory", dir }, {
    on_exit = function() live_server_job = nil end,
  })
  local open_cmd = vim.fn.has("mac") == 1 and "open" or (vim.fn.has("win32") == 1 and "cmd.exe" or "xdg-open")
  if open_cmd == "cmd.exe" then
    vim.fn.jobstart({ "cmd.exe", "/c", "start", "http://localhost:5500" }, { detach = true })
  else
    vim.fn.jobstart({ open_cmd, "http://localhost:5500" }, { detach = true })
  end
  vim.notify("Live Server started at http://localhost:5500 (" .. dir .. ")", vim.log.levels.INFO, { title = "Live Server" })
end

local function stop_live_server()
  if not live_server_job then
    vim.notify("No Live Server currently running", vim.log.levels.WARN, { title = "Live Server" })
    return
  end
  vim.fn.jobstop(live_server_job)
  live_server_job = nil
  vim.notify("Live Server stopped", vim.log.levels.INFO, { title = "Live Server" })
end

vim.api.nvim_create_user_command("LiveServerStart", start_live_server, { desc = "Start Live Server" })
vim.api.nvim_create_user_command("LiveServerStop", stop_live_server, { desc = "Stop Live Server" })
map({ "n", "i" }, "<F6>", function()
  if live_server_job then stop_live_server() else start_live_server() end
end, { desc = "Toggle Live Server (F6)" })

-- -------------------------------------------------------------------
-- 21. Mouse Hover & Cursor Tooltips for Diagnostics & Solutions
-- -------------------------------------------------------------------
local mouse_hover_timer = nil
local mouse_hover_win = nil
local last_mouse_cell = { -1, -1 }

function _G.close_mouse_hover()
  if mouse_hover_win and vim.api.nvim_win_is_valid(mouse_hover_win) then
    pcall(vim.api.nvim_win_close, mouse_hover_win, true)
  end
  mouse_hover_win = nil
end

local function on_mouse_move()
  if mouse_hover_timer then
    mouse_hover_timer:stop()
  end
  mouse_hover_timer = vim.defer_fn(function()
    local mouse = vim.fn.getmousepos()
    if mouse.winid <= 0 or not vim.api.nvim_win_is_valid(mouse.winid) then
      _G.close_mouse_hover()
      return
    end

    local cur_buf = vim.api.nvim_win_get_buf(mouse.winid)
    if not vim.api.nvim_buf_is_valid(cur_buf) or vim.bo[cur_buf].buftype ~= "" or (vim.bo[cur_buf].filetype and vim.bo[cur_buf].filetype:match("snacks")) then
      _G.close_mouse_hover()
      return
    end

    if last_mouse_cell[1] == mouse.screenrow and last_mouse_cell[2] == mouse.screencol then
      return
    end
    last_mouse_cell = { mouse.screenrow, mouse.screencol }

    local row = mouse.line
    local col = mouse.column - 1
    local total_lines = vim.api.nvim_buf_line_count(cur_buf)
    if row <= 0 or row > total_lines then
      _G.close_mouse_hover()
      return
    end

    -- 1. Check if there are diagnostics on this line
    local diags = vim.diagnostic.get(cur_buf, { lnum = row - 1 })
    if #diags > 0 then
      local relevant_diags = {}
      for _, d in ipairs(diags) do
        local d_start = d.col or 0
        local d_end = d.end_col or 9999
        if (col >= d_start and col <= d_end) or #diags == 1 then
          table.insert(relevant_diags, d)
        end
      end
      if #relevant_diags == 0 then
        relevant_diags = diags
      end

      local lines = {}
      local severity_labels = {
        [vim.diagnostic.severity.ERROR] = { icon = "", name = "Error" },
        [vim.diagnostic.severity.WARN] = { icon = "", name = "Warning" },
        [vim.diagnostic.severity.INFO] = { icon = "", name = "Info" },
        [vim.diagnostic.severity.HINT] = { icon = "", name = "Hint" },
      }

      for i, d in ipairs(relevant_diags) do
        local sev = severity_labels[d.severity] or { icon = "●", name = "Problem" }
        local src = d.source or "LSP"
        local code = d.code and (" (" .. tostring(d.code) .. ")") or ""
        table.insert(lines, string.format("%s [%s] %s%s", sev.icon, src, sev.name, code))

        for msg_line in d.message:gmatch("[^\r\n]+") do
          table.insert(lines, "  " .. msg_line)
        end

        if d.relatedInformation and #d.relatedInformation > 0 then
          table.insert(lines, "  ── Related Information ──")
          for _, rel in ipairs(d.relatedInformation) do
            local rel_msg = rel.message or ""
            local rel_loc = ""
            if rel.location and rel.location.uri then
              local file = vim.uri_to_fname(rel.location.uri)
              local lnum = (rel.location.range and rel.location.range.start and rel.location.range.start.line or 0) + 1
              rel_loc = " (" .. vim.fn.fnamemodify(file, ":t") .. ":" .. lnum .. ")"
            end
            table.insert(lines, "    󰋽 " .. rel_msg .. rel_loc)
          end
        end

        if i < #relevant_diags then
          table.insert(lines, "───────────────────────────────────────")
        end
      end

      table.insert(lines, "")
      table.insert(lines, "💡 Quick Fix: Press Alt+Enter or Ctrl+. for solutions")

      _G.close_mouse_hover()
      local float_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
      vim.bo[float_buf].bufhidden = "wipe"

      local max_w = 0
      for _, l in ipairs(lines) do
        local len = vim.fn.strdisplaywidth(l)
        if len > max_w then max_w = len end
      end
      local width = math.min(math.max(max_w + 2, 42), vim.o.columns - 4)
      local height = math.min(#lines, vim.o.lines - 4)

      local s_row = math.min(mouse.screenrow + 1, vim.o.lines - height - 2)
      local s_col = math.min(mouse.screencol, vim.o.columns - width - 2)
      if s_row < 0 then s_row = 1 end
      if s_col < 0 then s_col = 1 end

      local ok_win, win = pcall(vim.api.nvim_open_win, float_buf, false, {
        relative = "editor",
        row = s_row,
        col = s_col,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        title = " Problem Details & Solutions ",
        title_pos = "center",
        focusable = false,
      })
      if ok_win then
        mouse_hover_win = win
      end
      return
    end

    -- 2. Check for spelling error under mouse pointer
    local mouse_line = vim.api.nvim_buf_get_lines(cur_buf, row - 1, row, false)[1] or ""
    local mouse_word = mouse_line:sub(col + 1):match("^[%w_]+") or mouse_line:sub(1, col + 1):match("[%w_]+$")
    if mouse_word and mouse_word ~= "" and vim.wo.spell then
      local badinfo = vim.fn.spellbadword(mouse_word)
      if badinfo and badinfo[1] ~= "" then
        local suggs = vim.fn.spellsuggest(badinfo[1], 5)
        local lines = {
          "󰓆 Code Spell Checker",
          "Unknown word: \"" .. badinfo[1] .. "\"",
          "Suggestions: " .. table.concat(suggs, ", "),
          "",
          "💡 Quick Fix: Press Alt+Enter or Ctrl+. for corrections",
        }
        _G.close_mouse_hover()
        local float_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
        vim.bo[float_buf].bufhidden = "wipe"

        local max_w = 54
        local width = math.min(max_w, vim.o.columns - 4)
        local height = #lines
        local s_row = math.min(mouse.screenrow + 1, vim.o.lines - height - 2)
        local s_col = math.min(mouse.screencol, vim.o.columns - width - 2)
        if s_row < 0 then s_row = 1 end
        if s_col < 0 then s_col = 1 end

        local ok_win, win = pcall(vim.api.nvim_open_win, float_buf, false, {
          relative = "editor",
          row = s_row,
          col = s_col,
          width = width,
          height = height,
          style = "minimal",
          border = "rounded",
          title = " Spelling Issue ",
          title_pos = "center",
          focusable = false,
        })
        if ok_win then
          mouse_hover_win = win
        end
        return
      end
    end

    -- 3. If no diagnostics or spelling errors, check if LSP symbol hover is available
    local clients = vim.lsp.get_clients({ bufnr = cur_buf })
    if #clients > 0 then
      local params = {
        textDocument = vim.lsp.util.make_text_document_params(cur_buf),
        position = { line = row - 1, character = col },
      }
      vim.lsp.buf_request(cur_buf, "textDocument/hover", params, function(err, result)
        if err or not result or not result.contents then
          _G.close_mouse_hover()
          return
        end
        local current_mouse = vim.fn.getmousepos()
        if math.abs(current_mouse.screenrow - mouse.screenrow) > 1 or math.abs(current_mouse.screencol - mouse.screencol) > 2 then
          return
        end
        local hover_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        hover_lines = vim.lsp.util.trim_empty_lines(hover_lines)
        if #hover_lines == 0 then
          _G.close_mouse_hover()
          return
        end

        _G.close_mouse_hover()
        local h_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(h_buf, 0, -1, false, hover_lines)
        vim.bo[h_buf].filetype = "markdown"
        vim.bo[h_buf].bufhidden = "wipe"

        local max_w = 0
        for _, l in ipairs(hover_lines) do
          local len = vim.fn.strdisplaywidth(l)
          if len > max_w then max_w = len end
        end
        local width = math.min(math.max(max_w + 2, 32), vim.o.columns - 4)
        local height = math.min(#hover_lines, 15)

        local s_row = math.min(mouse.screenrow + 1, vim.o.lines - height - 2)
        local s_col = math.min(mouse.screencol, vim.o.columns - width - 2)
        if s_row < 0 then s_row = 1 end
        if s_col < 0 then s_col = 1 end

        local ok_win, win = pcall(vim.api.nvim_open_win, h_buf, false, {
          relative = "editor",
          row = s_row,
          col = s_col,
          width = width,
          height = height,
          style = "minimal",
          border = "rounded",
          title = " Code Info ",
          title_pos = "center",
          focusable = false,
        })
        if ok_win then
          mouse_hover_win = win
        end
      end)
    else
      _G.close_mouse_hover()
    end
  end, 350)
end

map({ "n", "i" }, "<MouseMove>", on_mouse_move, { silent = true, desc = "Mouse Hover Tooltip" })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertCharPre", "BufLeave", "WinLeave" }, {
  callback = function()
    _G.close_mouse_hover()
  end,
  desc = "Close mouse hover tooltip on activity",
})

-- -------------------------------------------------------------------
-- 22. Cursor Hover Tooltips (Auto-show details & solutions on pause)
-- -------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    local cur_buf = vim.api.nvim_get_current_buf()
    if vim.bo[cur_buf].buftype ~= "" or (vim.bo[cur_buf].filetype and vim.bo[cur_buf].filetype:match("snacks")) then
      return
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= "" then
        return
      end
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local lnum = cursor[1] - 1
    local diags = vim.diagnostic.get(cur_buf, { lnum = lnum })
    if #diags == 0 then
      if vim.wo.spell then
        local badinfo = vim.fn.spellbadword()
        if badinfo and badinfo[1] ~= "" then
          local badword = badinfo[1]
          local suggs = vim.fn.spellsuggest(badword, 5)
          local lines = {
            "󰓆 Code Spell Checker",
            "Unknown word: \"" .. badword .. "\"",
            "Suggestions: " .. table.concat(suggs, ", "),
            "",
            "💡 Quick Fix: Press Alt+Enter or Ctrl+. to autocorrect",
          }
          _G.close_mouse_hover()
          local float_buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
          vim.bo[float_buf].bufhidden = "wipe"
          local ok_w, win = pcall(vim.api.nvim_open_win, float_buf, false, {
            relative = "cursor",
            row = 1,
            col = 0,
            width = 54,
            height = #lines,
            style = "minimal",
            border = "rounded",
            title = " Spelling Issue ",
            title_pos = "center",
            focusable = false,
          })
          if ok_w then
            mouse_hover_win = win
          end
        end
      end
      return
    end

    vim.diagnostic.open_float(cur_buf, {
      scope = "cursor",
      focusable = false,
      close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" },
      border = "rounded",
      source = "always",
      header = { " Problem Details & Solutions", "DiagnosticFloatingHeader" },
      prefix = function(diag)
        local icons = { " ", " ", " ", " " }
        return (icons[diag.severity] or "● "), "DiagnosticSign" .. (diag.severity == 1 and "Error" or diag.severity == 2 and "Warn" or "Info")
      end,
      format = function(diag)
        local msg = diag.message
        if diag.code then msg = msg .. " (" .. tostring(diag.code) .. ")" end
        if diag.relatedInformation and #diag.relatedInformation > 0 then
          for _, rel in ipairs(diag.relatedInformation) do
            msg = msg .. "\n  󰋽 " .. (rel.message or "")
          end
        end
        return msg .. "\n💡 Quick Fix: Press Alt+Enter or Ctrl+. for solutions"
      end,
    })
  end,
  desc = "Auto-show problem details and solutions on cursor pause",
})

-- -------------------------------------------------------------------
-- 23. Problem Navigation & Quick Fix Shortcuts
-- -------------------------------------------------------------------
local function jump_diag(count)
  local float_opts = {
    border = "rounded",
    source = "always",
    header = { " Problem Details & Solutions", "DiagnosticFloatingHeader" },
    prefix = function(diag)
      local icons = { " ", " ", " ", " " }
      return (icons[diag.severity] or "● "), "DiagnosticSign" .. (diag.severity == 1 and "Error" or diag.severity == 2 and "Warn" or "Info")
    end,
    format = function(diag)
      local msg = diag.message
      if diag.code then msg = msg .. " (" .. tostring(diag.code) .. ")" end
      if diag.relatedInformation and #diag.relatedInformation > 0 then
        for _, rel in ipairs(diag.relatedInformation) do
          msg = msg .. "\n  󰋽 " .. (rel.message or "")
        end
      end
      return msg .. "\n💡 Quick Fix: Press Alt+Enter or Ctrl+. for solutions"
    end,
  }
  if vim.diagnostic.jump then
    vim.diagnostic.jump({ count = count, float = float_opts })
  elseif count > 0 then
    vim.diagnostic.goto_next({ float = float_opts })
  else
    vim.diagnostic.goto_prev({ float = float_opts })
  end
end

-- Next Problem (F8) & Previous Problem (Shift+F8)
map({ "n", "i" }, "<F8>", function() jump_diag(1) end, { desc = "Next Problem (F8)" })
map({ "n", "i" }, "<S-F8>", function() jump_diag(-1) end, { desc = "Previous Problem (Shift+F8)" })

-- -------------------------------------------------------------------
-- 23. Problem Navigation, Code Spell Checker & Quick Fix
-- -------------------------------------------------------------------
function _G.CodeSpellChecker()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()

  local badinfo = vim.fn.spellbadword()
  local target_word = badinfo and badinfo[1]
  if not target_word or target_word == "" then
    target_word = vim.fn.expand("<cword>")
  end

  if not target_word or target_word == "" then
    vim.notify("No word at cursor to check spelling", vim.log.levels.INFO, { title = "Code Spell Checker" })
    return
  end

  local suggestions = vim.fn.spellsuggest(target_word, 8)
  local options = {}

  for _, s in ipairs(suggestions) do
    table.insert(options, {
      kind = "suggestion",
      label = "󰓆 " .. s,
      replacement = s,
    })
  end

  table.insert(options, {
    kind = "add",
    label = " Add '" .. target_word .. "' to User Dictionary",
  })
  table.insert(options, {
    kind = "ignore",
    label = " Ignore '" .. target_word .. "' for this session",
  })

  vim.ui.select(options, {
    prompt = "Code Spell Checker: '" .. target_word .. "'",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then return end
    if choice.kind == "suggestion" then
      local pattern = "%f[%w_]" .. vim.pesc(target_word) .. "%f[^%w_]"
      local s_start, s_end = line:find(pattern)
      if not s_start then
        s_start, s_end = line:find("[%w_]+", math.max(1, col - #target_word))
      end
      if s_start and s_end then
        local new_line = line:sub(1, s_start - 1) .. choice.replacement .. line:sub(s_end + 1)
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, { row, math.min(#new_line, s_start + #choice.replacement - 1) })
      else
        vim.cmd("normal! ciw" .. choice.replacement)
      end
      vim.notify("Autocorrected '" .. target_word .. "' -> '" .. choice.replacement .. "'", vim.log.levels.INFO, { title = "Code Spell Checker" })
      vim.schedule(function()
        if vim.bo.buftype == "" and vim.bo.modifiable then
          vim.cmd("startinsert")
        end
      end)
    elseif choice.kind == "add" then
      vim.cmd("spellgood " .. target_word)
      vim.notify("Added '" .. target_word .. "' to user dictionary", vim.log.levels.INFO, { title = "Code Spell Checker" })
    elseif choice.kind == "ignore" then
      vim.cmd("spellrare " .. target_word)
      vim.notify("Ignored '" .. target_word .. "' for this session", vim.log.levels.INFO, { title = "Code Spell Checker" })
    end
  end)
end

vim.api.nvim_create_user_command("SpellCheck", function() _G.CodeSpellChecker() end, { desc = "Code Spell Checker Autocorrect" })
vim.api.nvim_create_user_command("FixSpelling", function() _G.CodeSpellChecker() end, { desc = "Code Spell Checker Autocorrect" })
map({ "n", "i" }, "<F7>", function() _G.CodeSpellChecker() end, { desc = "Code Spell Checker (F7)" })

-- Unified Quick Fix: checks spelling mistake first, or LSP code actions
local function unified_quick_fix()
  local badinfo = vim.fn.spellbadword()
  local is_misspelled = badinfo and badinfo[1] ~= ""

  local cur_buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1] - 1
  local diags = vim.diagnostic.get(cur_buf, { lnum = lnum })

  if is_misspelled and #diags == 0 then
    _G.CodeSpellChecker()
  else
    vim.lsp.buf.code_action()
  end
end

-- Quick Fix / Solutions (Ctrl+.)
map({ "n", "i" }, "<C-.>", unified_quick_fix, { desc = "Quick Fix / Solutions (Ctrl+.)" })

-- Hover Symbol / Problem Details (Ctrl+K Ctrl+I, gh, Alt+H)
local function show_hover_or_diagnostic()
  local cur_buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1] - 1
  local diags = vim.diagnostic.get(cur_buf, { lnum = lnum })
  if #diags > 0 then
    vim.diagnostic.open_float(cur_buf, {
      scope = "cursor",
      border = "rounded",
      source = "always",
      header = { " Problem Details & Solutions", "DiagnosticFloatingHeader" },
      prefix = function(diag)
        local icons = { " ", " ", " ", " " }
        return (icons[diag.severity] or "● "), "DiagnosticSign" .. (diag.severity == 1 and "Error" or diag.severity == 2 and "Warn" or "Info")
      end,
      format = function(diag)
        local msg = diag.message
        if diag.code then msg = msg .. " (" .. tostring(diag.code) .. ")" end
        if diag.relatedInformation and #diag.relatedInformation > 0 then
          for _, rel in ipairs(diag.relatedInformation) do
            msg = msg .. "\n  󰋽 " .. (rel.message or "")
          end
        end
        return msg .. "\n💡 Quick Fix: Press Alt+Enter or Ctrl+. for solutions"
      end,
    })
    return
  end

  local badinfo = vim.fn.spellbadword()
  if badinfo and badinfo[1] ~= "" then
    local badword = badinfo[1]
    local suggs = vim.fn.spellsuggest(badword, 5)
    local lines = {
      "󰓆 Code Spell Checker",
      "Unknown word: \"" .. badword .. "\"",
      "Suggestions: " .. table.concat(suggs, ", "),
      "",
      "💡 Quick Fix: Press Alt+Enter or Ctrl+. to autocorrect",
    }
    _G.close_mouse_hover()
    local float_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
    vim.bo[float_buf].bufhidden = "wipe"
    local ok_w, win = pcall(vim.api.nvim_open_win, float_buf, false, {
      relative = "cursor",
      row = 1,
      col = 0,
      width = 54,
      height = #lines,
      style = "minimal",
      border = "rounded",
      title = " Spelling Issue ",
      title_pos = "center",
      focusable = false,
    })
    if ok_w then
      _G.mouse_hover_win = win
    end
    return
  end

  vim.lsp.buf.hover()
end

map({ "n", "i" }, "<C-k><C-i>", show_hover_or_diagnostic, { desc = "Show Hover / Problem Details (VS Code Ctrl+K Ctrl+I)" })
map("n", "gh", show_hover_or_diagnostic, { desc = "Show Hover / Problem Details (gh)" })

map({ "n", "i" }, "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition (F12)" })
map({ "n", "i" }, "<S-F12>", function() Snacks.picker.lsp_references() end, { desc = "Find All References (Shift+F12)" })
map({ "n", "i" }, "<F2>", function() vim.lsp.buf.rename() end, { desc = "Rename Symbol (F2)" })

map({ "n", "i", "x" }, "<M-S-f>", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format Document (Shift+Alt+F)" })
map({ "n", "i", "x" }, "<M-S-F>", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format Document (Shift+Alt+F)" })

-- -------------------------------------------------------------------
-- 22. Go Auto-Imports & Formatting on Save
-- -------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    if #clients == 0 then return end
    local enc = clients[1].offset_encoding or "utf-16"
    local params = vim.lsp.util.make_range_params(0, enc)
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 1000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local client = vim.lsp.get_client_by_id(cid)
          local client_enc = client and client.offset_encoding or enc
          pcall(vim.lsp.util.apply_workspace_edit, r.edit, client_enc)
        end
      end
    end
  end,
  desc = "Go organize imports on save",
})

-- -------------------------------------------------------------------
-- 23. Color Themes & Theme Toggling (VS Code Ctrl+K Ctrl+T / F10)
-- -------------------------------------------------------------------
-- VS Code Standard Theme Picker: Ctrl+K Ctrl+T
map({ "n", "i" }, "<C-k><C-t>", function() _G.SelectThemePicker() end, { desc = "Color Theme Picker (VS Code Ctrl+K Ctrl+T)" })

-- Quick Theme Toggle: F10 (cycles Dark Magic -> Cyber Aurora -> Medieval Scriptorium)
map({ "n", "i" }, "<F10>", function() _G.ToggleTheme() end, { desc = "Toggle Theme (F10)" })

-- User commands
vim.api.nvim_create_user_command("Theme", function() _G.SelectThemePicker() end, { desc = "Open Color Theme Picker" })
vim.api.nvim_create_user_command("ColorTheme", function() _G.SelectThemePicker() end, { desc = "Open Color Theme Picker" })
vim.api.nvim_create_user_command("SelectTheme", function() _G.SelectThemePicker() end, { desc = "Open Color Theme Picker" })
vim.api.nvim_create_user_command("ToggleTheme", function() _G.ToggleTheme() end, { desc = "Cycle between Dark Magic, Cyber Aurora, and Medieval Scriptorium" })

-- Indent Rainbow Guides Command
function _G.ToggleIndentRainbow()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.indent then
    if snacks.indent.enabled then
      snacks.indent.disable()
      vim.notify("Indent Rainbow Guides: Disabled", vim.log.levels.INFO, { title = "Minimal Editor" })
    else
      snacks.indent.enable()
      vim.notify("Indent Rainbow Guides: Enabled", vim.log.levels.INFO, { title = "Minimal Editor" })
    end
  end
end
vim.api.nvim_create_user_command("IndentRainbow", _G.ToggleIndentRainbow, { desc = "Toggle Indent Rainbow Guides" })
vim.api.nvim_create_user_command("IndentToggle", _G.ToggleIndentRainbow, { desc = "Toggle Indent Rainbow Guides" })

-- -------------------------------------------------------------------
-- 24. Native macOS Command Key (Cmd / ⌘) Support
-- -------------------------------------------------------------------
-- Save: Cmd+S / Cmd+Shift+S
map({ "n", "i", "x", "s" }, "<D-s>", function() _G.SmartSave(false) end, { desc = "Save (Cmd+S)" })
map({ "n", "i", "x", "s" }, "<D-S-s>", function() _G.SmartSave(true) end, { desc = "Save As (Cmd+Shift+S)" })

-- Quick Open: Cmd+P
map({ "n", "i" }, "<D-p>", function() Snacks.picker.files() end, { desc = "Quick Open File (Cmd+P)" })

-- Command Palette: Cmd+Shift+P
map({ "n", "i" }, "<D-S-p>", function() Snacks.picker.commands() end, { desc = "Command Palette (Cmd+Shift+P)" })

-- Find: Cmd+F / Cmd+Shift+F
map({ "n", "i", "x", "s" }, "<D-f>", function() Snacks.picker.lines() end, { desc = "Find in File (Cmd+F)" })
map({ "n", "i" }, "<D-S-f>", function() Snacks.picker.grep() end, { desc = "Find in Files (Cmd+Shift+F)" })

-- Replace: Cmd+H / Cmd+Shift+H
map({ "n", "i", "x", "s" }, "<D-h>", function() _G.ReplaceInFile() end, { desc = "Replace in File (Cmd+H)" })
map({ "n", "i" }, "<D-S-h>", function() _G.ReplaceInFiles() end, { desc = "Replace in Files (Cmd+Shift+H)" })

-- Go to Line: Cmd+G
map({ "n", "i" }, "<D-g>", go_to_line, { desc = "Go to Line (Cmd+G)" })

-- Clipboard: Cmd+C, Cmd+V, Cmd+X
map({ "x", "s" }, "<D-c>", copy_selection, { desc = "Copy Selection (Cmd+C)" })
map("n", "<D-c>", copy_line, { desc = "Copy Current Line (Cmd+C)" })
map("i", "<D-c>", copy_line, { desc = "Copy Current Line (Cmd+C)" })

map("n", "<D-v>", '"+p', { desc = "Paste (Cmd+V)" })
map({ "x", "s" }, "<D-v>", paste_selection, { desc = "Paste Over Selection (Cmd+V)" })
map("i", "<D-v>", "<C-r><C-o>+", { desc = "Paste from Clipboard (Cmd+V)" })

map({ "x", "s" }, "<D-x>", cut_selection, { desc = "Cut Selection (Cmd+X)" })
map("n", "<D-x>", cut_line_insert, { desc = "Cut Current Line (Cmd+X)" })
map("i", "<D-x>", cut_line_insert, { desc = "Cut Current Line (Cmd+X)" })

-- Select All: Cmd+A
map({ "n", "i", "x", "s" }, "<D-a>", "<Esc>ggVG<C-g>", { desc = "Select All (Cmd+A)" })

-- Comments: Cmd+/ (Line) and Cmd+Alt+A (Block)
map({ "n", "i", "x", "s" }, "<D-/>", function() _G.ToggleLineComment(vim.fn.mode()) end, { desc = "Toggle Line Comment (Cmd+/)" })
map({ "n", "i", "x", "s" }, "<D-A-a>", function() _G.ToggleBlockComment(vim.fn.mode()) end, { desc = "Toggle Block Comment (Cmd+Option+A)" })
map({ "n", "i", "x", "s" }, "<D-A-A>", function() _G.ToggleBlockComment(vim.fn.mode()) end, { desc = "Toggle Block Comment (Cmd+Option+A)" })

-- Quick Fix / Solutions: Cmd+.
map({ "n", "i" }, "<D-.>", unified_quick_fix, { desc = "Quick Fix / Solutions (Cmd+.)" })

-- Multi-Cursor: Cmd+D (Add Next Match)
map({ "n", "i", "x" }, "<D-d>", "<C-d>", { remap = true, desc = "Add Next Match Multi-Cursor (Cmd+D)" })

-- New File: Cmd+N / Open Folder: Cmd+O
map({ "n", "i" }, "<D-n>", "<cmd>enew<cr><cmd>startinsert<cr>", { desc = "New File (Cmd+N)" })
map({ "n", "i" }, "<D-o>", function() _G.OpenFolderPicker() end, { desc = "Open Folder (Cmd+O)" })

-- Undo / Redo: Cmd+Z / Cmd+Shift+Z
map("n", "<D-z>", "u", { desc = "Undo (Cmd+Z)" })
map("i", "<D-z>", "<C-o>u", { desc = "Undo (Cmd+Z)" })
map({ "x", "s" }, "<D-z>", "<Esc>u<cmd>startinsert<cr>", { desc = "Undo (Cmd+Z)" })
map({ "n", "i", "x", "s" }, "<D-S-z>", "<Esc><C-r><cmd>startinsert<cr>", { desc = "Redo (Cmd+Shift+Z)" })

-- Toggle Sidebar: Cmd+B
map({ "n", "i" }, "<D-b>", function() Snacks.explorer() end, { desc = "Toggle Explorer Sidebar (Cmd+B)" })

-- Toggle Terminal: Cmd+` or Ctrl+`
map({ "n", "i", "t" }, "<D-`>", toggle_terminal, { desc = "Toggle Terminal (Cmd+`)" })

-- Close Tab: Cmd+W / Quit: Cmd+Q
map({ "n", "i" }, "<D-w>", close_current_buffer, { desc = "Close Tab (Cmd+W)" })
map({ "n", "i", "s", "x", "t" }, "<D-q>", function() _G.SmartQuit() end, { desc = "Quit Minimal (Cmd+Q)" })
