return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', vim.tbl_extend('force', opts, { desc = 'Diagnostics (Trouble)' }))
    vim.keymap.set(
      'n',
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      vim.tbl_extend('force', opts, { desc = 'Buffer Diagnostics (Trouble)' })
    )
    vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', vim.tbl_extend('force', opts, { desc = 'Symbols (Trouble)' }))
    vim.keymap.set(
      'n',
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      vim.tbl_extend('force', opts, { desc = 'LSP Definitions / references / ... (Trouble)' })
    )
    vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>', vim.tbl_extend('force', opts, { desc = 'Location List (Trouble)' }))
    vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', vim.tbl_extend('force', opts, { desc = 'Quickfix List (Trouble)' }))
  end,
}
