local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add({
  extension = {
    gradle = "groovy",
    ympl = "yaml",
  },
  pattern = {
    ["Dockerfile%..*"] = "dockerfile",
  },
})

local general = augroup("config.general", { clear = true })

autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = general,
  command = "checktime",
})

autocmd("VimResized", {
  group = general,
  command = "tabdo wincmd =",
})

autocmd("FileType", {
  group = general,
  pattern = { "json", "jsonc" },
  callback = function()
    pcall(vim.cmd, "syntax match Comment +//.*$+")
  end,
})

autocmd("FileType", {
  group = general,
  pattern = "qf",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set("n", "<CR>", "<CR><cmd>cclose<CR>", opts)
    vim.keymap.set("n", "q", "<cmd>cclose<CR>", opts)
  end,
})

autocmd("FileType", {
  group = general,
  pattern = "snacks_terminal",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-q>", [[<C-\><C-n><C-w>h]], opts)
  end,
})

local tab_width = {
  css = 2,
  html = 2,
  javascript = 2,
  json = 2,
  lua = 2,
  markdown = 2,
  proto = 2,
  scss = 2,
  sh = 2,
  typescript = 2,
  typescriptreact = 2,
  vue = 2,
  yaml = 2,
}

local indentation = augroup("config.indentation", { clear = true })

for filetype, width in pairs(tab_width) do
  autocmd("FileType", {
    group = indentation,
    pattern = filetype,
    callback = function()
      vim.bo.shiftwidth = width
      vim.bo.softtabstop = width
      vim.bo.tabstop = width
      vim.bo.expandtab = true
    end,
  })
end
