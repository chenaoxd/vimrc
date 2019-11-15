call plug#begin('~/.config/nvim/bundle')

Plug 'elzr/vim-json'
Plug 'kien/ctrlp.vim'
Plug 'leafgarland/typescript-vim'
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
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

call plug#end()
