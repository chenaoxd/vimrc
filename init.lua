local vimrc = vim.fn.stdpath("config") .. "/oldconf.vim"
vim.cmd.source(vimrc)

local map = vim.keymap.set

-- keymap for source init.lua
map('n', '<leader>sv', ":source $MYVIMRC<cr>", {silent = true})

-----------------------------------------------------------------------------
-- filetype configs
-----------------------------------------------------------------------------
local tab_width = {
  python = 4,
  markdown = 2,
  html = 2,
  javascript = 2,
  typescript = 2,
  typescriptreact = 2,
  go = 4,
  kotlin = 4,
  yaml = 2,
  Jenkinsfile = 2,
  sh = 2,
  scss = 2,
  proto = 2,
  vue = 2,
  lua = 2,
  css = 2,
}

for filetype, width in pairs(tab_width) do
local function set_tab_width(filetype, tab_width)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetype,
    callback = function()
      vim.bo.tabstop = tab_width
      vim.bo.shiftwidth = tab_width
      vim.bo.expandtab = true
    end,
  })
end

  set_tab_width(filetype, width)
end

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
  }
})
map('n', '<C-y>', ":NvimTreeToggle<cr>", {silent = true})
map('n', '<leader>tt', ":NvimTreeFindFile<cr>", {silent = true})

-----------------------------------------------------------------------------
-- telescope configs 
-----------------------------------------------------------------------------
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      "node_modules"
    },
  },
}

map('n', '<C-h>', ":Telescope find_files<cr>", {silent = true})
map('n', '<leader>fg', ":Telescope live_grep<cr>", {silent = true})
map('n', '<leader>fb', ":Telescope buffers<cr>", {silent = true})
map('n', '<leader>fh', ":Telescope help_tags<cr>", {silent = true})

-----------------------------------------------------------------------------
-- zbirenbaum/copilot settings
-----------------------------------------------------------------------------
require("copilot").setup({
  panel = {
    auto_refresh = true,
  },
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<C-l>",
      next = "<C-j>",
      prev = "<C-k>",
    }
  },
  filetypes = {
    yaml = true,
    markdown = true,
  }
})

local chat = require("CopilotChat")
local select = require("CopilotChat.select")

-----------------------------------------------------------------------------
-- CopilotC-Nvim/CopilotChat settings
-----------------------------------------------------------------------------
chat.setup {
  debug = true, -- Enable debugging
  show_help = "yes",
  prompts = {
    Review = "Review the following code and provide concise suggestions.",
    Tests = "Briefly explain how the selected code works, then generate unit tests.",
    Refactor = "Refactor the code to improve clarity and readability.",
  },
  build = function()
    vim.notify("Please update the remote plugins by running".. 
      " ':UpdateRemotePlugins', then restart Neovim.")
  end,
  window = {
    layout = 'float',
    relative = 'editor',
    width = 0.8,
    height = 0.8,
  },
  event = "VeryLazy",
}

vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
    chat.ask(args.args, { selection = select.buffer })
end, { nargs = '*', range = true })
vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
    chat.ask(args.args, { selection = select.visual })
end, { nargs = '*', range = true })

map('v', '<leader>cce', "<cmd>CopilotChatExplain<cr>", {silent = true})
map('v', '<leader>cct', "<cmd>CopilotChatTests<cr>", {silent = true})
map('v', '<leader>ccx', ":CopilotChatFix<cr>", {silent = true})
map('v', '<leader>ccq', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    vim.cmd("CopilotChatVisual " .. input)
  end
end, {silent = true})
map('v', '<leader>ccb', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    vim.cmd("CopilotChatBuffer " .. input)
  end
end, {silent = true})
map("n", '<leader>cca', function()
  local input = vim.fn.input("Ask Copilot: ")
  if input ~= "" then
    vim.cmd("CopilotChat " .. input)
  end
end, {silent = true, desc = "CopilotChatVisual - Ask input"})
map('n', '<leader>cct', ":CopilotChatToggle<cr>", {silent = true})

-----------------------------------------------------------------------------
-- iamcco/markdown-preview.nvim settings
-----------------------------------------------------------------------------
map('n', '<leader>mp', ":MarkdownPreview<cr>", {silent = true})
map('n', '<leader>ms', ":MarkdownPreviewStop<cr>", {silent = true})
map('n', '<leader>mt', ":MarkdownPreviewToggle<cr>", {silent = true})
map('i', '<C-e>', function()
  return '```\n```<Esc>O'
end, { expr = true, noremap = true, silent = true })
