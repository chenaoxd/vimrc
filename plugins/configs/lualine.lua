local M = {}

require("lualine").setup({
  options = {
    theme = "dracula",
    component_separators = "|",
    section_separators = "",
    globalstatus = true,
  },
  extensions = { "nvim-tree" },
})

return M
