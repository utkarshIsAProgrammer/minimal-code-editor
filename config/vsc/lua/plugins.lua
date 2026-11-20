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
            { icon = " ", key = "f", desc = "Find File (Ctrl+P)", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "n", desc = "New File (Ctrl+N)", action = ":ene | startinsert" },
            { icon = "󰉎 ", key = "o", desc = "Open Folder (Ctrl+O)", action = ":lua OpenFolderPicker()" },
            { icon = " ", key = "g", desc = "Find in Files (Ctrl+Shift+F)", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent Projects & Files", action = ":lua ShowRecentPicker()" },
            { icon = " ", key = "c", desc = "Command Palette (Ctrl+Shift+P)", action = ":lua Snacks.picker.commands()" },
            { icon = " ", key = "p", desc = "Color Theme (Ctrl+K Ctrl+T)", action = ":lua SelectThemePicker()" },
            { icon = " ", key = "t", desc = "Terminal (Ctrl+`)", action = ":lua Snacks.terminal()" },
            { icon = " ", key = "q", desc = "Quit Minimal (:q / Ctrl+Q)", action = ":lua SmartQuit()" },
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
        shell = "/bin/bash",
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

      require("snacks").setup(opts)
    end,
  },

  -- 6. Error Lens (Inline Diagnostics Badges & Background + Gutter Signs)
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    lazy = false,
    priority = 1000,
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
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = {
          function(cmp)
            local is_open = false
            local menu_ok, menu = pcall(require, "blink.cmp.completion.windows.menu")
            if (cmp.is_visible and cmp.is_visible()) or (menu_ok and menu and menu.win and menu.win:is_open()) then
              is_open = true
            end
            if vim.fn.pumvisible() == 1 then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n")
              return true
            end
            if is_open then
              vim.schedule(function()
                pcall(function()
                  if menu and menu.close then menu.close() end
                  local trigger = require("blink.cmp.completion.trigger")
                  if trigger and trigger.hide then trigger.hide() end
                  local list = require("blink.cmp.completion.list")
                  if list and list.hide then list.hide() end
                  local doc = require("blink.cmp.completion.windows.documentation")
                  if doc and doc.close then doc.close() end
                end)
              end)
              return true
            end
          end,
          "fallback",
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
      completion = {
        accept = {
          dot_repeat = false, -- Disables Vim dot-repeat hack that injected '_' or 'a' or left characters!
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

  -- 9. Universal Commenting (Ctrl+/ single & multiline like VS Code)
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {},
    config = function()
      require("Comment").setup()

      function _G.ToggleComment(mode)
        local cur_buf = vim.api.nvim_get_current_buf()
        if not vim.bo[cur_buf].commentstring or vim.bo[cur_buf].commentstring == "" then
          vim.bo[cur_buf].commentstring = "// %s"
        end

        if mode == "x" or mode == "s" then
          vim.cmd("normal! \27")
          local s_line = vim.fn.getpos("'<")[2]
          local e_line = vim.fn.getpos("'>")[2]
          if s_line > e_line then s_line, e_line = e_line, s_line end
          if s_line <= 0 then s_line = 1 end
          if e_line <= 0 then e_line = s_line end
          vim.cmd(string.format("%d,%dnormal gcc", s_line, e_line))
          vim.cmd("normal! gv")
          if mode == "s" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)
          end
        elseif mode == "i" then
          vim.cmd("normal gcc")
          vim.cmd("startinsert")
        else
          vim.cmd("normal gcc")
        end
      end

      local map = vim.keymap.set
      -- Single line comment toggle (Ctrl+/ and Ctrl+_)
      map("n", "<C-/>", function() _G.ToggleComment("n") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })
      map("n", "<C-_>", function() _G.ToggleComment("n") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })
      map("i", "<C-/>", function() _G.ToggleComment("i") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })
      map("i", "<C-_>", function() _G.ToggleComment("i") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })

      -- Multiline selection comment toggle (Visual & Select modes)
      map("x", "<C-/>", function() _G.ToggleComment("x") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })
      map("x", "<C-_>", function() _G.ToggleComment("x") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })
      map("s", "<C-/>", function() _G.ToggleComment("s") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })
      map("s", "<C-_>", function() _G.ToggleComment("s") end, { desc = "Toggle Comment (VS Code Ctrl+/)" })

      -- VS Code chord aliases (Ctrl+K Ctrl+C)
      map({ "n", "i", "x", "s" }, "<C-k><C-c>", function() _G.ToggleComment(vim.fn.mode()) end, { desc = "Toggle Comment (Ctrl+K Ctrl+C)" })
      map({ "n", "i", "x", "s" }, "<C-k><C-C>", function() _G.ToggleComment(vim.fn.mode()) end, { desc = "Toggle Comment (Ctrl+K Ctrl+C)" })
    end,
  },

  -- 10. Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = {
        "bash",
        "lua",
        "python",
        "javascript",
        "typescript",
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
    lazy = false,
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
    lazy = false,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        "gopls",
        "pyright",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "emmet_ls",
      },
      handlers = {
        function(server_name)
          local ok, lspconfig = pcall(require, "lspconfig")
          if ok and lspconfig[server_name] then
            local caps = {}
            local ok_blink, blink = pcall(require, "blink.cmp")
            if ok_blink then
              caps = blink.get_lsp_capabilities()
            end

            -- Special high-performance config for Go (gopls)
            if server_name == "gopls" then
              lspconfig.gopls.setup({
                capabilities = caps,
                settings = {
                  gopls = {
                    analyses = {
                      unusedparams = true,
                      shadow = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                    completeUnimported = true,
                    usePlaceholders = true,
                  },
                },
              })
              return
            end

            lspconfig[server_name].setup({
              capabilities = caps,
            })
          end
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
}
