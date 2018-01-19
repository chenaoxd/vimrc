set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim_config/bundle/Vundle.vim
call vundle#begin('~/.vim_config/bundle/')

Plugin 'VundleVim/Vundle.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'elzr/vim-json'
Plugin 'kien/ctrlp.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'groenewege/vim-less'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'scrooloose/nerdtree'
Plugin 'jceb/vim-orgmode'

call vundle#end()            " required
filetype plugin indent on    " required
