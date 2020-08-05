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
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'towolf/vim-helm'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'ncm2/ncm2'	
Plug 'ncm2/ncm2-path'
Plug 'rust-lang/rust.vim'
Plug 'pearofducks/ansible-vim'

call plug#end()
