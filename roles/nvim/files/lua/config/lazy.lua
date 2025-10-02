local vim = vim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim";
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.rtp:prepend(lazypath);

require("lazy").setup({
    -- colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]]);
            vim.g.tokyonight_style = 'night';
        end,
    },

    -- Functionality
    { 'mfussenegger/nvim-lint'},
    { 'cappyzawa/trim.nvim' },
    { 'numToStr/Comment.nvim' },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    { 'wellle/targets.vim' },
    { 'nvim-tree/nvim-tree.lua' },
    { 'nvim-tree/nvim-web-devicons' },

    { 'norcalli/nvim-colorizer.lua' },
    { 'lukas-reineke/indent-blankline.nvim' },
    { 'akinsho/bufferline.nvim', branch = 'main' },

    {
        'Pocco81/auto-save.nvim',
        config = function()
            require("auto-save").setup {}
        end
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
            },
        },
        opts = {
            defaults = {
                layout_strategy = 'flex',
            },
            layout_config = {
                height = 0.95,
                width = 0.95,
                vertical = {
                    preview_cutoff = 60,
                    preview_height = 0.7,
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                }
            },
            pickers = {
                buffers = {
                    sort_mru = true,
                    sort_lastused = true,
                }
            }
        }
    },
    -- Language support
    { 'towolf/vim-helm' },

    -- LSP
    { 'soulis-1256/eagle.nvim' },
    { 'neovim/nvim-lspconfig' },
    {
        "nvimdev/lspsaga.nvim",
        dependencies = { 'neovim/nvim-lspconfig' },
        config = function()
            require("lspsaga").setup({
                lightbulb = { enable = false }
            })
        end,
    },

    { 'ray-x/lsp_signature.nvim' },
    {
        'mason-org/mason-lspconfig.nvim',
        opts = {
        },
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'neovim/nvim-lspconfig',
        },
    },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'onsails/lspkind-nvim' },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },

    -- Git
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },
    { 'sindrets/diffview.nvim' },

    { 'tpope/vim-sleuth' },     -- Automatic tab expand configuration
    {
        'kylechui/nvim-surround',
        version = '*',
        event = 'VeryLazy',
        config = function()
            require("nvim-surround").setup({
            })
        end
    },


  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
});

require("bufferline").setup {}

local telescope = require('telescope')
telescope.load_extension("fzf");

require('colorizer').setup()

require('lint').linters_by_ft = {
    python = {'mypy'},
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  callback = function()
    require("lint").try_lint()
  end
})

require('trim').setup({
    ft_blocklist = {'patch'},
});

require('eagle').setup({})

require('nvim-tree').setup()

require('nvim-treesitter.configs').setup({
    autotag = { enable = true },
    ensure_installed = "all",
    ignore_install = { "hoon", "ipkg" },
    highlight = {
        enable = true
    },
    textobjects = {
        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
            }
        },
        move = {
            enable = true;
            set_jumps = true,
            goto_next_start = {
                ["]f"] = "@function.outer",
            },
        },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },
})

-- Lsp configuration
local cmp = require('cmp');
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    -- sources for autocompletion
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP
        { name = "buffer" },   -- text within the current buffer
        { name = "path" },     -- file system paths
    }),
})

require("nvim-tree").setup({
});

require("nvim-web-devicons").setup()
