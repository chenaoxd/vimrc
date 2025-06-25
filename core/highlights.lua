-- Highlight and color settings
local M = {}

-- Set colorscheme
vim.cmd.colorscheme("molokai")

-- Custom highlights
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 236 })

-- gitgutter highlights
vim.api.nvim_set_hl(0, "GitGutterAdd", { ctermfg = "Green" })
vim.api.nvim_set_hl(0, "GitGutterDelete", { ctermfg = "Red" })
vim.api.nvim_set_hl(0, "GitGutterChange", { ctermfg = 214 })

-- CoC highlight
vim.api.nvim_set_hl(0, "CocMenuSel", { ctermbg = 239, bg = "#13354A" })

return M