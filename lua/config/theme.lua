local function apply_highlights()
  local hl = vim.api.nvim_set_hl
  local picker_line = "#2B3150"
  local picker_border = "#6272A4"
  local picker_title = "#8BE9FD"
  local picker_file = "#F8F8F2"
  local picker_dir = "#8BE9FD"
  local picker_dirpath = "#7AA2F7"
  local picker_hidden = "#C3CCEA"
  local picker_ignored = "#6B7394"
  local picker_tree = "#56607A"
  local blink_bg = "#2F3440"
  local blink_bg_alt = "#383E4A"
  local blink_fg = "#E6EDF7"
  local blink_border = "#6272A4"
  local blink_select = "#4C7AD9"
  local blink_select_fg = "#FFFFFF"

  hl(0, "Normal", { bg = "NONE" })
  hl(0, "NormalNC", { bg = "NONE" })
  hl(0, "SignColumn", { bg = "NONE" })
  hl(0, "EndOfBuffer", { bg = "NONE" })
  hl(0, "LineNr", { bg = "NONE" })
  hl(0, "CursorLineNr", { bg = "NONE" })
  hl(0, "FoldColumn", { bg = "NONE" })
  hl(0, "NormalFloat", { bg = "NONE" })
  hl(0, "FloatBorder", { bg = "NONE", fg = "#6272A4" })

  hl(0, "Pmenu", { bg = "#3E4452", fg = "#ABB2BF" })
  hl(0, "PmenuSel", { bg = "#528BFF", fg = "#FFFFFF", bold = true })
  hl(0, "PmenuSbar", { bg = "#5C6370" })
  hl(0, "PmenuThumb", { bg = "#ABB2BF" })

  hl(0, "BlinkCmpMenu", { bg = blink_bg, fg = blink_fg })
  hl(0, "BlinkCmpMenuBorder", { bg = blink_bg, fg = blink_border })
  hl(0, "BlinkCmpMenuSelection", { bg = blink_select, fg = blink_select_fg, bold = true })
  hl(0, "BlinkCmpScrollBarThumb", { bg = "#6B7488" })
  hl(0, "BlinkCmpScrollBarGutter", { bg = blink_bg_alt })
  hl(0, "BlinkCmpLabel", { bg = "NONE", fg = blink_fg })
  hl(0, "BlinkCmpLabelMatch", { bg = "NONE", fg = "#7AA2F7", bold = true })
  hl(0, "BlinkCmpLabelDeprecated", { bg = "NONE", fg = "#7F849C", strikethrough = true })
  hl(0, "BlinkCmpLabelDetail", { bg = "NONE", fg = "#C678DD", italic = true })
  hl(0, "BlinkCmpLabelDescription", { bg = "NONE", fg = "#9AA4BF" })
  hl(0, "BlinkCmpSource", { bg = "NONE", fg = "#8BE9FD", italic = true })
  hl(0, "BlinkCmpKind", { bg = "NONE", fg = "#ABB2BF" })
  hl(0, "BlinkCmpKindText", { bg = "NONE", fg = "#ABB2BF" })
  hl(0, "BlinkCmpKindMethod", { bg = "NONE", fg = "#C678DD" })
  hl(0, "BlinkCmpKindFunction", { bg = "NONE", fg = "#C678DD" })
  hl(0, "BlinkCmpKindConstructor", { bg = "NONE", fg = "#E06C75" })
  hl(0, "BlinkCmpKindField", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpKindVariable", { bg = "NONE", fg = "#E06C75" })
  hl(0, "BlinkCmpKindClass", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpKindInterface", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpKindModule", { bg = "NONE", fg = "#61AFEF" })
  hl(0, "BlinkCmpKindProperty", { bg = "NONE", fg = "#E06C75" })
  hl(0, "BlinkCmpKindUnit", { bg = "NONE", fg = "#98C379" })
  hl(0, "BlinkCmpKindValue", { bg = "NONE", fg = "#98C379" })
  hl(0, "BlinkCmpKindEnum", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpKindKeyword", { bg = "NONE", fg = "#C678DD" })
  hl(0, "BlinkCmpKindSnippet", { bg = "NONE", fg = "#56B6C2" })
  hl(0, "BlinkCmpKindColor", { bg = "NONE", fg = "#98C379" })
  hl(0, "BlinkCmpKindFile", { bg = "NONE", fg = "#ABB2BF" })
  hl(0, "BlinkCmpKindReference", { bg = "NONE", fg = "#ABB2BF" })
  hl(0, "BlinkCmpKindFolder", { bg = "NONE", fg = "#61AFEF" })
  hl(0, "BlinkCmpKindEnumMember", { bg = "NONE", fg = "#98C379" })
  hl(0, "BlinkCmpKindConstant", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpKindStruct", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpKindEvent", { bg = "NONE", fg = "#C678DD" })
  hl(0, "BlinkCmpKindOperator", { bg = "NONE", fg = "#56B6C2" })
  hl(0, "BlinkCmpKindTypeParameter", { bg = "NONE", fg = "#E5C07B" })
  hl(0, "BlinkCmpDoc", { bg = blink_bg, fg = blink_fg })
  hl(0, "BlinkCmpDocBorder", { bg = blink_bg, fg = blink_border })
  hl(0, "BlinkCmpSignatureHelp", { bg = blink_bg, fg = blink_fg })
  hl(0, "BlinkCmpSignatureHelpBorder", { bg = blink_bg, fg = blink_border })

  hl(0, "CmpItemMenu", { fg = "#C678DD", italic = true })
  hl(0, "CmpItemAbbr", { fg = "#ABB2BF" })
  hl(0, "CmpItemAbbrMatch", { fg = "#61AFEF", bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#61AFEF", bold = true })
  hl(0, "CmpItemKindText", { fg = "#ABB2BF" })
  hl(0, "CmpItemKindMethod", { fg = "#C678DD" })
  hl(0, "CmpItemKindFunction", { fg = "#C678DD" })
  hl(0, "CmpItemKindConstructor", { fg = "#E06C75" })
  hl(0, "CmpItemKindField", { fg = "#E5C07B" })
  hl(0, "CmpItemKindVariable", { fg = "#E06C75" })
  hl(0, "CmpItemKindClass", { fg = "#E5C07B" })
  hl(0, "CmpItemKindInterface", { fg = "#E5C07B" })
  hl(0, "CmpItemKindModule", { fg = "#61AFEF" })
  hl(0, "CmpItemKindProperty", { fg = "#E06C75" })
  hl(0, "CmpItemKindUnit", { fg = "#98C379" })
  hl(0, "CmpItemKindValue", { fg = "#98C379" })
  hl(0, "CmpItemKindEnum", { fg = "#E5C07B" })
  hl(0, "CmpItemKindKeyword", { fg = "#C678DD" })
  hl(0, "CmpItemKindSnippet", { fg = "#56B6C2" })
  hl(0, "CmpItemKindColor", { fg = "#98C379" })
  hl(0, "CmpItemKindFile", { fg = "#ABB2BF" })
  hl(0, "CmpItemKindReference", { fg = "#ABB2BF" })
  hl(0, "CmpItemKindFolder", { fg = "#61AFEF" })
  hl(0, "CmpItemKindEnumMember", { fg = "#98C379" })
  hl(0, "CmpItemKindConstant", { fg = "#E5C07B" })
  hl(0, "CmpItemKindStruct", { fg = "#E5C07B" })
  hl(0, "CmpItemKindEvent", { fg = "#C678DD" })
  hl(0, "CmpItemKindOperator", { fg = "#56B6C2" })
  hl(0, "CmpItemKindTypeParameter", { fg = "#E5C07B" })

  hl(0, "DiffAdd", { bg = "#2D3F34" })
  hl(0, "DiffDelete", { bg = "#4A2D2D" })
  hl(0, "DiffChange", { bg = "#2D324A" })
  hl(0, "DiffText", { bg = "#3E5C4A", bold = true })

  hl(0, "SnacksPicker", { bg = "NONE" })
  hl(0, "SnacksPickerBorder", { bg = "NONE", fg = picker_border })
  hl(0, "SnacksPickerTitle", { bg = "NONE", fg = picker_title, bold = true })
  hl(0, "SnacksPickerFooter", { bg = "NONE", fg = picker_dirpath })
  hl(0, "SnacksPickerCursorLine", { bg = picker_line })

  hl(0, "SnacksPickerList", { bg = "NONE" })
  hl(0, "SnacksPickerListBorder", { bg = "NONE", fg = picker_border })
  hl(0, "SnacksPickerListTitle", { bg = "NONE", fg = picker_title, bold = true })
  hl(0, "SnacksPickerListFooter", { bg = "NONE", fg = picker_dirpath })
  hl(0, "SnacksPickerListCursorLine", { bg = picker_line })

  hl(0, "SnacksPickerBox", { bg = "NONE" })
  hl(0, "SnacksPickerBoxBorder", { bg = "NONE", fg = picker_border })
  hl(0, "SnacksPickerBoxTitle", { bg = "NONE", fg = picker_title, bold = true })
  hl(0, "SnacksPickerBoxFooter", { bg = "NONE", fg = picker_dirpath })
  hl(0, "SnacksPickerInput", { bg = "NONE" })
  hl(0, "SnacksPickerInputBorder", { bg = "NONE", fg = picker_border })
  hl(0, "SnacksPickerInputTitle", { bg = "NONE", fg = picker_title, bold = true })
  hl(0, "SnacksPickerInputFooter", { bg = "NONE", fg = picker_dirpath })

  hl(0, "SnacksPickerPreview", { bg = "NONE" })
  hl(0, "SnacksPickerPreviewBorder", { bg = "NONE", fg = picker_border })
  hl(0, "SnacksPickerPreviewTitle", { bg = "NONE", fg = picker_title, bold = true })
  hl(0, "SnacksPickerPreviewFooter", { bg = "NONE", fg = picker_dirpath })
  hl(0, "SnacksPickerPreviewCursorLine", { bg = picker_line })

  hl(0, "SnacksPickerFile", { fg = picker_file })
  hl(0, "SnacksPickerDirectory", { fg = picker_dir, bold = true })
  hl(0, "SnacksPickerDir", { fg = picker_dirpath })
  hl(0, "SnacksPickerPathHidden", { fg = picker_hidden, italic = true })
  hl(0, "SnacksPickerPathIgnored", { fg = picker_ignored, italic = true })
  hl(0, "SnacksPickerTree", { fg = picker_tree })
end

apply_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("config.theme", { clear = true }),
  callback = apply_highlights,
})
