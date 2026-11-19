-- Cyber Aurora Theme for Neovim / LazyVim
-- Created for Indiedev: High-contrast electric aurora syntax on deep midnight background (#07070f)
-- Retains exact background tones and transparent mode support

local c = {
  -- Base Backgrounds (strictly identical to user's setup)
  bg = "#07070f",
  bg_dark = "#05050a",
  bg_sidebar = "#07070f",
  bg_status = "#0f0f17",
  bg_surface = "#17171f",
  bg_float = "#11111a",
  bg_highlight = "#181824",
  bg_visual = "#242438",
  
  -- Hierarchy & Foreground
  fg = "#e2ebf5",          -- Luminous Ice White
  fg_dark = "#96a6c8",     -- Secondary / Muted labels
  fg_muted = "#677399",    -- Muted elements
  fg_gutter = "#3e4668",   -- Line numbers
  
  -- Borders
  border = "#20202e",
  border_focus = "#00e5ff",
  border_float = "#2c2c40",
  
  -- Cyber Aurora Syntax Accents
  cyan = "#00e5ff",        -- Functions, Methods, Calls, Active Cursor, Titles (Electric Cyan)
  purple = "#bf7af0",      -- Keywords, Statements, Conditionals, Tags, Imports (Royal Orchid Violet)
  pink = "#ff5ea0",        -- Strings, Characters, Regex Quotes (Vibrant Neon Rose)
  gold = "#ffd166",        -- Types, Classes, Interfaces, Enums (Sunburst Amber/Gold)
  mint = "#38ef7d",        -- Variables, Identifiers, Properties (Laser Emerald Mint)
  orange = "#ff9f43",      -- Numbers, Booleans, Floats, Constants (Sunset Neon Amber)
  coral = "#ff5370",       -- Operators, Special Characters, Exceptions (Electric Coral)
  teal = "#2dd4bf",        -- Parameters, Builtins, Regex (Radiant Aqua Teal)
  delim = "#94a3b8",       -- Delimiters, Brackets, Parentheses (Moonlit Slate)
  comment = "#677399",     -- Comments (Twilight Slate, italic)
  
  -- Git
  git_add = "#38ef7d",
  git_change = "#00e5ff",
  git_delete = "#ff3860",
  
  -- Diagnostics
  error = "#ff3860",
  warn = "#ffbe3b",
  info = "#00e5ff",
  hint = "#2dd4bf",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "cyberaurora"
vim.o.termguicolors = true

local transparent = vim.g.cyberaurora_transparent ~= false
local bg_main = transparent and "NONE" or c.bg
local bg_sidebar = transparent and "NONE" or c.bg_sidebar
local bg_float = transparent and "NONE" or c.bg_float
local bg_status = transparent and "NONE" or c.bg_status

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===================================================================
-- UI & Editor Basics (Backgrounds preserved, text colors enhanced)
-- ===================================================================
hl("Normal", { fg = c.fg, bg = bg_main })
hl("NormalNC", { fg = c.fg, bg = bg_main })
hl("NormalFloat", { fg = c.fg, bg = bg_float })
hl("FloatBorder", { fg = c.border_float, bg = bg_float })
hl("FloatTitle", { fg = c.cyan, bg = bg_float, bold = true })

hl("Cursor", { fg = c.bg, bg = c.cyan })
hl("CursorLine", { bg = c.bg_highlight })
hl("CursorColumn", { bg = c.bg_highlight })
hl("ColorColumn", { bg = c.bg_surface })

hl("LineNr", { fg = c.fg_gutter, bg = bg_main })
hl("CursorLineNr", { fg = c.cyan, bg = bg_main, bold = true })
hl("SignColumn", { fg = c.fg_gutter, bg = bg_main })
hl("FoldColumn", { fg = c.fg_gutter, bg = bg_main })
hl("Folded", { fg = c.fg_muted, bg = c.bg_surface })
hl("EndOfBuffer", { fg = c.border, bg = bg_main })

hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border, bold = true })

hl("Visual", { bg = c.bg_visual })
hl("VisualNOS", { bg = c.bg_visual })

hl("Search", { fg = c.bg, bg = c.cyan, bold = true })
hl("IncSearch", { fg = c.bg, bg = c.orange, bold = true })
hl("CurSearch", { fg = c.bg, bg = c.orange, bold = true })

hl("StatusLine", { fg = c.fg, bg = bg_status })
hl("StatusLineNC", { fg = c.fg_muted, bg = bg_status })

hl("TabLine", { fg = c.fg_muted, bg = c.bg_status })
hl("TabLineFill", { bg = c.bg_status })
hl("TabLineSel", { fg = c.cyan, bg = c.bg_surface, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel", { fg = c.cyan, bg = c.bg_visual, bold = true })
hl("PmenuSbar", { bg = c.bg_surface })
hl("PmenuThumb", { bg = c.border_float })

hl("MatchParen", { fg = c.cyan, bg = c.bg_visual, bold = true, underline = true })
hl("Directory", { fg = c.cyan, bold = true })
hl("Question", { fg = c.cyan })
hl("MoreMsg", { fg = c.cyan })
hl("ModeMsg", { fg = c.cyan, bold = true })
hl("WarningMsg", { fg = c.warn, bold = true })
hl("ErrorMsg", { fg = c.error, bold = true })
hl("Title", { fg = c.cyan, bold = true })
hl("Conceal", { fg = c.fg_muted })
hl("NonText", { fg = c.border })
hl("SpecialKey", { fg = c.border })
hl("Whitespace", { fg = c.border })

-- ===================================================================
-- Syntax Highlighting (Classic)
-- ===================================================================
hl("Comment", { fg = c.comment, italic = true })

hl("Constant", { fg = c.orange })
hl("String", { fg = c.pink })
hl("Character", { fg = c.pink })
hl("Number", { fg = c.orange })
hl("Boolean", { fg = c.orange, bold = true })
hl("Float", { fg = c.orange })

hl("Identifier", { fg = c.mint })
hl("Function", { fg = c.cyan, bold = true })

hl("Statement", { fg = c.purple })
hl("Conditional", { fg = c.purple })
hl("Repeat", { fg = c.purple })
hl("Label", { fg = c.purple })
hl("Operator", { fg = c.coral })
hl("Keyword", { fg = c.purple })
hl("Exception", { fg = c.coral, bold = true })

hl("PreProc", { fg = c.cyan })
hl("Include", { fg = c.purple })
hl("Define", { fg = c.purple })
hl("Macro", { fg = c.cyan })
hl("PreCondit", { fg = c.purple })

hl("Type", { fg = c.gold })
hl("StorageClass", { fg = c.purple })
hl("Structure", { fg = c.gold })
hl("Typedef", { fg = c.gold })

hl("Special", { fg = c.coral })
hl("SpecialChar", { fg = c.orange })
hl("Tag", { fg = c.purple })
hl("Delimiter", { fg = c.delim })
hl("SpecialComment", { fg = c.fg_dark, bold = true })
hl("Debug", { fg = c.warn })

hl("Underlined", { underline = true })
hl("Ignore", { fg = c.fg_muted })
hl("Error", { fg = c.error, bold = true })
hl("Todo", { fg = c.bg, bg = c.cyan, bold = true })

-- ===================================================================
-- Treesitter Highlights
-- ===================================================================
hl("@comment", { link = "Comment" })
hl("@comment.documentation", { fg = c.fg_dark, italic = true })

hl("@variable", { fg = c.mint })
hl("@variable.builtin", { fg = c.teal, bold = true })
hl("@variable.parameter", { fg = c.teal })
hl("@variable.member", { fg = c.mint })

hl("@constant", { fg = c.orange })
hl("@constant.builtin", { fg = c.orange, bold = true })
hl("@constant.macro", { fg = c.orange })

hl("@module", { fg = c.gold })
hl("@module.builtin", { fg = c.gold, bold = true })

hl("@string", { fg = c.pink })
hl("@string.regex", { fg = c.teal })
hl("@string.escape", { fg = c.orange })
hl("@string.special", { fg = c.orange })

hl("@character", { fg = c.pink })
hl("@character.special", { fg = c.orange })
hl("@number", { fg = c.orange })
hl("@number.float", { fg = c.orange })
hl("@boolean", { fg = c.orange, bold = true })

hl("@type", { fg = c.gold })
hl("@type.builtin", { fg = c.gold, bold = true })
hl("@type.definition", { fg = c.gold })
hl("@type.qualifier", { fg = c.purple })

hl("@attribute", { fg = c.gold })
hl("@property", { fg = c.mint })

hl("@function", { fg = c.cyan })
hl("@function.builtin", { fg = c.cyan, bold = true })
hl("@function.call", { fg = c.cyan })
hl("@function.macro", { fg = c.cyan })
hl("@function.method", { fg = c.cyan })
hl("@function.method.call", { fg = c.cyan })
hl("@constructor", { fg = c.gold })

hl("@operator", { fg = c.coral })
hl("@keyword", { fg = c.purple })
hl("@keyword.coroutine", { fg = c.purple })
hl("@keyword.function", { fg = c.purple })
hl("@keyword.operator", { fg = c.coral })
hl("@keyword.import", { fg = c.purple })
hl("@keyword.type", { fg = c.purple })
hl("@keyword.modifier", { fg = c.purple })
hl("@keyword.repeat", { fg = c.purple })
hl("@keyword.return", { fg = c.purple, bold = true })
hl("@keyword.debug", { fg = c.warn })
hl("@keyword.exception", { fg = c.coral, bold = true })
hl("@keyword.conditional", { fg = c.purple })
hl("@keyword.directive", { fg = c.cyan })

hl("@punctuation.delimiter", { fg = c.delim })
hl("@punctuation.bracket", { fg = c.delim })
hl("@punctuation.special", { fg = c.coral })

hl("@tag", { fg = c.purple })
hl("@tag.attribute", { fg = c.cyan })
hl("@tag.delimiter", { fg = c.delim })

hl("@markup.heading", { fg = c.cyan, bold = true })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.link", { fg = c.cyan, underline = true })
hl("@markup.link.url", { fg = c.teal, underline = true })
hl("@markup.raw", { fg = c.pink })
hl("@markup.list", { fg = c.cyan })

-- ===================================================================
-- LSP Semantic Tokens
-- ===================================================================
hl("@lsp.type.class", { link = "@type" })
hl("@lsp.type.decorator", { link = "@attribute" })
hl("@lsp.type.enum", { link = "@type" })
hl("@lsp.type.enumMember", { link = "@constant" })
hl("@lsp.type.function", { link = "@function" })
hl("@lsp.type.interface", { link = "@type" })
hl("@lsp.type.macro", { link = "@function.macro" })
hl("@lsp.type.method", { link = "@function.method" })
hl("@lsp.type.namespace", { link = "@module" })
hl("@lsp.type.parameter", { link = "@variable.parameter" })
hl("@lsp.type.property", { link = "@property" })
hl("@lsp.type.struct", { link = "@type" })
hl("@lsp.type.type", { link = "@type" })
hl("@lsp.type.typeParameter", { link = "@type.definition" })
hl("@lsp.type.variable", { link = "@variable" })
hl("LspInlayHint", { fg = c.fg_dark, bg = c.bg_highlight })

-- ===================================================================
-- Diagnostics
-- ===================================================================
hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn", { fg = c.warn })
hl("DiagnosticInfo", { fg = c.info })
hl("DiagnosticHint", { fg = c.hint })

hl("DiagnosticVirtualTextError", { fg = c.error, bg = "#1c0c16" })
hl("DiagnosticVirtualTextWarn", { fg = c.warn, bg = "#242019" })
hl("DiagnosticVirtualTextInfo", { fg = c.info, bg = "#131e2a" })
hl("DiagnosticVirtualTextHint", { fg = c.hint, bg = "#122221" })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })

-- ===================================================================
-- Git & Diffs
-- ===================================================================
hl("DiffAdd", { bg = "#222c15" })
hl("DiffChange", { bg = "#0e2633" })
hl("DiffDelete", { bg = "#330f1d" })
hl("DiffText", { bg = "#154657" })

hl("GitSignsAdd", { fg = c.git_add })
hl("GitSignsChange", { fg = c.git_change })
hl("GitSignsDelete", { fg = c.git_delete })

-- ===================================================================
-- Plugins (LazyVim UI & Sidebars)
-- ===================================================================
-- Snacks (Sidebar & Explorer)
hl("SnacksNormal", { fg = c.fg, bg = bg_main })
hl("SnacksNormalNC", { fg = c.fg, bg = bg_main })
hl("SnacksWinSeparator", { fg = c.border, bg = bg_main })
hl("SnacksPicker", { fg = c.fg, bg = bg_main })
hl("SnacksPickerNormal", { fg = c.fg, bg = bg_main })
hl("SnacksPickerList", { fg = c.fg, bg = bg_main })
hl("SnacksPickerBorder", { fg = c.border, bg = bg_main })
hl("SnacksPickerInput", { fg = c.fg, bg = bg_main })
hl("SnacksPickerInputBorder", { fg = c.border, bg = bg_main })
hl("SnacksPickerListBorder", { fg = c.border, bg = bg_main })
hl("SnacksPickerBox", { fg = c.fg, bg = bg_main })
hl("SnacksPickerPreview", { fg = c.fg, bg = bg_main })
hl("SnacksPickerPrompt", { fg = c.cyan, bg = bg_main })
hl("SnacksPickerTitle", { fg = c.cyan, bg = bg_main, bold = true })
hl("SnacksPickerDirectory", { fg = c.cyan, bold = true })
hl("SnacksPickerDir", { fg = c.cyan, bold = true })
hl("SnacksPickerFile", { fg = c.fg })
hl("SnacksPickerTree", { fg = c.border })
hl("SnacksPickerSelected", { fg = c.cyan, bg = c.bg_visual, bold = true })
hl("SnacksPickerMatch", { fg = c.orange, bold = true })
hl("SnacksPickerGitStatusAdded", { fg = c.git_add, bold = true })
hl("SnacksPickerGitStatusModified", { fg = c.git_change, bold = true })
hl("SnacksPickerGitStatusDeleted", { fg = c.git_delete, bold = true })
hl("SnacksPickerGitStatusUntracked", { fg = c.cyan, bold = true })
hl("SnacksPickerGitStatusStaged", { fg = c.green, bold = true })
hl("SnacksPickerGitStatusUnmerged", { fg = c.red, bold = true })
hl("SnacksPickerGitStatusRenamed", { fg = c.purple, bold = true })
hl("SnacksPickerGitStatusCopied", { fg = c.yellow, bold = true })
hl("SnacksPickerGitStatusIgnored", { fg = c.comment })
hl("SnacksPickerPathIgnored", { fg = c.comment })
hl("SnacksPickerPathHidden", { fg = c.border })

-- Mini.icons
hl("MiniIconsAzure", { fg = c.cyan })
hl("MiniIconsBlue", { fg = c.blue })
hl("MiniIconsCyan", { fg = c.cyan })
hl("MiniIconsGreen", { fg = c.green })
hl("MiniIconsGrey", { fg = c.fg_dark })
hl("MiniIconsOrange", { fg = c.orange })
hl("MiniIconsPurple", { fg = c.purple })
hl("MiniIconsRed", { fg = c.red })
hl("MiniIconsYellow", { fg = c.yellow })
hl("SnacksDashboardHeader", { fg = c.cyan, bold = true })
hl("SnacksDashboardDesc", { fg = c.fg_dark })
hl("SnacksDashboardIcon", { fg = c.purple })
hl("SnacksDashboardKey", { fg = c.orange, bold = true })
hl("SnacksIndent", { fg = c.border })
hl("SnacksIndentScope", { fg = c.cyan })

-- Neo-tree (File Tree Sidebar)
hl("NeoTreeNormal", { fg = c.fg, bg = bg_main })
hl("NeoTreeNormalNC", { fg = c.fg, bg = bg_main })
hl("NeoTreeEndOfBuffer", { fg = c.border, bg = bg_main })
hl("NeoTreeDirectoryIcon", { fg = c.cyan })
hl("NeoTreeDirectoryName", { fg = c.cyan, bold = true })
hl("NeoTreeFileName", { fg = c.fg })
hl("NeoTreeFileIcon", { fg = c.fg_dark })
hl("NeoTreeRootName", { fg = c.cyan, bold = true })
hl("NeoTreeIndentMarker", { fg = c.border })
hl("NeoTreeWinSeparator", { fg = c.border, bg = bg_main })
hl("NeoTreeGitAdded", { fg = c.git_add })
hl("NeoTreeGitModified", { fg = c.git_change })
hl("NeoTreeGitDeleted", { fg = c.git_delete })
hl("NeoTreeGitUntracked", { fg = c.orange })

-- Telescope
hl("TelescopeNormal", { fg = c.fg, bg = bg_float })
hl("TelescopeBorder", { fg = c.border_float, bg = bg_float })
hl("TelescopePromptNormal", { fg = c.fg, bg = bg_main })
hl("TelescopePromptBorder", { fg = c.cyan, bg = bg_main })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.cyan, bold = true })
hl("TelescopeSelection", { fg = c.cyan, bg = c.bg_visual, bold = true })

