local function setup_diff_mappings()
  vim.api.nvim_create_autocmd('DiffUpdated', {
    pattern = '*',
    callback = function()
      if vim.opt.diff:get() then
        vim.keymap.set('n', '<leader>dfg', '<cmd>diffget<CR>', {
          buffer = true,
          desc = '[D]i[F]f [G]et',
        })
        vim.keymap.set('n', '<leader>dfp', '<cmd>diffput<CR>', {
          buffer = true,
          desc = '[D]i[F]f [P]ut',
        })
      end
    end,
  })
  WK = require 'which-key'
  WK.add {
    { '<leader>df', desc = '[D]if[F]' },
    { '<leader>df_', hidden = true },
  }
end

return { setup = setup_diff_mappings }
