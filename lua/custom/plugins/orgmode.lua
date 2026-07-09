return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = { '~/notes/org/**/*.org', '~/notes/*.org' },
        org_default_notes_file = '~/notes/notes.org',
        org_todo_keywords = { 'TODO(t)', 'ONGOING(o)', 'PENDING(p)', 'FIX(f)', '|', 'DONE(d)', 'CANCELED(c)', 'DELEGATED(e)' },
        org_capture_templates = {
          p = {
            description = 'Personal',
            template = '* %?\n  %u',
            target = '~/notes/org/personal/personal.org',
          },
          s = {
            description = 'SAP',
            template = '* %?\n  %u',
            target = '~/notes/org/sap/sap.org',
          },
        },
      }

      -- Experimental LSP support
      vim.lsp.enable 'org'
    end,
  },
  {
    'hamidi-dev/org-super-agenda.nvim',
    dependencies = {
      'nvim-orgmode/orgmode', -- required
      { 'lukas-reineke/headlines.nvim', config = true }, -- optional nicety
    },
  },
  {
    'nvim-orgmode/telescope-orgmode.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-orgmode/orgmode',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'orgmode'

      local ext = require('telescope').extensions.orgmode
      vim.keymap.set('n', '<leader>fh', ext.search_headings, { desc = 'Org headlines' })
      vim.keymap.set('n', '<leader>ft', ext.search_tags, { desc = 'Org tags' })
      vim.keymap.set('n', '<leader>r', ext.refile_heading, { desc = 'Org refile' })
      vim.keymap.set('n', '<leader>li', ext.insert_link, { desc = 'Org insert link' })
    end,
  },
  {
    'aaratha/org-cycle-lite.nvim',
    config = function()
      require('org-cycle-lite').setup {
        keymap = '<TAB>', -- Optional: change keymap
      }
    end,
  },
}
