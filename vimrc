set nocompatible
"set background=dark
set showcmd
let mapleader=","
"colorscheme molokai

filetype plugin indent on
set autochdir
set backspace=indent,eol,start
set directory=~/.vim/tmp
set iskeyword+=_,$,@,%,#
set mouse=a
set noerrorbells
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db

" ui
set cursorcolumn
set cursorline
set incsearch
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set novisualbell
set number
set ruler
set scrolloff=5
set ttyfast
set undolevels=200

set shortmess=atI
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

set smartcase
set shiftwidth=4
set softtabstop=4
set tabstop=8
set bs=2

" cursor keys are evil, disable them to force learning hjkl
inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>

" remove ALL auto-commands so there are no dupes
autocmd!

syntax on

if has("autocmd")
    " Restore cursor position
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

    au FileType helpfile set nonumber      " no line numbers when viewing help
    au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
    au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

    au FileType mail,tex set textwidth=72
    au FileType cpp,c,java,sh,perl,php,python,haskell,html,css set autoindent
    au FileType cpp,c,java,sh,perl,php,python,haskell,html,css set smartindent
    au FileType cpp,c,java,sh,perl,php,python set cindent
    au FileType python set foldmethod=indent
    au FileType python set textwidth=79  " PEP-8 friendly
    au FileType python inoremap # X#
    au FileType python,javascript,html,css set expandtab
    au FileType python set omnifunc=pythoncomplete#Complete
    autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

    au BufWritePost   *.sh             !chmod +x %

    au BufNewFile,BufRead  *.pls    set syntax=dosini
    au BufNewFile,BufRead  modprobe.conf    set syntax=modconf
endif

let g:C_MapLeader  = ','

