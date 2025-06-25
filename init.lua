-- Neovim configuration entry point
-- Author: chenao
-- Optimized structure for better maintainability

-- Ensure we can find our modules from any directory
local config_path = vim.fn.stdpath("config")
-- Add config path to Lua package path if not already there
if not package.path:find(config_path, 1, true) then
    package.path = config_path .. "/?.lua;" .. package.path
end

-- Load core configurations first
require("core.options")      -- Basic vim options (includes netrw disable)

-- Load plugin configurations
require("plugins.init")

-- Load remaining core configurations
require("core.keymaps")      -- Global key mappings
require("core.autocmds")     -- Auto commands
require("core.theme")        -- Theme and UI highlights
