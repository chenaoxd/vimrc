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
    "junegunn/fzf",
    build = ":call fzf#install()"
  },
  "junegunn/fzf.vim",
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

  -- Linting and formatting
  {
    "dense-analysis/ale",
    config = function()
      require("plugins.configs.ale")
    end
  },

  -- Git integration
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",
  "f-person/git-blame.nvim",

  -- Language support
  "groenewege/vim-less",
  "jceb/vim-orgmode",
  "tpope/vim-speeddating",
  "chr4/nginx.vim",
  "udalov/kotlin-vim",
  "yuezk/vim-js",
  "maxmellon/vim-jsx-pretty",
  "rust-lang/rust.vim",
  "pearofducks/ansible-vim",
  "cespare/vim-toml",
  "vmchale/dhall-vim",
  "craigmac/vim-mermaid",
  "leafOfTree/vim-vue-plugin",

  -- Debugging
  "sebdah/vim-delve",

  -- UI enhancements
  {
    "Yggdroot/indentLine",
    config = function()
      require("plugins.configs.ui")
    end
  },
  "pedrohdz/vim-yaml-folds",
  "vim-airline/vim-airline",
  "nvim-tree/nvim-web-devicons",
  "echasnovski/mini.nvim",

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

  -- Markdown support
  {
    "MeanderingProgrammer/render-markdown.nvim",
    config = function()
      require("plugins.configs.markdown")
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npx --yes yarn install"
  },

  -- Editor config
  "editorconfig/editorconfig-vim",

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
