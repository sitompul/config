" Vim Configuration
set nocompatible
filetype off

syntax enable
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
set undolevels=1000
set backspace=indent,eol,start
hi Pmenu ctermbg=black ctermfg=white

" Plugin List
call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'dyng/ctrlsf.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'wincent/terminus'
Plug 'scrooloose/nerdtree'

call plug#end()

"vim-closetag configuration
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.tsx,*.jsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.tsx,*.xml,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

" Plugin Configuration
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-o> :CtrlSF<space>
nmap <C-b> :NERDTreeToggle<CR>
