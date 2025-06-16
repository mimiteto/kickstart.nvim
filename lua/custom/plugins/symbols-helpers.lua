return {
  { 'liuchengxu/vista.vim', event = 'VeryLazy' },
  {
    'hedyhli/outline.nvim',
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })

      require('outline').setup {
        keymaps = {
          up_and_jump = '<C-p>',
          down_and_jump = '<C-n>',
        },
        symbol_folding = {
          autofold_depth = 1,
          auto_unfold = {
            hovered = true,
          },
        },
        preview_window = {
          auto_preview = true,
        },
        -- Do I need those lines?
        outline_items = {
          show_symbol_lineno = true,
        },
      }
    end,
    event = 'VeryLazy',
  },
}
