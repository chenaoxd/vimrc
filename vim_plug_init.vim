call plug#begin('~/.config/nvim/bundle')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'groenewege/vim-less'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
" Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'sebdah/vim-delve'
Plug 'chr4/nginx.vim'
" Plug 'roxma/nvim-yarp'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'udalov/kotlin-vim'
Plug 'yuezk/vim-js'
" Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'rust-lang/rust.vim'
Plug 'pearofducks/ansible-vim'
Plug 'Yggdroot/indentLine'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'vim-airline/vim-airline'
Plug 'vmchale/dhall-vim'
Plug 'neoclide/coc.nvim', {'branch':'release'}
let g:coc_global_extensions = [
            \ 'coc-json', 'coc-tsserver', 'coc-css', 'coc-rust-analyzer', 
            \ 'coc-pyright', 'coc-go', '@yaegassy/coc-tailwindcss3',
            \ '@yaegassy/coc-volar',
            \ ]
Plug 'cespare/vim-toml'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'puremourning/vimspector'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'f-person/git-blame.nvim'
Plug 'zbirenbaum/copilot.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }
Plug 'craigmac/vim-mermaid'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

call plug#end()
