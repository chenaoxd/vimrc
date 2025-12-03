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
  "nvim-tree/nvim-web-devicons",
  "echasnovski/mini.nvim",
  "folke/snacks.nvim", -- Required for claudecode.nvim

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