-- Enhanced LSP hover using render-markdown.nvim for beautiful markdown rendering
local M = {}

-- Helper function to trim whitespace
local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

-- Diagnostic severity mapping
local severity_map = {
  [vim.diagnostic.severity.ERROR] = { icon = '❌', name = 'ERROR', hl = 'DiagnosticError' },
  [vim.diagnostic.severity.WARN] = { icon = '⚠️', name = 'WARN', hl = 'DiagnosticWarn' },
  [vim.diagnostic.severity.HINT] = { icon = '💡', name = 'HINT', hl = 'DiagnosticHint' },
  [vim.diagnostic.severity.INFO] = { icon = 'ℹ️', name = 'INFO', hl = 'DiagnosticInfo' },
}

-- Add diagnostic information as markdown
local function add_diagnostics_markdown(diagnostics)
  if #diagnostics == 0 then return "" end
  
  local lines = {"🔍 **Diagnostics**", ""}
  
  for _, diagnostic in ipairs(diagnostics) do
    local severity_info = severity_map[diagnostic.severity] or severity_map[vim.diagnostic.severity.INFO]
    local code = diagnostic.code and string.format(" `[%s]`", diagnostic.code) or ""
    local line_text = string.format("- %s **%s**: %s%s", 
      severity_info.icon, severity_info.name, diagnostic.message, code)
    table.insert(lines, line_text)
  end
  
  table.insert(lines, "")
  table.insert(lines, "---")
  table.insert(lines, "")
  
  return table.concat(lines, "\n")
end

-- Create and display the enhanced hover window with markdown rendering
local function create_markdown_hover_window(content)
  -- Create a temporary buffer for markdown content
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Set buffer options for markdown
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  
  -- Set the markdown content
  local lines = vim.split(content, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- Make buffer read-only after setting content
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  
  -- Calculate window dimensions
  local max_width = math.min(80, vim.o.columns - 4)
  local max_height = math.min(#lines + 2, vim.o.lines - 4)
  
  -- Create floating window (focusable for scrolling)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'cursor',
    width = max_width,
    height = max_height,
    row = 1,
    col = 0,
    border = 'rounded',
    style = 'minimal',
    zindex = 1000,
    focusable = true,
  })
  
  -- Set window-specific highlighting to avoid white backgrounds
  vim.api.nvim_set_option_value('winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder', { win = win })
  
  -- Enable render-markdown for this buffer if available
  local ok, render_markdown = pcall(require, 'render-markdown')
  if ok then
    -- Enable render-markdown for this specific buffer
    render_markdown.enable(buf)
    
    -- Set up specific render-markdown config for hover windows
    vim.api.nvim_buf_call(buf, function()
      vim.b.render_markdown = {
        enabled = true,
        max_file_size = 10.0, -- Allow larger content for documentation
        render_modes = true,
        anti_conceal = {
          enabled = false, -- Keep concealing for cleaner display
        },
        heading = {
          enabled = true,
          sign = false, -- Disable signs in floating window
          icons = { '📌 ', '▶ ', '▸ ', '• ', '◦ ', '▫ ' },
          width = 'full',
          min_width = 20,
          backgrounds = { '', '', '', '', '', '' }, -- Remove heading backgrounds
        },
        code = {
          enabled = true,
          sign = false,
          style = 'full',
          position = 'left',
          language_pad = 2,
          width = 'block',
          min_width = 60,
        },
        bullet = {
          enabled = false, -- Disable render-markdown bullet rendering
        },
        checkbox = {
          enabled = true,
          unchecked = { icon = '󰄱 ' },
          checked = { icon = '󰱒 ' },
        },
        quote = {
          enabled = true,
          icon = '▎',
        },
        pipe_table = {
          enabled = true,
          style = 'full',
        },
        callout = {
          enabled = true,
          note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
          tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
          important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
          warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
          caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
        },
        link = {
          enabled = true,
          image = '󰥶 ',
          hyperlink = '󰌷 ',
        },
        sign = {
          enabled = false, -- Disable signs in floating windows
        },
      }
    end)
  end
  
  -- Auto-close on cursor movement or other events (but not when focus is on hover window)
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter' }, {
    once = true,
    callback = function()
      -- Only close if current window is not the hover window
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_current_win() ~= win then
        close_hover_window()
      end
    end,
  })
  
  -- Helper function to close window and clean up
  local function close_hover_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    -- Clean up global focus keymap
    pcall(vim.keymap.del, 'n', '<Tab>')
  end
  
  -- Add scrolling and navigation keymaps
  local scroll_keymaps = {
    ['<Esc>'] = close_hover_window,
    ['q'] = close_hover_window,
    ['<C-f>'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! ' .. math.floor(vim.api.nvim_win_get_height(win) * 0.75) .. 'j')
      end)
    end,
    ['<C-b>'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! ' .. math.floor(vim.api.nvim_win_get_height(win) * 0.75) .. 'k')
      end)
    end,
    ['<C-d>'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! ' .. math.floor(vim.api.nvim_win_get_height(win) * 0.5) .. 'j')
      end)
    end,
    ['<C-u>'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! ' .. math.floor(vim.api.nvim_win_get_height(win) * 0.5) .. 'k')
      end)
    end,
    ['j'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! j')
      end)
    end,
    ['k'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! k')
      end)
    end,
    ['gg'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! gg')
      end)
    end,
    ['G'] = function()
      vim.api.nvim_win_call(win, function()
        vim.cmd('normal! G')
      end)
    end,
  }
  
  for key, func in pairs(scroll_keymaps) do
    vim.keymap.set('n', key, func, { buffer = buf, nowait = true })
  end
  
  -- Global keymap to focus the hover window for scrolling
  local focus_keymap_id = vim.keymap.set('n', '<Tab>', function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_current_win(win)
    end
  end, { desc = 'Focus hover window for scrolling' })
