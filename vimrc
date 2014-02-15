set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'sjl/splice.vim.git'
Bundle 'tpope/vim-fugitive'
Bundle 'mhinz/vim-signify'
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_sign_add               = '+'
let g:signify_sign_change            = '!'
let g:signify_sign_delete            = '✗'
let g:signify_sign_delete_first_line = '✗'

Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'mbbill/undotree'

Bundle 'kien/ctrlp.vim'
let g:ctrlp_extensions = ['mixed']
let g:ctrlp_cmd = 'CtrlPMixed'

Bundle 'bling/vim-airline'
let g:airline_theme='bubblegum'
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

Bundle 'scrooloose/nerdtree'
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

Bundle 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled=1

set nocompatible
set mouse=a

if has("gui_running")
   " Remove Toolbar
   set guioptions-=T
   set guifont=Droid\ Sans\ Mono\ 10
endif

" Easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set background=dark
colorscheme xoria256

syntax on

filetype plugin indent on
set directory=~/.vim/tmp
set autochdir
set noerrorbells

set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db

set laststatus=2

set incsearch
set hlsearch
set ignorecase
set lazyredraw
set novisualbell
set number
set ruler
set scrolloff=3
set ttyfast
set undolevels=200
set updatecount=50
set showmatch matchtime=3

set smartcase
set shiftwidth=4
set softtabstop=4
set tabstop=8
set bs=2
set autoindent
set expandtab
set smarttab

au FileType helpfile set nonumber      " no line numbers when viewing help
au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

set textwidth=79
au FileType mail,tex set textwidth=72

set smartindent
set cindent

augroup filetypedetect
    au! BufRead,BufNewFile *.pp     setfiletype puppet
augroup END
augroup puppet
  autocmd!
  autocmd BufWritePost *.pp !puppet parser validate <afile>
  autocmd BufWritePost *.pp !puppet-lint <afile>
augroup END

autocmd FileType ruby,puppet,yaml,json set shiftwidth=2

highlight TrailWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match TrailWhitespace /\s\+$\| \+\ze\t/
