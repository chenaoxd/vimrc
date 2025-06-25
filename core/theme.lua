-- Theme and UI highlight settings
local M = {}

-- Set colorscheme
vim.cmd.colorscheme("dracula")

-- Completion menu highlights
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C678DD", italic = true })
vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#ABB2BF" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#61AFEF", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#61AFEF", bold = true })

-- Completion item kinds
vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#ABB2BF" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#56B6C2" })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#ABB2BF" })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#ABB2BF" })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#56B6C2" })
vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#E5C07B" })

-- Popup menu background with better contrast
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#3E4452", fg = "#ABB2BF" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#528BFF", fg = "#FFFFFF", bold = true })
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#5C6370" })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#ABB2BF" })

-- Transparent background settings
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })

return M
