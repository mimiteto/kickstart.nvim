return {
  -- JQ integration
  { 'gennaro-tedesco/nvim-jqx', ft = { 'json', 'yaml' }, event = 'VeryLazy' }, -- Qs with integrations
  { 'mogelbrod/vim-jsonpath', ft = { 'json', 'yaml' }, event = 'VeryLazy' }, -- Shows current JSON path
  { 'towolf/vim-helm', event = 'VeryLazy' },
  {
    'cuducos/yaml.nvim',
    ft = { 'yaml' }, -- optional
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', event = 'VeryLazy' },
      { 'nvim-telescope/telescope.nvim', event = 'VeryLazy' },
    },
    event = 'VeryLazy',
  },
}
