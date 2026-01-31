-- Plugin management with lazy.nvim
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Core dependencies
  "nvim-lua/plenary.nvim",

  -- File explorer and search
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.configs.telescope")
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.nvim-tree")
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("plugins.configs.treesitter")
    end
  },
  "nvim-treesitter/nvim-treesitter-textobjects",

  -- Git integration
  "airblade/vim-gitgutter",
  "f-person/git-blame.nvim",
  {
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff explorer" },
      { "<leader>gh", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff with HEAD" },
    },
    cmd = "CodeDiff",
    config = function()
      require("vscode-diff").setup({})
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = true,
          diffview = false, -- Using vscode-diff instead
        },
        mappings = {
          status = {
            ["q"] = "Close",
            ["d"] = false, -- Disable default, we'll use vscode-diff
          },
          popup = {
            ["d"] = false, -- Disable DiffPopup, we'll use vscode-diff
          },
        },
      })

      -- vscode-diff integration for neogit status view (handles both files and commits)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NeogitStatus",
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "d", function()
              local line = vim.api.nvim_get_current_line()

              -- Check if line is a commit (format: "abc1234 message" or " abc1234 message")
              local commit = line:match("^%s*(%x%x%x%x%x%x%x+)%s")
              if commit then
                -- It's a commit line - show commit diff
                local ok = pcall(function()
                  vim.cmd("CodeDiff " .. commit .. "^ " .. commit)
                end)
                if not ok then
                  vim.notify("Could not show diff (possibly root commit)", vim.log.levels.WARN)
                end
                return
              end

              -- Otherwise try to find file path
              local filepath = nil

              -- Try neogit's internal API (wrapped in pcall for safety)
              pcall(function()
                local status_buf = require("neogit.buffers.status")
                local inst = type(status_buf.instance) == "function" and status_buf.instance() or status_buf.instance
                if inst and inst.buffer and inst.buffer.ui then
                  local item = inst.buffer.ui:get_item_under_cursor()
                  if item then
                    filepath = item.absolute_path or item.escaped_path
                  end
                end
              end)

              -- Fallback: parse file path from line content
              if not filepath then
                -- Pattern: "  Modified   lua/foo.lua" or "  New file   src/bar.lua"
                local parsed = line:match("^%s+%S+%s+(.+)$")
                if parsed then
                  parsed = parsed:gsub("^%s+", ""):gsub("%s+$", "")
                  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
                  if git_root and vim.v.shell_error == 0 then
                    filepath = git_root .. "/" .. parsed
                  end
                end
              end

              if filepath and vim.fn.filereadable(filepath) == 1 then
                vim.cmd("tabnew " .. vim.fn.fnameescape(filepath))
                vim.cmd("CodeDiff file HEAD")
              elseif filepath then
                vim.notify("File deleted or not readable: " .. filepath, vim.log.levels.WARN)
              else
                vim.notify("No file or commit under cursor", vim.log.levels.WARN)
              end
            end, { buffer = true, desc = "Open diff in vscode-diff" })
          end)
        end,
      })

      -- vscode-diff integration for neogit log view (commit diffs)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NeogitLogView",
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "d", function()
            local commit = nil

            -- Try neogit's internal API first (wrapped in pcall for safety)
            pcall(function()
              local log_buf = require("neogit.buffers.log_view")
              local inst = type(log_buf.instance) == "function" and log_buf.instance() or log_buf.instance
              if inst and inst.buffer and inst.buffer.ui then
                commit = inst.buffer.ui:get_commit_under_cursor()
              end
            end)

            -- Fallback: parse commit hash from line (format: "* abc1234 ...")
            if not commit then
              local line = vim.api.nvim_get_current_line()
              commit = line:match("[%*|]%s*(%x+)%s")
            end

            if commit then
              -- Show diff between commit's parent and commit
              -- Use pcall to handle root commits (no parent)
              local ok, err = pcall(function()
                vim.cmd("CodeDiff " .. commit .. "^ " .. commit)
              end)
              if not ok then
                -- Might be root commit, try showing just the commit
                vim.notify("Could not show diff (possibly root commit): " .. tostring(err), vim.log.levels.WARN)
              end
            else
              vim.notify("No commit under cursor", vim.log.levels.WARN)
            end
          end, { buffer = true, desc = "Open commit diff in vscode-diff" })
          end)
        end,
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
    end,
  },

  -- Language support (only those not fully covered by standard Treesitter/LSP or with unique features)
  "jceb/vim-orgmode",
  "tpope/vim-speeddating",
  "pearofducks/ansible-vim",
  "craigmac/vim-mermaid",

  -- Java (nvim-jdtls for proper Gradle/Maven support)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- Debugging
  "sebdah/vim-delve",
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("plugins.configs.dap")
    end,
  },

  -- UI enhancements
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("plugins.configs.indent-blankline")
    end
  },
  "pedrohdz/vim-yaml-folds",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "thin",
        },
      })
      -- 快捷键
      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Close buffer" })
      vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
    end,
  },
  "nvim-tree/nvim-web-devicons",
  "echasnovski/mini.nvim",
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("snacks").setup({
        notifier = {
          enabled = true,
          timeout = 3000,
        },
      })
      -- LSP Progress notification
      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
          return 20
        end,
        open_mapping = nil,
        direction = "vertical",
        shade_terminals = false,
        persist_size = true,
        close_on_exit = true,
      })

      vim.keymap.set("n", "<Leader>tt", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle terminal (right)" })
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
      vim.keymap.set("t", "<C-q>", [[<C-\><C-n><C-W>h]], { desc = "Terminal: go left" })
    end,
  },

  -- Themes
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    priority = 1000,
    lazy = false,
    config = function()
      require("dracula").setup({
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true,
        -- use transparent background
        transparent_bg = true,
        -- set italic comment
        italic_comment = true,
      })
      vim.cmd[[colorscheme dracula]]
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
    init = function()
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
    end,
  },

  -- LSP and completion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugins.configs.lsp")
    end
  },

})
