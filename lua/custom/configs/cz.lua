local M = {}

function M.setup()
  vim.api.nvim_create_user_command('CZ', function()
    local file = vim.fn.expand '%:p'
    if file == '' then
      print 'CZ: no file in current buffer'
      return
    end
    local out = vim.fn.system { 'chezmoi', 'add', file }
    if vim.v.shell_error ~= 0 then
      print('CZ failed: ' .. out)
    else
      print('CZ added: ' .. file)
    end
  end, { desc = 'Track changes in chezmoi' })
end

return M
