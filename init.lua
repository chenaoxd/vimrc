local vimrc = vim.fn.stdpath("config") .. "/oldconf.vim"
vim.cmd.source(vimrc)

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
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.keymap.set('n', '<C-y>', ":NvimTreeToggle<cr>", {silent = true})

-----------------------------------------------------------------------------
-- telescope configs 
-----------------------------------------------------------------------------
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-h>', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})