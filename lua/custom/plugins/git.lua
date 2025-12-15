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
    config = function()
      require('gitlinker').setup {
        router = {
          browse = {
            ['^github%.tools%.sap'] = require('gitlinker.routers').github_browse,
            ['^github%.wdf%.sap%.corp'] = require('gitlinker.routers').github_browse,
          },
          blame = {
            ['^github%.tools%.sap'] = require('gitlinker.routers').github_blame,
            ['^github%.wdf%.sap%.corp'] = require('gitlinker.routers').github_blame,
          },
        },
      }
    end,
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
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
