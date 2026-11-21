-- ===================================================================
-- Medieval Scriptorium Theme for Minimal Code Editor
-- A bespoke medieval aesthetic: Aged Vellum Manuscript, Illuminated Gold Leaf,
-- Dragon Blood Rubrication, Deep Hearth Ember, and Dark Castle Crypt Stone.
-- Handcrafted by indiedev
-- ===================================================================

local c = {
  -- Base Backgrounds (Aged Castle Crypt, Hearth Charcoal & Smoked Oak)
  bg = "#0e0d0b",          -- Deep Castle Stone / Iron Hearth
  bg_dark = "#080706",     -- Deepest Crypt Obsidian
  bg_sidebar = "#0e0d0b",  -- Matching Sidebar
  bg_status = "#14120e",   -- Forged Iron Crossbeam
  bg_surface = "#191612",  -- Carved Dark Bog Oak
  bg_float = "#1c1914",    -- Smoky Hearth Chamber
  bg_highlight = "#221d17",-- Candlelit Gutter / Line Highlight
  bg_visual = "#382f23",   -- Warm Beeswax Ember Selection
  
  -- Hierarchy & Foreground (Illuminated Manuscript Vellum)
  fg = "#dfcfb2",          -- Aged Illuminated Parchment / Warm Vellum
  fg_dark = "#a89984",     -- Monastic Sepia / Secondary Inscriptions
  fg_muted = "#7c6f5e",    -- Faded Scriptorium Marginalia
  fg_gutter = "#504538",   -- Aged Ledger Rules
  
  -- Borders
  border = "#2a241d",      -- Hand-forged Dark Iron
  border_focus = "#e5b567",-- Burnished Gold Leaf
  border_float = "#3d3429",-- Chiseled Granite Border
  
  -- Medieval Illuminated Manuscript Accents
  gold = "#e5b567",        -- Illuminated Gold Leaf (Functions, Methods, Relics)
  amber = "#f0c674",       -- Dragon Bullion / Sunstone (Types, Classes, Structs, Enums)
  crimson = "#d14d41",     -- Scarlet Rubrication / Dragon Blood (Keywords, Control, Tags)
  moss = "#98bb6c",        -- Forest Sylvan Moss / Herbalist Green (Strings, Literals)
  torch = "#e67e38",       -- Flickering Torchlight / Beeswax Flame (Numbers, Booleans, Constants)
  steel = "#6897bb",       -- Crusader Steel / Gothic Stained Glass Cobalt (Operators, Delimiters)
  purple = "#ba8bcf",      -- Archmage Velvet / Royal Amethyst (Imports, Preprocessors, StorageClass)
  teal = "#62a88e",        -- Alchemical Verdigris / Emerald Elixir (Variables, Properties, Identifiers)
  comment = "#857562",     -- Monastic Quill Inscription (Comments, italic sepia)
  
  -- Git (Heraldic Marks)
  git_add = "#98bb6c",     -- Sylvan Bloom Green
  git_change = "#e5b567",  -- Gold Leaf Amber
  git_delete = "#d14d41",  -- Scarlet Wax Seal
  
  -- Diagnostics
  error = "#e0554c",       -- Crimson Inquisition
  warn = "#e6983b",        -- Torchlight Flare
  info = "#6897bb",        -- Cobalt Scripture
  hint = "#98bb6c",        -- Herbalist Rune
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "medieval"
vim.o.termguicolors = true

local transparent = vim.g.medieval_transparent ~= false
local bg_main = transparent and "NONE" or c.bg
local bg_sidebar = transparent and "NONE" or c.bg_sidebar
local bg_float = transparent and "NONE" or c.bg_float
local bg_status = transparent and "NONE" or c.bg_status

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===================================================================
-- UI & Editor Basics (Stone Castle & Manuscript Aesthetics)
-- ===================================================================
hl("Normal", { fg = c.fg, bg = bg_main })
hl("NormalNC", { fg = c.fg, bg = bg_main })
hl("NormalFloat", { fg = c.fg, bg = bg_float })
hl("FloatBorder", { fg = c.border_float, bg = bg_float })
hl("FloatTitle", { fg = c.gold, bg = bg_float, bold = true })

hl("Cursor", { fg = c.bg, bg = c.gold })
hl("CursorLine", { bg = c.bg_highlight })
hl("CursorColumn", { bg = c.bg_highlight })
hl("ColorColumn", { bg = c.bg_surface })

hl("LineNr", { fg = c.fg_gutter, bg = bg_main })
hl("CursorLineNr", { fg = c.gold, bg = bg_main, bold = true })
hl("SignColumn", { fg = c.fg_gutter, bg = bg_main })
hl("FoldColumn", { fg = c.fg_gutter, bg = bg_main })
hl("Folded", { fg = c.fg_muted, bg = c.bg_surface })
hl("EndOfBuffer", { fg = c.border, bg = bg_main })

hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border, bold = true })

