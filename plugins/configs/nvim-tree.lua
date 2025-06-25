-- NvimTree configuration
local M = {}

local map = vim.keymap.set

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
  },
  -- Auto open when starting nvim with a directory
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
}

-- NvimTree key mappings
map('n', '<C-y>', ":NvimTreeToggle<cr>", {silent = true})
map('n', '<leader>tt', ":NvimTreeFindFile<cr>", {silent = true})

-- Auto open nvim-tree when starting with a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
      return
    end

    -- change to the directory
    vim.cmd.cd(data.file)

    -- open the tree
    require("nvim-tree.api").tree.open()
  end,
})

return M