return {
  'ldelossa/gh.nvim',
  dependencies = {
    {
      'ldelossa/litee.nvim',
      config = function()
        require('litee.lib').setup()
      end,
    },
    {
      'tpope/vim-fugitive',
      config = function()
        vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = '[G]it [S]tatus' })
        vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = '[G]it [A]dd current file' })
        vim.keymap.set(
          'n',
          '<leader>gfp',
          ':Git commit --amend --no-edit<CR>:Git push --force-with-lease<CR>',
          { desc = '[G]it [F]orce [P]ush current change set' }
        )
      end,
    },
    'tpope/vim-rhubarb',
    'sindrets/diffview.nvim', -- Advanced diff, git aware
    {
      'pwntester/octo.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require('octo').setup()
      end,
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
