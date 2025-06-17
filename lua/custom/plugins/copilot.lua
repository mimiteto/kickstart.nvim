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
    build = function()
      os.execute 'sudo luarocks install --lua-version 5.4 tiktoken_core'
    end,
    opts = {
      debug = false, -- Enable debugging
      context = 'files', -- 'buffers',
      question_header = '## ¯\\_(ツ)_/¯',
      error_header = '## (╯°□°)╯︵ ┻━┻',
      answer_header = '## [[°⏠°]]',
      model = 'claude-3.7-sonnet',
      {
        '<leader>ccp',
        function()
          require 'CopilotChat.actions'
        end,
        desc = 'CopilotChat - Prompt actions',
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
