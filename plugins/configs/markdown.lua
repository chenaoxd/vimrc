-- Markdown related configuration
local M = {}

-- Markdown preview mappings
local map = vim.keymap.set
map('n', '<leader>mp', ":MarkdownPreview<cr>", {silent = true})
map('n', '<leader>ms', ":MarkdownPreviewStop<cr>", {silent = true})
map('n', '<leader>mt', ":MarkdownPreviewToggle<cr>", {silent = true})
map('i', '<C-e>', function()
  return '```\n```<Esc>O'
end, { expr = true, noremap = true, silent = true })

-- Render markdown setup
require("render-markdown").setup {
  file_types = { "markdown", "Avante" },
}

return M