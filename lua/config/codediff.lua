local M = {}

local function window_belongs_to_live_tab(winid)
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    return false
  end

  return vim.fn.win_id2tabwin(winid)[1] ~= 0
end

local function guard_live_tab_window(fn)
  return function(winid)
    if not window_belongs_to_live_tab(winid) then
      return
    end

    return fn(winid)
  end
end

local function patch_welcome_window()
  local welcome_window = require("codediff.ui.view.welcome_window")
  if welcome_window._config_live_tab_guard_applied then
    return
  end

  welcome_window.apply = guard_live_tab_window(welcome_window.apply)
  welcome_window.apply_normal = guard_live_tab_window(welcome_window.apply_normal)
  welcome_window.sync = guard_live_tab_window(welcome_window.sync)

  welcome_window._config_live_tab_guard_applied = true
end

function M.setup(opts)
  require("codediff").setup(opts)
  patch_welcome_window()
end

return M
