-- Avante AI Assistant configuration
return {
  provider = "copilot",
  acp_providers = {
    ["claude-code"] = {
      command = "npx",
      args = { "@zed-industries/claude-code-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
      },
    },
  },
  behaviour = {
    auto_suggestions = true,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = true,
  },
  mappings = {
    ask = "<leader>aa",
    edit = "<leader>ae",
    refresh = "<leader>ar",
    toggle = {
      default = "<leader>at",
      debug = "<leader>ad",
      hint = "<leader>ah",
    },
    sidebar = {
      close = {"<Esc>", "q"},
      close_from_input = { normal = "<Esc>", insert = "<C-d>" },
    },
  },
  hints = { enabled = true },
  windows = {
    wrap = true,
    width = 30,
    sidebar_header = {
      align = "center",
      rounded = true,
    },
  },
  highlights = {
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  diff = {
    debug = false,
    autojump = true,
    list_opener = "copen",
  },
}
