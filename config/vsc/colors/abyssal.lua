-- ===================================================================
-- Abyssal Trench Theme for Minimal Code Editor
-- Midnight Ocean Trench, Mariana Depths, and Bioluminescent Electric Aqua
-- Handcrafted by indiedev
-- ===================================================================

local c = {
  -- Base Backgrounds
  bg = "#05080f",
  bg_dark = "#03050a",
  bg_sidebar = "#05080f",
  bg_status = "#080e1a",
  bg_surface = "#0d1629",
  bg_float = "#111c33",
  bg_highlight = "#172645",
  bg_visual = "#223761",

  -- Hierarchy & Foreground
  fg = "#d8e2fd",
  fg_dark = "#9cb3de",
  fg_muted = "#5f769f",
  fg_gutter = "#344665",

  -- Borders
  border = "#162238",
  border_focus = "#00f5d4",
  border_float = "#1e3052",

  -- Syntax Tokens
  fn = "#00f5d4",
  type = "#9d4edd",
  kw = "#f72585",
  str = "#4cc9f0",
  const = "#ffb703",
  op = "#48cae4",
  preproc = "#7209b7",
  var = "#c2d4f8",
  comment = "#3d5a80",

  -- Git
  git_add = "#00f5d4",
  git_change = "#ffb703",
  git_delete = "#f72585",

  -- Diagnostics
  error = "#f72585",
  warn = "#ffb703",
  info = "#4cc9f0",
  hint = "#00f5d4",

  -- Diagnostic Backgrounds
  diag_err_bg = "#290c1a",
  diag_warn_bg = "#291f0c",
  diag_info_bg = "#0e1f2d",
  diag_hint_bg = "#092420",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "abyssal"
vim.o.termguicolors = true

-- Background transparency configuration
local transparent = vim.g.abyssal_transparent ~= false
local bg_main = transparent and "NONE" or c.bg
local bg_sidebar = transparent and "NONE" or c.bg_sidebar
local bg_float = transparent and "NONE" or c.bg_float
local bg_status = transparent and "NONE" or c.bg_status

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===================================================================
-- UI & Editor Basics
-- ===================================================================
hl("Normal", { fg = c.fg, bg = bg_main })
hl("NormalNC", { fg = c.fg, bg = bg_main })
hl("NormalFloat", { fg = c.fg, bg = bg_float })
hl("FloatBorder", { fg = c.border_float, bg = bg_float })
hl("FloatTitle", { fg = c.fn, bg = bg_float, bold = true })

hl("Cursor", { fg = c.bg, bg = c.fn })
hl("CursorLine", { bg = c.bg_highlight })
hl("CursorColumn", { bg = c.bg_highlight })
hl("ColorColumn", { bg = c.bg_surface })

hl("LineNr", { fg = c.fg_gutter, bg = bg_main })
hl("CursorLineNr", { fg = c.fn, bg = bg_main, bold = true })
hl("SignColumn", { fg = c.fg_gutter, bg = bg_main })
hl("FoldColumn", { fg = c.fg_gutter, bg = bg_main })
hl("Folded", { fg = c.fg_muted, bg = c.bg_surface })
hl("EndOfBuffer", { fg = c.border, bg = bg_main })

hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border, bold = true })

hl("Visual", { bg = c.bg_visual })
hl("VisualNOS", { bg = c.bg_visual })

hl("Search", { fg = c.bg, bg = c.fn, bold = true })
hl("IncSearch", { fg = c.bg, bg = c.const, bold = true })
hl("CurSearch", { fg = c.bg, bg = c.const, bold = true })

hl("StatusLine", { fg = c.fg, bg = bg_status })
hl("StatusLineNC", { fg = c.fg_muted, bg = bg_status })

