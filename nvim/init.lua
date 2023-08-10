function map(mode, lhs, rhs, opts)
  local options = {
    noremap = true
  }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Options Configuration
vim.opt.syntax = "enable"
vim.opt.signcolumn = "yes"
vim.opt.showmode = true
vim.opt.wrap = false
vim.opt.smartcase = true
-- vim.opt.cursorline = true
vim.opt.ttyfast = true
vim.opt.lazyredraw = true
vim.opt.laststatus = 2
vim.opt.autoindent = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.background = "dark"
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.undolevels = 1000
vim.opt.backspace = {"indent", "eol", "start"}
vim.o.fillchars = "vert: ,eob: "
vim.opt.colorcolumn = "101"
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.vscode_italic_comment = 1
vim.g.nvim_tree_respect_buf_cwd = 1
vim.cmd [[
  hi CursorLine cterm=NONE ctermbg=236
  hi VertSplit cterm=NONE ctermbg=245 ctermfg=245
  hi Pmenu ctermbg=black ctermfg=white
  hi ColorColumn guibg=#a9a9a9 ctermbg=236
]]

-- Extensions
require("packer").startup(function(user)
  use "wbthomason/packer.nvim"
  use "mfussenegger/nvim-dap"
  use {
    "rcarriga/nvim-dap-ui",
    requires = {" mfussenegger/nvim-dap"}
  }
  use "RRethy/vim-illuminate"
  use "lukas-reineke/indent-blankline.nvim"
  use "Mofiqul/vscode.nvim"
  use "akinsho/toggleterm.nvim"
  use {
    "ibhagwan/fzf-lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
      branch = "master"
    }
  }
  -- Surround
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })
  use "nvim-tree/nvim-tree.lua"
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {"JoosepAlviste/nvim-ts-context-commentstring"},
    run = function()
      require("nvim-treesitter.install").update({
        with_sync = true
      })
    end
  }
  -- Bufferline and Scope
  use {
    "akinsho/bufferline.nvim",
    tag = "*",
    requires = "nvim-tree/nvim-web-devicons"
  }
  use("tiagovla/scope.nvim")
  -- Auto close tag
  use "windwp/nvim-ts-autotag"
  -- Auto pairs: nvim-autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-vsnip"
  use "hrsh7th/vim-vsnip"
  use "neovim/nvim-lspconfig"
  -- Comment
  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      })
    end
  }
end)

---------------------------
-- CUSTOM VANILLA BINDING
---------------------------
map("n", "tp", ":noh<CR>", {
  silent = true
})

---------------------------
-- TEXT EDITOR FEATURES:
-- FUZZY SEARCH, DIRECTORY
-- LIST & TERMINAL
---------------------------
-- Terminal
require"toggleterm".setup {
  size = 20,
  open_mapping = [[<c-\>]],
  shade_terminals = true,
  direction = "float"
}
-- Fuzzy Search: fzf-lua
require"fzf-lua".setup {
  fzf_bin = "sk",
  -- fzf_bin = "fzf"
  winopts = {
    width = 0.85,
    preview = {
      layout = "vertical",
      vertical = "down:60%",
      winopts = {
        number = false
      }
    }
  }
}
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", {
  noremap = true,
  silent = true
})
vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>lua require('fzf-lua').grep({ multiprocess=true })<CR>", {
  noremap = true,
  silent = false
})
vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>lua require('fzf-lua').buffers()<CR>", {
  noremap = true,
  silent = false
})
-- Files tree.
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  update_focused_file = {
    enable = true,
    update_cwd = true
  },
  renderer = {
    -- group_empty = true
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  "
      }
    }
  },
  filters = {
    dotfiles = true
  }
})
map("n", "th", ":NvimTreeToggle <CR>", {
  silent = true
})
map("n", "tf", ":NvimTreeFindFile <CR>", {
  silent = true
})

---------------------------
-- UI THEME
---------------------------
-- Buffer UI
require("bufferline").setup {}
require("scope").setup({})
-- VSCode theme
local c = require("vscode.colors").get_colors()
require("vscode").setup({
  -- Alternatively set style in setup
  style = "dark",

  -- Enable transparent background
  transparent = true,

  -- Enable italic comment
  italic_comments = true,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = true,

  -- Override highlight groups (see ./lua/vscode/theme.lua)
  group_overrides = {
    -- this supports the same val table as vim.api.nvim_set_hl
    -- use colors from this colorscheme by requiring vscode.colors!
    Cursor = {
      fg = c.vscDarkBlue,
      bg = c.vscLightGreen,
      bold = true
    },
    VertSplit = {
      fg = c.vscSplitDark,
      bg = "#3A3A3A"
    }
  }
})
require("vscode").load()

