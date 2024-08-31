-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- Indentation keymaps
vim.api.nvim_set_keymap('n', '<Space>', 'za', { noremap = true, silent = true })

-- Configure stuff for VimVista
vim.api.nvim_set_keymap('n', '<Leader>vv', ':Vista!!<CR>', { noremap = true, desc = "[V]iew [Vista]" })

-- NVIM Tree
vim.api.nvim_set_keymap(
  'n', '<Leader>ntf', ':NvimTreeFindFile<CR>',
  { noremap = true, desc = "[N]Vim [T]ree [F]ind" }
)

-- JsonPath
vim.keymap.set("n", "<Leader>json", ":JsonPath<CR>")
vim.keymap.set("n", "<Leader>qjson", ":JsonPath ")

-- Enable UndoTree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- CopilotChat.nvim keymaps
vim.keymap.set('n', '<leader>cc', ':CopilotChat<CR>', { noremap = true, silent = true, desc = '[C]opilot [C]hat' })
vim.keymap.set('n', '<leader>cq', ':CopilotChatQuick<CR>', { noremap = true, silent = true, desc = '[C]opilot [Q]uick' })
vim.keymap.set('n', '<leader>cs', ':CopilotChatStop<CR>', { noremap = true, silent = true, desc = '[C]opilot [S]top' })
vim.keymap.set('n', '<leader>cr', ':CopilotChatRestart<CR>',
  { noremap = true, silent = true, desc = '[C]opilot [R]estart' })
vim.keymap.set('n', '<leader>cl', ':CopilotChatLog<CR>', { noremap = true, silent = true, desc = '[C]opilot [L]og' })
vim.keymap.set('n', '<leader>ch', ':CopilotChatHelp<CR>', { noremap = true, silent = true, desc = '[C]opilot [H]elp' })


-- Motion understands camelCase
vim.keymap.set(
  { "n", "o", "x" },
  "w",
  "<cmd>lua require('spider').motion('w')<CR>",
  { desc = "Spider-w" }
)
vim.keymap.set(
  { "n", "o", "x" },
  "e",
  "<cmd>lua require('spider').motion('e')<CR>",
  { desc = "Spider-e" }
)
vim.keymap.set(
  { "n", "o", "x" },
  "b",
  "<cmd>lua require('spider').motion('b')<CR>",
  { desc = "Spider-b" }
)