-- WhichKey
hl("WhichKey", { fg = c.cyan })
hl("WhichKeyGroup", { fg = c.purple, bold = true })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.fg_muted })
hl("WhichKeyFloat", { bg = bg_float })

-- Bufferline
hl("BufferLineFill", { bg = c.bg_status })
hl("BufferLineBackground", { fg = c.fg_muted, bg = c.bg_status })
hl("BufferLineBufferSelected", { fg = c.cyan, bg = c.bg, bold = true })
hl("BufferLineIndicatorSelected", { fg = c.cyan, bg = c.bg })
hl("BufferLineSeparator", { fg = c.bg_status, bg = c.bg_status })

-- Cmp / Blink
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.fg_muted, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = c.cyan, bold = true })
hl("CmpItemKindFunction", { fg = c.cyan })
hl("CmpItemKindMethod", { fg = c.cyan })
hl("CmpItemKindVariable", { fg = c.mint })
hl("CmpItemKindKeyword", { fg = c.purple })
hl("CmpItemKindClass", { fg = c.gold })
hl("CmpItemKindInterface", { fg = c.gold })
hl("CmpItemKindProperty", { fg = c.mint })

-- DAP (Debug Adapter Protocol)
hl("DapBreakpoint", { fg = c.error, bold = true })
hl("DapBreakpointCondition", { fg = c.orange, bold = true })
hl("DapBreakpointRejected", { fg = c.fg_muted })
hl("DapLogPoint", { fg = c.cyan })
hl("DapStopped", { fg = c.mint, bold = true })
hl("DapStoppedLine", { bg = c.bg_visual })

-- DBUI (Dadbod Database UI)
hl("dbui_tables", { fg = c.cyan, bold = true })
hl("NotificationInfo", { fg = c.info })
hl("NotificationWarning", { fg = c.warn })
hl("NotificationError", { fg = c.error })
