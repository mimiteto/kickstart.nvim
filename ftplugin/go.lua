vim.keymap.set('n', '<leader>tm', function()
  require('dap-go').debug_test()
end, { desc = 'Dap [T]est [M]ethod' })

vim.keymap.set('n', '<leader>tlm', function()
  require('dap-go').debug_last_test()
end, { desc = 'Dap [T]est [L]ast [M]ethod' })

vim.keymap.set(
  'n', '<leader>tc', '<cmd>! go test -cover<CR>',
  { desc = 'CLI [T]est [C]overage' }
)

vim.keymap.set(
  'n', '<leader>tc', '<cmd>! go test -race<CR>',
  { desc = 'CLI [T]est [R]ace' }
)

vim.keymap.set(
  'n', '<leader>tc', '<cmd>! go test -bench=.<CR>',
  { desc = 'CLI [T]est [B]ench' }
)

vim.keymap.set(
  'n', '<leader>tt', '<cmd>! go test -race; go vet<CR>',
  { desc = 'CLI [T]est [T]est' }
)
