vim.o.foldmethod = 'indent'

vim.keymap.set('n', '<leader>tm', function()
  require('dap-python').test_method()
end, { desc = 'Dap [T]est [M]ethod' })

vim.keymap.set('n', '<leader>tc', function()
  require('dap-python').test_class()
end, { desc = 'Dap [T]est [C]lass' })
