source ~/.vim_config/vundle_init.vim

" Basic settings
inoremap jk <ESC>
set expandtab
set shiftwidth=2
set softtabstop=2

" YouCompleteMe related autocomplete settings
let g:ycm_semantic_triggers = {
      \   'css': [ 're!^\s{2}', 're!:\s+' ],
      \   'less': [ 're!^\s{2}', 're!:\s+' ],
      \ }

:iabbrev </ </<C-X><C-O>

" JSX related settings
let g:jsx_ext_required = 0

" Color theme
colorscheme molokai
