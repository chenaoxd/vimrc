-- UI and visual enhancements configuration
local M = {}

local map = vim.keymap.set

-- GitGutter key mappings
map("n", "<Leader>gp", "<Plug>(GitGutterPreviewHunk)", { silent = true })
map("n", "<Leader>gu", "<Plug>(GitGutterUndoHunk)", { silent = true })
map("n", "<Leader>gs", "<Plug>(GitGutterStageHunk)", { silent = true })

return M
