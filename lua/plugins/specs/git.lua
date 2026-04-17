return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      preview_config = {
        border = "rounded",
      },
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      word_diff = false,
    },
    keys = {
      { "]c", "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
      { "[c", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
      { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
    },
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff explorer" },
      { "<leader>gh", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff with HEAD" },
    },
    opts = {},
    config = function(_, opts)
      require("config.codediff").setup(opts)
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
    },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = false,
          diffview = false,
        },
        mappings = {
          popup = {
            ["d"] = false,
          },
          status = {
            ["d"] = false,
            ["q"] = "Close",
          },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("plugins.neogit.status", { clear = true }),
        pattern = "NeogitStatus",
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "d", function()
              local line = vim.api.nvim_get_current_line()
              local commit = line:match("^%s*(%x%x%x%x%x%x%x+)%s")

              if commit then
                local ok = pcall(function()
                  vim.cmd("CodeDiff " .. commit .. "^ " .. commit)
                end)
                if not ok then
                  vim.notify("Could not show diff (possibly root commit)", vim.log.levels.WARN)
                end
                return
              end

              local filepath

              pcall(function()
                local status_buf = require("neogit.buffers.status")
                local inst = type(status_buf.instance) == "function" and status_buf.instance() or status_buf.instance
                if inst and inst.buffer and inst.buffer.ui then
                  local item = inst.buffer.ui:get_item_under_cursor()
                  if item then
                    filepath = item.absolute_path or item.escaped_path
                  end
                end
              end)

              if not filepath then
                local parsed = line:match("^%s+%S+%s+(.+)$")
                if parsed then
                  parsed = parsed:gsub("^%s+", ""):gsub("%s+$", "")
                  local git_root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
                  if git_root and vim.v.shell_error == 0 then
                    filepath = git_root .. "/" .. parsed
                  end
                end
              end

              if filepath and vim.fn.filereadable(filepath) == 1 then
                vim.cmd("tabnew " .. vim.fn.fnameescape(filepath))
                vim.cmd("CodeDiff file HEAD")
              elseif filepath then
                vim.notify("File deleted or not readable: " .. filepath, vim.log.levels.WARN)
              else
                vim.notify("No file or commit under cursor", vim.log.levels.WARN)
              end
            end, { buffer = true, desc = "Open diff in codediff" })
          end)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("plugins.neogit.log", { clear = true }),
        pattern = "NeogitLogView",
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "d", function()
              local commit

              pcall(function()
                local log_buf = require("neogit.buffers.log_view")
                local inst = type(log_buf.instance) == "function" and log_buf.instance() or log_buf.instance
                if inst and inst.buffer and inst.buffer.ui then
                  commit = inst.buffer.ui:get_commit_under_cursor()
                end
              end)

              if not commit then
                commit = vim.api.nvim_get_current_line():match("[%*|]%s*(%x+)%s")
              end

              if not commit then
                vim.notify("No commit under cursor", vim.log.levels.WARN)
                return
              end

              local ok, err = pcall(function()
                vim.cmd("CodeDiff " .. commit .. "^ " .. commit)
              end)

              if not ok then
                vim.notify("Could not show diff (possibly root commit): " .. tostring(err), vim.log.levels.WARN)
              end
            end, { buffer = true, desc = "Open commit diff in codediff" })
          end)
        end,
      })
    end,
  },
}
