-- Java configuration via nvim-jdtls (clean, fast defaults)

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local jdtls_setup = require("jdtls.setup")

-- Prefer multi-module roots (settings.gradle or wrapper), then fall back to single-module markers
local root_dir = jdtls_setup.find_root({
  "settings.gradle.kts",
  "settings.gradle",
  "gradlew",
  "mvnw",
  ".mvn",
})
if not root_dir then
  root_dir = jdtls_setup.find_root({
    "build.gradle.kts",
    "build.gradle",
    "pom.xml",
  })
end
if not root_dir then
  root_dir = jdtls_setup.find_root({ ".git" })
end
if not root_dir then
  vim.notify("jdtls: Could not find project root", vim.log.levels.WARN)
  return
end

-- Unique workspace per project to avoid collisions
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local project_hash = vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "-" .. project_hash

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
  vim.notify("jdtls: Could not find launcher jar", vim.log.levels.ERROR)
  return
end

local lombok_jar = mason_path .. "/lombok.jar"

local uname = vim.loop.os_uname()
local machine = uname.machine or ""
local config_dir
if vim.fn.has("mac") == 1 then
  config_dir = mason_path .. (machine == "arm64" and "/config_mac_arm" or "/config_mac")
elseif vim.fn.has("unix") == 1 then
  config_dir = mason_path .. (machine == "aarch64" and "/config_linux_arm" or "/config_linux")
else
  config_dir = mason_path .. "/config_win"
end

local java_home = vim.env.JAVA_HOME
if not java_home or java_home == "" then
  for _, candidate in ipairs({
    "/usr/lib/jvm/java-21-openjdk",
    "/usr/lib/jvm/jdk21-openjdk",
    "/usr/lib/jvm/java-25-openjdk",
    "/usr/lib/jvm/jdk25-openjdk",
  }) do
    if vim.fn.executable(candidate .. "/bin/java") == 1 then
      java_home = candidate
      break
    end
  end
end

local function resolve_java_executable()
  if java_home and java_home ~= "" then
    local candidate = java_home .. "/bin/java"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  local exepath = vim.fn.exepath("java")
  if exepath ~= "" then
    return exepath
  end

  return nil
end

local function detect_java_major(java_executable)
  if not java_executable then
    return nil
  end

  local result = vim.system({ java_executable, "-version" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  local output = table.concat(vim.tbl_filter(function(part)
    return type(part) == "string" and part ~= ""
  end, { result.stdout, result.stderr }), "\n")

  local version = output:match('version%s+"(%d+)')
  if not version then
    version = output:match('version%s+"1%.(%d+)')
  end

  return tonumber(version)
end

local java_executable = resolve_java_executable()
local java_major = detect_java_major(java_executable)

if not java_major or java_major < 21 then
  local warn_key = ("jdtls-java-version:%s"):format(root_dir)
  vim.g._jdtls_java_requirement_warned = vim.g._jdtls_java_requirement_warned or {}

  if not vim.g._jdtls_java_requirement_warned[warn_key] then
    vim.g._jdtls_java_requirement_warned[warn_key] = true
    local found = java_major and ("Java " .. java_major) or "no usable Java runtime"
    local source = java_executable or "$JAVA_HOME/bin/java or PATH"

    vim.schedule(function()
      vim.notify(
        ("jdtls disabled for %s: Java 21+ is required, found %s at %s"):format(project_name, found, source),
        vim.log.levels.WARN
      )
    end)
  end

  return
end

local jdtls_executable = mason_path .. "/bin/jdtls"
if vim.fn.executable(jdtls_executable) ~= 1 then
  vim.notify("jdtls: Could not find Mason wrapper", vim.log.levels.ERROR)
  return
end

local cmd = {
  jdtls_executable,
  "--java-executable", java_executable,
  "--jvm-arg=-Dlog.level=WARNING",
  "--jvm-arg=-Xms256m",
  "--jvm-arg=-Xmx2g",
  "-data", workspace_dir,
}

if vim.loop.fs_stat(lombok_jar) then
  table.insert(cmd, 4, "--jvm-arg=-javaagent:" .. lombok_jar)
end

local gradle_home = vim.env.GRADLE_HOME
local gradle_snapshot_wrapper = false

local wrapper_props = root_dir .. "/gradle/wrapper/gradle-wrapper.properties"
if vim.loop.fs_stat(wrapper_props) then
  local ok_read, lines = pcall(vim.fn.readfile, wrapper_props)
  if ok_read then
    for _, line in ipairs(lines) do
      if line:match("^distributionUrl=") and line:find("distributions%-snapshots") then
        gradle_snapshot_wrapper = true
        break
      end
    end
  end
end

local gradle_available = gradle_home ~= nil and gradle_home ~= ""
local gradle_wrapper_enabled = not gradle_snapshot_wrapper
local gradle_enabled = gradle_wrapper_enabled or gradle_available

local settings = {
  java = {
    server = { launchMode = "Standard" },
    configuration = {
      updateBuildConfiguration = "interactive",
    },
    autobuild = { enabled = false },
    project = {
      resourceFilters = { "node_modules", "\\.git", "build", "target", "dist", "out", "\\.gradle" },
    },
    import = {
      projectSelection = "automatic",
      maven = {
        enabled = true,
        downloadSources = false,
      },
      gradle = {
        enabled = gradle_enabled,
        wrapper = { enabled = gradle_wrapper_enabled },
        home = gradle_available and gradle_home or nil,
        offline = { enabled = false },
        annotationProcessing = { enabled = false },
      },
    },
    eclipse = { downloadSources = false },
    maven = { downloadSources = false },
    contentProvider = { preferred = "fernflower" },
    completion = {
      favoriteStaticMembers = {
        "org.junit.jupiter.api.Assertions.*",
        "org.mockito.Mockito.*",
        "org.assertj.core.api.Assertions.*",
      },
      filteredTypes = {
        "com.sun.*",
        "io.micrometer.shaded.*",
        "java.awt.*",
        "jdk.*",
        "sun.*",
      },
    },
    inlayHints = {
      parameterNames = { enabled = "literals" },
    },
  },
}

if java_home and java_home ~= "" then
  settings.java.jdt = settings.java.jdt or {}
  settings.java.jdt.ls = settings.java.jdt.ls or {}
  settings.java.jdt.ls.java = { home = java_home }
end

settings.java.jdt = settings.java.jdt or {}
settings.java.jdt.ls = settings.java.jdt.ls or {}
settings.java.jdt.ls.lombokSupport = { enabled = true }

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function on_attach(_, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>La", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format { async = true }
  end, opts)

  vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)

  vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Organize imports" })
  vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { buffer = bufnr, desc = "Extract variable" })
  vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, { buffer = bufnr, desc = "Extract variable" })
  vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, { buffer = bufnr, desc = "Extract constant" })
  vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, { buffer = bufnr, desc = "Extract constant" })
  vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, { buffer = bufnr, desc = "Extract method" })
end

local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = capabilities,
  settings = settings,
  init_options = { bundles = {} },
  on_attach = on_attach,
}

jdtls.start_or_attach(config)
