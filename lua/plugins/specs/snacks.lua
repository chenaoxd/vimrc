local function has_executable(commands)
  commands = type(commands) == "table" and commands or { commands }
  for _, command in ipairs(commands) do
    if vim.fn.executable(command) == 1 then
      return true
    end
  end
  return false
end

local has_fd = has_executable({ "fd", "fdfind" })
local files_cmd = has_executable("rg") and "rg" or has_fd and "fd" or has_executable("find") and "find" or nil

local function open_files(opts)
  Snacks.picker.files(vim.tbl_deep_extend("force", {
    cmd = files_cmd,
  }, opts or {}))
end

local function open_explorer()
  if has_fd then
    return Snacks.explorer()
  end

  Snacks.notify.warn("`fd` is not installed. Falling back to sidebar file picker.")
  open_files({
    hidden = true,
    ignored = true,
    layout = {
      preset = "sidebar",
    },
  })
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = {
        enabled = has_fd,
        replace_netrw = has_fd,
        trash = true,
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = {
        enabled = true,
        ui_select = true,
        sources = {
          files = {
            cmd = files_cmd,
          },
          explorer = {
            auto_close = false,
            hidden = true,
            ignored = true,
            layout = {
              preset = "sidebar",
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      terminal = {
        enabled = true,
      },
      words = { enabled = true },
    },
    keys = {
      { "<C-h>", function() open_files() end, desc = "Find files" },
      { "<C-y>", open_explorer, desc = "File explorer" },
      { "<leader>ff", function() open_files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      {
        "<leader>tt",
        function()
          Snacks.terminal.toggle(nil, {
            win = {
              position = "right",
              width = 0.4,
            },
          })
        end,
        desc = "Toggle terminal",
      },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", {
            off = "light",
            on = "dark",
            name = "Dark Background",
          }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
        end,
      })
    end,
  },
}