hl("Visual", { bg = c.bg_visual })
hl("VisualNOS", { bg = c.bg_visual })

hl("Search", { fg = c.bg, bg = c.gold, bold = true })
hl("IncSearch", { fg = c.bg, bg = c.torch, bold = true })
hl("CurSearch", { fg = c.bg, bg = c.torch, bold = true })

hl("StatusLine", { fg = c.fg, bg = bg_status })
hl("StatusLineNC", { fg = c.fg_muted, bg = bg_status })

hl("TabLine", { fg = c.fg_muted, bg = c.bg_status })
hl("TabLineFill", { bg = c.bg_status })
hl("TabLineSel", { fg = c.gold, bg = c.bg_surface, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel", { fg = c.gold, bg = c.bg_visual, bold = true })
hl("PmenuSbar", { bg = c.bg_surface })
hl("PmenuThumb", { bg = c.border_float })

hl("MatchParen", { fg = c.gold, bg = c.bg_visual, bold = true, underline = true })
hl("Directory", { fg = c.amber, bold = true })
hl("Question", { fg = c.gold })
hl("MoreMsg", { fg = c.gold })
hl("ModeMsg", { fg = c.gold, bold = true })
hl("WarningMsg", { fg = c.warn, bold = true })
hl("ErrorMsg", { fg = c.error, bold = true })
hl("Title", { fg = c.gold, bold = true })
hl("Conceal", { fg = c.fg_muted })
hl("NonText", { fg = c.fg_gutter })
hl("SpecialKey", { fg = c.fg_gutter })
hl("Whitespace", { fg = c.border })

-- ===================================================================
-- Standard Vim Syntax Highlighting (Illuminated Codex Palette)
-- ===================================================================
hl("Comment", { fg = c.comment, italic = true })

hl("Constant", { fg = c.torch })
hl("String", { fg = c.moss })
hl("Character", { fg = c.moss })
hl("Number", { fg = c.torch })
hl("Boolean", { fg = c.torch, bold = true })
hl("Float", { fg = c.torch })

hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.gold, bold = true })

hl("Statement", { fg = c.crimson, bold = true })
hl("Conditional", { fg = c.crimson, bold = true })
hl("Repeat", { fg = c.crimson, bold = true })
hl("Label", { fg = c.crimson })
hl("Operator", { fg = c.steel })
hl("Keyword", { fg = c.crimson, bold = true })
hl("Exception", { fg = c.crimson, bold = true })

hl("PreProc", { fg = c.purple })
hl("Include", { fg = c.crimson, bold = true })
hl("Define", { fg = c.purple })
hl("Macro", { fg = c.purple })
hl("PreCondit", { fg = c.purple })

hl("Type", { fg = c.amber, bold = true })
hl("StorageClass", { fg = c.crimson })
hl("Structure", { fg = c.amber, bold = true })
hl("Typedef", { fg = c.amber })

hl("Special", { fg = c.torch })
hl("SpecialChar", { fg = c.torch })
hl("Tag", { fg = c.crimson })
hl("Delimiter", { fg = c.steel })
hl("SpecialComment", { fg = c.gold, italic = true })
hl("Debug", { fg = c.crimson })

