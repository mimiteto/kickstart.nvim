vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
  pattern = '*.py',
  callback = function()
    vim.o.foldmethod = 'indent'
  end,
})
