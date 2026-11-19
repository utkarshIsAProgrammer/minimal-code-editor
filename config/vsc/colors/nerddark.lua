-- Nerd Dark Theme for Neovim / LazyVim
-- Designed for old-school hackers & terminal nerds who love eye-pleasing, soothing dark colors.
-- Muted, organic, earthy tones inspired by Kanagawa Dragon, Gruvbox Dark, and Vesper.
-- Preserves the exact deep midnight background (#07070f) and transparent mode support.

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
  
  -- Hierarchy & Foreground (Antique parchment: zero glare, zero eye fatigue)
  fg = "#c5c9c5",          -- Mellow antique bone white
  fg_dark = "#8a8a82",     -- Subdued secondary text
  fg_muted = "#625e5a",    -- Muted elements
  fg_gutter = "#3b3836",   -- Subtle line numbers
  
  -- Borders
  border = "#20202e",
  border_focus = "#8ba4b0",
  border_float = "#2c2c40",
  
  -- Nerd Dark Syntax Accents (Soothing, earthy, non-glaring)
  red = "#c4746e",         -- Keywords, Statements, Conditionals, Storage (Terracotta Red)
  blue = "#8ba4b0",        -- Functions, Methods, Calls, Titles (Weathered Denim)
  green = "#87a987",       -- Strings, Characters (Organic Forest Sage)
  yellow = "#e6c384",      -- Special Constants, Modules (Burnished Amber Gold)
  orange = "#dca561",      -- Numbers, Booleans, Floats (Harvest Amber)
  violet = "#957fb8",      -- Types, Classes, Interfaces, Structs (Smoked Amethyst)
  aqua = "#8ea4a2",        -- Parameters, Builtins, Regex (Subdued Sage Aqua)
  coral = "#e46876",       -- Operators, Exceptions, Warnings (Muted Brick Coral)
  delim = "#7a8382",       -- Delimiters, Brackets, Parentheses (Weathered Stone)
  comment = "#737c73",     -- Comments (Moss Slate, italic)
  
  -- Git
  git_add = "#87a987",
  git_change = "#8ba4b0",
  git_delete = "#c4746e",
  
  -- Diagnostics
  error = "#c4746e",
  warn = "#dca561",
  info = "#8ba4b0",
  hint = "#8ea4a2",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "nerddark"
vim.o.termguicolors = true

local transparent = vim.g.nerddark_transparent ~= false
local bg_main = transparent and "NONE" or c.bg
local bg_sidebar = transparent and "NONE" or c.bg_sidebar
local bg_float = transparent and "NONE" or c.bg_float
local bg_status = transparent and "NONE" or c.bg_status

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===================================================================
-- UI & Editor Basics (Backgrounds preserved, text colors soothing)
-- ===================================================================
hl("Normal", { fg = c.fg, bg = bg_main })
hl("NormalNC", { fg = c.fg, bg = bg_main })
hl("NormalFloat", { fg = c.fg, bg = bg_float })
hl("FloatBorder", { fg = c.border_float, bg = bg_float })
hl("FloatTitle", { fg = c.blue, bg = bg_float, bold = true })

hl("Cursor", { fg = c.bg, bg = c.fg })
hl("CursorLine", { bg = c.bg_highlight })
hl("CursorColumn", { bg = c.bg_highlight })
hl("ColorColumn", { bg = c.bg_surface })

hl("LineNr", { fg = c.fg_gutter, bg = bg_main })
hl("CursorLineNr", { fg = c.yellow, bg = bg_main, bold = true })
hl("SignColumn", { fg = c.fg_gutter, bg = bg_main })
hl("FoldColumn", { fg = c.fg_gutter, bg = bg_main })
hl("Folded", { fg = c.fg_muted, bg = c.bg_surface })
hl("EndOfBuffer", { fg = c.border, bg = bg_main })

hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border, bold = true })

hl("Visual", { bg = c.bg_visual })
hl("VisualNOS", { bg = c.bg_visual })

hl("Search", { fg = c.bg, bg = c.yellow, bold = true })
hl("IncSearch", { fg = c.bg, bg = c.orange, bold = true })
hl("CurSearch", { fg = c.bg, bg = c.orange, bold = true })

hl("StatusLine", { fg = c.fg, bg = bg_status })
hl("StatusLineNC", { fg = c.fg_muted, bg = bg_status })

