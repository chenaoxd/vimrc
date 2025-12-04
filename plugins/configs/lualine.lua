local M = {}

require("lualine").setup({
  options = {
    theme = "dracula",
    component_separators = "|",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_c = {
      { "filename", path = 1 },  -- 1=相对路径, 2=绝对路径
    },
  },
  extensions = { "nvim-tree" },
})

return M
