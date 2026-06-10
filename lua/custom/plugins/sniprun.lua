return {
  'michaelb/sniprun',
  build = 'sh install.sh',
  config = function()
    vim.api.nvim_set_keymap('v', '<leader>r', '<Plug>SnipRun', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>r', '<Plug>SnipRun', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>SnipRunOperator', { silent = true })
  end,
}