hl("Underlined", { underline = true })
hl("Bold", { bold = true })
hl("Italic", { italic = true })
hl("Ignore", { fg = c.fg_muted })
hl("Error", { fg = c.error, bg = c.bg_surface, bold = true })
hl("Todo", { fg = c.bg, bg = c.gold, bold = true })

-- ===================================================================
-- Tree-sitter Standard & Extended Groups
-- ===================================================================
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.amber, italic = true })
hl("@variable.parameter", { fg = c.teal })
hl("@variable.member", { fg = c.teal })

hl("@constant", { fg = c.torch })
hl("@constant.builtin", { fg = c.torch, bold = true })
hl("@constant.macro", { fg = c.torch })

hl("@module", { fg = c.amber })
hl("@label", { fg = c.crimson })

hl("@string", { fg = c.moss })
hl("@string.regex", { fg = c.torch })
hl("@string.escape", { fg = c.amber, bold = true })
hl("@string.special", { fg = c.torch })
hl("@character", { fg = c.moss })
hl("@character.special", { fg = c.amber })

hl("@number", { fg = c.torch })
hl("@number.float", { fg = c.torch })
hl("@boolean", { fg = c.torch, bold = true })

hl("@function", { fg = c.gold, bold = true })
hl("@function.builtin", { fg = c.gold })
hl("@function.call", { fg = c.gold })
hl("@function.macro", { fg = c.gold })
hl("@function.method", { fg = c.gold })
hl("@constructor", { fg = c.amber, bold = true })

hl("@operator", { fg = c.steel })

hl("@keyword", { fg = c.crimson, bold = true })
hl("@keyword.function", { fg = c.crimson, bold = true })
hl("@keyword.operator", { fg = c.crimson })
hl("@keyword.import", { fg = c.crimson, bold = true })
hl("@keyword.return", { fg = c.crimson, bold = true })
hl("@keyword.conditional", { fg = c.crimson, bold = true })
hl("@keyword.repeat", { fg = c.crimson, bold = true })
hl("@keyword.exception", { fg = c.crimson, bold = true })

hl("@punctuation.delimiter", { fg = c.steel })
hl("@punctuation.bracket", { fg = c.steel })
hl("@punctuation.special", { fg = c.gold })

hl("@comment", { fg = c.comment, italic = true })
hl("@comment.documentation", { fg = c.fg_dark, italic = true })

hl("@type", { fg = c.amber, bold = true })
hl("@type.builtin", { fg = c.amber })
hl("@type.definition", { fg = c.amber, bold = true })
hl("@type.qualifier", { fg = c.crimson })

hl("@tag", { fg = c.crimson, bold = true })
hl("@tag.attribute", { fg = c.gold })
hl("@tag.delimiter", { fg = c.steel })

hl("@property", { fg = c.teal })

hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.heading", { fg = c.gold, bold = true })
hl("@markup.quote", { fg = c.comment, italic = true })
hl("@markup.link", { fg = c.steel, underline = true })
hl("@markup.link.url", { fg = c.amber, underline = true })
hl("@markup.list", { fg = c.crimson })
hl("@markup.raw", { fg = c.moss })

hl("@diff.plus", { fg = c.git_add })
hl("@diff.minus", { fg = c.git_delete })
hl("@diff.delta", { fg = c.git_change })

-- ===================================================================
-- LSP Semantic Tokens
-- ===================================================================
hl("@lsp.type.class", { fg = c.amber, bold = true })
hl("@lsp.type.decorator", { fg = c.purple })
hl("@lsp.type.enum", { fg = c.amber, bold = true })
hl("@lsp.type.enumMember", { fg = c.torch })
hl("@lsp.type.function", { fg = c.gold, bold = true })
hl("@lsp.type.interface", { fg = c.amber, bold = true })
hl("@lsp.type.macro", { fg = c.purple })
hl("@lsp.type.method", { fg = c.gold })
hl("@lsp.type.namespace", { fg = c.amber })
hl("@lsp.type.parameter", { fg = c.teal })
hl("@lsp.type.property", { fg = c.teal })
hl("@lsp.type.struct", { fg = c.amber, bold = true })
hl("@lsp.type.type", { fg = c.amber, bold = true })
hl("@lsp.type.typeParameter", { fg = c.amber, italic = true })
hl("@lsp.type.variable", { fg = c.fg })

