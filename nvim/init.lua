--Vim Highlight
vim.cmd[[
  syntax on
  hi CursorLine cterm=NONE ctermbg=236
  hi VertSplit cterm=NONE ctermbg=245 ctermfg=245
  hi Pmenu ctermbg=black ctermfg=white
  hi ColorColumn guibg=#a9a9a9 ctermbg=236
  set noshowmode
  set nowrap
  syntax enable
  set hidden
  set linebreak
  set showmatch
  set visualbell
  set mouse=n
  set hlsearch
  set smartcase
  set ignorecase
  set incsearch
  set cursorline
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
  set colorcolumn=100
]]

-- Options Configuration
vim.o.fillchars = "vert: ,eob:_"

require("packer").startup(function(use)
  -- Extensions
  use "wbthomason/packer.nvim"
	use "junegunn/fzf"
	use "junegunn/fzf.vim"
  use "voldikss/vim-floaterm"
  use "tpope/vim-fugitive"
  use { "mg979/vim-visual-multi", branch = "master" }
  use "jiangmiao/auto-pairs"
  use "alvan/vim-closetag"
  use "scrooloose/nerdcommenter"
  use "scrooloose/nerdtree"
  use "tpope/vim-surround"
  use "itchyny/lightline.vim"
  use "neovim/nvim-lspconfig"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
  }

  -- Keybinding helpers
  function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end

  -- Keybindings
  map("n", "<C-p>", ":FZF<CR>", { silent = true })
  map("n", "<C-a>", ":Buffers<CR>", { silent = true })
  map("n", "th", ":NERDTreeToggle<CR>", { silent = true })
  map("n", "tf", ":NERDTreeFind<CR>", { silent = true })
  map("n", "tp", ":noh<CR>", { silent = true })
  map("n", "tn", ":tabnew<CR>", { silent = true })
  map("n", "<C-f>", ":Ag ")

  -- Globals
  vim.g.closetag_filenames                = "*.html,*.xhtml,*.phtml,*.tsx,*.jsx"
  vim.g.closetag_xhtml_filenames          = "*.xhtml,*.tsx,*.xml,*.jsx"
  vim.g.closetag_emptyTags_caseSensitive  = 1
  vim.g.closetag_close_shortcut           = "<leader>>"
  vim.g.lightline                         = { colorscheme = "ayu_dark" }

  -- Floaterm Globals
  vim.g.floaterm_title         = "[$1 of $2]"
  vim.g.floaterm_keymap_new    = "<Leader>fc"
  vim.g.floaterm_keymap_prev   = "<Leader>fp"
  vim.g.floaterm_keymap_next   = "<Leader>fn"
  vim.g.floaterm_keymap_toggle = "<Leader>ft"
  vim.g.floaterm_keymap_kill   = "<Leader>fx"
  vim.g.floaterm_width         = 0.9999
  vim.g.floaterm_position      = "bottom"

  -- Neovim treesitter
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "rust",
      "cpp",
      "javascript",
      "typescript",
      "python",
      "dart",
      "java",
      "go",
      "c_sharp",
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
  }

  -- LSP Configuration
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }
  require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
  }
  require'lspconfig'.gopls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require'lspconfig'.clangd.setup{
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require'lspconfig'.jdtls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
  }
end)
