-- NvimTree configuration
local M = {}

local map = vim.keymap.set

-- 自定义键位映射函数
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- 默认映射
  api.config.mappings.default_on_attach(bufnr)

  -- 自定义映射
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))                        -- l: 展开目录或打开文件
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory')) -- h: 收起目录
end

require("nvim-tree").setup {
  sort_by = "case_sensitive",
  on_attach = my_on_attach,
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