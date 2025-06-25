-- Neovim configuration entry point
-- Author: chenao
-- Optimized structure for better maintainability

-- Load core configurations first
require("core.options")      -- Basic vim options (includes netrw disable)

-- Load plugin configurations
require("plugins.init")

-- Load remaining core configurations
require("core.keymaps")      -- Global key mappings
require("core.autocmds")     -- Auto commands
require("core.highlights")   -- Colors and highlights