---------------------------
-- HIGHLIGHTER & TREESITTER
---------------------------
-- Showing IDE like blank line.
require("indent_blankline").setup {
  show_end_of_line = true,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true
}
-- Highlighter
require"nvim-treesitter.configs".setup {
  ensure_installed = {"go", "rust"},

  auto_install = true,
  context_commentstring = {
    enable = true
  },
  highlight = {
    enable = true
  },
  autotag = {
    enable = true
  },
  indent = {
    enable = true
  }
}
-- Illuminate tag highlight.
require("illuminate").configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {"lsp", "treesitter", "regex"},
  -- delay: delay in milliseconds
  delay = 100,
  -- filetype_overrides: filetype specific overrides.
  -- The keys are strings to represent the filetype while the values are tables that
  -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
  filetype_overrides = {},
  -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
  filetypes_denylist = {"dirvish", "fugitive", "NvimTree", "packer"},
  -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
  filetypes_allowlist = {},
  -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
  -- See `:help mode()` for possible values
  modes_denylist = {},
  -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
  -- See `:help mode()` for possible values
  modes_allowlist = {},
  -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
  -- Only applies to the 'regex' provider
  -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  providers_regex_syntax_denylist = {},
  -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
  -- Only applies to the 'regex' provider
  -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  providers_regex_syntax_allowlist = {},
  -- under_cursor: whether or not to illuminate under the cursor
  under_cursor = true,
  -- large_file_cutoff: number of lines at which to use large_file_config
  -- The `under_cursor` option is disabled when this cutoff is hit
  large_file_cutoff = nil,
  -- large_file_config: config to use for large files (based on large_file_cutoff).
  -- Supports the same keys passed to .configure
  -- If nil, vim-illuminate will be disabled for large files.
  large_file_overrides = nil,
  -- min_count_to_highlight: minimum number of matches required to perform highlighting
  min_count_to_highlight = 1
})

---------------------------
-- DEBUGGER
---------------------------
-- Debuggers Configuration.
vim.keymap.set("n", "<leader>b", function()
  require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "F5", function()
  require("dap").continue()
end)
-- Debugger Setup using DAP
local dap = require("dap")
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode-14", -- Change this if the version of lldb is different.
  name = "lldb"
}
-- CPP Debugger
dap.configurations.cpp = {
  name = "Launch",
  type = "lldb",
  request = "launch",
  program = function()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
  end,
  cwd = "${workspaceFolder}"
}
-- C Debugger
dap.configurations.c = dap.configurations.cpp
-- Rust Debugger
dap.configurations.rust = {
  name = "Launch",
  type = "lldb",
  request = "launch",
  program = function()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
  end,
  cwd = "${workspaceFolder}",
  initCommands = function()
    -- Find out where to look for the pretty printer Python module
    local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

    local script_import = "command script import \"" .. rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py\""
    local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

    local commands = {}
    local file = io.open(commands_file, "r")
    if file then

      for line in file:lines() do
        table.insert(commands, line)
      end
      file:close()
    end

    table.insert(commands, 1, script_import)
    return commands
  end
}
-- Golang Debugger
dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = {"dap", "-l", "127.0.0.1:${port}"}
  }
}
dap.configurations.go = {{
  type = "delve",
  name = "Debug",
  request = "launch",
  program = "${file}"
}, {
  type = "delve",
  name = "Debug test", -- configuration for debugging test files
  request = "launch",
  mode = "test",
  program = "${file}"
}, -- works with go.mod packages and sub packages 
{
  type = "delve",
  name = "Debug test (go.mod)",
  request = "launch",
  mode = "test",
  program = "./${relativeFileDirname}"
}}

---------------------------
-- AUTOCOMPLETE & LSP
---------------------------
-- Autocomplete: cmp
local cmp = require "cmp"
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      select = true
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, {"i", "s"}),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, {"i", "s"})
  }),
  sources = cmp.config.sources({{
    name = "nvim_lsp"
  }, {
    name = "vsnip"
  } -- For vsnip users.
  }, {{
    name = "buffer"
  }})
})
-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({{
    name = "cmp_git"
  } -- You can specify the `cmp_git` source if you were installed it.
  }, {{
    name = "buffer"
  }})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({"/", "?"}, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{
    name = "buffer"
  }}
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({{
    name = "path"
  }}, {{
    name = "cmdline"
  }})
})
-- LSP
-- Setup language servers.
local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- JavaScript TypeScript LSP 
lspconfig.tsserver.setup {
  capabilities = capabilities
}
-- Golang LSP
lspconfig.gopls.setup {
  capabilities = capabilities,
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true
      },
      staticcheck = true
    }
  }
}
-- Python LSP
lspconfig.pyright.setup {
  capabilities = capabilities
}
-- CPP LSP
lspconfig.clangd.setup {
  capabilities = capabilities
}
-- Rust LSP
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = false
      }
    }
  }
}
-- Auto pairs and autocomplete integration.
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- Native LSP Mapping
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = {
      buffer = ev.buf
    }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format {
        async = true
      }
    end, opts)
  end
})
-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format {
      async = false
    }
    vim.lsp.buf.code_action({
      context = {
        only = {"source.organizeImports"}
      },
      apply = true
    })
  end
})
