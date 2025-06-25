-- UI and visual enhancements configuration
local M = {}

local map = vim.keymap.set

-- IndentLine settings
vim.g.indentLine_char = '│'
vim.g.indentLine_fileTypeExclude = {'markdown', 'json'}

-- GitGutter key mappings
map("n", "<Leader>gp", "<Plug>(GitGutterPreviewHunk)", { silent = true })
map("n", "<Leader>gu", "<Plug>(GitGutterUndoHunk)", { silent = true })
map("n", "<Leader>gs", "<Plug>(GitGutterStageHunk)", { silent = true })

-- fzf Rg command
vim.cmd([[
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.<q-args>, 1,
  \   fzf#vim#with_preview(), <bang>0)
]])

-- EditorConfig
vim.g.EditorConfig_disable_rules = {'max_line_length'}

return M