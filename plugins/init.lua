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
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true,
          telescope = true,
        },
        mappings = {
          status = {
            ["q"] = "Close",
          },
        },
      })
      -- Keymaps
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
      vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
      vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
      vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })
    end,
  },

  -- Language support (only those not fully covered by standard Treesitter/LSP or with unique features)
  "jceb/vim-orgmode",
  "tpope/vim-speeddating",
  "pearofducks/ansible-vim",
  "craigmac/vim-mermaid",

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

  -- Java support (nvim-java 4.0.0+)
  {
    "nvim-java/nvim-java",
    config = function()
      require("java").setup({
        checks = {
          nvim_version = true,
          nvim_jdtls_conflict = true,
        },
        jdtls = {
          version = "1.43.0",
          -- jdtls settings for better Gradle support
          settings = {
            java = {
              -- Gradle import settings
              import = {
                gradle = {
                  enabled = true,
                  wrapper = {
                    enabled = true,
                  },
                  -- Use Gradle for building instead of Eclipse internal builder
                  buildServer = {
                    enabled = true,
                  },
                },
              },
              -- Enable annotation processing for Lombok etc.
              eclipse = {
                downloadSources = true,
              },
              maven = {
                downloadSources = true,
              },
              autobuild = {
                enabled = true,
              },
            },
          },
        },
        lombok = {
          enable = true,
          version = "1.18.40",
        },
        java_test = {
          enable = true,
          version = "0.40.1",
        },
        java_debug_adapter = {
          enable = true,
          version = "0.58.2",
        },
        spring_boot_tools = {
          enable = true,
          version = "1.55.1",
        },
        jdk = {
          auto_install = true,
          -- nvim-java only supports JDK 17 for auto_install
          -- jdtls will use system Java 21 if available via JAVA_HOME
          version = "17",
        },
        log = {
          use_console = true,
          use_file = true,
          level = "info",
          log_file = vim.fn.stdpath("state") .. "/nvim-java.log",
          max_lines = 1000,
          show_location = false,
        },
      })
      vim.lsp.enable("jdtls")

      -- Java LSP keymaps (on LspAttach for jdtls)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local opts = { buffer = args.buf, silent = true }
            -- LSP navigation
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', function()
              require('plugins.configs.lsp-hover-enhanced').show_enhanced_hover()
            end, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>La', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
            -- Diagnostic keymaps
            vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
          end
        end,
      })

      -- Java specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local opts = { buffer = true, silent = true }

          -- Build
          vim.keymap.set("n", "<leader>jbb", "<cmd>JavaBuildBuildWorkspace<cr>", vim.tbl_extend("force", opts, { desc = "Java: Build workspace" }))
          vim.keymap.set("n", "<leader>jbc", "<cmd>JavaBuildCleanWorkspace<cr>", vim.tbl_extend("force", opts, { desc = "Java: Clean workspace" }))

          -- Runner
          vim.keymap.set("n", "<leader>jr", "<cmd>JavaRunnerRunMain<cr>", vim.tbl_extend("force", opts, { desc = "Java: Run main" }))
          vim.keymap.set("n", "<F5>", "<cmd>JavaRunnerRunMain<cr>", vim.tbl_extend("force", opts, { desc = "Java: Run main" }))
          vim.keymap.set("n", "<leader>js", "<cmd>JavaRunnerStopMain<cr>", vim.tbl_extend("force", opts, { desc = "Java: Stop main" }))
          vim.keymap.set("n", "<S-F5>", "<cmd>JavaRunnerStopMain<cr>", vim.tbl_extend("force", opts, { desc = "Java: Stop main" }))
          vim.keymap.set("n", "<leader>jl", "<cmd>JavaRunnerToggleLogs<cr>", vim.tbl_extend("force", opts, { desc = "Java: Toggle logs" }))

          -- DAP
          vim.keymap.set("n", "<leader>jdc", "<cmd>JavaDapConfig<cr>", vim.tbl_extend("force", opts, { desc = "Java: Configure DAP" }))

          -- Test
          vim.keymap.set("n", "<leader>jtc", "<cmd>JavaTestRunCurrentClass<cr>", vim.tbl_extend("force", opts, { desc = "Java: Test class" }))
          vim.keymap.set("n", "<leader>jtC", "<cmd>JavaTestDebugCurrentClass<cr>", vim.tbl_extend("force", opts, { desc = "Java: Debug test class" }))
          vim.keymap.set("n", "<leader>jtm", "<cmd>JavaTestRunCurrentMethod<cr>", vim.tbl_extend("force", opts, { desc = "Java: Test method" }))
          vim.keymap.set("n", "<leader>jtM", "<cmd>JavaTestDebugCurrentMethod<cr>", vim.tbl_extend("force", opts, { desc = "Java: Debug test method" }))
          vim.keymap.set("n", "<leader>jtr", "<cmd>JavaTestViewLastReport<cr>", vim.tbl_extend("force", opts, { desc = "Java: View test report" }))

          -- Profile
          vim.keymap.set("n", "<leader>jp", "<cmd>JavaProfile<cr>", vim.tbl_extend("force", opts, { desc = "Java: Profiles UI" }))

          -- Refactor
          vim.keymap.set({ "n", "v" }, "<leader>jrv", "<cmd>JavaRefactorExtractVariable<cr>", vim.tbl_extend("force", opts, { desc = "Java: Extract variable" }))
          vim.keymap.set({ "n", "v" }, "<leader>jrV", "<cmd>JavaRefactorExtractVariableAllOccurrence<cr>", vim.tbl_extend("force", opts, { desc = "Java: Extract variable (all)" }))
          vim.keymap.set({ "n", "v" }, "<leader>jrc", "<cmd>JavaRefactorExtractConstant<cr>", vim.tbl_extend("force", opts, { desc = "Java: Extract constant" }))
          vim.keymap.set({ "n", "v" }, "<leader>jrm", "<cmd>JavaRefactorExtractMethod<cr>", vim.tbl_extend("force", opts, { desc = "Java: Extract method" }))
          vim.keymap.set({ "n", "v" }, "<leader>jrf", "<cmd>JavaRefactorExtractField<cr>", vim.tbl_extend("force", opts, { desc = "Java: Extract field" }))

          -- Settings
          vim.keymap.set("n", "<leader>jsr", "<cmd>JavaSettingsChangeRuntime<cr>", vim.tbl_extend("force", opts, { desc = "Java: Change runtime" }))
        end,
      })
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

  -- AI Completion
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          auto_refresh = true,
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
            next = "<C-j>",
            prev = "<C-k>",
          }
        },
        filetypes = {
          yaml = true,
          markdown = true,
        },
      })
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