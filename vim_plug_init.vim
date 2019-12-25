call plug#begin('~/.config/nvim/bundle')

Plug 'elzr/vim-json'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'towolf/vim-helm'

call plug#end()
