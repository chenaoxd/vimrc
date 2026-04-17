local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local lsp = require("config.lsp")
local jdtls_setup = require("jdtls.setup")

local function read_cache(name)
  local value = vim.g[name]
  return type(value) == "table" and value or {}
end

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
  vim.notify("jdtls: Could not find Gradle/Maven project root", vim.log.levels.WARN)
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":t")
local project_hash = vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = vim.fn.stdpath("state") .. "/jdtls/" .. project_name .. "-" .. project_hash

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local lombok_jar = mason_path .. "/lombok.jar"
local jdtls_executable = mason_path .. "/bin/jdtls"

if vim.fn.executable(jdtls_executable) ~= 1 then
  vim.notify("jdtls: Could not find Mason wrapper", vim.log.levels.ERROR)
  return
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

local runtime_cache = read_cache("_jdtls_runtime_cache")
local java_home_cache_key = java_home or "<unset>"
local runtime = runtime_cache[java_home_cache_key]

if not runtime then
  local java_executable = resolve_java_executable()
  runtime = {
    executable = java_executable,
    major = detect_java_major(java_executable),
    home = java_home,
  }
  runtime_cache[java_home_cache_key] = runtime
  vim.g._jdtls_runtime_cache = runtime_cache
end

local java_executable = runtime.executable
local java_major = runtime.major
java_home = runtime.home

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

local cmd = {
  jdtls_executable,
  "--java-executable",
  java_executable,
  "--jvm-arg=-Dlog.level=WARNING",
  "--jvm-arg=-Xms256m",
  "--jvm-arg=-Xmx2g",
  "-data",
  workspace_dir,
}

if vim.uv.fs_stat(lombok_jar) then
  table.insert(cmd, 4, "--jvm-arg=-javaagent:" .. lombok_jar)
end

local gradle_home = vim.env.GRADLE_HOME
local snapshot_wrapper_cache = read_cache("_jdtls_gradle_snapshot_wrapper_cache")
local gradle_snapshot_wrapper = snapshot_wrapper_cache[root_dir]

if gradle_snapshot_wrapper == nil then
  gradle_snapshot_wrapper = false
  local wrapper_props = root_dir .. "/gradle/wrapper/gradle-wrapper.properties"

  if vim.uv.fs_stat(wrapper_props) then
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

  snapshot_wrapper_cache[root_dir] = gradle_snapshot_wrapper
  vim.g._jdtls_gradle_snapshot_wrapper_cache = snapshot_wrapper_cache
end

local gradle_available = gradle_home ~= nil and gradle_home ~= ""
local gradle_wrapper_enabled = not gradle_snapshot_wrapper
local gradle_enabled = gradle_wrapper_enabled or gradle_available

local settings = {
  java = {
    autobuild = { enabled = false },
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
    configuration = {
      updateBuildConfiguration = "interactive",
    },
    contentProvider = { preferred = "fernflower" },
    eclipse = { downloadSources = false },
    import = {
      projectSelection = "automatic",
      gradle = {
        annotationProcessing = { enabled = false },
        enabled = gradle_enabled,
        home = gradle_available and gradle_home or nil,
        offline = { enabled = false },
        wrapper = { enabled = gradle_wrapper_enabled },
      },
      maven = {
        downloadSources = false,
        enabled = true,
      },
    },
    inlayHints = {
      parameterNames = { enabled = "literals" },
    },
    jdt = {
      ls = {
        lombokSupport = { enabled = true },
      },
    },
    maven = { downloadSources = false },
    project = {
      resourceFilters = { "node_modules", "\\.git", "build", "target", "dist", "out", "\\.gradle" },
    },
    server = { launchMode = "Standard" },
  },
}

if java_home and java_home ~= "" then
  settings.java.jdt.ls.java = { home = java_home }
end

local function on_attach(client, bufnr)
  lsp.on_attach(client, bufnr)

  vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Organize imports" })
  vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { buffer = bufnr, desc = "Extract variable" })
  vim.keymap.set("v", "<leader>jv", function()
    jdtls.extract_variable(true)
  end, { buffer = bufnr, desc = "Extract variable" })
  vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, { buffer = bufnr, desc = "Extract constant" })
  vim.keymap.set("v", "<leader>jc", function()
    jdtls.extract_constant(true)
  end, { buffer = bufnr, desc = "Extract constant" })
  vim.keymap.set("v", "<leader>jm", function()
    jdtls.extract_method(true)
  end, { buffer = bufnr, desc = "Extract method" })
end

jdtls.start_or_attach({
  cmd = cmd,
  root_dir = root_dir,
  capabilities = lsp.capabilities,
  settings = settings,
  init_options = { bundles = {} },
  on_attach = on_attach,
})
