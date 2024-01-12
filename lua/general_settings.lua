-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'nv'

--- Disable wrap
vim.wo.wrap = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
if vim.fn.has('macunix') ~= 0 then
  vim.o.clipboard = 'unnamed'
  OPEN_CMD = 'open'
else
  vim.o.clipboard = 'unnamedplus'
  OPEN_CMD = 'xdg-open'
end

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- MEH, I want control over case sensitivity
-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = false
vim.o.smartcase = false

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Folds
vim.o.foldenable = false

-- Line at 100vim.opt.colorcolumn = "100"
vim.opt.colorcolumn = "100"

-- Set cursor according modes
vim.opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Nullify :W and :Q
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "W", "<nop>")

-- FormatJson
vim.api.nvim_command("com! FormatJSON %!jq")

-- Bind vball
vim.keymap.set("n", "<Leader>vball", ":vertical ball<CR>")

-- Disable background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Correct scroll level
vim.o.scrolloff = 8

-- Correct tabstop
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Exiting with a blinking cursor
vim.api.nvim_create_autocmd('VimLeave', {
  once = true,
  callback = function()
    vim.opt.guicursor =
    "n-v-c-i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
  end
})

-- Fugitive config
vim.api.nvim_create_user_command(
  'Browse',
  function(opts)
    vim.fn.system { OPEN_CMD, opts.fargs[1] }
  end,
  { nargs = 1 }
)
