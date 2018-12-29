source ~/.config/nvim/vundle_init.vim

" Basic
set expandtab
set shiftwidth=2
set softtabstop=2
set smarttab
set autoindent
set autoread
set number

set ignorecase
set smartcase
set hidden
set incsearch
set tabstop=2

" swap ^ & 0
nnoremap 0 ^
nnoremap ^ 0

" swap gj&j gk&k
nnoremap gj j
nnoremap j gj
nnoremap gk k
nnoremap k gk

" YouCompleteMe related autocomplete
" let g:ycm_semantic_triggers = { \   'css': [ 're!^\s{2}', 're!:\s+' ], \   'less': [ 're!^\s{2}', 're!:\s+' ],
"      \ }

:iabbrev </ </<C-X><C-O>

" JSX related let g:jsx_ext_required = 0

" Color theme
colorscheme molokai " hi MatchParen ctermfg=249 ctermbg=236 cterm=bold

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Ctrl-p ignore
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_custom_ignore = 'node_modules\|\.git\|vendor\|*.pyc\|__pycache__'

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 20
" let g:deoplete#go#gocode_binary = '~/go/bin/gocode'
" let g:deoplete#sources#go#source_importer = 1
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Language Server
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
      \'java': ['/home/dreamszl/softwares/jdt-language-server-0.12.1/java-lang-server.sh'],
      \'javascript': ['javascript-typescript-stdio'],
      \'javascript.jsx': ['javascript-typescript-stdio'],
      \'typescript': ['javascript-typescript-stdio'],
      \'python': ['pyls'],
      \ 'go': ['bingo', '--enable-global-cache', 'true', '--mode', 'stdio', '--logfile', '/tmp/lspserver.log','--trace', '--pprof', ':6060'],
      \}
let g:LanguageClient_rootMarkers = {
      \ 'go': ['go.mod'],
      \ }
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
let g:LanguageClient_diagnosticsEnable = 0

" python-pep8-indentation
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4

" html&js indentation
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2

" golang indentation
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" gitgutter
set updatetime=10

" set leader
nnoremap <SPACE> <Nop>
let mapleader=" "

nmap <leader>w :w!<cr>
nmap <leader>o <C-W>o
nmap <leader>h <C-W>h
nmap <leader>k <C-W>k
nmap <leader>j <C-W>j
nmap <leader>l <C-W>l
nmap <leader>i <C-W>k<C-W>q
nmap <leader>v <C-W>v
nmap <leader>s :noh<cr>
nmap <leader>y "+y
nmap <leader>p "+p
nmap <leader>r :e!<cr>

" vim-go
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1

let g:go_gocode_propose_source=0

" let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"

" Error and warning signs.
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '?'
highlight ALEWarning ctermbg=DarkGreen
highlight ALEError ctermbg=Yellow
highlight clear ALEErrorSign
highlight clear ALEWarningSign

" gitgutter
nmap <leader>gp <Plug>GitGutterPreviewHunk
nmap <leader>gu <Plug>GitGutterUndoHunk
nmap <leader>gs <Plug>GitGutterStageHunk
