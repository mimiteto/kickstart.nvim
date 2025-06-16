-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Disable mouse mode
vim.o.mouse = ''

--- Disable wrap
vim.wo.wrap = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Folds
vim.o.foldenable = false

-- Line at 100
vim.opt.colorcolumn = '100'

-- Nullify :W and :Q
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', 'W', '<nop>')

-- Bind vball
vim.keymap.set('n', '<Leader>vball', ':vertical ball<CR>')

-- Correct tabstop
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
