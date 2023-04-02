-- Util function
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
vim.opt.syntax = 'enable'
vim.opt.showmode = true
vim.opt.wrap = false
vim.opt.mouse = 'n'
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
vim.opt.background = 'dark'
vim.opt.expandtab = true
vim.opt.undolevels = 1000
vim.opt.backspace = {'indent', 'eol', 'start'}
vim.o.fillchars = "vert: ,eob:_"
vim.opt.colorcolumn = "101"
vim.cmd [[
      hi CursorLine cterm=NONE ctermbg=236
      hi VertSplit cterm=NONE ctermbg=245 ctermfg=245
      hi Pmenu ctermbg=black ctermfg=white
      hi ColorColumn guibg=#a9a9a9 ctermbg=236
    ]]

-- Extensions
require('packer').startup(function(user)
    use 'Mofiqul/vscode.nvim'
    use "wbthomason/packer.nvim"
    use 'akinsho/toggleterm.nvim'
    use {
        'ibhagwan/fzf-lua',
        requires = {'kyazdani42/nvim-web-devicons'}
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
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {"nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"}
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({
                with_sync = true
            })
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }
    -- Auto close tag
    use 'windwp/nvim-ts-autotag'

    -- Auto pairs: nvim-autopairs
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    use {
      "windwp/nvim-spectre",
      requires = { "nvim-lua/plenary.nvim" }
    }

    -- Terminal
    require'toggleterm'.setup {
        size = 20,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        direction = 'float'
    }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'neovim/nvim-lspconfig'
    -- Comment
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
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

    -- Folder Tree Explorer: Neo-tree
    map("n", "th", ":NeoTreeShowToggle<CR>", {
        silent = true
    })
    map("n", "tf", ":NeoTreeRevealToggle<CR>", {
        silent = true
    })

    -- Highlighter
    require'nvim-treesitter.configs'.setup {
        ensure_installed = {"rust", "cpp", "javascript", "typescript", "go"},
        auto_install = true,
        highlight = {
            enable = true
        },
        autotag = {
            enable = true
        }
    }

    -- Statusline
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'vscode',
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
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff'},
            lualine_c = {'filename'},
            lualine_x = {'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = {'tabs'},
            lualine_b = {'filename'},
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
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
        VertSplit = {fg=c.vscSplitDark, bg='#545454'}
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
