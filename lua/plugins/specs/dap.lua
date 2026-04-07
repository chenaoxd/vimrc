return {
  {
    "sebdah/vim-delve",
    ft = "go",
    cmd = {
      "DlvConnect",
      "DlvToggleBreakpoint",
      "DlvClearAll",
    },
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", desc = "Toggle breakpoint" },
      { "<leader>dB", desc = "Conditional breakpoint" },
      { "<leader>dc", desc = "Continue" },
      { "<leader>dn", desc = "Step over" },
      { "<leader>ds", desc = "Step into" },
      { "<leader>do", desc = "Step out" },
      { "<leader>dr", desc = "Restart" },
      { "<leader>dq", desc = "Terminate" },
      { "<leader>du", desc = "Toggle DAP UI" },
      { "<leader>de", mode = { "n", "v" }, desc = "Evaluate expression" },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        virt_text_pos = "eol",
      })

      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      local keymap_opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", keymap_opts, { desc = "Toggle breakpoint" }))
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, vim.tbl_extend("force", keymap_opts, { desc = "Conditional breakpoint" }))
      vim.keymap.set("n", "<leader>dc", dap.continue, vim.tbl_extend("force", keymap_opts, { desc = "Continue" }))
      vim.keymap.set("n", "<leader>dn", dap.step_over, vim.tbl_extend("force", keymap_opts, { desc = "Step over" }))
      vim.keymap.set("n", "<leader>ds", dap.step_into, vim.tbl_extend("force", keymap_opts, { desc = "Step into" }))
      vim.keymap.set("n", "<leader>do", dap.step_out, vim.tbl_extend("force", keymap_opts, { desc = "Step out" }))
      vim.keymap.set("n", "<leader>dr", dap.restart, vim.tbl_extend("force", keymap_opts, { desc = "Restart" }))
      vim.keymap.set("n", "<leader>dq", dap.terminate, vim.tbl_extend("force", keymap_opts, { desc = "Terminate" }))
      vim.keymap.set("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", keymap_opts, { desc = "Toggle DAP UI" }))
      vim.keymap.set("n", "<leader>de", dapui.eval, vim.tbl_extend("force", keymap_opts, { desc = "Evaluate expression" }))
      vim.keymap.set("v", "<leader>de", dapui.eval, vim.tbl_extend("force", keymap_opts, { desc = "Evaluate selection" }))
    end,
  },
}
