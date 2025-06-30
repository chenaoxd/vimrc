-- Markdown related configuration
local M = {}

-- Markdown preview mappings
local map = vim.keymap.set
map('n', '<leader>mp', ":MarkdownPreview<cr>", {silent = true})
map('n', '<leader>ms', ":MarkdownPreviewStop<cr>", {silent = true})
map('n', '<leader>mt', ":MarkdownPreviewToggle<cr>", {silent = true})
map('i', '<C-e>', function()
  return '```\n```<Esc>O'
end, { expr = true, noremap = true, silent = true })

-- Render markdown setup
require("render-markdown").setup {
  enabled = true,
  max_file_size = 5.0,
  debounce = 100,
  file_types = { "markdown", "Avante" },
  render_modes = { 'n', 'v', 'c' },
  exclude = {
    buftypes = {},
  },
  anti_conceal = {
    enabled = true,
  },
  heading = {
    enabled = true,
    sign = true,
    position = 'overlay',
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    signs = { '󰫎 ' },
    width = 'full',
    left_pad = 0,
    right_pad = 0,
    min_width = 0,
    border = true,
    border_virtual = false,
    border_prefix = false,
    above = '▄',
    below = '▀',
    backgrounds = {
      'RenderMarkdownH1Bg',
      'RenderMarkdownH2Bg',
      'RenderMarkdownH3Bg',
      'RenderMarkdownH4Bg',
      'RenderMarkdownH5Bg',
      'RenderMarkdownH6Bg',
    },
    foregrounds = {
      'RenderMarkdownH1',
      'RenderMarkdownH2',
      'RenderMarkdownH3',
      'RenderMarkdownH4',
      'RenderMarkdownH5',
      'RenderMarkdownH6',
    },
  },
  code = {
    enabled = true,
    sign = false,
    style = 'full',
    position = 'left',
    language_pad = 0,
    language_name = true,
    disable_background = { 'diff' },
    width = 'full',
    left_pad = 0,
    right_pad = 0,
    min_width = 0,
    border = 'thin',
    above = '▄',
    below = '▀',
    highlight = 'RenderMarkdownCode',
    highlight_inline = 'RenderMarkdownCodeInline',
  },
  dash = {
    enabled = true,
    icon = '─',
    width = 'full',
    highlight = 'RenderMarkdownDash',
  },
  bullet = {
    enabled = true,
    icons = { '●', '○', '◆', '◇' },
    left_pad = 0,
    right_pad = 0,
    highlight = 'RenderMarkdownBullet',
  },
  checkbox = {
    enabled = true,
    position = 'inline',
    unchecked = {
      icon = '󰄱 ',
      highlight = 'RenderMarkdownUnchecked',
      scope_highlight = nil,
    },
    checked = {
      icon = '󰱒 ',
      highlight = 'RenderMarkdownChecked',
      scope_highlight = nil,
    },
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
    },
  },
  quote = {
    enabled = true,
    icon = '▋',
    repeat_linebreak = false,
    highlight = 'RenderMarkdownQuote',
  },
  pipe_table = {
    enabled = true,
    preset = 'round',
    style = 'full',
    cell = 'padded',
    min_width = 0,
    border = {
      '┌', '┬', '┐',
      '├', '┼', '┤',
      '└', '┴', '┘',
      '│', '─',
    },
    alignment_indicator = '━',
    head = 'RenderMarkdownTableHead',
    row = 'RenderMarkdownTableRow',
    filler = 'RenderMarkdownTableFill',
  },
  callout = {
    note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
    tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
    important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
    warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
    caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
    -- 自定义 obsidian callouts
    abstract = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo' },
    info = { raw = '[!INFO]', rendered = '󰋽 Info', highlight = 'RenderMarkdownInfo' },
    todo = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownWarn' },
    hint = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess' },
    success = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess' },
    question = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn' },
    failure = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError' },
    danger = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError' },
    bug = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError' },
    example = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint' },
    quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote' },
  },
}

return M