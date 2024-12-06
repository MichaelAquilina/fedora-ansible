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
    { 'wellle/targets.vim' },
    { 'kyazdani42/nvim-tree.lua' },
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
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },

    -- Language support
    { 'towolf/vim-helm' },

    -- LSP
    { 'VonHeikemen/lsp-zero.nvim' },
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
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'onsails/lspkind-nvim' },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'windwp/nvim-ts-autotag' },

    -- Git
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },

    { 'tpope/vim-sleuth' },     -- Automatic tab expand configuration
    { 'tpope/vim-commentary' }, -- Comment out blocks of code
    {
        'kylechui/nvim-surround',
        version = '*',
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
telescope.setup({
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
});
telescope.load_extension("fzf");

require('colorizer').setup()

require('eagle').setup({})

require('nvim-tree').setup()

require('nvim-treesitter.configs').setup({
    autotag = { enable = true },
    ensure_installed = "all",
    ignore_install = { "hoon" },
    highlight = {
        enable = true
    },
    textobjects = {
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
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    automatic_installation = true,
    ensure_installed = {
        'pylsp',
        'lua_ls',
        'ts_ls',
        'clangd',
    },
    handlers = {
        lsp_zero.default_setup,
    }
})

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

-- NvimTree
vim.g.nvim_tree_ignore = { '.git' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    files = 0,
    folder_arrows = 1,
};
