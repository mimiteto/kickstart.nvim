return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    config = function()
      require('treesitter-context').setup {
        multiline_threshold = 20000,
        trim_scope = 'inner',
      }
    end,
  },
}
