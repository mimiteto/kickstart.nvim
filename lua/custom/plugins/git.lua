return {
  {
    'ldelossa/gh.nvim',
    dependencies = {
      {
        'ldelossa/litee.nvim',
        config = function()
          require('litee.lib').setup()
        end,
        event = 'VeryLazy',
      },
    },
    config = function()
      require('litee.gh').setup()
    end,
  },
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {},
    keys = {
      { '<leader>gy', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Yank git link' },
      { '<leader>gY', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open git link' },
    },
  },
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = '[G]it [A]dd current file' })
      vim.api.nvim_create_user_command('Gpf', function(opts)
        local cmd = 'Git push --force-with-lease'
        local is_u = vim.tbl_contains(vim.split(opts.args, ' ', { trimempty = true }), '-u')
        if is_u then
          cmd = cmd .. ' -u'
        end
        vim.cmd(cmd)
      end, { nargs = '*', desc = 'git push --force-with-lease [-u]' })
      -- Fugitive config
      vim.api.nvim_create_user_command('Browse', function(opts)
        vim.fn.system { OPEN_CMD, opts.fargs[1] }
      end, { nargs = 1 })

      vim.g.github_enterprise_urls = {
        'https://github.wdf.sap.corp',
        'github.tools.sap',
      }
    end,
  },
  { 'tpope/vim-rhubarb', event = 'VeryLazy' },
  { 'sindrets/diffview.nvim', event = 'VeryLazy' }, -- Advanced diff, git aware
  {
    'pwntester/octo.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', event = 'VeryLazy' },
      { 'nvim-telescope/telescope.nvim', event = 'VeryLazy' },
      { 'nvim-tree/nvim-web-devicons', event = 'VeryLazy' },
    },
    config = function()
      require('octo').setup {
        use_local_fs = true,
      }
    end,
    event = 'VeryLazy',
  },
}
