set nocompatible
set nowrap
filetype off

syntax enable
set number
set linebreak
set showmatch
set visualbell
set mouse=n
set rnu
set hlsearch
set smartcase
set ignorecase
set incsearch

set ttyfast
set lazyredraw

set laststatus=2
set autoindent
set shiftwidth=2
set smartindent
set smarttab
set tabstop=2
set softtabstop=2
set background=dark
set expandtab
set undolevels=1000
set backspace=indent,eol,start
hi Pmenu ctermbg=black ctermfg=white
set colorcolumn=100
hi ColorColumn guibg=#a9a9a9 ctermbg=236

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dyng/ctrlsf.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'

"IDE Support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'rust-lang/rust.vim'

call plug#end()

let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.tsx,*.jsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.tsx,*.xml,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
  \ 'typescript.tsx': 'jsxRegion,tsxRegion',
  \ 'javascript.jsx': 'jsxRegion',
  \ }
let g:closetag_close_shortcut = '<leader>>'
let g:lightline = {
  \ 'colorscheme': 'ayu_dark',
  \ }
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <C-a> :Buffers<CR>
nnoremap tn :tabnew<CR>
nnoremap th :NERDTreeToggle<CR>
nnoremap tf :NERDTreeFind<CR>
let NERDTreeShowHidden=1
nnoremap tp :noh<CR>
nnoremap <C-o> :CtrlSF<space>
nnoremap d "_d
vnoremap d "_d

setlocal winhighlight=Normal:PreviewWindowHighlight
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
