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
vim.opt.cursorline = true
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
vim.cmd [[
      hi CursorLine cterm=NONE ctermbg=236
      hi VertSplit cterm=NONE ctermbg=245 ctermfg=245
      hi Pmenu ctermbg=black ctermfg=white
      hi ColorColumn guibg=#a9a9a9 ctermbg=236
    ]]

-- Extensions
require("packer").startup(function(user)
    use "RRethy/vim-illuminate"
    use "lukas-reineke/indent-blankline.nvim"
    use "Mofiqul/vscode.nvim"
    use "wbthomason/packer.nvim"
    use "akinsho/toggleterm.nvim"
    use {
        "ibhagwan/fzf-lua",
        requires = {"nvim-tree/nvim-web-devicons"}
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
        run = function()
            require("nvim-treesitter.install").update({
                with_sync = true
            })
        end
    }
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
            opt = true
        }
    }
    -- Auto close tag
    use "windwp/nvim-ts-autotag"

    -- Auto pairs: nvim-autopairs
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    use {
        "windwp/nvim-spectre",
        requires = {"nvim-lua/plenary.nvim"}
    }
    use "hrsh7th/cmp-nvim-lsp"
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use 'neovim/nvim-lspconfig'
    -- Comment
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    require("indent_blankline").setup {
        show_end_of_line = true
    }

    -- Terminal
    require"toggleterm".setup {
        size = 20,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        direction = 'float'
    }

    -- Fuzzy Search: fzf-lua
    require'fzf-lua'.setup {
        fzf_bin = "sk"
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
        renderer = {
            group_empty = true
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

    -- Highlighter
    require"nvim-treesitter.configs".setup {
        ensure_installed = {"rust", "cpp", "javascript", "typescript", "go"},
        auto_install = true,
        highlight = {
            enable = true
        },
        autotag = {
            enable = true
        }
    }

    -- Illuminate tag highlight.
    require('illuminate').configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {'lsp', 'treesitter', 'regex'},
        -- delay: delay in milliseconds
        delay = 100,
        -- filetype_overrides: filetype specific overrides.
        -- The keys are strings to represent the filetype while the values are tables that
        -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
        filetype_overrides = {},
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {'dirvish', 'fugitive'},
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

    -- Statusline
    require("lualine").setup {
        options = {
            icons_enabled = true,
            theme = "vscode",
            component_separators = "",
            section_separators = {
                left = "",
                right = ""
            },
            disabled_filetypes = {
                statusline = {},
                winbar = {}
            },
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000
            }
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {"branch", "diff"},
            lualine_c = {"filename"},
            lualine_x = {"filetype"},
            lualine_y = {"progress"},
            lualine_z = {"location"}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {"filename"},
            lualine_x = {"location"},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = {"tabs"},
            lualine_b = {{
                "filename",
                path = 1,
                file_status = true
            }},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }

    -- Autocomplete: cmp
    local cmp = require 'cmp'
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
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({
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
            name = 'nvim_lsp'
        }, {
            name = 'vsnip'
        } -- For vsnip users.
        }, {{
            name = 'buffer'
        }})
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({{
            name = 'cmp_git'
        } -- You can specify the `cmp_git` source if you were installed it.
        }, {{
            name = 'buffer'
        }})
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({'/', '?'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{
            name = 'buffer'
        }}
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{
            name = 'path'
        }}, {{
            name = 'cmdline'
        }})
    })

    -- LSP

    -- Setup language servers.
    require("mason").setup()
    require("mason-lspconfig").setup()
    local lspconfig = require('lspconfig')
    local util = require('lspconfig/util')

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lspconfig.tsserver.setup {
        capabilities = capabilities
    }
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
    lspconfig.pyright.setup {
        capabilities = capabilities
    }
    lspconfig.clangd.setup {
        capabilities = capabilities
    }
    lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        settings = {
            ['rust-analyzer'] = {
                diagnostics = {
                    enable = false
                }
            }
        }
    }

    -- Auto pairs and autocomplete integration
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

end)

local c = require('vscode.colors').get_colors()
require('vscode').setup({
    -- Alternatively set style in setup
    style = 'dark',

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
            bg = '#3A3A3A'
        }
    }
})
require('vscode').load()

-- Vanilla Binding
map("n", "tp", ":noh<CR>", {
    silent = true
})
map("n", "tn", ":tabnew<CR>", {
    silent = true
})

-- Native LSP Mapping
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = {
            buffer = ev.buf
        }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format {
                async = true
            }
        end, opts)
    end
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.format {
            async = false
        }
        vim.lsp.buf.code_action({
            context = {
                only = {'source.organizeImports'}
            },
            apply = true
        })
    end
})

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>', {
    desc = "Open Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
