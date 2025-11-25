vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.yaml',
  callback = function()
    local first_50 = table.concat(vim.api.nvim_buf_get_lines(0, 0, 50, false), '\n')
    if first_50:match 'apiVersion:' and first_50:match 'kind:' then
      vim.bo.filetype = 'yaml.kubernetes'
    end
    if vim.api.nvim_buf_get_name(0):match 'kustomization%.yaml$' then
      vim.bo.filetype = 'yaml.kubernetes'
    end
  end,
})
