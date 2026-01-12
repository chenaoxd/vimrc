-- Java specific configuration using nvim-jdtls
-- This file is loaded automatically for Java files

local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

-- Find project root (look for build.gradle.kts, build.gradle, pom.xml, or .git)
local root_markers = { 'build.gradle.kts', 'build.gradle', 'settings.gradle.kts', 'settings.gradle', 'pom.xml', '.git' }
local root_dir = jdtls_setup.find_root(root_markers)

if not root_dir then
  vim.notify("jdtls: Could not find project root", vim.log.levels.WARN)
  return
end

-- Create unique workspace directory per project
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.expand('~/.cache/jdtls-workspace/') .. project_name

-- Determine OS-specific config
local mason_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
local config_dir
if vim.fn.has('mac') == 1 then
  if vim.fn.system('uname -m'):gsub('%s+', '') == 'arm64' then
    config_dir = mason_path .. '/config_mac_arm'
  else
    config_dir = mason_path .. '/config_mac'
  end
elseif vim.fn.has('unix') == 1 then
  if vim.fn.system('uname -m'):gsub('%s+', '') == 'aarch64' then
    config_dir = mason_path .. '/config_linux_arm'
  else
    config_dir = mason_path .. '/config_linux'
  end
else
  config_dir = mason_path .. '/config_win'
end

-- Find the launcher jar
local launcher_jar = vim.fn.glob(mason_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher_jar == '' then
  vim.notify("jdtls: Could not find launcher jar", vim.log.levels.ERROR)
  return
end

-- Find lombok jar
local lombok_jar = mason_path .. '/lombok.jar'

-- Setup capabilities for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. lombok_jar,
    '-jar', launcher_jar,
    '-configuration', config_dir,
    '-data', workspace_dir,
  },

  root_dir = root_dir,
  capabilities = capabilities,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
          'org.assertj.core.api.Assertions.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        updateBuildConfiguration = 'automatic',
      },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDeccessors = true },
      inlayHints = {
        parameterNames = { enabled = 'all' },
      },
    },
  },

  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    -- Standard LSP keymaps
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
    vim.keymap.set({ 'n', 'v' }, '<leader>La', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Diagnostic keymaps
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)

    -- Java specific keymaps
    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, { buffer = bufnr, desc = 'Organize imports' })
    vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, { buffer = bufnr, desc = 'Extract variable' })
    vim.keymap.set('v', '<leader>jv', function() jdtls.extract_variable(true) end, { buffer = bufnr, desc = 'Extract variable' })
    vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, { buffer = bufnr, desc = 'Extract constant' })
    vim.keymap.set('v', '<leader>jc', function() jdtls.extract_constant(true) end, { buffer = bufnr, desc = 'Extract constant' })
    vim.keymap.set('v', '<leader>jm', function() jdtls.extract_method(true) end, { buffer = bufnr, desc = 'Extract method' })

    -- Notify that jdtls is attached
    vim.notify('jdtls attached to ' .. project_name, vim.log.levels.INFO)
  end,

  init_options = {
    bundles = {},
  },
}

-- Start jdtls
jdtls.start_or_attach(config)
