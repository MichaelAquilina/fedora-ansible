local vim = vim

vim.opt.title = true;

vim.g.cp = false;

-- old init.vim code will slowly be migrated out of this file
vim.cmd("source ~/.config/nvim/legacy.vim");

vim.o.termguicolors = true;
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0

vim.g.mapleader = " ";

-- Python configuration
vim.python_host_prog = '/usr/bin/python';
vim.python3_host_prog = '/usr/bin/python3';

local packer = require('packer');
packer.startup(function(use)
  use('wbthomason/packer.nvim');

  -- colorscheme
  use({'folke/tokyonight.nvim', branch = 'main' });

  -- Functionality
  use({'wellle/targets.vim'});
  use({'kyazdani42/nvim-tree.lua'});
  use('norcalli/nvim-colorizer.lua');
  use('lukas-reineke/indent-blankline.nvim');
  use({'akinsho/bufferline.nvim', branch = 'main'});

  use({
    'Pocco81/auto-save.nvim',
    config = function()
      require("auto-save").setup {
        -- your config goes here
	-- or just leave it empty :)
      }
    end
  })

  -- Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  })
  use({'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- Language support
  use({'towolf/vim-helm'});

  -- LSP
  use({'VonHeikemen/lsp-zero.nvim'});
  use({'soulis-1256/eagle.nvim'});
  use({'neovim/nvim-lspconfig'});
  use ({
    "nvimdev/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
        require("lspsaga").setup({})
    end,
})

  use('ray-x/lsp_signature.nvim');
  use('williamboman/mason.nvim');
  use('williamboman/mason-lspconfig.nvim')

  use('hrsh7th/nvim-cmp');
  use('hrsh7th/cmp-nvim-lsp');
  use('L3MON4D3/LuaSnip');
  use('saadparwaiz1/cmp_luasnip');
  use('onsails/lspkind-nvim');

  -- Treesitter
  use({'nvim-treesitter/nvim-treesitter'});
  use({'nvim-treesitter/nvim-treesitter-textobjects'});
  use({'windwp/nvim-ts-autotag'});

  -- Git
  use('tpope/vim-fugitive');
  use('tpope/vim-rhubarb');

  use('tpope/vim-sleuth');  -- Automatic tab expand configuration
  use('tpope/vim-commentary');  -- Comment out blocks of code
  use({
    'kylechui/nvim-surround',
    tag = '*',
    config = function()
        require("nvim-surround").setup({
        })
    end
  });  -- change surrounding elements
end);


vim.g.tokyonight_style = 'night';
vim.cmd("colorscheme tokyonight");

-- Bufferline

require("bufferline").setup{}

vim.o.spell = true;

-- Telescope
local telescope = require('telescope')
telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
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

-- Colorizer

require('colorizer').setup()

--- Eagle

require('eagle').setup({})
vim.o.mousemoveevent = true

-- Treesitter configuration

require('nvim-tree').setup()


local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
  autotag = { enable = true },
  ensure_installed = "all",
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
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {},
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
    { name = "buffer" }, -- text within the current buffer
    { name = "path" }, -- file system paths
  }),
})

-- NvimTree
vim.g.nvim_tree_ignore = { '.git' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_show_icons = {
    git = 0,
    folders= 1,
    files = 0,
    folder_arrows = 1,
};

vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>el', ':edit ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>ez', ':edit ~/.zshrc<cr>')
vim.keymap.set('n', '<leader>es', ':edit ~/.config/sway/config<cr>')
vim.keymap.set('n', '<leader>ek', ':edit ~/.config/kitty/kitty.conf<cr>')

vim.keymap.set('n', '<c-p>', ':Telescope find_files find_command=rg,--ignore,-g,!.git/,--hidden,--files<cr>')
vim.keymap.set('n', '<c-b>', ':Telescope buffers<cr>')
vim.keymap.set('n', '<c-k>', ':Telescope live_grep<cr>')

vim.keymap.set('v', 'cp', '"+y')
vim.keymap.set('n', 'vp', '"+p')

vim.keymap.set('n', 'Q', '<nop>') -- Disable Ex mode
vim.keymap.set('n', '<c-s>', '<nop>') -- Disable stop redraw

vim.keymap.set('n', '<esc>',':let @/=""<cr>') -- Cancel current search

-- Quickly move lines up and down
vim.keymap.set('n', '-', 'ddp')
vim.keymap.set('n', '_', 'ddkP')

vim.keymap.set('n', '<leader>,', ':call CopyRelativePath(0)<cr>')
vim.keymap.set('n', '<leader>.', ':call CopyRelativePath(1)<cr>')

vim.keymap.set('n', '<leader>]', '<Plug>(GitGutterNextHunk)')
vim.keymap.set('n', '<leader>[', '<Plug>(GitGutterPrevHunk)')

vim.keymap.set('n', 'gs', ':Lspsaga signature_help<CR>')
vim.keymap.set('n', 'K', ':Lspsaga hover_doc<CR>')
vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse>:lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'ca', ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'cd', ':lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'gu', ':Telescope lsp_references<CR>')

vim.keymap.set('v', '<leader>gb', ':GBrowse<cr>')

vim.keymap.set('n', '<leader>/', ':NvimTreeToggle<cr>')

-- Miscellaneous options

vim.o.list = true;
vim.o.completeopt = "menuone,noinsert,noselect";
vim.o.encoding = "utf-8";
vim.o.emoji = true;
vim.o.inccommand =  "nosplit"  -- Enable previewing of %s//
vim.o.mouse = "a"
vim.o.wrap = false;
vim.o.number = true;
vim.o.hidden = true;
vim.o.backup = false;
vim.o.writebackup = false;
vim.o.swapfile = false;
vim.o.cursorline = true;
vim.o.cursorcolumn = true;
vim.o.expandtab = true;
vim.o.shiftwidth = 4
vim.o.tabstop = 4
