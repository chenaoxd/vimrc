source ~/.config/nvim/vim_plug_init.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set softtabstop=2
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

" jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

autocmd BufReadPost *.kt setlocal filetype=kotlin
autocmd BufReadPost *.gradle setlocal filetype=groovy
autocmd BufReadPost *.tsx setlocal filetype=typescript.tsx
autocmd BufReadPost *.jsx setlocal filetype=javascript.jsx

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme molokai " hi MatchParen ctermfg=249 ctermbg=236 cterm=bold


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctrl-p ignore
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_custom_ignore = 'node_modules\|\.git\|vendor\|*.pyc\|__pycache__'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" python-pep8-indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" html&js indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType typescript setlocal shiftwidth=4 tabstop=4 softtabstop=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" golang indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" kotlin indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType kotlin set shiftwidth=4 tabstop=4 softtabstop=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=10


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
nmap <leader>s :noh<cr>
nmap <leader>Y V"+y
nmap <leader>y "+y
nmap <leader>p "+p
nmap <leader>r :e!<cr>
nmap <leader>c cT(
nmap <leader>!w :w !sudo tee %
nmap <leader>a :Ag 
nmap <leader>gg :LanguageClientStop<cr>:LanguageClientStart<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:go_auto_type_info = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F8> :DlvConnect localhost:33333<CR>
nnoremap <silent> <F9> :DlvToggleBreakpoint<CR>
nnoremap <silent> <F10> :DlvClearAll<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>gp <Plug>GitGutterPreviewHunk
nmap <leader>gu <Plug>GitGutterUndoHunk
nmap <leader>gs <Plug>GitGutterStageHunk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
" :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ale
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight ALEWarning ctermbg=DarkGreen
highlight ALEError ctermbg=DarkRed
highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_linters = {
      \ 'python': ['flake8'], 
      \ 'proto': [],
      \ 'javascript':[],
      \ 'go': ['gopls', 'golangci-lint'],
      \ 'kotlin':['ktlint'],
      \ }
let g:ale_fixers = {
      \ 'python': ['autopep8'],
      \ 'go': ['gofmt'],
      \ 'rust': ['rustfmt'],
      \ 'kotlin': ['ktlint'],
      \ }
let g:ale_fix_on_save = 1
let g:ale_go_golangci_lint_options = '--fast'
let g:ale_go_golangci_lint_package = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""	
" Language Server	
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""	
autocmd BufReadPost *.kt setlocal filetype=kotlin	
autocmd BufReadPost *.gradle setlocal filetype=groovy	

let jsserver = ['typescript-language-server', '--stdio']

let g:LanguageClient_autoStart = 1	
let g:LanguageClient_serverCommands = {	
      \'java': ['/home/dreamszl/softwares/jdt-language-server-0.12.1/java-lang-server.sh'],
      \'css': ['css-languageserver', '--stdio'],
      \'javascript': jsserver,
      \'javascript.jsx': jsserver,
      \'typescript.tsx': jsserver,
      \'typescriptreact': jsserver,
      \'typescript': jsserver,
      \'python': ['pyls'],
      \'go': ['gopls', '-rpc.trace', '-logfile', '/tmp/gopls.log'],	
      \'html': ['html-languageserver', '--stdio'],	
      \'kotlin': ['kotlin-language-server'],
      \'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
      \'proto': ['protocol-buffers-language-server'],
      \}	

" protobuf lsp: https://github.com/micnncim/protocol-buffers-language-server

" use virtualenv pyls if is in virtualenv	
if !empty($VIRTUAL_ENV)	
  let g:LanguageClient_serverCommands['python'] = [$VIRTUAL_ENV.'/bin/pyls']	
endif	

let g:LanguageClient_rootMarkers = {	
      \ 'go': ['go.mod'],	
      \ }	
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>	
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>	
nnoremap <silent> gi :call LanguageClient_textDocument_implementation()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>	
let g:LanguageClient_diagnosticsEnable = 0	


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""	
" ncm2	
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""	
autocmd BufEnter * call ncm2#enable_for_buffer()	
set completeopt=noinsert,menuone,noselect	
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"	
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"	

