local M = {}

function M.setup()
  vim.api.nvim_create_user_command('CZ', function()
    vim.cmd '!chezmoi add %'
  end, { desc = 'Track changes in chezmoi' })
end
