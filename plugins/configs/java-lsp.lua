-- Enhanced Java LSP configuration with Spring Boot and Lombok support
local M = {}

function M.setup(on_attach, capabilities)
  require('lspconfig').jdtls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = "JavaSE-21",
              path = "/opt/homebrew/opt/java",
              default = true,
            },
          }
        },
        compile = {
          nullAnalysis = {
            mode = "automatic",
          },
        },
        contentProvider = { preferred = "fernflower" },
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
          updateSnapshots = true,
        },
        gradle = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        format = {
          enabled = true,
          settings = {
            profile = "GoogleStyle",
          },
        },
        saveActions = {
          organizeImports = true,
        },
        -- Spring Boot specific settings
        boot = {
          validation = {
            enabled = true,
          },
        },
        -- Lombok support
        project = {
          sourcePaths = {},
        },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
          "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
          "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
          "org.springframework.boot.test.context.SpringBootTest.*",
        },
        importOrder = {
          "java",
          "javax", 
          "org",
          "com",
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
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
        generateComments = true,
      },
    },
    init_options = {
      extendedClientCapabilities = {
        progressReportProvider = true,
        classFileContentsSupport = true,
        generateToStringPromptSupport = true,
        hashCodeEqualsPromptSupport = true,
        advancedExtractRefactoringSupport = true,
        advancedOrganizeImportsSupport = true,
        generateConstructorsPromptSupport = true,
        generateDelegateMethodsPromptSupport = true,
        moveRefactoringSupport = true,
      },
    },
    -- File type associations for Spring Boot
    filetypes = { "java" },
    root_dir = function(fname)
      return vim.fs.root(fname, {
        'pom.xml',
        'build.gradle',
        'build.gradle.kts',
        '.git'
      }) or vim.fn.getcwd()
    end,
  })
end

return M
