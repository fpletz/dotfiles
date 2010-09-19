set nocompatible
set background=dark
syntax on

filetype plugin indent on
set autochdir
set backspace=indent,eol,start
set directory=~/.vim/tmp
set iskeyword+=_,$,@,%,#
set mouse=a
set noerrorbells

" ui
set cursorcolumn
set cursorline
set incsearch
set laststatus=2
set lazyredraw
set novisualbell
set number
set ruler
set scrolloff=10

set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

set smartcase
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=8


inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
