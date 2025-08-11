-- ClaudeCode.nvim configuration
-- AI coding assistant integration for Neovim

local claudecode = require("claudecode")

claudecode.setup({
  -- Server Configuration
  port_range = { min = 10000, max = 65535 },
  auto_start = true,
  log_level = "info", -- "trace", "debug", "info", "warn", "error"
  terminal_cmd = nil, -- Custom terminal command (default: "claude")
                      -- For local installations: "~/.claude/local/claude"
                      -- For native binary: use output from 'which claude'

  -- Selection Tracking
  track_selection = true,
  visual_demotion_delay_ms = 50,

  -- Terminal Configuration
  terminal = {
    split_side = "right", -- "left" or "right"
    split_width_percentage = 0.30,
    provider = "auto", -- "auto", "snacks", "native", "external", or custom provider table
    auto_close = true,
    snacks_win_opts = {
      position = "float",
      width = 0.85,
      height = 0.85,
      border = "rounded",
      backdrop = 80,
      keys = {
        claude_hide = { "<Esc>", function(self) self:hide() end, mode = "t", desc = "Hide Claude" },
        claude_close = { "q", "close", mode = "n", desc = "Close Claude" },
      },
    },

    -- Provider-specific options
    provider_opts = {
      external_terminal_cmd = nil, -- Command template for external terminal provider (e.g., "alacritty -e %s")
    },
  },

  -- Diff Integration
  diff_opts = {
    auto_close_on_accept = true,
    vertical_split = true,
    open_in_current_tab = true,
    keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
  },
})

-- Additional configuration for floating window with custom keybindings
-- You can add this if you prefer a floating window approach:
--[[
claudecode.setup({
  terminal = {
    snacks_win_opts = {
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
      backdrop = 90,
      keys = {
        claude_hide_ctrl = { "<C-,>", function(self) self:hide() end, mode = "t", desc = "Hide (Ctrl+,)" },
        claude_hide_esc = { "<Esc>", function(self) self:hide() end, mode = "t", desc = "Hide (Esc)" },
      },
    },
  },
})
--]]

-- Set up statusline integration (optional)
vim.api.nvim_create_autocmd("User", {
  pattern = "ClaudeCodeStatusUpdate",
  callback = function()
    -- You can integrate with your statusline plugin here
    -- For example, with lualine or airline
  end,
})

-- Auto-save exclusion for diff buffers (if using auto-save plugins)
-- This prevents auto-save from immediately accepting Claude's diff suggestions
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function(ev)
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if bufname:match("%(proposed%)") or 
       bufname:match("%(NEW FILE %- proposed%)") or 
       bufname:match("%(New%)") then
      vim.b[ev.buf].auto_save_disabled = true
    end
  end,
})