set nocompatible
filetype off

syntax enable
set number relativenumber
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
Plugin 'tpope/vim-commentary'
Plugin 'dyng/ctrlsf.vim'
Plugin 'vim-airline/vim-airline'

" Language support.
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'thosakwe/vim-flutter'
Plugin 'peitalin/vim-jsx-typescript'

nnoremap tn :tabnew<CR>
call vundle#end()    
filetype plugin indent on

" Language server for flutter
let g:lsc_auto_map = v:true
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" CtrlP configuration
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" CtrSF configuration
let g:ctrlsf_ackprg = 'ag'
let g:ctrlsf_position = 'bottom'
