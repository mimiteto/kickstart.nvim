local function get_correct_model()
  if vim.fn.has 'mac' == 1 then
    return 'claude-opus-4.5'
  else
    return 'claude-sonnet-4.6'
  end
end

return {
  {
    -- Completion
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
    -- Buddy
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'franco-ruggeri/codecompanion-spinner.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>cc', ':CodeCompanion', { noremap = true, silent = true, desc = '[C]ode [C]ompanion' })
      vim.keymap.set('n', '<leader>ccc', ':CodeCompanionChat Toggle<CR>', { noremap = true, silent = true, desc = '[C]ode [C]ompanion [C]hat' })
      vim.keymap.set('n', '<leader>cca', ':CodeCompanionActions<CR>', { noremap = true, silent = true, desc = '[C]ode [C]ompanion [A]ctions' })
      require('codecompanion').setup {
        log_level = 'DEBUG',
        strategies = {
          chat = {
            adapter = {
              name = 'copilot',
              -- model = 'claude-opus-4.5',
              model = get_correct_model(),
            },
          },
        },
        inline = {
          keymaps = {
            accept_change = {
              modes = { n = '<leader>ca' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = '<leader>cr' },
              opts = { nowait = true },
              description = 'Reject the suggested change',
            },
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = '## ¯\\_(ツ)_/¯', -- '## (╯°□°)╯︵ ┻━┻' , '## [[°⏠°]]'
            provider = 'telescope',
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            },
          },
        },
        extensions = {
          spinner = {
            opts = {},
          },
        },
      }
    end,
  },
}
