-- LSP Configuration
local M = {}

-- Setup Mason
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Setup Mason LSPConfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
    "pyright",
    "gopls",
    "jdtls",
    "cssls",
    "jsonls",
    "tailwindcss",
    "volar",
  },
  automatic_installation = true,
})

-- LSP keymaps
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }
  
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  -- Diagnostic keymaps
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
end

-- Completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure individual LSP servers using vim.lsp.config (Neovim 0.11+)

-- Lua
vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
          [vim.fn.expand("/usr/share/nvim/runtime/lua")] = true
        }
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- TypeScript/JavaScript
vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Rust
vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})

-- Python
vim.lsp.config('pyright', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Go
vim.lsp.config('gopls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Java (with Spring Boot and Lombok support)
require('plugins.configs.java-lsp').setup(on_attach, capabilities)

-- CSS
vim.lsp.config('cssls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- JSON
vim.lsp.config('jsonls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Tailwind CSS
vim.lsp.config('tailwindcss', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Vue
vim.lsp.config('volar', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Completion setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
    }),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Command line completion
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Auto-close quickfix when selecting an item
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>:cclose<CR>', { buffer = true, silent = true })
  end,
})

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})


return M
