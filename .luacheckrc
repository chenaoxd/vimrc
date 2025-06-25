-- Luacheck configuration for Neovim
-- https://luacheck.readthedocs.io/en/stable/config.html

-- Standard library definitions
std = "luajit"

-- Global variables that are okay to use
globals = {
  "vim",
  "_G",
}

-- Files and directories to ignore
exclude_files = {
  "bundle/",
  "*.min.lua",
}

-- Warnings to ignore
ignore = {
  "211",  -- Unused local variable
  "212",  -- Unused argument
  "213",  -- Unused loop variable
  "231",  -- Set but never accessed
  "311",  -- Value assigned to a local variable is unused
  "631",  -- Line is too long
}

-- Neovim-specific globals
read_globals = {
  "vim",
}

-- Maximum line length
max_line_length = false

-- Allow unused arguments starting with underscore
unused_args = false

-- Allow defining globals
allow_defined = true

-- Don't warn about global access
global = false