end

-- Convert LSP hover content to better markdown format
local function process_hover_content(contents)
  local content = ""
  
  -- Handle different types of LSP content
  if type(contents) == 'string' then
    content = contents
  elseif contents.kind == 'markdown' then
    content = contents.value
  elseif contents.kind == 'plaintext' then
    -- Wrap plain text in code blocks for better formatting
    content = "```\n" .. contents.value .. "\n```"
  elseif type(contents) == 'table' then
    local result = {}
    for _, item in ipairs(contents) do
      if type(item) == 'string' then
        table.insert(result, item)
      elseif item.kind == 'markdown' then
        table.insert(result, item.value)
      elseif item.kind == 'plaintext' then
        table.insert(result, "```\n" .. item.value .. "\n```")
      end
    end
    content = table.concat(result, "\n\n")
  end
  
  -- Process and clean up the content
  if content ~= "" then
    -- Split into lines for better processing
    local lines = vim.split(content, '\n')
    local processed_lines = {}
    local prev_was_list = false
    local prev_indent_level = 0
    
    for i, line in ipairs(lines) do
      local indent = line:match("^(%s*)")
      local is_list = line:match("^%s*[%*%-]%s+")
      
      if is_list then
        local current_indent_level = #indent
        local list_content = line:match("^%s*[%*%-]%s+(.*)")
        
        -- Add spacing before first-level list items (except the very first one)
        if current_indent_level == 0 and prev_was_list and prev_indent_level > 0 then
          table.insert(processed_lines, "")
        end
        
        table.insert(processed_lines, indent .. "▸ " .. list_content)
        prev_was_list = true
        prev_indent_level = current_indent_level
      else
        -- Not a list item
        if trim(line) == "" then
          -- Keep empty lines but avoid duplicates
          if #processed_lines > 0 and processed_lines[#processed_lines] ~= "" then
            table.insert(processed_lines, "")
          end
        else
          table.insert(processed_lines, line)
        end
        prev_was_list = false
        prev_indent_level = 0
      end
    end
    
    content = table.concat(processed_lines, '\n')
    
    -- Final cleanup: remove excessive empty lines
    content = content:gsub("\n\n\n+", "\n\n")
    content = content:gsub("^%s*\n", "") -- Remove leading empty lines
    content = content:gsub("\n%s*$", "") -- Remove trailing empty lines
  end
  
  return content
end

-- Main function to show enhanced hover with render-markdown
function M.show_enhanced_hover()
  -- Get diagnostics for current line
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  
  -- Request LSP hover information
  local params = vim.lsp.util.make_position_params(0, 'utf-16')
  vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result)
    if err then
      -- Fallback to diagnostics only if available
      if #diagnostics > 0 then
        vim.diagnostic.open_float()
      end
      return
    end
    
    local markdown_content = ""
    
    -- Add diagnostics if present
    local diagnostic_markdown = add_diagnostics_markdown(diagnostics)
    if diagnostic_markdown ~= "" then
      markdown_content = diagnostic_markdown
    end
    
    -- Process hover content if available
    if result and result.contents then
      local hover_markdown = process_hover_content(result.contents)
      if hover_markdown and hover_markdown ~= "" then
        if markdown_content ~= "" then
          markdown_content = markdown_content .. "\n"
        end
        markdown_content = markdown_content .. "📖 **Documentation**\n\n" .. hover_markdown
      end
    end
    
    -- Show content if we have any
    if markdown_content ~= "" then
      create_markdown_hover_window(markdown_content)
    elseif #diagnostics > 0 then
      -- Fallback to standard diagnostic float
      vim.diagnostic.open_float()
    end
  end)
end

return M