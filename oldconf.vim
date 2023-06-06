source ~/.config/nvim/vim_plug_init.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set sw=4
set ts=4
set sts=4

set autoindent
set autoread
set number
set ignorecase
set smartcase
set hidden
set incsearch

set cursorline

" code folding
set foldmethod=syntax
set foldnestmax=10
set nofoldenable
set foldlevel=2

" swap ^ & 0
nnoremap 0 ^
nnoremap ^ 0

" swap gj&j gk&k
nnoremap gj j
nnoremap j gj
nnoremap gk k
nnoremap k gk

" jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

autocmd BufReadPost,BufNewFile *.kt setlocal filetype=kotlin
autocmd BufReadPost,BufNewFile *.gradle setlocal filetype=groovy
autocmd BufReadPost,BufNewFile *.tsx setlocal filetype=typescriptreact
autocmd BufReadPost,BufNewFile *.jsx setlocal filetype=javascript.jsx
autocmd BufReadPost,BufNewFile *.ympl setlocal filetype=yaml
autocmd BufReadPost,BufNewFile Dockerfile.* setlocal filetype=dockerfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python setlocal sw=4 ts=4 sts=4
autocmd FileType html setlocal sw=2 ts=2 sts=2
autocmd FileType javascript setlocal sw=2 ts=2 sts=2
autocmd FileType typescript setlocal sw=2 ts=2 sts=2
autocmd FileType typescriptreact setlocal sw=2 ts=2 sts=2
autocmd FileType go setlocal noexpandtab sw=4 ts=4 sts=4
autocmd FileType kotlin setlocal sw=4 ts=4 sts=4
autocmd FileType yaml setlocal expandtab ts=2 sts=2 sw=2
autocmd FileType Jenkinsfile setlocal ts=2 sts=2 sw=2
autocmd FileType sh setlocal noexpandtab ts=2 sts=2 sw=2
autocmd FileType scss setlocal ts=2 sts=2 sw=2
autocmd FileType proto setlocal ts=2 sts=2 sw=2
autocmd FileType vue setlocal ts=2 sts=2 sw=2
autocmd FileType lua setlocal ts=2 sts=2 sw=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme molokai " hi MatchParen ctermfg=249 ctermbg=236 cterm=bold
hi CursorLine ctermbg=236

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IndentetLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set list lcs=tab:│\ 
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['markdown', 'json']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=10
highlight GitGutterAdd ctermfg = Green
highlight GitGutterDelete ctermfg = Red
highlight GitGutterChange ctermfg = 214

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <SPACE> <Nop>
let mapleader=" "

nmap <Leader>w :w!<cr>
nmap <Leader>oo <C-W>o
nmap <Leader>q <C-W>q
nmap <Leader>h <C-W>h
nmap <Leader>k <C-W>k
nmap <Leader>j <C-W>j
nmap <Leader>l <C-W>l
nmap <Leader>i <C-W>k<C-W>q
nmap <Leader>v <C-W>v
nmap <Leader>nh :noh<cr>
nmap <Leader>nf :e %:h/
nmap <Leader>Y V"+y
nmap <Leader>y "+y
nmap <Leader>u "up
nmap <Leader>p "+p
nmap <Leader>rr :e!<cr>
nmap <Leader>c cT(
nmap <Leader>!w :w !sudo tee %
nmap <Leader>rg :Rg 
nmap <Leader>gg :LanguageClientStop<cr>:LanguageClientStart<cr>
nmap <Leader>ss :mksession! ~/.vimsession<cr>
nmap <Leader>sl :source ~/.vimsession<cr>
nmap <Leader>sa :set syntax=yaml.ansible<cr>
nmap <Leader>sh :set syntax=helm<cr>
nmap <Leader>st :set syntax=
nmap <Leader>Q :q!<cr>
nmap <Leader>cnn :CocDisable<cr>
nmap <Leader>cny :CocEnable<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tab related mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>tn :tabnew<cr>
nmap <Leader>tm :tabmove
nmap <Leader>tc :tabclose<cr>
nmap <Leader>to :tabonly<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:go_auto_type_info = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F8> :DlvConnect localhost:33333<CR>
nnoremap <silent> <F9> :DlvToggleBreakpoint<CR>
nnoremap <silent> <F10> :DlvClearAll<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <Leader>gs <Plug>(GitGutterStageHunk)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.<q-args>, 1,
  \   fzf#vim#with_preview(), <bang>0)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ale
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters_explicit = 1
let g:ale_linters = {
            \ 'go': ['golangci-lint'],
            \ 'javascript': ['eslint'],
            \ 'typescript': ['eslint'],
            \ 'typescriptreact': ['eslint'],
            \ 'vue': ['eslint'],
            \ }
let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

let g:ale_fixers = {
      \ 'python': ['autopep8'],
      \ 'go': ['gofmt'],
      \ 'rust': ['rustfmt'],
      \ 'kotlin': ['ktlint'],
      \ 'javascript': ['prettier'],
      \ 'typescript': ['prettier'],
      \ 'typescriptreact': ['prettier'],
      \ 'vue': ['prettier'],
      \ 'sh': ['shfmt'],
      \ }
let g:ale_fix_on_save = 1

nmap <Leader>ay :let b:ale_fix_on_save=1<cr>
nmap <Leader>an :let b:ale_fix_on_save=0<cr>
nmap <Leader>af :ALEFix<cr>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.config/nvim/coc.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimspector
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

let g:vimspector_sign_priority = {
      \    'vimspectorBP':         100,
      \    'vimspectorBPCond':     100,
      \    'vimspectorBPLog':      100,
      \    'vimspectorBPDisabled': 100,
      \ }
let g:vimspector_enable_mappings = 'HUMAN'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editorconfig
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EditorConfig_disable_rules = ['max_line_length']
