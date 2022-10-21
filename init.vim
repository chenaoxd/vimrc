let g:vimspector_enable_mappings = 'HUMAN'

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme molokai " hi MatchParen ctermfg=249 ctermbg=236 cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IndentetLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set list lcs=tab:│\ 
let g:indentLine_char = '│'
let g:indentLine_fileTypeExclude = ['markdown', 'json']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-y> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctrl-p ignore
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map = '<c-h>'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" let g:ctrlp_custom_ignore = 'node_modules\|\.git\|vendor\|*.pyc\|__pycache__\|venv\|bin\|bundle\|target'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=10
highlight GitGutterAdd ctermfg = Green
highlight GitGutterDelete ctermfg = Red
highlight GitGutterChange ctermfg = 214

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <SPACE> <Nop>
let mapleader=" "

nmap <leader>w :w!<cr>
nmap <leader>oo <C-W>o
nmap <leader>q <C-W>q
nmap <leader>h <C-W>h
nmap <leader>k <C-W>k
nmap <leader>j <C-W>j
nmap <leader>l <C-W>l
nmap <leader>i <C-W>k<C-W>q
nmap <leader>v <C-W>v
nmap <leader>nh :noh<cr>
nmap <leader>nf :e %:h/
nmap <leader>Y V"+y
nmap <leader>y "+y
nmap <leader>u "up
nmap <leader>p "+p
nmap <leader>rr :e!<cr>
nmap <leader>c cT(
nmap <leader>!w :w !sudo tee %
nmap <leader>rg :Rg 
nmap <leader>gg :LanguageClientStop<cr>:LanguageClientStart<cr>
nmap <leader>ss :mksession! ~/.vimsession<cr>
nmap <leader>sl :source ~/.vimsession<cr>
nmap <leader>sa :set syntax=yaml.ansible<cr>
nmap <leader>sh :set syntax=helm<cr>
nmap <leader>st :set syntax=
nmap <leader>Q :q!<cr>
nmap <leader>cnn :CocDisable<cr>
nmap <leader>cny :CocEnable<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tab related mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>tn :tabnew<cr>
nmap <leader>tm :tabmove
nmap <leader>tc :tabclose<cr>
nmap <leader>to :tabonly<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ale related mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>ay :let g:ale_fix_on_save=1<cr>
nmap <leader>an :let g:ale_fix_on_save=0<cr>
nmap <leader>af :ALEFix<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:go_auto_type_info = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F8> :DlvConnect localhost:33333<CR>
nnoremap <silent> <F9> :DlvToggleBreakpoint<CR>
nnoremap <silent> <F10> :DlvClearAll<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)

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
      \ 'sh': ['shfmt'],
      \ }
let g:ale_fix_on_save = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.config/nvim/coc.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ }
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

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
