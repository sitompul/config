set nocompatible
filetype off

syntax enable
" colorscheme industry
set number
set linebreak
set textwidth=100
set showmatch
set visualbell
set mouse=a

set hlsearch
set smartcase
set ignorecase
set incsearch

set ttyfast
set lazyredraw 

set autoindent
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=4
set background=dark
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
Plugin 'dyng/ctrlsf.vim'
Plugin 'preservim/nerdtree'
nnoremap tn :tabnew<CR>
map <C-n> :NERDTreeToggle<CR>
call vundle#end()    
filetype plugin indent on

" CtrlP configuration
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" CtrSF configuration
let g:ctrlsf_ackprg = 'ag'
let g:ctrlsf_position = 'bottom'
