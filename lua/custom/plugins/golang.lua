return {
  {
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
  },
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    lazy = true,
    -- Breaks initial install
    -- build = function()
    --   vim.cmd.GoInstallDeps()
    -- end,
    config = function()
      vim.keymap.set(
        { 'n' },
        '<leader>gtaj',
        "<cmd>lua require('gopher').tags.add 'json'",
        { noremap = true, silent = true, desc = '[G]opher [T]ag [A]add [J]son' }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>gtrj',
        "<cmd>lua require('gopher').tags.rm 'json'",
        { noremap = true, silent = true, desc = '[G]opher [T]ag [R]emove [J]son' }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>gtaj',
        "<cmd>lua require('gopher').tags.add 'yaml'",
        { noremap = true, silent = true, desc = '[G]opher [T]ag [A]add [Y]aml' }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>gtrj',
        "<cmd>lua require('gopher').tags.rm 'yaml'",
        { noremap = true, silent = true, desc = '[G]opher [T]ag [R]emove [Y]aml' }
      )
      vim.keymap.set({ 'n' }, '<leader>gimpl', '<cmd>GoImpl ', { noremap = true, silent = true, desc = '[G]opher [T][M][P][L]ement interface' })
      vim.keymap.set({ 'n' }, '<leader>gcmt', '<cmd>GoCmt<CR>', { noremap = true, silent = true, desc = '[G]opher [C]o[M]men[T]' })
      vim.keymap.set({ 'n' }, '<leader>gerr', '<cmd>GoIfErr<CR>', { noremap = true, silent = true, desc = '[G]opher handle [E][R][R]' })
    end,
  },
}
