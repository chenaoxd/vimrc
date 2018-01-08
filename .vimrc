source ~/.vim_config/vundle_init.vim

" Basic
inoremap jk <ESC>
set expandtab
set shiftwidth=2
set softtabstop=2

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

" NERDTree
map <C-n> :NERDTreeToggle<CR>
