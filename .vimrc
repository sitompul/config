set nocompatible
filetype off

syntax enable
colorscheme industry
set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch
set visualbell
set mouse=a

set ttyfast
set lazyredraw

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=4

set ruler
set undolevels=1000
set backspace=indent,eol,start

" Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'leafgarland/typescript-vim'
Plugin 'tpope/vim-commentary'
Plugin 'wincent/terminus'
nnoremap tn :tabnew<CR>
call vundle#end()    
filetype plugin indent on

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
