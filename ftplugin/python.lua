vim.o.foldmethod = 'indent'

vim.keymap.set('n', '<leader>tm', function()
  require('dap-python').test_method()
end, { desc = 'Dap [T]est [M]ethod' })

vim.keymap.set('n', '<leader>tc', function()
  require('dap-python').test_class()
end, { desc = 'Dap [T]est [C]lass' })

vim.keymap.set('n', '<leader>tf', function()
  require('dap-python').test_file()
end, { desc = 'Dap [T]est [F]ile' })

vim.keymap.set('n', '<leader>rp', function()
  vim.cmd('!python %<CR>')
end, { desc = '[R]un [P]rogram' })

vim.keymap.set('n', '<leader>rpa', function()
  vim.cmd('!python %')
end, { desc = '[R]un [P]rogram with [A]rgs' })
