return {
  'chrisgrieser/nvim-spider',
  lazy = true,
  ft = 'go',
  config = function()
    require('spider').setup {
      skipInsignificantPunctuation = false,
    }

    -- Set up keymaps immediately since we're already in a Go buffer
    vim.keymap.set({ 'n', 'o', 'x' }, 'w', "<cmd>lua require('spider').motion('w')<CR>", { buffer = true })
    vim.keymap.set({ 'n', 'o', 'x' }, 'e', "<cmd>lua require('spider').motion('e')<CR>", { buffer = true })
    vim.keymap.set({ 'n', 'o', 'x' }, 'b', "<cmd>lua require('spider').motion('b')<CR>", { buffer = true })
  end,
}
