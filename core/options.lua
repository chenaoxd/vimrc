-- Core vim options
local M = {}

local opt = vim.opt

-- Basic editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Editor behavior
opt.autoindent = true
opt.autoread = true
opt.number = true
opt.ignorecase = true
opt.smartcase = true
opt.hidden = true
opt.incsearch = true
opt.cursorline = true

-- Code folding
opt.foldmethod = "syntax"
opt.foldnestmax = 10
opt.foldenable = false
opt.foldlevel = 2
opt.formatoptions:remove({ "t", "c" })

-- UI enhancements
opt.list = true
opt.listchars = { tab = "│ " }
opt.updatetime = 300
opt.termguicolors = true

-- Disable netrw (we use nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key
vim.g.mapleader = " "

return M