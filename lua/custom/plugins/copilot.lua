return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
      { 'echasnovski/mini.nvim', version = '*' },
    },
    config = function()
      require('CopilotChat').setup {
        debug = false, -- Enable debugging
        context = 'files', -- 'buffers',
        question_header = '## ¯\\_(ツ)_/¯',
        error_header = '## (╯°□°)╯︵ ┻━┻',
        answer_header = '## [[°⏠°]]',
        model = 'claude-3.7-sonnet',
        show_help = true,
        -- Define keymaps for CopilotChat actions
        mappings = {
          complete = {
            insert = '<C-CR>',
            normal = '<leader>cc',
          },
          show_prompt_actions = {
            normal = '<leader>ccp',
          },
        },
      }

      -- CopilotChat.nvim keymaps
      vim.keymap.set('n', '<leader>cc', ':CopilotChatToggle<CR>', { noremap = true, silent = true, desc = '[C]opilot [C]hat' })
      vim.keymap.set('n', '<leader>cq', ':CopilotChatQuick<CR>', { noremap = true, silent = true, desc = '[C]opilot [Q]uick' })
      vim.keymap.set('n', '<leader>cs', ':CopilotChatStop<CR>', { noremap = true, silent = true, desc = '[C]opilot [S]top' })
      vim.keymap.set('n', '<leader>cr', ':CopilotChatRestart<CR>', { noremap = true, silent = true, desc = '[C]opilot [R]estart' })
      vim.keymap.set('n', '<leader>cl', ':CopilotChatLog<CR>', { noremap = true, silent = true, desc = '[C]opilot [L]og' })
      vim.keymap.set('n', '<leader>ch', ':CopilotChatHelp<CR>', { noremap = true, silent = true, desc = '[C]opilot [H]elp' })
    end,
  },
}
