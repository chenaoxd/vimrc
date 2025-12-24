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
  },
})

-- Ensure DAP packages are installed
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  callback = function()
    vim.schedule(function()
      print("Mason tools installed")
    end)
  end,
})

local registry = require("mason-registry")
local function ensure_installed(packages)
  for _, name in ipairs(packages) do
    local ok, pkg = pcall(registry.get_package, name)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end

-- Note: Java tools (jdtls, java-debug-adapter, java-test) are managed by nvim-java plugin

-- Setup Mason LSPConfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
    "pyright",
    "ruff",  -- Python linting/formatting (fast, written in Rust)
    "gopls",
    -- jdtls is managed by nvim-java plugin
    "cssls",
    "jsonls",
    "tailwindcss",
    "eslint",
  },
  automatic_installation = true,
})

-- LSP keymaps
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', function()
    require('plugins.configs.lsp-hover-enhanced').show_enhanced_hover()
  end, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>La', vim.lsp.buf.code_action, opts)  -- 改成 La (LSP action), 避免和 <leader>l 窗口导航冲突
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

-- TypeScript/JavaScript (with React support)
vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
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

-- Python (Pyright for type checking + hover docs)
vim.lsp.config('pyright', {
  on_attach = on_attach,
  capabilities = capabilities,
  before_init = function(_, config)
    -- 自动检测项目中的 .venv 虚拟环境 (uv 默认使用 .venv)
    local cwd = config.root_dir or vim.fn.getcwd()
    local venv_path = cwd .. '/.venv'
    if vim.fn.isdirectory(venv_path) == 1 then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = venv_path .. '/bin/python'
      config.settings.python.venvPath = cwd
      config.settings.python.venv = '.venv'
      -- 添加 site-packages 到 extraPaths，确保可以跳转到库定义
      local site_packages = venv_path .. '/lib/python3.*/site-packages'
      local expanded = vim.fn.glob(site_packages, false, true)
      if #expanded > 0 then
        config.settings.python.analysis = config.settings.python.analysis or {}
        config.settings.python.analysis.extraPaths = expanded
      end
    end
  end,
  settings = {
    pyright = {
      -- 禁用 pyright 的 organizing imports，让 ruff 来处理
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        -- 降低诊断级别而不是完全忽略，保持跳转功能
        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues = "none",
          reportOptionalMemberAccess = "none",
          reportOptionalSubscript = "none",
          reportPrivateImportUsage = "none",
        },
      },
    },
  },
})

-- Python (Ruff for linting + formatting，比 flake8/black 快 10-100 倍)
vim.lsp.config('ruff', {
  on_attach = function(client, bufnr)
    -- 禁用 ruff 的 hover 功能，使用 pyright 的 hover（文档更详细）
    client.server_capabilities.hoverProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    settings = {
      -- Ruff 配置
      lineLength = 88,
      -- 选择启用的规则集
      lint = {
        select = {
          "E",   -- pycodestyle errors
          "F",   -- Pyflakes
          "I",   -- isort
          "UP",  -- pyupgrade
          "B",   -- flake8-bugbear
        },
        ignore = {
          "E402",   -- module level import not at top of file
          "I001",   -- import block is un-sorted or un-formatted
          "RUF001", -- ambiguous unicode character (中文逗号等)
          "RUF002", -- ambiguous unicode character in docstring
          "RUF003", -- ambiguous unicode character in comment
        },
      },
    },
  },
})

-- Go
vim.lsp.config('gopls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Java (jdtls) is configured by nvim-java plugin

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

-- ESLint (for React/JavaScript linting)
vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    -- Call the default on_attach first
    on_attach(client, bufnr)

    -- ESLint specific keymaps
    vim.keymap.set('n', '<leader>ef', function()
      vim.lsp.buf.execute_command({
        command = 'eslint.executeAutofix',
      })
    end, { buffer = bufnr, desc = 'ESLint: Fix all auto-fixable problems' })
  end,
  capabilities = capabilities,
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true
      }
    },
    codeActionOnSave = {
      enable = false,
      mode = "all"
    },
    experimental = {
      useFlatConfig = false
    },
    format = false,  -- 让 TypeScript 服务器处理格式化
    nodePath = "",
    onIgnoredFiles = "off",
    problems = {
      shortenToSingleLine = false
    },
    quiet = false,
    rulesCustomizations = {
      -- 避免与 TypeScript 服务器重复的规则
      ["@typescript-eslint/no-explicit-any"] = "off",
      ["@typescript-eslint/no-unused-vars"] = "off",
      ["@typescript-eslint/explicit-function-return-type"] = "off",
    },
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "location"
    }
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
    ['<C-b>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.scroll_docs(-4)
      else
        -- Emacs: move backward one character
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left>', true, false, true), 'n', false)
      end
    end, { 'i' }),
    ['<C-f>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.scroll_docs(4)
      else
        -- Emacs: move forward one character
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Right>', true, false, true), 'n', false)
      end
    end, { 'i' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        -- Emacs: move down one visual line (like gj)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>gj', true, false, true), 'n', false)
      end
    end, { 'i' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        -- Emacs: move up one visual line (like gk)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>gk', true, false, true), 'n', false)
      end
    end, { 'i' }),
    ['<C-Space>'] = cmp.mapping.complete(),
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

-- Enable all configured LSP servers (Neovim 0.11+ requires explicit enable)
-- Note: jdtls is enabled by nvim-java plugin
vim.lsp.enable({
  'lua_ls',
  'ts_ls',
  'rust_analyzer',
  'pyright',
  'ruff',
  'gopls',
  'cssls',
  'jsonls',
  'tailwindcss',
  'eslint',
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
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    format = function(diagnostic)
      local code = diagnostic.code or diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code
      if code then
        return string.format("%s [%s]", diagnostic.message, code)
      end
      return diagnostic.message
    end,
  },
})

return M
