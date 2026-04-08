local function blink_fuzzy_lib_extension()
  local os = jit.os:lower()
  if os == "osx" or os == "mac" then
    return "dylib"
  end
  if os == "windows" then
    return "dll"
  end
  return "so"
end

local function has_blink_rust_fuzzy()
  local lib = vim.fn.stdpath("data")
    .. "/lazy/blink.cmp/target/release/libblink_cmp_fuzzy."
    .. blink_fuzzy_lib_extension()
  return vim.uv.fs_stat(lib) ~= nil
end

local blink_fuzzy = has_blink_rust_fuzzy()
    and {
      implementation = "prefer_rust",
      prebuilt_binaries = {
        download = false,
      },
    }
  or {
    implementation = "lua",
    prebuilt_binaries = {
      download = false,
    },
  }

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts_extend = { "sources.default" },
    opts = {
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },
      snippets = {
        preset = "luasnip",
      },
      completion = {
        menu = {
          auto_show = true,
          border = "rounded",
        },
        documentation = {
          auto_show = false,
          auto_show_delay_ms = 150,
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = { "buffer", "cmdline" },
      },
      fuzzy = blink_fuzzy,
      keymap = {
        preset = "default",
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-k>"] = false,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp").setup()
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
