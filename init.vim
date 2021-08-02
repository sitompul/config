set nocompatible
set nowrap
filetype off
set noshowmode
syntax enable
set number
set hidden
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

Plug 'voldikss/vim-floaterm'
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

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

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


" COC Diagnostic
nmap <silent> <space>j :call CocAction('diagnosticNext')<cr>
nmap <silent> <space>k :call CocAction('diagnosticPrevious')<cr>

" Float term
let g:floaterm_keymap_new    = '<Leader>fc'
let g:floaterm_keymap_prev   = '<Leader>fp'
let g:floaterm_keymap_next   = '<Leader>fn'
let g:floaterm_keymap_toggle = '<Leader>ft'
let g:floaterm_keymap_kill = '<Leader>fq'

"Syntax highlighting for neovim
if has('nvim')
lua <<EOF
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
  ensure_installed = {
    "go",
    "javascript",
    "typescript",
    "swift",
    "php",
    "dart",
    "rust",
    "html",
    "rust",
    "toml",
    "c",
    "cpp",
    "c_sharp",
    "bash",
    "vue",
    "python",
    "graphql",
    "java",
    "dockerfile",
    "kotlin",
    "json"
  }
}
EOF
endif

" Coc Default Configuration.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
