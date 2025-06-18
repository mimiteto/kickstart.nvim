return {
  -- JQ integration
  { 'gennaro-tedesco/nvim-jqx', ft = { 'json', 'yaml' }, event = 'VeryLazy' }, -- Qs with integrations
  {
    'mogelbrod/vim-jsonpath',
    ft = { 'json', 'yaml' },
    event = 'VeryLazy',
    setup = function()
      -- FormatJson
      vim.api.nvim_command 'com! FormatJSON %!jq'
      vim.keymap.set('n', '<Leader>json', ':JsonPath<CR>')
      vim.keymap.set('n', '<Leader>qjson', ':JsonPath ')
    end,
  }, -- Shows current JSON path
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
