-- ALE configuration
local M = {}

local map = vim.keymap.set

-- ALE settings
vim.g.ale_linters_explicit = 1
vim.g.ale_linters = {
  go = {'golangci-lint'},
  python = {'ruff'},
  css = {'stylelint'},
  javascript = {'eslint'},
  typescript = {'eslint'},
  typescriptreact = {'eslint'},
}

vim.g.ale_go_golangci_lint_options = ''
vim.g.ale_go_golangci_lint_package = 1
vim.g.ale_sign_error = '✘'
vim.g.ale_sign_warning = '⚠'

vim.g.ale_fixers = {
  python = {'ruff', 'ruff_format'},
  go = {'gofmt'},
  rust = {'rustfmt'},
  kotlin = {'ktlint'},
  javascript = {'prettier'},
  typescript = {'prettier'},
  typescriptreact = {'prettier'},
  css = {'prettier'},
  vue = {'prettier'},
  sh = {'shfmt'},
}
vim.g.ale_fix_on_save = 1

-- ALE key mappings
map("n", "<Leader>ay", ":let b:ale_fix_on_save=1<cr>", { silent = true })
map("n", "<Leader>an", ":let b:ale_fix_on_save=0<cr>", { silent = true })
map("n", "<Leader>af", ":ALEFix<cr>", { silent = true })
map("n", "<C-k>", "<Plug>(ale_previous_wrap)", { silent = true })
map("n", "<C-j>", "<Plug>(ale_next_wrap)", { silent = true })

return M