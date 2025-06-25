-- Auto commands
local M = {}

local autocmd = vim.api.nvim_create_autocmd

-- jsonc support
autocmd("FileType", {
  pattern = "json",
  command = "syntax match Comment +\\/\\/.*$+"
})

-- File type associations
autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = "*.kt",
  command = "setlocal filetype=kotlin"
})

autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = "*.gradle",
  command = "setlocal filetype=groovy"
})

autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = "*.tsx",
  command = "setlocal filetype=typescriptreact"
})

autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = "*.jsx",
  command = "setlocal filetype=javascript.jsx"
})

autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = "*.ympl",
  command = "setlocal filetype=yaml"
})

autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = "Dockerfile.*",
  command = "setlocal filetype=dockerfile"
})

-- Filetype specific tab width
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
  json = 2,
}

for ft, tw in pairs(tab_width) do
  autocmd('FileType', {
    pattern = ft,
    callback = function()
      vim.bo.tabstop = tw
      vim.bo.shiftwidth = tw
      vim.bo.expandtab = true
    end,
  })
end

return M