-- ===================================================================
-- LSP Diagnostics & Error Lens
-- ===================================================================
hl("DiagnosticError", { fg = c.error })
hl("DiagnosticWarn", { fg = c.warn })
hl("DiagnosticInfo", { fg = c.info })
hl("DiagnosticHint", { fg = c.hint })

hl("DiagnosticVirtualTextError", { fg = c.error, bg = "#241312" })
hl("DiagnosticVirtualTextWarn", { fg = c.warn, bg = "#241a10" })
hl("DiagnosticVirtualTextInfo", { fg = c.info, bg = "#141b24" })
hl("DiagnosticVirtualTextHint", { fg = c.hint, bg = "#132117" })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })

-- ===================================================================
-- Git Signs & Diffs (Heraldic Standard)
-- ===================================================================
hl("GitSignsAdd", { fg = c.git_add, bg = bg_main })
hl("GitSignsChange", { fg = c.git_change, bg = bg_main })
hl("GitSignsDelete", { fg = c.git_delete, bg = bg_main })

hl("diffAdded", { fg = c.git_add })
hl("diffRemoved", { fg = c.git_delete })
hl("diffChanged", { fg = c.git_change })
hl("diffFile", { fg = c.amber, bold = true })
hl("diffNewFile", { fg = c.git_add, bold = true })
hl("diffLine", { fg = c.comment })

-- ===================================================================
-- Snacks.nvim (Dashboard, Explorer, Indent, Pickers)
-- ===================================================================
hl("SnacksDashboardHeader", { fg = c.gold, bold = true })
hl("SnacksDashboardDesc", { fg = c.fg_dark })
hl("SnacksDashboardIcon", { fg = c.amber })
hl("SnacksDashboardKey", { fg = c.crimson, bold = true })
hl("SnacksIndent", { fg = c.border })
hl("SnacksIndentScope", { fg = c.gold })

-- ===================================================================
-- File Explorer Sidebar
-- ===================================================================
hl("SnacksPickerDirectory", { fg = c.amber, bold = true })
hl("SnacksPickerFile", { fg = c.fg })
hl("SnacksPickerMatch", { fg = c.gold, bold = true })

-- ===================================================================
-- Cmp / Blink Completion Menu
-- ===================================================================
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.fg_muted, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = c.gold, bold = true })
hl("CmpItemKindFunction", { fg = c.gold })
hl("CmpItemKindMethod", { fg = c.gold })
hl("CmpItemKindVariable", { fg = c.teal })
hl("CmpItemKindKeyword", { fg = c.crimson })
hl("CmpItemKindClass", { fg = c.amber })
hl("CmpItemKindInterface", { fg = c.amber })
hl("CmpItemKindProperty", { fg = c.teal })

hl("BlinkCmpLabel", { fg = c.fg })
hl("BlinkCmpLabelMatch", { fg = c.gold, bold = true })
hl("BlinkCmpKindFunction", { fg = c.gold })
hl("BlinkCmpKindMethod", { fg = c.gold })
hl("BlinkCmpKindVariable", { fg = c.teal })
hl("BlinkCmpKindKeyword", { fg = c.crimson })
hl("BlinkCmpKindClass", { fg = c.amber })

-- ===================================================================
-- Bufferline & Statusline
-- ===================================================================
hl("BufferLineFill", { bg = c.bg_status })
hl("BufferLineBackground", { fg = c.fg_muted, bg = c.bg_status })
hl("BufferLineBufferSelected", { fg = c.gold, bg = c.bg, bold = true })
hl("BufferLineIndicatorSelected", { fg = c.gold, bg = c.bg })
hl("BufferLineSeparator", { fg = c.bg_status, bg = c.bg_status })
