local M = {}

function M.setup()
  vim.keymap.set('n', '<leader>ts', '<cmd>Telescope <CR>', { desc = '[T]ele[s]cope' })
  vim.keymap.set('n', '<leader>tss', '<cmd>Telescope spell_suggest<CR>', { desc = '[T]ele[s]cope [S]pell' })
end

return M
