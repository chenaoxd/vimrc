-- Enhanced LSP hover with beautiful styling and diagnostics integration
local M = {}

-- Highlight group definitions
local highlights = {
  title = { fg = '#7aa2f7', bold = true },
  error = { fg = '#f7768e' },
  warn = { fg = '#e0af68' },
  hint = { fg = '#0db9d7' },
  info = { fg = '#9ece6a' },
  code_bg = { bg = '#2a2a2a', fg = '#c0caf5' },
  code_lang = { fg = '#f7768e', italic = true, bold = true },
  inline_code = { bg = '#1f2335', fg = '#bb9af7' },
}

-- Setup highlight groups
local function setup_highlights()
  for name, config in pairs(highlights) do
    vim.api.nvim_set_hl(0, 'LspHover' .. name:gsub('_', ''):gsub('^%l', string.upper), config)
  end
end

-- Diagnostic severity mapping
local severity_map = {
  [vim.diagnostic.severity.ERROR] = { icon = '❌', name = 'ERROR', hl = 'LspHoverError' },
  [vim.diagnostic.severity.WARN] = { icon = '⚠️', name = 'WARN', hl = 'LspHoverWarn' },
  [vim.diagnostic.severity.HINT] = { icon = '💡', name = 'HINT', hl = 'LspHoverHint' },
  [vim.diagnostic.severity.INFO] = { icon = 'ℹ️', name = 'INFO', hl = 'LspHoverInfo' },
}

-- Process inline code patterns
local function process_inline_code(text, highlights_list, line_idx)
  local processed = text
  local inline_codes = {}
  
  -- Find all inline code patterns
  for code_match in text:gmatch("`([^`]+)`") do
    local start_pos, end_pos = text:find("`" .. code_match:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1") .. "`")
    if start_pos then
      table.insert(inline_codes, { 
        start_pos = start_pos - 1, 
        end_pos = end_pos, 
        text = code_match 
      })
    end
  end
  
  -- Replace inline code display and add highlights
  for i = #inline_codes, 1, -1 do
    local code = inline_codes[i]
    processed = processed:sub(1, code.start_pos) .. "⟨" .. code.text .. "⟩" .. processed:sub(code.end_pos + 1)
    local new_start = code.start_pos
    local new_end = new_start + 1 + #code.text + 1  -- ⟨text⟩
    table.insert(highlights_list, { 
      line = line_idx, 
      col_start = new_start, 
      col_end = new_end, 
      hl_group = 'LspHoverInlineCode' 
    })
  end
  
  return processed
end

-- Process code blocks from hover content
local function process_code_blocks(hover_lines, lines, highlights_list)
  local in_code_block = false
  local code_width = 70  -- Minimum width for background consistency
  
  for _, line in ipairs(hover_lines) do
    if line:match("^```") then
      if not in_code_block then
        -- Start of code block
        in_code_block = true
        local code_lang = line:match("^```(%w+)") or "text"
        local lang_text = "  " .. (code_lang ~= "text" and code_lang or "code") .. ":"
        table.insert(lines, lang_text)
        
        -- Highlight only the language name and colon
        local lang_start = 2
        local lang_end = lang_start + #(code_lang ~= "text" and code_lang or "code") + 1
        table.insert(highlights_list, { 
          line = #lines - 1, 
          col_start = lang_start, 
          col_end = lang_end, 
          hl_group = 'LspHoverCodeLang' 
        })
      else
        -- End of code block
        in_code_block = false
        table.insert(lines, "")  -- Add spacing after code block
      end
    elseif in_code_block then
      -- Code block content
      local content = "    " .. line
      if #content < code_width then
        content = content .. string.rep(" ", code_width - #content)
      end
      table.insert(lines, content)
      
      -- Background highlight starting from position 2 (aligned with language label)
      table.insert(highlights_list, { 
        line = #lines - 1, 
        col_start = 2, 
        col_end = -1, 
        hl_group = 'LspHoverCodeBg' 
      })
    else
      -- Regular text with inline code processing
      local processed_line = process_inline_code(line, highlights_list, #lines)
      table.insert(lines, processed_line)
    end
  end
end

-- Add diagnostic information to display
local function add_diagnostics(diagnostics, lines, highlights_list)
  if #diagnostics == 0 then return end
  
  table.insert(lines, "🔍 Diagnostics")
  table.insert(highlights_list, { 
    line = #lines - 1, 
    col_start = 0, 
    col_end = -1, 
    hl_group = 'LspHoverTitle' 
  })
  table.insert(lines, "")
  
  for _, diagnostic in ipairs(diagnostics) do
    local severity_info = severity_map[diagnostic.severity] or severity_map[vim.diagnostic.severity.INFO]
    local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
    local line_text = string.format("• %s %s: %s%s", 
      severity_info.icon, severity_info.name, diagnostic.message, code)
    
    table.insert(lines, line_text)
    table.insert(highlights_list, { 
      line = #lines - 1, 
      col_start = 0, 
      col_end = -1, 
      hl_group = severity_info.hl 
    })
  end
  
  -- Add separator
  table.insert(lines, "")
  table.insert(lines, "────────────────────")
  table.insert(lines, "")
end

-- Create and display the enhanced hover window
local function create_hover_window(lines, highlights_list)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'cursor',
    width = math.min(80, vim.o.columns - 4),
    height = math.min(#lines + 2, vim.o.lines - 4),
    row = 1,
    col = 0,
    border = 'rounded',
    style = 'minimal',
    title = ' 📖 LSP Info ',
    title_pos = 'center',
  })
  
  -- Apply all highlights
  local ns_id = vim.api.nvim_create_namespace('lsp_hover_enhanced')
  for _, hl in ipairs(highlights_list) do
    vim.api.nvim_buf_add_highlight(buf, ns_id, hl.hl_group, hl.line, hl.col_start, hl.col_end)
  end
  
  -- Make buffer read-only
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  
  -- Auto-close on cursor movement
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter' }, {
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
end

-- Main function to show enhanced hover
function M.show_enhanced_hover()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  
  -- Request LSP hover information
  local params = vim.lsp.util.make_position_params(0, 'utf-16')
  vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result)
    if err or not result or not result.contents then
      -- Fallback to diagnostics only if available
      if #diagnostics > 0 then
        vim.diagnostic.open_float()
      end
      return
    end
    
    local lines = {}
    local highlights_list = {}
    
    -- Add diagnostics if present
    add_diagnostics(diagnostics, lines, highlights_list)
    
    -- Process hover content
    local hover_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    if #hover_lines > 0 then
      table.insert(lines, "📖 Documentation")
      table.insert(highlights_list, { 
        line = #lines - 1, 
        col_start = 0, 
        col_end = -1, 
        hl_group = 'LspHoverTitle' 
      })
      table.insert(lines, "")
      
      process_code_blocks(hover_lines, lines, highlights_list)
    end
    
    -- Display the enhanced hover window
    create_hover_window(lines, highlights_list)
  end)
end

-- Initialize highlights on module load
setup_highlights()

return M