hl("TabLine", { fg = c.fg_muted, bg = c.bg_status })
hl("TabLineFill", { bg = c.bg_status })
hl("TabLineSel", { fg = c.yellow, bg = c.bg_surface, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel", { fg = c.yellow, bg = c.bg_visual, bold = true })
hl("PmenuSbar", { bg = c.bg_surface })
hl("PmenuThumb", { bg = c.border_float })

hl("MatchParen", { fg = c.yellow, bg = c.bg_visual, bold = true, underline = true })
hl("Directory", { fg = c.blue, bold = true })
hl("Question", { fg = c.aqua })
hl("MoreMsg", { fg = c.aqua })
hl("ModeMsg", { fg = c.yellow, bold = true })
hl("WarningMsg", { fg = c.warn, bold = true })
hl("ErrorMsg", { fg = c.error, bold = true })
hl("Title", { fg = c.blue, bold = true })
hl("Conceal", { fg = c.fg_muted })
hl("NonText", { fg = c.border })
hl("SpecialKey", { fg = c.border })
hl("Whitespace", { fg = c.border })

-- ===================================================================
-- Syntax Highlighting (Classic)
-- ===================================================================
hl("Comment", { fg = c.comment, italic = true })

hl("Constant", { fg = c.orange })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.orange })
hl("Boolean", { fg = c.orange, bold = true })
hl("Float", { fg = c.orange })

hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.blue, bold = true })

hl("Statement", { fg = c.red })
hl("Conditional", { fg = c.red })
hl("Repeat", { fg = c.red })
hl("Label", { fg = c.red })
hl("Operator", { fg = c.coral })
hl("Keyword", { fg = c.red })
hl("Exception", { fg = c.coral, bold = true })

hl("PreProc", { fg = c.yellow })
hl("Include", { fg = c.red })
hl("Define", { fg = c.red })
hl("Macro", { fg = c.blue })
hl("PreCondit", { fg = c.red })

hl("Type", { fg = c.violet })
hl("StorageClass", { fg = c.red })
hl("Structure", { fg = c.violet })
hl("Typedef", { fg = c.violet })

hl("Special", { fg = c.aqua })
hl("SpecialChar", { fg = c.orange })
hl("Tag", { fg = c.blue })
hl("Delimiter", { fg = c.delim })
hl("SpecialComment", { fg = c.fg_dark, bold = true })
hl("Debug", { fg = c.warn })

hl("Underlined", { underline = true })
hl("Ignore", { fg = c.fg_muted })
hl("Error", { fg = c.error, bold = true })
hl("Todo", { fg = c.bg, bg = c.yellow, bold = true })

-- ===================================================================
-- Treesitter Highlights
-- ===================================================================
hl("@comment", { link = "Comment" })
hl("@comment.documentation", { fg = c.fg_dark, italic = true })

hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.yellow, bold = true })
hl("@variable.parameter", { fg = c.aqua })
hl("@variable.member", { fg = c.fg })

hl("@constant", { fg = c.orange })
hl("@constant.builtin", { fg = c.orange, bold = true })
hl("@constant.macro", { fg = c.yellow })

hl("@module", { fg = c.yellow })
hl("@module.builtin", { fg = c.yellow, bold = true })

hl("@string", { fg = c.green })
hl("@string.regex", { fg = c.aqua })
hl("@string.escape", { fg = c.orange })
hl("@string.special", { fg = c.orange })

hl("@character", { fg = c.green })
hl("@character.special", { fg = c.orange })
hl("@number", { fg = c.orange })
hl("@number.float", { fg = c.orange })
hl("@boolean", { fg = c.orange, bold = true })

hl("@type", { fg = c.violet })
hl("@type.builtin", { fg = c.violet, bold = true })
hl("@type.definition", { fg = c.violet })
hl("@type.qualifier", { fg = c.red })

hl("@attribute", { fg = c.yellow })
hl("@property", { fg = c.fg })

hl("@function", { fg = c.blue })
hl("@function.builtin", { fg = c.blue, bold = true })
hl("@function.call", { fg = c.blue })
hl("@function.macro", { fg = c.blue })
hl("@function.method", { fg = c.blue })
hl("@function.method.call", { fg = c.blue })
hl("@constructor", { fg = c.violet })

hl("@operator", { fg = c.coral })
hl("@keyword", { fg = c.red })
hl("@keyword.coroutine", { fg = c.red })
hl("@keyword.function", { fg = c.red })
hl("@keyword.operator", { fg = c.coral })
hl("@keyword.import", { fg = c.red })
hl("@keyword.type", { fg = c.red })
hl("@keyword.modifier", { fg = c.red })
hl("@keyword.repeat", { fg = c.red })
hl("@keyword.return", { fg = c.red, bold = true })
hl("@keyword.debug", { fg = c.warn })
hl("@keyword.exception", { fg = c.coral, bold = true })
hl("@keyword.conditional", { fg = c.red })
hl("@keyword.directive", { fg = c.yellow })

hl("@punctuation.delimiter", { fg = c.delim })
hl("@punctuation.bracket", { fg = c.delim })
hl("@punctuation.special", { fg = c.coral })

hl("@tag", { fg = c.blue })
hl("@tag.attribute", { fg = c.yellow })
hl("@tag.delimiter", { fg = c.delim })

