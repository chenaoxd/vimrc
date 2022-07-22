call plug#begin('~/.config/nvim/bundle')

Plug 'kien/ctrlp.vim'
Plug 'groenewege/vim-less'
Plug 'scrooloose/nerdtree'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'sebdah/vim-delve'
Plug 'chr4/nginx.vim'
Plug 'roxma/nvim-yarp'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', {
  \ 'dir': '~/.fzf',
  \ 'do': './install --all'
  \ }
Plug 'junegunn/fzf.vim'
Plug 'udalov/kotlin-vim'
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'rust-lang/rust.vim'
Plug 'pearofducks/ansible-vim'
Plug 'Yggdroot/indentLine'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'itchyny/lightline.vim'
Plug 'vmchale/dhall-vim'
Plug 'neoclide/coc.nvim', {'branch':'release'}
let g:coc_global_extensions = [
            \ 'coc-json', 'coc-tsserver', 'coc-css', 'coc-rust-analyzer', 
            \ 'coc-java', 'coc-pyright', 'coc-go',
            \ ]
Plug 'cespare/vim-toml'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'

call plug#end()
