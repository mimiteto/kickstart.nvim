return {
  'nvim-neorg/neorg',
  build = ':Neorg sync-parsers',
  version = 'v9.2.0',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- Automatically keep worklog written for today:
    { 'bottd/neorg-worklog' },
  },
  lazy = false,
  config = function()
    -- Append the custom parser path
    vim.opt.runtimepath:append(vim.fn.stdpath 'data' .. '/treesitter')

    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            icon_preset = 'diamond',
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              sap = '~/notes/sap',
              personal = '~/notes/personal',
            },
            default_workspace = function()
              if vim.fn.has 'macunix' ~= 0 then
                return 'sap'
              end
              return 'personal'
            end,
            index = 'index.norg',
          },
        },
        ['core.keybinds'] = {
          config = {
            default_keybinds = true,
          },
        },
        ['core.qol.todo_items'] = {
          config = {
            create_todo_item = true,
            create_todo_parents = true,
          },
        },
      },
    }
    -- print(vim.inspect(require("nvim-treesitter.parsers").get_parser_configs().norg))
  end,
}
