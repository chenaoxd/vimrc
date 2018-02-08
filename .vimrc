source ~/.vim_config/vundle_init.vim

" Basic
inoremap jk <ESC>

set expandtab
set shiftwidth=2
set softtabstop=2
set smarttab
set autoindent

set ignorecase
set smartcase
set hidden
set incsearch
set tabstop=2

" YouCompleteMe related autocomplete
let g:ycm_semantic_triggers = {
      \   'css': [ 're!^\s{2}', 're!:\s+' ],
      \   'less': [ 're!^\s{2}', 're!:\s+' ],
      \ }

:iabbrev </ </<C-X><C-O>

" JSX related
let g:jsx_ext_required = 0

" Color theme
colorscheme molokai
let g:molokai_original = 1
hi MatchParen ctermfg=208 ctermbg=233 cterm=bold

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Ctrl-p ignore
let g:ctrlp_custom_ignore = 'node_modules\|\.git'

" deoplete
let g:deoplete#enable_at_startup = 1

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" Language Server
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
  \'java': ['/home/dreamszl/softwares/jdt-language-server-0.12.1/java-lang-server.sh'],
  \'javascript': ['javascript-typescript-stdio'],
  \'javascript.jsx': ['javascript-typescript-stdio'],
  \'typescript': ['javascript-typescript-stdio'],
  \'python': ['pyls']
  \}
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" python-pep8-indent
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
