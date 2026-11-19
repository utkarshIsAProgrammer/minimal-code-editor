-- Dark Magic Theme for Neovim / LazyVim
-- Extracted directly and accurately from VS Code "Dark Magic" (DavidMorais.dark-magic-themes)
-- Retains exact background tones, borders, and transparent mode support

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
  
  -- Hierarchy & Foreground (VS Code editor.foreground: #bbccee)
  fg = "#bbccee",
  fg_dark = "#8899bb",
  fg_muted = "#606085",
  fg_gutter = "#424260",
  
  -- Borders
  border = "#20202e",
  border_focus = "#66eeaa",
  border_float = "#2c2c40",
  
  -- Exact VS Code Dark Magic Syntax Colors
  purple = "#cfa3f5",    -- Keywords, Statements, Control, Storage, Imports (VS Code: #cfa3f5)
  blue = "#6bc7f5",      -- Functions, Methods, Calls, Links (VS Code: #6bc7f5)
  pink = "#db6797",      -- Strings, Regex characters, Raw markup (VS Code: #db6797)
  lime = "#b4f09e",      -- Numbers, Integers, Floats, Booleans, Constants, Attributes (VS Code: #b4f09e)
  gold = "#c7c56c",      -- Types, Classes, Interfaces, Namespaces, self/this (VS Code: #c7c56c)
  mint = "#66eeaa",      -- Variables, Identifiers, Tags, Headings (VS Code: #66eeaadd)
  orange = "#ff9d62",    -- Operators, Support Functions, Enums (VS Code: #ff9d62)
  red = "#ff385e",       -- Red / Errors / Deleted
  comment = "#606085",   -- Comments (VS Code: #bbccee77)
  
  -- Git (VS Code Dark Magic diff)
  git_add = "#c1ff38",
  git_change = "#38daff",
  git_delete = "#ff385e",
  
  -- Diagnostics
  error = "#bb324c",
  warn = "#fbde66",
  info = "#6bc7f5",
  hint = "#66eeaa",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "darkmagic"
vim.o.termguicolors = true

-- Background transparency configuration
local transparent = vim.g.darkmagic_transparent ~= false
local bg_main = transparent and "NONE" or c.bg
local bg_sidebar = transparent and "NONE" or c.bg_sidebar
local bg_float = transparent and "NONE" or c.bg_float
local bg_status = transparent and "NONE" or c.bg_status

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ===================================================================
-- UI & Editor Basics (Preserved 100% Identical)
-- ===================================================================
hl("Normal", { fg = c.fg, bg = bg_main })
hl("NormalNC", { fg = c.fg, bg = bg_main })
hl("NormalFloat", { fg = c.fg, bg = bg_float })
hl("FloatBorder", { fg = c.border_float, bg = bg_float })
hl("FloatTitle", { fg = c.mint, bg = bg_float, bold = true })

hl("Cursor", { fg = c.bg, bg = c.mint })
hl("CursorLine", { bg = c.bg_highlight })
hl("CursorColumn", { bg = c.bg_highlight })
hl("ColorColumn", { bg = c.bg_surface })

hl("LineNr", { fg = c.fg_gutter, bg = bg_main })
hl("CursorLineNr", { fg = c.mint, bg = bg_main, bold = true })
hl("SignColumn", { fg = c.fg_gutter, bg = bg_main })
hl("FoldColumn", { fg = c.fg_gutter, bg = bg_main })
hl("Folded", { fg = c.fg_muted, bg = c.bg_surface })
hl("EndOfBuffer", { fg = c.border, bg = bg_main })

hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border, bold = true })

hl("Visual", { bg = c.bg_visual })
hl("VisualNOS", { bg = c.bg_visual })

hl("Search", { fg = c.bg, bg = c.mint })
hl("IncSearch", { fg = c.bg, bg = c.orange, bold = true })
hl("CurSearch", { fg = c.bg, bg = c.orange, bold = true })

hl("StatusLine", { fg = c.fg, bg = bg_status })
hl("StatusLineNC", { fg = c.fg_muted, bg = bg_status })

hl("TabLine", { fg = c.fg_muted, bg = c.bg_status })
hl("TabLineFill", { bg = c.bg_status })
hl("TabLineSel", { fg = c.mint, bg = c.bg_surface, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.bg_surface })
hl("PmenuSel", { fg = c.mint, bg = c.bg_visual, bold = true })
hl("PmenuSbar", { bg = c.bg_surface })
hl("PmenuThumb", { bg = c.border_float })

hl("MatchParen", { fg = c.mint, bg = c.bg_visual, bold = true, underline = true })
hl("Directory", { fg = c.blue, bold = true })
hl("Question", { fg = c.mint })
hl("MoreMsg", { fg = c.mint })
hl("ModeMsg", { fg = c.mint, bold = true })
hl("WarningMsg", { fg = c.warn, bold = true })
hl("ErrorMsg", { fg = c.error, bold = true })
hl("Title", { fg = c.mint, bold = true })
hl("Conceal", { fg = c.fg_muted })
hl("NonText", { fg = c.border })
hl("SpecialKey", { fg = c.border })
hl("Whitespace", { fg = c.border })

-- ===================================================================
-- Syntax Highlighting (Classic / Fallback)
-- Matched to exact VS Code Dark Magic definitions
-- ===================================================================
hl("Comment", { fg = c.comment, italic = true })

-- Constants & Numbers (VS Code Dark Magic: #b4f09e)
hl("Constant", { fg = c.lime })
hl("Number", { fg = c.lime })
hl("Boolean", { fg = c.lime, bold = true })
hl("Float", { fg = c.lime })

-- Strings (VS Code Dark Magic: #db6797)
hl("String", { fg = c.pink })
hl("Character", { fg = c.pink })

-- Variables & Identifiers (VS Code Dark Magic: #66eeaadd)
hl("Identifier", { fg = c.mint })

-- Functions & Methods (VS Code Dark Magic: #6bc7f5)
hl("Function", { fg = c.blue, bold = true })

-- Keywords & Control (VS Code Dark Magic: #cfa3f5)
hl("Statement", { fg = c.purple })
hl("Conditional", { fg = c.purple })
hl("Repeat", { fg = c.purple })
hl("Label", { fg = c.purple })
hl("Keyword", { fg = c.purple })
hl("Exception", { fg = c.purple })

-- Preprocessor & Includes (VS Code Dark Magic: #cfa3f5 / #6bc7f5)
hl("PreProc", { fg = c.purple })
hl("Include", { fg = c.purple })
hl("Define", { fg = c.purple })
hl("Macro", { fg = c.blue })
hl("PreCondit", { fg = c.purple })

-- Types & Classes (VS Code Dark Magic: #c7c56c)
hl("Type", { fg = c.gold })
hl("StorageClass", { fg = c.purple })
hl("Structure", { fg = c.gold })
hl("Typedef", { fg = c.gold })

-- Operators & Delimiters
hl("Operator", { fg = c.orange })
hl("Delimiter", { fg = c.fg })
hl("Special", { fg = c.mint })
hl("SpecialChar", { fg = c.orange })
hl("Tag", { fg = c.mint })
hl("SpecialComment", { fg = c.fg_dark, bold = true })
hl("Debug", { fg = c.warn })

hl("Underlined", { underline = true })
hl("Ignore", { fg = c.fg_muted })
hl("Error", { fg = c.error, bold = true })
hl("Todo", { fg = c.bg, bg = c.mint, bold = true })

-- ===================================================================
-- Treesitter Highlights (VS Code Dark Magic Exact Grammar Mappings)
-- ===================================================================
hl("@comment", { link = "Comment" })
hl("@comment.documentation", { fg = c.fg_dark, italic = true })

-- Variables & Identifiers
hl("@variable", { fg = c.mint })
hl("@variable.builtin", { fg = c.gold, bold = true })  -- self, this, super
hl("@variable.parameter", { fg = c.fg })               -- parameters default to editor foreground
hl("@variable.parameter.builtin", { fg = c.gold })     -- special self/this in params
hl("@variable.member", { fg = c.mint })                -- fields / properties

-- Constants & Numbers (Lime in Dark Magic)
hl("@constant", { fg = c.lime })
hl("@constant.builtin", { fg = c.lime, bold = true })
hl("@constant.macro", { fg = c.lime })

hl("@number", { fg = c.lime })
hl("@number.float", { fg = c.lime })
hl("@boolean", { fg = c.lime, bold = true })

-- Strings & Characters (Pink in Dark Magic)
hl("@string", { fg = c.pink })
hl("@string.regex", { fg = c.mint })
hl("@string.escape", { fg = c.orange })
hl("@string.special", { fg = c.orange })
hl("@character", { fg = c.pink })
hl("@character.special", { fg = c.orange })

-- Types & Classes & Namespaces (Gold/Yellow in Dark Magic)
hl("@type", { fg = c.gold })
hl("@type.builtin", { fg = c.gold })
hl("@type.definition", { fg = c.gold })
hl("@type.qualifier", { fg = c.purple })
hl("@constructor", { fg = c.gold })
hl("@module", { fg = c.gold })
hl("@module.builtin", { fg = c.gold, bold = true })
hl("@attribute", { fg = c.lime }) -- HTML/JSX attributes are lime in Dark Magic
hl("@property", { fg = c.mint })

-- Functions & Methods (Sky Blue in Dark Magic)
hl("@function", { fg = c.blue })
hl("@function.builtin", { fg = c.orange }) -- support.function in Dark Magic rule 95 is #ff9d62
hl("@function.call", { fg = c.blue })
hl("@function.macro", { fg = c.blue })
hl("@function.method", { fg = c.blue })
hl("@function.method.call", { fg = c.blue })

-- Keywords & Statements (Purple in Dark Magic)
hl("@keyword", { fg = c.purple })
hl("@keyword.coroutine", { fg = c.purple })
hl("@keyword.function", { fg = c.purple })
hl("@keyword.operator", { fg = c.purple })
hl("@keyword.import", { fg = c.purple })
hl("@keyword.type", { fg = c.purple })
hl("@keyword.modifier", { fg = c.purple })
hl("@keyword.repeat", { fg = c.purple })
hl("@keyword.return", { fg = c.purple })
hl("@keyword.debug", { fg = c.warn })
hl("@keyword.exception", { fg = c.purple })
hl("@keyword.conditional", { fg = c.purple })
hl("@keyword.directive", { fg = c.purple })

-- Operators & Punctuation
hl("@operator", { fg = c.orange })
hl("@punctuation.delimiter", { fg = c.fg })
hl("@punctuation.bracket", { fg = c.fg })
hl("@punctuation.special", { fg = c.mint })

-- Tags (HTML, XML, JSX, TSX)
hl("@tag", { fg = c.mint })
hl("@tag.builtin", { fg = c.mint })
hl("@tag.attribute", { fg = c.lime }) -- Attributes are #b4f09e
hl("@tag.delimiter", { fg = c.fg })

-- Markup (Markdown)
hl("@markup.heading", { fg = c.mint, bold = true })
hl("@markup.heading.1", { fg = c.mint, bold = true })
hl("@markup.heading.2", { fg = c.mint, bold = true })
hl("@markup.heading.3", { fg = c.mint, bold = true })
hl("@markup.strong", { bold = true })
hl("@markup.italic", { italic = true })
hl("@markup.strikethrough", { strikethrough = true })
hl("@markup.underline", { underline = true })
hl("@markup.link", { fg = c.blue, underline = true })
hl("@markup.link.url", { fg = c.gold, underline = true })
hl("@markup.raw", { fg = c.pink })
hl("@markup.list", { fg = c.mint })
hl("@markup.quote", { fg = c.fg_muted, italic = true })

-- ===================================================================
-- LSP Semantic Tokens (Faithful to VS Code Dark Magic Semantic Rules)
-- Crucial: Avoid blanket @lsp.type.variable override so Treesitter
-- granular colors are NOT flattened across LSP-attached files!
-- ===================================================================
hl("@lsp.type.variable", {}) -- Do not override: allow Treesitter granular tokens to shine through
hl("@lsp.type.property", { fg = c.mint })
hl("@lsp.type.parameter", { fg = c.fg })
hl("@lsp.type.function", { fg = c.blue })
hl("@lsp.type.method", { fg = c.blue })
hl("@lsp.type.class", { fg = c.gold })
hl("@lsp.type.type", { fg = c.gold })
hl("@lsp.type.interface", { fg = c.gold })
hl("@lsp.type.struct", { fg = c.gold })
hl("@lsp.type.enum", { fg = c.gold })
hl("@lsp.type.enumMember", { fg = c.orange })      -- VS Code semanticTokenColors.enumMember
hl("@lsp.type.namespace", { fg = c.gold })
hl("@lsp.type.macro", { fg = c.blue })
hl("@lsp.type.decorator", { fg = c.lime })
hl("@lsp.type.keyword", { fg = c.purple })

-- Semantic Token Modifiers
hl("@lsp.typemod.variable.readonly", { fg = c.lime })         -- VS Code variable.constant
hl("@lsp.typemod.variable.constant", { fg = c.lime })         -- VS Code variable.constant
hl("@lsp.typemod.variable.defaultLibrary", { fg = c.gold })   -- VS Code variable.defaultLibrary
hl("@lsp.typemod.function.defaultLibrary", { fg = c.orange })
hl("@lsp.typemod.property.readonly", { fg = c.lime })
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
hl("GitSignsUntracked", { fg = c.mint })

-- ===================================================================
-- Plugins (LazyVim UI & Sidebars - Backgrounds strictly preserved)
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
hl("SnacksPickerPrompt", { fg = c.mint, bg = bg_main })
hl("SnacksPickerTitle", { fg = c.mint, bg = bg_main, bold = true })
hl("SnacksPickerDirectory", { fg = c.blue, bold = true })
hl("SnacksPickerDir", { fg = c.blue, bold = true })
hl("SnacksPickerFile", { fg = c.fg })
hl("SnacksPickerTree", { fg = "#353555" })
hl("SnacksPickerSelected", { fg = c.mint, bg = c.bg_visual, bold = true })
hl("SnacksPickerMatch", { fg = c.orange, bold = true })

-- Snacks Picker & Explorer Git Status (matching VS Code sidebar)
hl("SnacksPickerGitStatus", { fg = c.fg_dark })
hl("SnacksPickerGitStatusAdded", { fg = c.lime, bold = true })             -- Added (Lime Green 'A')
hl("SnacksPickerGitStatusModified", { fg = c.blue, bold = true })          -- Modified (Sky Blue 'M')
hl("SnacksPickerGitStatusDeleted", { fg = c.red, bold = true })            -- Deleted (Rose Red 'D')
hl("SnacksPickerGitStatusUntracked", { fg = c.mint, bold = true })         -- Untracked (Mint Green 'U')
hl("SnacksPickerGitStatusStaged", { fg = "#c1ff38", bold = true })         -- Staged (Vibrant Lime 'S')
hl("SnacksPickerGitStatusUnmerged", { fg = "#ff5370", bold = true })       -- Conflict / Unmerged (Fiery Red 'C')
hl("SnacksPickerGitStatusRenamed", { fg = c.purple, bold = true })         -- Renamed (Purple 'R')
hl("SnacksPickerGitStatusCopied", { fg = c.gold, bold = true })            -- Copied (Gold 'C')
hl("SnacksPickerGitStatusIgnored", { fg = c.comment })                     -- Ignored (Dimmed Slate)
hl("SnacksPickerPathIgnored", { fg = c.comment })                          -- Ignored file in explorer
hl("SnacksPickerPathHidden", { fg = "#505070" })                           -- Hidden file in explorer

-- Mini.icons (Vibrant Material-style File Icon Colors)
hl("MiniIconsAzure", { fg = c.blue })      -- #6bc7f5 Sky Blue (TypeScript, Docker, CSS)
hl("MiniIconsBlue", { fg = "#519aba" })     -- #519aba Blue (React, Prisma, C++)
hl("MiniIconsCyan", { fg = c.mint })      -- #66eeaa Mint / Cyan (Go, Components, Markdown)
hl("MiniIconsGreen", { fg = c.lime })     -- #b4f09e Lime Green (Node, Public, Constants)
hl("MiniIconsGrey", { fg = c.fg_dark })    -- #8d8da8 Slate Grey (Build, Lockfiles, Info)
hl("MiniIconsOrange", { fg = c.orange })  -- #ff9d62 Warm Orange (Git, Rust, HTML, Svelte)
hl("MiniIconsPurple", { fg = c.purple })  -- #cfa3f5 Purple (API, GraphQL, Config)
hl("MiniIconsRed", { fg = c.red })        -- #ff385e Rose Red (Tests, Locks, Errors)
hl("MiniIconsYellow", { fg = c.gold })    -- #c7c56c Amber Gold (JS, Python, License, Env)
hl("SnacksDashboardHeader", { fg = c.mint, bold = true })
hl("SnacksDashboardDesc", { fg = c.fg_dark })
hl("SnacksDashboardIcon", { fg = c.blue })
hl("SnacksDashboardKey", { fg = c.orange, bold = true })
hl("SnacksIndent", { fg = c.border })
hl("SnacksIndentScope", { fg = c.mint })

-- Neo-tree (File Tree Sidebar)
hl("NeoTreeNormal", { fg = c.fg, bg = bg_main })
hl("NeoTreeNormalNC", { fg = c.fg, bg = bg_main })
hl("NeoTreeEndOfBuffer", { fg = c.border, bg = bg_main })
hl("NeoTreeDirectoryIcon", { fg = c.blue })
hl("NeoTreeDirectoryName", { fg = c.blue, bold = true })
hl("NeoTreeFileName", { fg = c.fg })
hl("NeoTreeFileIcon", { fg = c.fg_dark })
hl("NeoTreeRootName", { fg = c.mint, bold = true })
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
hl("TelescopePromptBorder", { fg = c.border_focus, bg = bg_main })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.mint, bold = true })
hl("TelescopeSelection", { fg = c.mint, bg = c.bg_visual, bold = true })

-- WhichKey
hl("WhichKey", { fg = c.mint })
hl("WhichKeyGroup", { fg = c.blue, bold = true })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.fg_muted })
hl("WhichKeyFloat", { bg = bg_float })

-- Bufferline
hl("BufferLineFill", { bg = c.bg_status })
hl("BufferLineBackground", { fg = c.fg_muted, bg = c.bg_status })
hl("BufferLineBufferSelected", { fg = c.mint, bg = c.bg, bold = true })
hl("BufferLineIndicatorSelected", { fg = c.mint, bg = c.bg })
hl("BufferLineSeparator", { fg = c.bg_status, bg = c.bg_status })

-- Cmp / Blink
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrDeprecated", { fg = c.fg_muted, strikethrough = true })
hl("CmpItemAbbrMatch", { fg = c.mint, bold = true })
hl("CmpItemKindFunction", { fg = c.blue })
hl("CmpItemKindMethod", { fg = c.blue })
hl("CmpItemKindVariable", { fg = c.mint })
hl("CmpItemKindKeyword", { fg = c.purple })
hl("CmpItemKindClass", { fg = c.gold })
hl("CmpItemKindInterface", { fg = c.gold })
hl("CmpItemKindProperty", { fg = c.mint })

-- DAP (Debug Adapter Protocol)
hl("DapBreakpoint", { fg = c.error, bold = true })
hl("DapBreakpointCondition", { fg = c.orange, bold = true })
hl("DapBreakpointRejected", { fg = c.fg_muted })
hl("DapLogPoint", { fg = c.mint })
hl("DapStopped", { fg = c.lime, bold = true })
hl("DapStoppedLine", { bg = c.bg_visual })

-- DBUI (Dadbod Database UI)
hl("dbui_tables", { fg = c.blue, bold = true })
hl("NotificationInfo", { fg = c.info })
hl("NotificationWarning", { fg = c.warn })
hl("NotificationError", { fg = c.error })
