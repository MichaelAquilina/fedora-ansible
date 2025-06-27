local vim = vim

vim.opt.title = true;

vim.g.cp = false;

-- TODO:
-- old init.vim code will slowly be migrated out of this file
vim.cmd("source ~/.config/nvim/legacy.vim");

vim.o.termguicolors = true;
vim.g.nvim_tree_disable_netrw = 0;
vim.g.nvim_tree_hijack_netrw = 0;
vim.g.editorconfig = false;

vim.g.mapleader = " ";

-- Python configuration
vim.g.python_host_prog = '/usr/bin/python';
vim.g.python3_host_prog = '/usr/bin/python3';

vim.o.spell = true;

-- Miscellaneous options

vim.o.mousemoveevent = true
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

require('config.lazy');

function CopyRelativePath(includeLineNumber)
    local filePath = vim.fn.expand('%');
    local lineNumber = vim.fn.line('.');
    if includeLineNumber then
        vim.api.nvim_echo({{'Copied relative path to clipboard (with line number)', 'None'}}, false, {});
        vim.fn.setreg('+', string.format('%s:%d', filePath, lineNumber))
    else
        vim.api.nvim_echo({{'Copied relative path to clipboard', 'None'}}, false, {});
        vim.fn.setreg('+', filePath);
    end
end

vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>el', ':edit ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>ez', ':edit ~/.zshrc<cr>')
vim.keymap.set('n', '<leader>es', ':edit ~/.config/sway/config<cr>')
vim.keymap.set('n', '<leader>ek', ':edit ~/.config/kitty/kitty.conf<cr>')

vim.keymap.set('n', '<leader>ff', ':lua vim.lsp.buf.format()<cr>')

vim.keymap.set('n', '<c-p>', ':Telescope find_files find_command=rg,--ignore,-g,!.git/,--hidden,--files<cr>')
vim.keymap.set('n', '<c-b>', ':Telescope buffers<cr>')
vim.keymap.set('n', '<c-k>', ':Telescope live_grep<cr>')

vim.keymap.set('v', 'cp', '"+y')
vim.keymap.set('n', 'vp', '"+p')

vim.keymap.set('n', 'Q', '<nop>')              -- Disable Ex mode
vim.keymap.set('n', '<c-s>', '<nop>')          -- Disable stop redraw

vim.keymap.set('n', '<esc>', ':let @/=""<cr>') -- Cancel current search

-- Quickly move lines up and down
vim.keymap.set('n', '-', 'ddp')
vim.keymap.set('n', '_', 'ddkP')

vim.keymap.set('n', '<leader>,', ':lua CopyRelativePath(false)<cr>')
vim.keymap.set('n', '<leader>.', ':lua CopyRelativePath(true)<cr>')

vim.keymap.set('n', '<leader>]', '<Plug>(GitGutterNextHunk)')
vim.keymap.set('n', '<leader>[', '<Plug>(GitGutterPrevHunk)')

vim.keymap.set('n', 'gs', ':Lspsaga signature_help<CR>')
vim.keymap.set('n', 'K', ':Lspsaga hover_doc<CR>')
vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse>:lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'ca', ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'cd', ':lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'gu', ':Telescope lsp_references<CR>')

vim.keymap.set('v', '<leader>gb', ':GBrowse!<cr>')

vim.keymap.set('n', '<leader>/', ':NvimTreeToggle<cr>')