hl("@markup.heading", { fg = c.yellow, bold = true })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.link", { fg = c.blue, underline = true })
hl("@markup.link.url", { fg = c.aqua, underline = true })
hl("@markup.raw", { fg = c.green })
hl("@markup.list", { fg = c.yellow })

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
hl("SnacksPickerPrompt", { fg = c.yellow, bg = bg_main })
hl("SnacksPickerTitle", { fg = c.yellow, bg = bg_main, bold = true })
hl("SnacksPickerDirectory", { fg = c.blue, bold = true })
hl("SnacksPickerDir", { fg = c.blue, bold = true })
hl("SnacksPickerFile", { fg = c.fg })
hl("SnacksPickerTree", { fg = c.border })
hl("SnacksPickerSelected", { fg = c.yellow, bg = c.bg_visual, bold = true })
hl("SnacksPickerMatch", { fg = c.orange, bold = true })
hl("SnacksPickerGitStatusAdded", { fg = c.git_add, bold = true })
hl("SnacksPickerGitStatusModified", { fg = c.git_change, bold = true })
hl("SnacksPickerGitStatusDeleted", { fg = c.git_delete, bold = true })
hl("SnacksPickerGitStatusUntracked", { fg = c.green, bold = true })
hl("SnacksPickerGitStatusStaged", { fg = c.green, bold = true })
hl("SnacksPickerGitStatusUnmerged", { fg = c.red, bold = true })
hl("SnacksPickerGitStatusRenamed", { fg = c.purple, bold = true })
hl("SnacksPickerGitStatusCopied", { fg = c.yellow, bold = true })
hl("SnacksPickerGitStatusIgnored", { fg = c.comment })
hl("SnacksPickerPathIgnored", { fg = c.comment })
hl("SnacksPickerPathHidden", { fg = c.border })

-- Mini.icons
hl("MiniIconsAzure", { fg = c.blue })
hl("MiniIconsBlue", { fg = c.blue })
hl("MiniIconsCyan", { fg = c.green })
hl("MiniIconsGreen", { fg = c.green })
hl("MiniIconsGrey", { fg = c.fg_dark })
hl("MiniIconsOrange", { fg = c.orange })
hl("MiniIconsPurple", { fg = c.purple })
hl("MiniIconsRed", { fg = c.red })
hl("MiniIconsYellow", { fg = c.yellow })
hl("SnacksDashboardHeader", { fg = c.yellow, bold = true })
hl("SnacksDashboardDesc", { fg = c.fg_dark })
hl("SnacksDashboardIcon", { fg = c.blue })
hl("SnacksDashboardKey", { fg = c.orange, bold = true })
hl("SnacksIndent", { fg = c.border })
hl("SnacksIndentScope", { fg = c.yellow })

-- Neo-tree (File Tree Sidebar)
hl("NeoTreeNormal", { fg = c.fg, bg = bg_main })
hl("NeoTreeNormalNC", { fg = c.fg, bg = bg_main })
hl("NeoTreeEndOfBuffer", { fg = c.border, bg = bg_main })
hl("NeoTreeDirectoryIcon", { fg = c.blue })
hl("NeoTreeDirectoryName", { fg = c.blue, bold = true })
hl("NeoTreeFileName", { fg = c.fg })
hl("NeoTreeFileIcon", { fg = c.fg_dark })
hl("NeoTreeRootName", { fg = c.yellow, bold = true })
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
hl("TelescopePromptBorder", { fg = c.yellow, bg = bg_main })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.yellow, bold = true })
hl("TelescopeSelection", { fg = c.yellow, bg = c.bg_visual, bold = true })

-- WhichKey
hl("WhichKey", { fg = c.yellow })
hl("WhichKeyGroup", { fg = c.blue, bold = true })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.fg_muted })
hl("WhichKeyFloat", { bg = bg_float })

-- Bufferline
hl("BufferLineFill", { bg = c.bg_status })
hl("BufferLineBackground", { fg = c.fg_muted, bg = c.bg_status })
hl("BufferLineBufferSelected", { fg = c.yellow, bg = c.bg, bold = true })
hl("BufferLineIndicatorSelected", { fg = c.yellow, bg = c.bg })
hl("BufferLineSeparator", { fg = c.bg_status, bg = c.bg_status })

-- Cmp / Blink
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.fg_muted, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = c.yellow, bold = true })
hl("CmpItemKindFunction", { fg = c.blue })
hl("CmpItemKindMethod", { fg = c.blue })
hl("CmpItemKindVariable", { fg = c.fg })
hl("CmpItemKindKeyword", { fg = c.red })
hl("CmpItemKindClass", { fg = c.violet })
hl("CmpItemKindInterface", { fg = c.violet })
hl("CmpItemKindProperty", { fg = c.fg })

-- DAP (Debug Adapter Protocol)
hl("DapBreakpoint", { fg = c.error, bold = true })
hl("DapBreakpointCondition", { fg = c.orange, bold = true })
hl("DapBreakpointRejected", { fg = c.fg_muted })
hl("DapLogPoint", { fg = c.yellow })
hl("DapStopped", { fg = c.green, bold = true })
hl("DapStoppedLine", { bg = c.bg_visual })

-- DBUI (Dadbod Database UI)
hl("dbui_tables", { fg = c.blue, bold = true })
hl("NotificationInfo", { fg = c.info })
hl("NotificationWarning", { fg = c.warn })
hl("NotificationError", { fg = c.error })
