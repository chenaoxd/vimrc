-- Telescope configuration
local M = {}

local map = vim.keymap.set

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
  },
}

-- Telescope key mappings
map('n', '<C-h>', ":Telescope find_files<cr>", {silent = true})
map('n', '<leader>fg', ":Telescope live_grep<cr>", {silent = true})
map('n', '<leader>fb', ":Telescope buffers<cr>", {silent = true})
map('n', '<leader>fh', ":Telescope help_tags<cr>", {silent = true})

return M