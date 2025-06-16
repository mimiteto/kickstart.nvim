-- The deps here are NOT actually dependencies of the "main" plugin not is the "main" plugin main!

return {
  { 'echasnovski/mini.surround', event = 'VeryLazy' },
  {
    'folke/zen-mode.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  -- Inc/decr dates
  { 'tpope/vim-speeddating', event = 'VeryLazy' },
  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  -- Sessions for neovim
  { 'tpope/vim-obsession', event = 'VeryLazy' },
  {
    'chentoast/marks.nvim', -- Better marks
    event = 'VeryLazy',
    opts = {},
  },
}
