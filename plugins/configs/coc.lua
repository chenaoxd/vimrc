-- CoC configuration
local M = {}

local keyset = vim.keymap.set

-- CoC global extensions
vim.g.coc_global_extensions = {
  'coc-json',
  'coc-tsserver',
  'coc-css',
  'coc-rust-analyzer',
  'coc-pyright',
  'coc-go',
  '@yaegassy/coc-tailwindcss3',
  '@yaegassy/coc-volar',
  'coc-sumneko-lua',
  'coc-java',
}

-- Some servers have issues with backup files, see #649.
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- Autocomplete function
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Tab completion
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Highlight the symbol and its references on CursorHold
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

-- Code actions
local action_opts = {silent = true, nowait = true}
keyset("x", "<leader>ca", "<Plug>(coc-codeaction-selected)", action_opts)
keyset("n", "<leader>ca", "<Plug>(coc-codeaction-selected)", action_opts)
keyset("n", "<leader>cac", "<Plug>(coc-codeaction-cursor)", action_opts)
keyset("n", "<leader>cas", "<Plug>(coc-codeaction-source)", action_opts)
keyset("n", "<leader>cf", "<Plug>(coc-fix-current)", action_opts)
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", action_opts)

-- Text objects
keyset("x", "if", "<Plug>(coc-funcobj-i)", action_opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", action_opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", action_opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", action_opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", action_opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", action_opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", action_opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", action_opts)

-- Scroll float windows/popups
local scroll_opts = {silent = true, nowait = true, expr = true}
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scroll_opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scroll_opts)
keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', scroll_opts)
keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', scroll_opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scroll_opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scroll_opts)

-- Use CTRL-S for selections ranges
keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})

-- Commands
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- CoCList mappings
local list_opts = {silent = true, nowait = true}
keyset("n", "<space>ca", ":<C-u>CocList diagnostics<cr>", list_opts)
keyset("n", "<space>ce", ":<C-u>CocList extensions<cr>", list_opts)
keyset("n", "<space>cc", ":<C-u>CocList commands<cr>", list_opts)
keyset("n", "<space>co", ":<C-u>CocList outline<cr>", list_opts)
keyset("n", "<space>cs", ":<C-u>CocList -I symbols<cr>", list_opts)
keyset("n", "<space>cj", ":<C-u>CocNext<cr>", list_opts)
keyset("n", "<space>ck", ":<C-u>CocPrev<cr>", list_opts)
keyset("n", "<space>cp", ":<C-u>CocListResume<cr>", list_opts)

-- Go specific mappings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set("n", "tj", ":CocCommand go.tags.add json<cr>", { buffer = true })
        vim.keymap.set("n", "ty", ":CocCommand go.tags.add yaml<cr>", { buffer = true })
        vim.keymap.set("n", "tx", ":CocCommand go.tags.clear<cr>", { buffer = true })
    end
})

-- CoC disable/enable mappings
keyset("n", "<leader>cnn", ":CocDisable<cr>", { silent = true })
keyset("n", "<leader>cny", ":CocEnable<cr>", { silent = true })

return M
