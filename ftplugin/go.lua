vim.keymap.set('n', '<leader>tm', function()
  require('dap-go').debug_test()
end, { desc = 'Dap [T]est [M]ethod' })

vim.keymap.set('n', '<leader>tlm', function()
  require('dap-go').debug_last_test()
end, { desc = 'Dap [T]est [L]ast [M]ethod' })

vim.keymap.set(
  'n', '<leader>tc', '<cmd>! go test ./... -cover<CR>',
  { desc = 'CLI [T]est [C]overage' }
)

vim.keymap.set(
  'n', '<leader>tc', '<cmd>! go test ./... -race<CR>',
  { desc = 'CLI [T]est [R]ace' }
)

vim.keymap.set(
  'n', '<leader>tc', '<cmd>! go test ./... -bench=.<CR>',
  { desc = 'CLI [T]est [B]ench' }
)

vim.keymap.set(
  'n', '<leader>tt', '<cmd>! go test ./... -race; go vet ./... <CR>',
  { desc = 'CLI [T]est [T]est' }
)

vim.keymap.set(
  'n', '<leader>tv', '<cmd>! go test ./... -v <CR>',
  { desc = 'CLI [T]est [V]erbose' }
)

-- Motion understands camelCase
require('spider').setup({ skipInsignificantPunctuation = false })
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
