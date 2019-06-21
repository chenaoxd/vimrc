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
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ }
Plug 'fatih/vim-go'
Plug 'airblade/vim-gitgutter'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'w0rp/ale'
Plug 'sebdah/vim-delve'
Plug 'chr4/nginx.vim'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-path'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-ultisnips'
Plug 'SirVer/ultisnips'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', {
  \ 'dir': '~/.fzf',
  \ 'do': './install --all'
  \ }
Plug 'junegunn/fzf.vim'

call plug#end()
