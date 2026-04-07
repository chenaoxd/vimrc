local M = {}

local function map(bufnr, modes, lhs, rhs, desc)
  vim.keymap.set(modes, lhs, rhs, {
    buffer = bufnr,
    silent = true,
    desc = desc,
  })
end

function M.on_attach(client, bufnr)
  map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map(bufnr, "n", "gd", vim.lsp.buf.definition, "Go to definition")
  map(bufnr, "n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map(bufnr, "n", "gr", vim.lsp.buf.references, "References")
  map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover")
  map(bufnr, "n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map(bufnr, "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map(bufnr, "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map(bufnr, "n", "<leader>wl", function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, "List workspace folders")
  map(bufnr, "n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
  map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map(bufnr, { "n", "v" }, "<leader>La", vim.lsp.buf.code_action, "Code action")
  map(bufnr, "n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format buffer")
  map(bufnr, "n", "[g", vim.diagnostic.goto_prev, "Previous diagnostic")
  map(bufnr, "n", "]g", vim.diagnostic.goto_next, "Next diagnostic")
  map(bufnr, "n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
  map(bufnr, "n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics to loclist")

  if client.server_capabilities.inlayHintProvider then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
  end
end

M.capabilities = require("blink.cmp").get_lsp_capabilities({
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
})

local function get_pyright_settings(root_dir)
  local settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues = "none",
          reportOptionalMemberAccess = "none",
          reportOptionalSubscript = "none",
          reportPrivateImportUsage = "none",
        },
      },
    },
  }

  if not root_dir or root_dir == "" then
    return settings
  end

  local venv_path = root_dir .. "/.venv"
  local python_path = venv_path .. "/bin/python"

  if vim.fn.executable(python_path) == 1 then
    settings.python.pythonPath = python_path
    settings.python.venvPath = root_dir
    settings.python.venv = ".venv"

    local site_packages = vim.fn.glob(venv_path .. "/lib/python*/site-packages", false, true)
    if #site_packages > 0 then
      settings.python.analysis.extraPaths = site_packages
    end
  end

  return settings
end

function M.setup()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "cssls",
      "eslint",
      "gopls",
      "jdtls",
      "jsonls",
      "lua_ls",
      "pyright",
      "ruff",
      "rust_analyzer",
      "tailwindcss",
      "ts_ls",
    },
    automatic_installation = true,
  })

  vim.lsp.config("lua_ls", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  vim.lsp.config("ts_ls", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    settings = {
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
    },
  })

  vim.lsp.config("rust_analyzer", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  })

  vim.lsp.config("pyright", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, {
        "pyproject.toml",
        "setup.py",
        "pyrightconfig.json",
        ".git",
      })
      if root then
        on_dir(root)
      end
    end,
    settings = get_pyright_settings(nil),
    before_init = function(_, config)
      config.settings = get_pyright_settings(config.root_dir)
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("config.lsp.pyright", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or client.name ~= "pyright" then
        return
      end

      client.settings = get_pyright_settings(client.root_dir)
      client:notify("workspace/didChangeConfiguration", {
        settings = client.settings,
      })
    end,
  })

  vim.lsp.config("ruff", {
    capabilities = M.capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      M.on_attach(client, bufnr)
    end,
    init_options = {
      settings = {
        lineLength = 120,
        lint = {
          select = { "E", "F", "I", "UP", "B" },
          ignore = {
            "E402",
            "I001",
            "RUF001",
            "RUF002",
            "RUF003",
          },
        },
      },
    },
  })

  vim.lsp.config("gopls", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  vim.lsp.config("cssls", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  vim.lsp.config("jsonls", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  vim.lsp.config("tailwindcss", {
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  vim.lsp.config("eslint", {
    capabilities = M.capabilities,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      map(bufnr, "n", "<leader>ef", function()
        vim.lsp.buf.execute_command({
          command = "eslint.executeAutofix",
        })
      end, "ESLint auto-fix")
    end,
    settings = {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = false,
        mode = "all",
      },
      experimental = {
        useFlatConfig = false,
      },
      format = false,
      onIgnoredFiles = "off",
      problems = {
        shortenToSingleLine = false,
      },
      quiet = false,
      rulesCustomizations = {
        ["@typescript-eslint/explicit-function-return-type"] = "off",
        ["@typescript-eslint/no-explicit-any"] = "off",
        ["@typescript-eslint/no-unused-vars"] = "off",
      },
      run = "onType",
      useESLintClass = false,
      validate = "on",
      workingDirectory = {
        mode = "location",
      },
    },
  })

  vim.lsp.enable({
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
    "pyright",
    "ruff",
    "gopls",
    "cssls",
    "jsonls",
    "tailwindcss",
    "eslint",
  })

  vim.diagnostic.config({
    virtual_text = {
      spacing = 2,
      source = "if_many",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "󰠠",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "if_many",
      header = "",
      prefix = "",
      format = function(diagnostic)
        local code = diagnostic.code
          or diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code

        if code then
          return string.format("%s [%s]", diagnostic.message, code)
        end

        return diagnostic.message
      end,
    },
  })
end

return M
