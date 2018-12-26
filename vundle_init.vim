set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle/')

Plugin 'VundleVim/Vundle.vim'
" Plugin 'flazz/vim-colorschemes'
Plugin 'elzr/vim-json'
Plugin 'kien/ctrlp.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'groenewege/vim-less'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'scrooloose/nerdtree'
Plugin 'jceb/vim-orgmode'
Plugin 'tpope/vim-speeddating'
Plugin 'autozimu/LanguageClient-neovim'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'
" Plugin 'Shougo/deoplete.nvim'
" Plugin 'zchee/deoplete-go'
Plugin 'airblade/vim-gitgutter'
Plugin 'martinda/Jenkinsfile-vim-syntax'
Plugin 'w0rp/ale'
Plugin 'sebdah/vim-delve'
Plugin 'chr4/nginx.vim'

call vundle#end()            " required
filetype plugin indent on    " required
