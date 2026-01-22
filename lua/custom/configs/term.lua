vim.api.nvim_create_user_command('Tsplit', function()
  vim.cmd('split term://' .. SHELL)
end, { desc = 'Open terminal in horizontal split' })

vim.api.nvim_create_user_command('Tvsplit', function()
  vim.cmd('vsplit term://' .. SHELL)
end, { desc = 'Open terminal in vertical split' })

vim.api.nvim_create_user_command('Ttab', function()
  vim.cmd('tabnew term://' .. SHELL)
end, { desc = 'Open terminal in new tab' })
