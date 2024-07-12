vim.keymap.set('n', '<leader>tm', function()
  require('dap-go').debug_test()
end, { desc = 'Dap [T]est [M]ethod' })

vim.keymap.set('n', '<leader>tlm', function()
  require('dap-go').debug_last_test()
end, { desc = 'Dap [T]est [L]ast [M]ethod' })
