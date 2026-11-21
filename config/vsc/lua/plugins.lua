-- ===================================================================
-- Terminal VS Code (vsc) - Curated Lightweight Plugin Suite
-- (Dark Magic Theme + Colorful Devicons + Auto-Pairs + Error Lens + LSP)
-- ===================================================================

local darkmagic_theme = {
  normal = {
    a = { bg = "#66eeaa", fg = "#07070f", gui = "bold" },
    b = { bg = "#17171f", fg = "#66eeaa" },
    c = { bg = "NONE", fg = "#bbccee" },
  },
  insert = {
    a = { bg = "#6bc7f5", fg = "#07070f", gui = "bold" },
    b = { bg = "#17171f", fg = "#6bc7f5" },
    c = { bg = "NONE", fg = "#bbccee" },
  },
  visual = {
    a = { bg = "#db6797", fg = "#07070f", gui = "bold" },
    b = { bg = "#17171f", fg = "#db6797" },
    c = { bg = "NONE", fg = "#bbccee" },
  },
  replace = {
    a = { bg = "#ff9d62", fg = "#07070f", gui = "bold" },
    b = { bg = "#17171f", fg = "#ff9d62" },
    c = { bg = "NONE", fg = "#bbccee" },
  },
  command = {
    a = { bg = "#cfa3f5", fg = "#07070f", gui = "bold" },
    b = { bg = "#17171f", fg = "#cfa3f5" },
    c = { bg = "NONE", fg = "#bbccee" },
  },
  inactive = {
    a = { bg = "NONE", fg = "#606085" },
    b = { bg = "NONE", fg = "#606085" },
    c = { bg = "NONE", fg = "#606085" },
  },
}