hl("TabLine", { fg = c.fg_muted, bg = bg_status })
hl("TabLineFill", { bg = bg_status })
hl("TabLineSel", { fg = c.fn, bg = c.bg_surface, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel", { fg = c.fn, bg = c.bg_visual, bold = true })
hl("PmenuSbar", { bg = c.bg_surface })
hl("PmenuThumb", { bg = c.border_float })

hl("MatchParen", { fg = c.fn, bg = c.bg_visual, bold = true, underline = true })
hl("Directory", { fg = c.type, bold = true })
hl("Question", { fg = c.fn })
hl("MoreMsg", { fg = c.fn })
hl("ModeMsg", { fg = c.fn, bold = true })
hl("WarningMsg", { fg = c.warn, bold = true })
hl("ErrorMsg", { fg = c.error, bold = true })
hl("Title", { fg = c.fn, bold = true })
hl("Conceal", { fg = c.fg_muted })
hl("NonText", { fg = c.fg_gutter })
hl("SpecialKey", { fg = c.fg_gutter })
hl("Whitespace", { fg = c.border })

-- ===================================================================
-- Standard Vim Syntax Highlighting
-- ===================================================================
hl("Comment", { fg = c.comment, italic = true })

hl("Constant", { fg = c.const })
hl("String", { fg = c.str })
hl("Character", { fg = c.str })
hl("Number", { fg = c.const })
hl("Boolean", { fg = c.const, bold = true })
hl("Float", { fg = c.const })

hl("Identifier", { fg = c.var })
hl("Function", { fg = c.fn, bold = true })

hl("Statement", { fg = c.kw, bold = true })
hl("Conditional", { fg = c.kw, bold = true })
hl("Repeat", { fg = c.kw, bold = true })
hl("Label", { fg = c.kw })
hl("Operator", { fg = c.op })
hl("Keyword", { fg = c.kw, bold = true })
hl("Exception", { fg = c.kw, bold = true })

hl("PreProc", { fg = c.preproc })
hl("Include", { fg = c.kw, bold = true })
hl("Define", { fg = c.preproc })
hl("Macro", { fg = c.preproc })
hl("PreCondit", { fg = c.preproc })

hl("Type", { fg = c.type, bold = true })
hl("StorageClass", { fg = c.kw })
hl("Structure", { fg = c.type, bold = true })
hl("Typedef", { fg = c.type })

hl("Special", { fg = c.const })
hl("SpecialChar", { fg = c.const })
hl("Tag", { fg = c.kw })
hl("Delimiter", { fg = c.op })
hl("SpecialComment", { fg = c.fn, italic = true })
hl("Debug", { fg = c.kw })

hl("Underlined", { underline = true })
hl("Bold", { bold = true })
hl("Italic", { italic = true })
hl("Ignore", { fg = c.fg_muted })
hl("Error", { fg = c.error, bg = c.bg_surface, bold = true })
hl("Todo", { fg = c.bg, bg = c.fn, bold = true })

-- ===================================================================
-- Tree-sitter Standard & Extended Groups
-- ===================================================================
hl("@variable", { fg = c.var })
hl("@variable.builtin", { fg = c.type, italic = true })
hl("@variable.parameter", { fg = c.var })
hl("@variable.member", { fg = c.var })

hl("@constant", { fg = c.const })
hl("@constant.builtin", { fg = c.const, bold = true })
hl("@constant.macro", { fg = c.const })

hl("@module", { fg = c.type })
hl("@label", { fg = c.kw })

hl("@string", { fg = c.str })
hl("@string.regex", { fg = c.const })
hl("@string.escape", { fg = c.type, bold = true })
hl("@string.special", { fg = c.const })
hl("@character", { fg = c.str })
hl("@character.special", { fg = c.type })

hl("@number", { fg = c.const })
hl("@number.float", { fg = c.const })
hl("@boolean", { fg = c.const, bold = true })

hl("@function", { fg = c.fn, bold = true })
hl("@function.builtin", { fg = c.fn })
hl("@function.call", { fg = c.fn })
hl("@function.macro", { fg = c.fn })
hl("@function.method", { fg = c.fn })
hl("@constructor", { fg = c.type, bold = true })

hl("@operator", { fg = c.op })

hl("@keyword", { fg = c.kw, bold = true })
hl("@keyword.function", { fg = c.kw, bold = true })
hl("@keyword.operator", { fg = c.kw })
hl("@keyword.import", { fg = c.kw, bold = true })
hl("@keyword.return", { fg = c.kw, bold = true })
hl("@keyword.conditional", { fg = c.kw, bold = true })
hl("@keyword.repeat", { fg = c.kw, bold = true })
hl("@keyword.exception", { fg = c.kw, bold = true })

hl("@punctuation.delimiter", { fg = c.op })
hl("@punctuation.bracket", { fg = c.op })
hl("@punctuation.special", { fg = c.fn })

hl("@comment", { fg = c.comment, italic = true })
hl("@comment.documentation", { fg = c.fg_dark, italic = true })

hl("@type", { fg = c.type, bold = true })
hl("@type.builtin", { fg = c.type })
hl("@type.definition", { fg = c.type, bold = true })
hl("@type.qualifier", { fg = c.kw })

hl("@tag", { fg = c.kw, bold = true })
hl("@tag.attribute", { fg = c.fn })
hl("@tag.delimiter", { fg = c.op })

hl("@property", { fg = c.var })

hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.heading", { fg = c.fn, bold = true })
hl("@markup.quote", { fg = c.comment, italic = true })
hl("@markup.link", { fg = c.op, underline = true })
hl("@markup.link.url", { fg = c.type, underline = true })
hl("@markup.list", { fg = c.kw })
hl("@markup.raw", { fg = c.str })

hl("@diff.plus", { fg = c.git_add })
hl("@diff.minus", { fg = c.git_delete })
hl("@diff.delta", { fg = c.git_change })

-- ===================================================================
-- LSP Semantic Tokens
-- ===================================================================
hl("@lsp.type.class", { fg = c.type, bold = true })
hl("@lsp.type.decorator", { fg = c.preproc })
hl("@lsp.type.enum", { fg = c.type, bold = true })
hl("@lsp.type.enumMember", { fg = c.const })
hl("@lsp.type.function", { fg = c.fn, bold = true })
hl("@lsp.type.interface", { fg = c.type, bold = true })
hl("@lsp.type.macro", { fg = c.preproc })
hl("@lsp.type.method", { fg = c.fn })
hl("@lsp.type.namespace", { fg = c.type })
hl("@lsp.type.parameter", { fg = c.var })
hl("@lsp.type.property", { fg = c.var })
hl("@lsp.type.struct", { fg = c.type, bold = true })
hl("@lsp.type.type", { fg = c.type, bold = true })
hl("@lsp.type.typeParameter", { fg = c.type, italic = true })
hl("@lsp.type.variable", { fg = c.var })

-- ===================================================================
-- LSP Diagnostics & Error Lens
-- ===================================================================
hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn", { fg = c.warn })
hl("DiagnosticInfo", { fg = c.info })
hl("DiagnosticHint", { fg = c.hint })

hl("DiagnosticVirtualTextError", { fg = c.error, bg = c.diag_err_bg })
hl("DiagnosticVirtualTextWarn", { fg = c.warn, bg = c.diag_warn_bg })
hl("DiagnosticVirtualTextInfo", { fg = c.info, bg = c.diag_info_bg })
hl("DiagnosticVirtualTextHint", { fg = c.hint, bg = c.diag_hint_bg })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })

-- ===================================================================
-- Git Signs & Diffs
-- ===================================================================
hl("GitSignsAdd", { fg = c.git_add, bg = bg_main })
hl("GitSignsChange", { fg = c.git_change, bg = bg_main })
hl("GitSignsDelete", { fg = c.git_delete, bg = bg_main })

hl("diffAdded", { fg = c.git_add })
hl("diffRemoved", { fg = c.git_delete })
hl("diffChanged", { fg = c.git_change })
hl("diffFile", { fg = c.type, bold = true })
hl("diffNewFile", { fg = c.git_add, bold = true })
hl("diffLine", { fg = c.comment })

-- ===================================================================
-- Snacks.nvim (Dashboard, Explorer, Indent, Pickers)
-- ===================================================================
hl("SnacksDashboardHeader", { fg = c.fn, bold = true })
hl("SnacksDashboardDesc", { fg = c.fg_dark })
hl("SnacksDashboardIcon", { fg = c.type })
hl("SnacksDashboardKey", { fg = c.kw, bold = true })
hl("SnacksIndent", { fg = c.border })
hl("SnacksIndentScope", { fg = c.fn, bold = true })

-- ===================================================================
-- File Explorer Sidebar
-- ===================================================================
hl("SnacksPickerDirectory", { fg = c.type, bold = true })
hl("SnacksPickerFile", { fg = c.fg })
hl("SnacksPickerMatch", { fg = c.fn, bold = true })

-- ===================================================================
-- Cmp / Blink Completion Menu
-- ===================================================================
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.fg_muted, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = c.fn, bold = true })
hl("CmpItemKindFunction", { fg = c.fn })
hl("CmpItemKindMethod", { fg = c.fn })
hl("CmpItemKindVariable", { fg = c.var })
hl("CmpItemKindKeyword", { fg = c.kw })
hl("CmpItemKindClass", { fg = c.type })
hl("CmpItemKindInterface", { fg = c.type })
hl("CmpItemKindProperty", { fg = c.var })

hl("BlinkCmpLabel", { fg = c.fg })
hl("BlinkCmpLabelMatch", { fg = c.fn, bold = true })
hl("BlinkCmpKindFunction", { fg = c.fn })
hl("BlinkCmpKindMethod", { fg = c.fn })
hl("BlinkCmpKindVariable", { fg = c.var })
hl("BlinkCmpKindKeyword", { fg = c.kw })
hl("BlinkCmpKindClass", { fg = c.type })

-- ===================================================================
-- Bufferline & Statusline
-- ===================================================================
hl("BufferLineFill", { bg = c.bg_status })
hl("BufferLineBackground", { fg = c.fg_muted, bg = c.bg_status })
hl("BufferLineBufferSelected", { fg = c.fn, bg = c.bg, bold = true })
hl("BufferLineIndicatorSelected", { fg = c.fn, bg = c.bg })
hl("BufferLineSeparator", { fg = c.bg_status, bg = c.bg_status })
