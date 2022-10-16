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
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }
  use { "ibhagwan/fzf-lua",  requires = { "kyazdani42/nvim-web-devicons" }}
  use "wbthomason/packer.nvim"
  use "voldikss/vim-floaterm"
  use "tpope/vim-fugitive"
  use { "mg979/vim-visual-multi", branch = "master" }
  use "jiangmiao/auto-pairs"
  use "scrooloose/nerdcommenter"
  use "tpope/vim-surround"
  use "itchyny/lightline.vim"
  use { "neoclide/coc.nvim", branch = "release" }
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

  -- FZF
  require'fzf-lua'.setup {
    fzf_bin         = "sk"
  }

  -- Keybindings
  vim.api.nvim_set_keymap("n", "<C-p>",
    "<cmd>lua require('fzf-lua').files()<CR>",
    { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-g>",
    "<cmd>lua require('fzf-lua').grep({ multiprocess=true })<CR>",
    { noremap = true, silent = false })
  vim.api.nvim_set_keymap("n", "<C-a>",
    "<cmd>lua require('fzf-lua').buffers()<CR>",
    { noremap = true, silent = false })
  map("n", "th", ":NeoTreeFocusToggle<CR>", { silent = true })
  map("n", "tf", ":NeoTreeRevealToggle<CR>", { silent = true })
  map("n", "tp", ":noh<CR>", { silent = true })
  map("n", "tn", ":tabnew<CR>", { silent = true })

  -- Globals
  vim.g.lightline              = { colorscheme = "ayu_dark" }

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

  -- Some servers have issues with backup files, see #649.
  vim.opt.backup = false
  vim.opt.writebackup = false

  -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  -- delays and poor user experience.
  vim.opt.updatetime = 300

  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appear/become resolved.
  -- vim.opt.signcolumn = "yes"

  local keyset = vim.keymap.set

  -- Use tab for trigger completion with characters ahead and navigate.
  -- NOTE: There's always complete item selected by default, you may want to enable
  -- no select by `"suggest.noselect": true` in your configuration file.
  -- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  -- other plugin before putting this into your config.
  local opts = {silent = true, noremap = true, expr = true}
  vim.cmd[[
    inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
  ]]
  keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

  -- Make <CR> to accept selected completion item or notify coc.nvim to format
  -- <C-g>u breaks current undo, please make your own choice.
  keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

  -- Use <c-j> to trigger snippets
  --keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
  -- Use <c-space> to trigger completion.
  keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

  -- Use `[g` and `]g` to navigate diagnostics
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
  keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

  -- GoTo code navigation.
  keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
  keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
  keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
  keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


  -- Use K to show documentation in preview window.
  function _G.show_docs()
      local cw = vim.fn.expand('<cword>')
      if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
      elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
      else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
      end
  end
  keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


  -- Highlight the symbol and its references when holding the cursor.
  vim.api.nvim_create_augroup("CocGroup", {})
  vim.api.nvim_create_autocmd("CursorHold", {
      group = "CocGroup",
      command = "silent call CocActionAsync('highlight')",
      desc = "Highlight symbol under cursor on CursorHold"
  })

  -- Formatting selected code.
  keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
  keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

  -- Setup formatexpr specified filetype(s).
  vim.api.nvim_create_autocmd("FileType", {
      group = "CocGroup",
      pattern = "typescript,json",
      command = "setl formatexpr=CocAction('formatSelected')",
      desc = "Setup formatexpr specified filetype(s)."
  })

  -- Update signature help on jump placeholder.
  vim.api.nvim_create_autocmd("User", {
      group = "CocGroup",
      pattern = "CocJumpPlaceholder",
      command = "call CocActionAsync('showSignatureHelp')",
      desc = "Update signature help on jump placeholder"
  })

  -- Applying codeAction to the selected region.
  -- Example: `<leader>aap` for current paragraph
  local opts = {silent = true, nowait = true}
  keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
  keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

  -- Remap keys for applying codeAction to the current buffer.
  keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)


  -- Apply AutoFix to problem on the current line.
  keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)


  -- Run the Code Lens action on the current line.
  keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


  -- Map function and class text objects
  -- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
  keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
  keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
  keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
  keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
  keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
  keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
  keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)


  -- Remap <C-f> and <C-b> for scroll float windows/popups.
  ---@diagnostic disable-next-line: redefined-local
  local opts = {silent = true, nowait = true, expr = true}
  keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
  keyset("i", "<C-f>",
         'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
  keyset("i", "<C-b>",
         'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
  keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
  keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


  -- Use CTRL-S for selections ranges.
  -- Requires 'textDocument/selectionRange' support of language server.
  keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
  keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


  -- Add `:Format` command to format current buffer.
  vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

  -- " Add `:Fold` command to fold current buffer.
  vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

  -- Add `:OR` command for organize imports of the current buffer.
  vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

  -- Add (Neo)Vim's native statusline support.
  -- NOTE: Please see `:h coc-status` for integrations with external plugins that
  -- provide custom statusline: lightline.vim, vim-airline.
  vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

  -- Mappings for CoCList
  -- code actions and coc stuff
  ---@diagnostic disable-next-line: redefined-local
  local opts = {silent = true, nowait = true}
  -- Show all diagnostics.
  keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
  -- Manage extensions.
  keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
  -- Show commands.
  keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
  -- Find symbol of current document.
  keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
  -- Search workspace symbols.
  keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
  -- Do default action for next item.
  keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
  -- Do default action for previous item.
  keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
  -- Resume latest coc list.
  keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
end)
