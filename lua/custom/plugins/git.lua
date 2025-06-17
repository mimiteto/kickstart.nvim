return {
  'ldelossa/gh.nvim',
  dependencies = {
    {
      'ldelossa/litee.nvim',
      config = function()
        require('litee.lib').setup()
      end,
      event = 'VeryLazy',
    },
    {
      'tpope/vim-fugitive',
      event = 'VeryLazy',
      config = function()
        vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = '[G]it [S]tatus' })
        vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = '[G]it [A]dd current file' })
        vim.keymap.set(
          'n',
          '<leader>gfp',
          ':Git commit --amend --no-edit<CR>:Git push --force-with-lease<CR>',
          { desc = '[G]it [F]orce [P]ush current change set' }
        )
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
        require('octo').setup()
      end,
      event = 'VeryLazy',
    },
  },
  config = function()
    require('litee.gh').setup()
  end,
  build = function()
    if not vim.fn.executable 'gh' then
      if vim.has 'macunix' then
        os.execute 'brew install gh'
      else
        os.execute 'sudo dnf install -y gh'
      end
    end
  end,
}
