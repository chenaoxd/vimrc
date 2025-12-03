-- Core keymaps
local M = {}

local map = vim.keymap.set
local opts = { silent = true }

-- Disable space in normal mode
map("n", "<Space>", "<Nop>", opts)

-- Better navigation
-- swap ^ & 0
map("n", "0", "^", opts)
map("n", "^", "0", opts)

-- swap gj&j gk&k for wrapped lines
map("n", "gj", "j", opts)
map("n", "j", "gj", opts)
map("n", "gk", "k", opts)
map("n", "k", "gk", opts)

-- File operations
map("n", "<Leader>w", ":w!<cr>", opts)
map("n", "<Leader>rr", ":e!<cr>", opts)
map("n", "<Leader>Q", ":q!<cr>", opts)
map("n", "<Leader>sv", ":source $MYVIMRC<cr>", opts)

-- Window management
map("n", "<Leader>oo", "<C-W>o", opts)
map("n", "<Leader>q", "<C-W>q", opts)
map("n", "<Leader>h", "<C-W>h", opts)
map("n", "<Leader>k", "<C-W>k", opts)
map("n", "<Leader>j", "<C-W>j", opts)
map("n", "<Leader>l", "<C-W>l", opts)
map("n", "<Leader>i", "<C-W>k<C-W>q", opts)
map("n", "<Leader>v", "<C-W>v", opts)

-- Search and navigation
map("n", "<Leader>nh", ":noh<cr>", opts)
map("n", "<Leader>nf", ":e %:h/", opts)

-- Clipboard operations
map("n", "<Leader>Y", "V\"+y", opts)
map("n", "<Leader>y", "\"+y", opts)
map("n", "<Leader>u", "\"up", opts)

-- Smart paste function that checks if buffer is modifiable
local function smart_paste()
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd('normal! "+p')
  else
    print("Buffer is not modifiable")
  end
end

-- Override default paste keys to use smart paste
map("n", "p", function()
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd('normal! p')
  else
    print("Buffer is not modifiable")
  end
end, opts)

map("n", "P", function()
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd('normal! P')
  else
    print("Buffer is not modifiable")
  end
end, opts)

map("n", "<Leader>p", smart_paste, opts)

-- Tab management
map("n", "<Leader>tn", ":tabnew<cr>", opts)
map("n", "<Leader>tm", ":tabmove ", opts)
map("n", "<Leader>tc", ":tabclose<cr>", opts)
map("n", "<Leader>to", ":tabonly<cr>", opts)

-- Misc operations
map("n", "<Leader>ct", "cT(", opts)  -- 移动到 ct (change to), 给 Claude 让出 c
map("n", "<Leader>!w", ":w !sudo tee %", opts)
map("n", "<Leader>rg", ":Rg ", opts)
map("n", "<Leader>lr", ":LspRestart<cr>", opts)

-- Session management
map("n", "<Leader>ss", ":mksession! ~/.vimsession<cr>", opts)
map("n", "<Leader>sl", ":source ~/.vimsession<cr>", opts)

-- Syntax settings
map("n", "<Leader>sa", ":set syntax=yaml.ansible<cr>", opts)
map("n", "<Leader>sh", ":set syntax=helm<cr>", opts)
map("n", "<Leader>st", ":set syntax=", opts)

-- Debug mappings (vim-delve)
map("n", "<F8>", ":DlvConnect localhost:33333<CR>", opts)
map("n", "<F9>", ":DlvToggleBreakpoint<CR>", opts)
map("n", "<F10>", ":DlvClearAll<CR>", opts)

return M