return {
  -- 1. Colorful & Big File Icons (nvim-web-devicons)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = {
      default = true,
      strict = true,
    },
  },

  -- 2. Auto-Closing Brackets, Quotes & Parentheses (nvim-autopairs)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
      check_ts = true,
    },
  },

  -- 3. Top Editor Tabs (Bufferline with Colorful Icons & Close Buttons)
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        mode = "buffers",
        always_show_bufferline = true,
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        show_buffer_icons = true,
        color_icons = true,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        show_buffer_close_icons = true,
        show_close_icon = false,
      },
    },
  },

  -- 4. Sleek Statusline (Lualine auto-adapting to active theme, NO Vim Mode indicator)
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        icons_enabled = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          {
            function()
              return "󰅪 MINIMAL"
            end,
            separator = { left = "", right = "" },
          },
        },
        lualine_b = {
          { "branch", icon = "󰊢" },
          { "diff" },
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_c = { { "filename", path = 1, file_status = true } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- 5. Snacks.nvim: Dashboard, Explorer Sidebar (Ctrl+B), Pickers & Terminal
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        width = 60,
        sections = function()
          local header = [[
███╗   ███╗ ██╗ ███╗   ██╗ ██╗ ███╗   ███╗  █████╗  ██╗     
████╗ ████║ ██║ ████╗  ██║ ██║ ████╗ ████║ ██╔══██╗ ██║     
██╔████╔██║ ██║ ██╔██╗ ██║ ██║ ██╔████╔██║ ███████║ ██║     
██║╚██╔╝██║ ██║ ██║╚██╗██║ ██║ ██║╚██╔╝██║ ██╔══██║ ██║     
██║ ╚═╝ ██║ ██║ ██║ ╚████║ ██║ ██║ ╚═╝ ██║ ██║  ██║ ███████╗
╚═╝     ╚═╝ ╚═╝ ╚═╝  ╚═══╝ ╚═╝ ╚═╝     ╚═╝ ╚═╝  ╚═╝ ╚══════╝

                       - by indiedev -
]]

          local items = {
            {
              icon = " ",
              key = "f",
              desc = "Open File (Ctrl+P)",
              action = function()
                local ok, snacks = pcall(require, "snacks")
                if ok and snacks.picker then snacks.picker.files() end
              end,
            },
            {
              icon = " ",
              key = "n",
              desc = "New File (Ctrl+N)",
              action = function()
                vim.cmd("enew")
                vim.cmd("startinsert")
              end,
            },
            {
              icon = "󰉎 ",
              key = "o",
              desc = "Open Folder (Ctrl+O)",
              action = function()
                if _G.OpenFolderPicker then
                  _G.OpenFolderPicker()
                else
                  pcall(require, "keymaps")
                  if _G.OpenFolderPicker then _G.OpenFolderPicker() end
                end
              end,
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Projects & Files",
              action = function()
                if _G.ShowRecentPicker then
                  _G.ShowRecentPicker()
                else
                  pcall(require, "recents")
                  if _G.ShowRecentPicker then _G.ShowRecentPicker() end
                end
              end,
            },
            {
              icon = " ",
              key = "c",
              desc = "Command Palette (Ctrl+Shift+P)",
              action = function()
                local ok, snacks = pcall(require, "snacks")
                if ok and snacks.picker then snacks.picker.commands() end
              end,
            },
            {
              icon = " ",
              key = "p",
              desc = "Color Theme (Ctrl+K Ctrl+T)",
              action = function()
                if _G.SelectThemePicker then
                  _G.SelectThemePicker()
                else
                  pcall(require, "theme")
                  if _G.SelectThemePicker then _G.SelectThemePicker() end
                end
              end,
            },
            {
              icon = " ",
              key = "t",
              desc = "Terminal (Ctrl+`)",
              action = function()
                local ok, snacks = pcall(require, "snacks")
                if ok and snacks.terminal then snacks.terminal() end
              end,
            },
            {
              icon = " ",
              key = "q",
              desc = "Quit Minimal (:q / Ctrl+Q)",
              action = function()
                if _G.SmartQuit then
                  _G.SmartQuit()
                else
                  vim.cmd("qa")
                end
              end,
            },
          }

          local box_w = 54
          local box_title = " Quick Actions "
          local top_line = "╭─" .. box_title .. string.rep("─", box_w - 3 - vim.api.nvim_strwidth(box_title)) .. "╮"
          local empty_line = "│" .. string.rep(" ", box_w - 2) .. "│"
          local bottom_line = "╰" .. string.rep("─", box_w - 2) .. "╯"

          local keys_section = {
            { text = top_line, align = "center", hl = "SnacksDashboardBorder" },
            { text = empty_line, align = "center", hl = "SnacksDashboardBorder" },
          }

          for _, it in ipairs(items) do
            local icon_w = vim.api.nvim_strwidth(it.icon .. " ")
            local d_w = vim.api.nvim_strwidth(it.desc)
            local k_w = vim.api.nvim_strwidth("[" .. it.key .. "]")
            local pad = box_w - 6 - icon_w - d_w - k_w
            if pad < 1 then pad = 1 end
            table.insert(keys_section, {
              text = {
                { "│  ", hl = "SnacksDashboardBorder" },
                { it.icon .. " ", hl = "SnacksDashboardIcon" },
                { it.desc .. string.rep(" ", pad), hl = "SnacksDashboardDesc" },
                { " [" .. it.key .. "] ", hl = "SnacksDashboardKey" },
                { "│", hl = "SnacksDashboardBorder" },
              },
              align = "center",
              key = it.key,
              action = it.action,
            })
          end
          table.insert(keys_section, { text = empty_line, align = "center", hl = "SnacksDashboardBorder" })
          table.insert(keys_section, { text = bottom_line, align = "center", hl = "SnacksDashboardBorder" })

          return {
            { text = header, hl = "SnacksDashboardHeader", align = "center", padding = 1 },
            keys_section,
            function()
              local stats = require("lazy.stats").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return {
                align = "center",
                padding = 1,
                text = {
                  { "⚡ Minimal loaded ", hl = "SnacksDashboardFooter" },
                  { tostring(stats.loaded) .. "/" .. tostring(stats.count), hl = "SnacksDashboardSpecial" },
                  { " plugins in ", hl = "SnacksDashboardFooter" },
                  { ms .. "ms", hl = "SnacksDashboardSpecial" },
                },
              }
            end,
          }
        end,
      },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 250 },
          easing = "outCubic",
        },
      },
      terminal = {
        shell = vim.o.shell,
        win = {
          position = "bottom",
          height = 0.35,
        },
      },
      picker = {
        icons = {
          git = {
            enabled = true,
            staged = "●",
            added = "✚ ",
            deleted = "✖ ",
            modified = "● ",
            renamed = "➜ ",
            untracked = "★ ",
            ignored = "◌ ",
          },
        },
        actions = {
          tab_fill_path = function(picker, item)
            item = item or picker:current()
            if not item then return end
            local path = item.file or (item.text and item.text:gsub("^%s+", "")) or ""
            if path == "" then return end
            if item.dir or vim.fn.isdirectory(path) == 1 then
              path = path:gsub("/+$", "") .. "/"
            end
            local rel = vim.fn.fnamemodify(path, ":~:.")
            if (item.dir or vim.fn.isdirectory(vim.fn.expand(path)) == 1) and not rel:match("/$") then
              rel = rel .. "/"
            end
            picker.input:set(rel)
            picker:find({ refresh = false })
            if picker.input and picker.input.win and picker.input.win:valid() then
              picker.input.win:focus()
              vim.cmd("startinsert!")
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<Tab>"] = { "tab_fill_path", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<Tab>"] = { "tab_fill_path", mode = { "n", "i", "x" } },
            },
          },
        },
        sources = {
          files = {
            hidden = false,
            ignored = false,
            exclude = {
              "node_modules",
              ".git",
              ".cache",
              ".local",
              "__pycache__",
              "dist",
              "build",
              "target",
              ".undo",
              "*.o",
              "*.bin",
              "*.dll",
              "*.exe",
            },
          },
          explorer = {
            git_status = true,
            git_status_open = true,
            git_untracked = true,
            auto_close = false,
            hidden = false,
            exclude = { ".git", "node_modules", ".cache", ".local" },
            win = {
              list = {
                keys = {
                  ["<Esc>"] = "close",
                  ["<C-b>"] = "close",
                  ["o"] = "confirm",
                  ["<CR>"] = "confirm",
                  ["<Right>"] = "confirm",
                  ["<Left>"] = "explorer_close",
                  ["<BS>"] = "explorer_up",
                  ["<Del>"] = "explorer_del",
                  ["<F2>"] = "explorer_rename",
                  ["a"] = "explorer_add",
                  ["A"] = "explorer_add",
                  ["r"] = "explorer_rename",
                  ["d"] = "explorer_del",
                },
              },
              input = {
                keys = {
                  ["<Esc>"] = "close",
                  ["<C-b>"] = "close",
                },
              },
            },
            formatters = {
              file = {
                filename_only = true,
                git_status_hl = true,
              },
            },
          },
          recent = {
            filter = {
              filter = function(item)
                local path = item.file or item.text or ""
                if path == "" then return false end
                local ignore = {
                  "/%.git/",
                  "/node_modules/",
                  "/%.local/",
                  "/%.cache/",
                  "/tmp/",
                  "/usr/",
                  "/etc/",
                  "/opt/",
                  "SilentSDDM",
                  "nvim%-config%-backup",
                  "nvram",
                  "snap/",
                  "%.shada",
                }
                for _, pat in ipairs(ignore) do
                  if path:find(pat) then return false end
                end
                return vim.fn.filereadable(path) == 1
              end,
            },
          },
        },
      },
      explorer = { enabled = true },
      indent = {
        enabled = true,
        priority = 1,
        char = "│",
        only_scope = false,
        only_current = false,
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
        },
      },
      scope = {
        enabled = true,
        priority = 200,
        char = "│",
        underline = false,
        only_current = false,
        hl = "SnacksIndentScope",
      },
    },
    config = function(_, opts)
      -- Vivid Git Status Colors for Sidebar & Explorer
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#e5c07b", bold = true })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#98c379", bold = true })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#98c379", bold = true })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted", { fg = "#e06c75", bold = true })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusStaged", { fg = "#61afef", bold = true })
      vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#5c6370" })

      -- Distinctive Dashboard Highlights (Minimal by indiedev)
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#cfa3f5", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardBorder", { fg = "#5c6370", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#6bc7f5" })
      vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#e6edf3" })
      vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#ff9d62", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#8b949e" })
      vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = "#b4f09e", bold = true })

      -- Indent Rainbow Highlight Colors (Modern & Vivid)
      vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#e06c75" }) -- Red / Coral
      vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#e5c07b" }) -- Gold / Yellow
      vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#98c379" }) -- Green
      vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#56b6c2" }) -- Cyan / Teal
      vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#61afef" }) -- Blue
      vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#c678dd" }) -- Purple
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#abb2bf", bold = true }) -- Active scope line

      require("snacks").setup(opts)
    end,
  },

  -- 6. Error Lens (Inline Diagnostics Badges & Background + Gutter Signs)
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach", "DiagnosticChanged" },
    opts = {
      preset = "modern",
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
      },
      options = {
        show_source = true,
        multilines = true,
        show_all_diags_on_cursorline = true,
      },
    },
    config = function(_, opts)
      vim.diagnostic.config({
        virtual_text = false, -- Handled by tiny-inline-diagnostic
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })
      require("tiny-inline-diagnostic").setup(opts)
    end,
  },

  -- 7. Auto-Suggestions: Blink.cmp (Fast Rust Completion) + English Dictionary + Snippets
  {
    "saghen/blink.cmp",
    version = "v0.*",
    dependencies = {
      "ribru17/blink-cmp-spell",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      enabled = function()
        return vim.bo.buftype == "" and vim.bo.modifiable
      end,
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.cancel()
              cmp.hide()
              return true
            end
            if _G.handle_escape then
              _G.handle_escape()
              return true
            end
          end,
          "fallback",
        },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-Space>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.hide()
              return true
            else
              cmp.show()
              return true
            end
          end,
          "fallback",
        },
      },
      completion = {
        accept = {
          dot_repeat = false, -- Disables Vim dot-repeat hack that injected '_' or 'a' or left characters!
        },
        list = {
          selection = {
            preselect = false, -- Don't automatically select the first suggestion
            auto_insert = false, -- Don't insert preview text until explicitly selected
          },
        },
        menu = {
          border = "rounded",
          scrollbar = false, -- Clean, modern popups without bulky scrollbar
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
            scrollbar = false, -- Clean documentation without bulky scrollbar
          },
        },
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer", "spell" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            score_offset = 100,
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 95,
            transform_items = function(ctx, items)
              local cursor_col = ctx.cursor[2]
              local line = ctx.line
              for _, item in ipairs(items) do
                if item.label == "!" and not item.textEdit then
                  local start_char = math.max(0, cursor_col - 1)
                  item.textEdit = {
                    range = {
                      start = { line = ctx.cursor[1] - 1, character = start_char },
                      ["end"] = { line = ctx.cursor[1] - 1, character = cursor_col },
                    },
                    newText = item.insertText or item.label,
                  }
                end
              end
              return items
            end,
            override = {
              get_trigger_characters = function(module)
                local triggers = module.get_trigger_characters and module:get_trigger_characters() or {}
                if not vim.tbl_contains(triggers, "!") then
                  table.insert(triggers, "!")
                end
                return triggers
              end,
            },
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = -10,
            opts = {
              enable_in_context = function() return true end,
            },
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 95,
            opts = {
              trailing_slash = true,
              label_trailing_slash = true,
              show_hidden_files_by_default = false,
              get_cwd = function(context)
                local buf = context.bufnr
                local name = vim.api.nvim_buf_get_name(buf)
                if name and name ~= "" then
                  return vim.fn.fnamemodify(name, ":p:h")
                end
                return vim.fn.getcwd()
              end,
            },
            override = {
              get_trigger_characters = function(module)
                local triggers = module.get_trigger_characters and module:get_trigger_characters() or {}
                for _, ch in ipairs({ "/", ".", "\\", "~", '"', "'" }) do
                  if not vim.tbl_contains(triggers, ch) then
                    table.insert(triggers, ch)
                  end
                end
                return triggers
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Patch blink.cmp keyword matching to include '!' (ASCII 33) so snippets like '!' show up instantly
      local ok_kw, kw = pcall(require, "blink.cmp.fuzzy.lua.keyword")
      if ok_kw and kw.with_constant_is_keyword then
        local orig = kw.with_constant_is_keyword
        kw.with_constant_is_keyword = function(cb)
          local existing = vim.opt.iskeyword
          vim.opt.iskeyword = "@,48-57,_,192-255,33"
          local ok, a, b = pcall(cb)
          vim.opt.iskeyword = existing
          if ok then return a, b end
          error(a)
        end
      end

      -- Subtle, beautiful scrollbar styling
      vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = "#3e4452" })
      vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { bg = "NONE" })

      require("blink.cmp").setup(opts)
    end,
  },

  -- 8. Multi-Cursor Editing (vim-visual-multi: Ctrl+D and Ctrl+Shift+L)
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Select All"] = "<C-S-l>",
        ["Add Cursor Down"] = "<C-A-Down>",
        ["Add Cursor Up"] = "<C-A-Up>",
        ["Select Cursor Down"] = "<M-S-Down>",
        ["Select Cursor Up"] = "<M-S-Up>",
        ["Select l"] = "",
        ["Select h"] = "",
        ["Select j"] = "",
        ["Select k"] = "",
      }
    end,
  },

  -- 9. Universal Commenting (Ctrl+/ single & multiline, Shift+Alt+A block comments like VS Code)
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
    init = function()
      local function ensure_commentstring()
        local cur_buf = vim.api.nvim_get_current_buf()
        local cs = vim.bo[cur_buf].commentstring
        if not cs or cs == "" then
          local ft = vim.bo[cur_buf].filetype
          if ft == "lua" then
            vim.bo[cur_buf].commentstring = "-- %s"
          elseif ft == "python" or ft == "sh" or ft == "bash" or ft == "yaml" or ft == "toml" then
            vim.bo[cur_buf].commentstring = "# %s"
          elseif ft == "html" or ft == "xml" or ft == "markdown" then
            vim.bo[cur_buf].commentstring = "<!-- %s -->"
          elseif ft == "css" then
            vim.bo[cur_buf].commentstring = "/* %s */"
          else
            vim.bo[cur_buf].commentstring = "// %s"
          end
        end
      end

      -- Line Comment Toggle (Ctrl+/)
      function _G.ToggleLineComment(mode)
        ensure_commentstring()
        if mode == "x" or mode == "s" then
          vim.cmd("normal! \x1b")
          local s_line = vim.fn.getpos("'<")[2]
          local e_line = vim.fn.getpos("'>")[2]
          if s_line > e_line then s_line, e_line = e_line, s_line end
          if s_line <= 0 then s_line = 1 end
          if e_line <= 0 then e_line = s_line end

          local cur_pos = vim.api.nvim_win_get_cursor(0)
          for line = s_line, e_line do
            vim.api.nvim_win_set_cursor(0, { line, 0 })
            pcall(vim.cmd, "normal gcc")
          end
          pcall(vim.api.nvim_win_set_cursor, 0, cur_pos)
          vim.cmd("normal! gv")
          if mode == "s" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
          end
        elseif mode == "i" then
          local cur_pos = vim.api.nvim_win_get_cursor(0)
          pcall(vim.cmd, "normal gcc")
          pcall(vim.api.nvim_win_set_cursor, 0, cur_pos)
          vim.cmd("startinsert")
        else
          pcall(vim.cmd, "normal gcc")
        end
      end

      -- Block Comment Toggle (Shift+Alt+A)
      function _G.ToggleBlockComment(mode)
        ensure_commentstring()
        local ft = vim.bo.filetype
        local left, right = "/*", "*/"
        if ft == "html" or ft == "xml" or ft == "markdown" then
          left, right = "<!--", "-->"
        elseif ft == "lua" then
          left, right = "--[[", "]]"
        elseif ft == "python" then
          left, right = '"""', '"""'
        end

        local s_line = vim.fn.line(".")
        local e_line = s_line
        if mode == "x" or mode == "s" then
          vim.cmd("normal! \x1b")
          s_line = vim.fn.getpos("'<")[2]
          e_line = vim.fn.getpos("'>")[2]
          if s_line > e_line then s_line, e_line = e_line, s_line end
        end

        if s_line <= 0 then s_line = 1 end
        if e_line <= 0 then e_line = s_line end

        local lines = vim.api.nvim_buf_get_lines(0, s_line - 1, e_line, false)
        if #lines == 0 then return end

        local first = lines[1]
        local last = lines[#lines]
        local p_left = vim.pesc(left)
        local p_right = vim.pesc(right)

        if first:match("^%s*" .. p_left) and last:match(p_right .. "%s*$") then
          lines[1] = first:gsub("^%s*" .. p_left .. "%s?", "")
          lines[#lines] = last:gsub("%s?" .. p_right .. "%s*$", "")
        else
          lines[1] = left .. " " .. lines[1]
          lines[#lines] = lines[#lines] .. " " .. right
        end

        vim.api.nvim_buf_set_lines(0, s_line - 1, e_line, false, lines)

        if mode == "x" or mode == "s" then
          vim.cmd("normal! gv")
          if mode == "s" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
          end
        elseif mode == "i" then
          vim.cmd("startinsert")
        end
      end

      -- Backward-compatibility bridge
      _G.ToggleComment = _G.ToggleLineComment

      local map = vim.keymap.set

      -- 1. Single-line & Multiline Line Comment Toggle (VS Code Ctrl+/ and macOS Cmd+/)
      local line_keys = { "<C-/>", "<C-_>", "<D-/>" }
      for _, key in ipairs(line_keys) do
        map("n", key, function() _G.ToggleLineComment("n") end, { desc = "Toggle Line Comment (Ctrl+/)" })
        map("i", key, function() _G.ToggleLineComment("i") end, { desc = "Toggle Line Comment (Ctrl+/)" })
        map("x", key, function() _G.ToggleLineComment("x") end, { desc = "Toggle Line Comment (Ctrl+/)" })
        map("s", key, function() _G.ToggleLineComment("s") end, { desc = "Toggle Line Comment (Ctrl+/)" })
      end

      -- 2. Block Comment Toggle (VS Code Shift+Alt+A / Option+Shift+A)
      local block_keys = { "<M-S-A>", "<M-S-a>", "<A-S-A>", "<A-S-a>", "<D-A-A>", "<D-A-a>" }
      for _, key in ipairs(block_keys) do
        map({ "n", "i", "x", "s" }, key, function() _G.ToggleBlockComment(vim.fn.mode()) end, { desc = "Toggle Block Comment (Shift+Alt+A)" })
      end
    end,
  },

  -- 10. Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "lua",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "markdown",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "rust",
        "yaml",
        "toml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- 11. Universal Code Formatter on Save (Conform: Auto-formats all kinds of files on Save / Ctrl+S)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        python = { "ruff_format", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
      },
    },
  },

  -- 12. Mason & LSP Setup (Go gopls, Emmet, Pyright, TS, HTML, CSS, JSON)
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUpdate" },
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = function()
      -- Only auto-install LSPs whose runtime dependencies exist on the host system.
      -- This prevents blocking "[mason-lspconfig] failed to install..." popups on fresh machines.
      local ensure = { "lua_ls" }
      local has_npm    = (vim.fn.executable("npm") == 1) or (vim.fn.executable("node") == 1)
      local has_go     = (vim.fn.executable("go") == 1)
      local has_cargo  = (vim.fn.executable("cargo") == 1) or (vim.fn.executable("rustc") == 1)
      local has_clang  = (vim.fn.executable("clang") == 1) or (vim.fn.executable("gcc") == 1)

      if has_npm then
        vim.list_extend(ensure, { "pyright", "ts_ls", "html", "cssls", "jsonls", "emmet_ls", "tailwindcss", "bashls", "yamlls" })
      end

      if has_go then
        table.insert(ensure, "gopls")
      end

      if has_cargo then
        table.insert(ensure, "rust_analyzer")
      end

      if has_clang then
        table.insert(ensure, "clangd")
      end

      local is_nvim_011 = (vim.fn.has("nvim-0.11") == 1)

      return {
        automatic_installation = false,
        ensure_installed = ensure,
        handlers = {
          function(server_name)
            local caps = {}
            local ok_blink, blink = pcall(require, "blink.cmp")
            if ok_blink then
              caps = blink.get_lsp_capabilities()
            end

            if is_nvim_011 then
              local cfg = { capabilities = caps }
              if server_name == "gopls" then
                cfg.settings = {
                  gopls = {
                    analyses = { unusedparams = true, shadow = true },
                    staticcheck = true,
                    gofumpt = true,
                    completeUnimported = true,
                    usePlaceholders = true,
                  },
                }
              end
              vim.lsp.config(server_name, cfg)
              vim.lsp.enable(server_name)
            else
              local ok, lspconfig = pcall(require, "lspconfig")
              if ok and lspconfig[server_name] then
                if server_name == "gopls" then
                  lspconfig.gopls.setup({
                    capabilities = caps,
                    settings = {
                      gopls = {
                        analyses = { unusedparams = true, shadow = true },
                        staticcheck = true,
                        gofumpt = true,
                        completeUnimported = true,
                        usePlaceholders = true,
                      },
                    },
                  })
                else
                  lspconfig[server_name].setup({ capabilities = caps })
                end
              end
            end
          end,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Attach to system-installed LSPs if available on PATH
      local is_nvim_011 = (vim.fn.has("nvim-0.11") == 1)
      local caps = {}
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        caps = blink.get_lsp_capabilities()
      end

      local common_servers = {
        "gopls", "pyright", "ts_ls", "lua_ls", "html", "cssls", "jsonls",
        "emmet_ls", "tailwindcss", "clangd", "rust_analyzer", "bashls", "yamlls"
      }

      if is_nvim_011 then
        for _, srv in ipairs(common_servers) do
          if vim.fn.executable(srv) == 1 then
            pcall(function()
              local cfg = { capabilities = caps }
              if srv == "gopls" then
                cfg.settings = {
                  gopls = {
                    analyses = { unusedparams = true, shadow = true },
                    staticcheck = true,
                    gofumpt = true,
                    completeUnimported = true,
                    usePlaceholders = true,
                  },
                }
              end
              vim.lsp.config(srv, cfg)
              vim.lsp.enable(srv)
            end)
          end
        end
      else
        local ok, lspconfig = pcall(require, "lspconfig")
        if not ok then return end
        for _, srv in ipairs(common_servers) do
          if vim.fn.executable(srv) == 1 and lspconfig[srv] then
            pcall(function()
              if srv == "gopls" then
                lspconfig.gopls.setup({
                  capabilities = caps,
                  settings = {
                    gopls = {
                      analyses = { unusedparams = true, shadow = true },
                      staticcheck = true,
                      gofumpt = true,
                      completeUnimported = true,
                      usePlaceholders = true,
                    },
                  },
                })
              else
                lspconfig[srv].setup({ capabilities = caps })
              end
            end)
          end
        end
      end
    end,
  },
}
