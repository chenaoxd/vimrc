local vimrc = vim.fn.stdpath("config") .. "/oldconf.vim"
vim.cmd.source(vimrc)

local map = vim.keymap.set

-- keymap for source init.lua
map('n', '<leader>sv', ":source $MYVIMRC<cr>", {silent = true})

-----------------------------------------------------------------------------
-- filetype configs
-----------------------------------------------------------------------------
local tab_width = {
  python = 4,
  markdown = 2,
  html = 2,
  javascript = 2,
  typescript = 2,
  typescriptreact = 2,
  go = 4,
  kotlin = 4,
  yaml = 2,
  Jenkinsfile = 2,
  sh = 2,
  scss = 2,
  proto = 2,
  vue = 2,
  lua = 2,
  css = 2,
  json = 2,
}

for ft, tw in pairs(tab_width) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = function()
      vim.bo.tabstop = tw
      vim.bo.shiftwidth = tw
      vim.bo.expandtab = true
    end,
  })
end

-----------------------------------------------------------------------------
-- nvim-tree configs 
-----------------------------------------------------------------------------
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup {
  sort_by = "case_sensitive",
  view = {
    width = 60,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false
      }
    }
  }
}
map('n', '<C-y>', ":NvimTreeToggle<cr>", {silent = true})
map('n', '<leader>tt', ":NvimTreeFindFile<cr>", {silent = true})

-----------------------------------------------------------------------------
-- telescope configs 
-----------------------------------------------------------------------------
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
  },
}

map('n', '<C-h>', ":Telescope find_files<cr>", {silent = true})
map('n', '<leader>fg', ":Telescope live_grep<cr>", {silent = true})
map('n', '<leader>fb', ":Telescope buffers<cr>", {silent = true})
map('n', '<leader>fh', ":Telescope help_tags<cr>", {silent = true})

-----------------------------------------------------------------------------
-- zbirenbaum/copilot settings
-----------------------------------------------------------------------------
-- require("copilot").setup {
--   panel = {
--     auto_refresh = true,
--   },
--   suggestion = {
--     auto_trigger = true,
--     keymap = {
--       accept = "<C-l>",
--       next = "<C-j>",
--       prev = "<C-k>",
--     }
--   },
--   filetypes = {
--     yaml = true,
--     markdown = true,
--   }
-- }

-----------------------------------------------------------------------------
-- iamcco/markdown-preview.nvim settings
-----------------------------------------------------------------------------
map('n', '<leader>mp', ":MarkdownPreview<cr>", {silent = true})
map('n', '<leader>ms', ":MarkdownPreviewStop<cr>", {silent = true})
map('n', '<leader>mt', ":MarkdownPreviewToggle<cr>", {silent = true})
map('i', '<C-e>', function()
  return '```\n```<Esc>O'
end, { expr = true, noremap = true, silent = true })

-----------------------------------------------------------------------------
-- yetone/avante.nvim settings
-----------------------------------------------------------------------------
-- require("avante_lib").load()
-- require("avante").setup {
--   provider = "copilot",
--   auto_suggestions_provider = "copilot",
--   copilot = {
--     model = "claude-3.5-sonnet",
--   },
-- }

-----------------------------------------------------------------------------
-- MeanderingProgrammer/render-markdown.nvim
-----------------------------------------------------------------------------
require("render-markdown").setup {
  file_types = { "markdown", "Avante" },
}
