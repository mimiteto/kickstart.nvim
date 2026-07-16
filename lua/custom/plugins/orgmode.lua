return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      -- Dynamic-date helpers ported from the old Neorg journal snippets.
      -- Called from capture templates via %(...) expansion. NOTE: the body of a
      -- %(...) is passed to lua load() as a function body, so it must `return`.
      local C = "require('custom.configs.org_captures')"
      local function ex(call)
        return '%(return ' .. C .. '.' .. call .. ')'
      end

      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = { '~/notes/**/*.org' },
        org_default_notes_file = '~/notes/notes.org',
        org_todo_keywords = { 'TODO(t)', 'ONGOING(o)', 'PENDING(p)', 'FIX(f)', '|', 'DONE(d)', 'CANCELED(c)', 'DELEGATED(e)' },
        org_capture_templates = {
          j = {
            description = 'Journal — workday',
            target = '~/notes/' .. ex 'journal_relpath()' .. '.org',
            template = {
              '#+title: ' .. ex 'eff_short()',
              '#+description: Journal for ' .. ex 'eff_short()',
              '#+filetags: :journal:%^{period}:',
              '',
              '* Tasks from last working day ' .. ex 'prev_leftovers_link()',
              '',
              '* Journal for ' .. ex 'eff_short()',
              '** ToDos:',
              '%?',
              '',
              '* Leftovers',
              '',
              '* Tomorrow ' .. ex 'tomorrow_link()',
            },
          },
          f = {
            description = 'Journal — first workday',
            target = '~/notes/' .. ex 'journal_relpath()' .. '.org',
            template = {
              '#+title: ' .. ex 'eff_short()',
              '#+description: Journal for ' .. ex 'eff_short()',
              '#+filetags: :journal:%^{period}:',
              '',
              '* Tasks from last working day ' .. ex 'prev_leftovers_link()',
              '',
              '* Journal for ' .. ex 'eff_short()',
              '** ToDos:',
              '- [ ] "Look at the graphs" event for AWS Route53 quota and rate limits',
              '  Canary - [[https://gardener-live.accounts.ondemand.com/saml2/idp/sso?sp=iaas-aws-canary]] (Acc - 220986883970)',
              '  Live - [[https://gardener-live.accounts.ondemand.com/saml2/idp/sso?sp=iaas-aws-live]] (Acc - 301167567572)',
              '  Relevant link - [[https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#dashboards/dashboard/gardener-api-dashboard?start=PT2160H&end=null]]',
              '- [ ] [[file:~/notes/sap/tasks/compliance-reporting.org]]',
              '- [ ] [[https://github.com/gardener/hyperkube][Check hyperkube]]',
              '%?',
              '',
              '* Leftovers',
              '',
              '* Tomorrow ' .. ex 'tomorrow_link()',
            },
          },
          d = {
            description = 'Journal — day of duty',
            target = '~/notes/' .. ex 'journal_relpath()' .. '.org',
            template = {
              '#+title: ' .. ex 'eff_short()',
              '#+description: Journal for ' .. ex 'eff_short()',
              '#+filetags: :journal:dod:',
              '',
              '* Shortcuts:',
              '** Notifications',
              '*** Github issues - [[https://github.tools.sap/notifications]]',
              '*** VO - [[https://portal.victorops.com/ui/sap-ti-ce/incidents]]',
              '** Live',
              '*** Dashboard - [[https://dashboard.garden.live.k8s.ondemand.com/namespace/_all/shoots]]',
              '*** Issues filter - [[https://github.tools.sap/kubernetes-live/issues-live/issues?q=is%3aissue+is%3aopen+-label%3astatus%2fowner-action++-label%3astatus%2fauthor-action+-label%3astatus%2fexternal-action]]',
              '** Canary',
              '*** Dashboard - [[https://dashboard.garden.canary.k8s.ondemand.com/namespace/_all/shoots]]',
              '*** Issues filter - [[https://github.tools.sap/kubernetes-canary/issues-canary/issues?q=is%3aissue+is%3aopen+-label%3astatus%2fowner-action++-label%3astatus%2fauthor-action+-label%3astatus%2fexternal-action]]',
              '',
              '* Tasks from last working day ' .. ex 'prev_leftovers_link()',
              '',
              '* Journal for ' .. ex 'eff_short()',
              '** ToDos:',
              '%?',
              '',
              '* Leftovers',
              '',
              '* Tomorrow ' .. ex 'tomorrow_link()',
            },
          },
          c = {
            description = 'KB component',
            template = {
              '#+title: %^{title}',
              '#+description: %^{description}',
              '#+filetags: :%^{category}:',
              '',
              '* Component %\\1',
              '',
              'URL: %?',
              'CI: ',
              '',
              '** How Tos',
              '',
            },
          },
          i = {
            description = 'Dir index',
            template = {
              '#+title: ' .. ex 'dirname()',
              '',
              '* ' .. ex 'dirname()',
              '** Items',
              '%?',
            },
          },
          p = {
            description = 'Personal quick',
            template = '* %?\n  %u',
            target = '~/notes/personal/personal.org',
          },
          s = {
            description = 'SAP quick',
            template = '* %?\n  %u',
            target = '~/notes/sap/sap.org',
          },
        },
      }

      -- Experimental LSP support
      vim.lsp.enable 'org'

      -- Capture menu (j/f/d/c/i/p/s)
      vim.keymap.set('n', '<leader>oc', '<cmd>lua require("orgmode").action("capture.prompt")<CR>', { desc = '[O]rg [C]apture menu' })

      -- Note command
      vim.api.nvim_create_user_command('Note', function(opts)
        local name = opts.args
        if not name:match '%.org$' then
          name = name .. '.org'
        end
        vim.cmd('edit ~/notes/' .. name)
      end, { nargs = 1 })

      -- Search
      --- Search TEXT inside your Org files (Requires ripgrep installed on your system)
      vim.keymap.set('n', '<leader>os', function()
        require('telescope.builtin').live_grep {
          cwd = '~/notes/',
          prompt_title = 'Search Org Notes Content',
        }
      end, { desc = '[O]rg notes [S]earch text' })

      --- Find/Open FILES by name inside your Org directory
      vim.keymap.set('n', '<leader>of', function()
        require('telescope.builtin').find_files {
          cwd = '~/notes/',
          prompt_title = 'Find Org Files',
        }
      end, { desc = '[O]rg file [F]ind' })
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

      -- Link the CURRENT file into an org note under a "NEEDS ORGANISATION" heading.
      -- Works from any filetype: pick a note in ~/notes via telescope, and the
      -- path of the file you invoked from gets appended as an org link.
      local ORG_ORGANISE_HEADING = 'NEEDS ORGANISATION'

      vim.keymap.set('n', '<leader>ol', function()
        local src = vim.fn.expand '%:p'
        if src == '' then
          vim.notify('Current buffer has no file path', vim.log.levels.WARN)
          return
        end

        require('telescope.builtin').find_files {
          cwd = vim.fn.expand '~/notes/',
          prompt_title = 'Link this file into note',
          attach_mappings = function(prompt_bufnr, _)
            local actions = require 'telescope.actions'
            local state = require 'telescope.actions.state'
            actions.select_default:replace(function()
              local entry = state.get_selected_entry()
              actions.close(prompt_bufnr)
              if not entry then
                return
              end
              local target = entry.path or entry[1]
              -- entry.path may be relative to cwd; make absolute.
              if not target:match '^/' then
                target = vim.fn.expand '~/notes/' .. target
              end

              local link = string.format('[[file:%s][%s]]', src, src)
              local lines = vim.fn.readfile(target)

              -- Find the organise heading (any level).
              local hidx = nil
              for i, l in ipairs(lines) do
                if l:match('^%*+%s+' .. vim.pesc(ORG_ORGANISE_HEADING) .. '%s*$') then
                  hidx = i
                  break
                end
              end

              if hidx then
                -- Insert link right after the heading line.
                table.insert(lines, hidx + 1, '- ' .. link)
              else
                -- Append heading + link at end of file.
                if #lines > 0 and lines[#lines] ~= '' then
                  table.insert(lines, '')
                end
                table.insert(lines, '* ' .. ORG_ORGANISE_HEADING)
                table.insert(lines, '- ' .. link)
              end

              vim.fn.writefile(lines, target)
              vim.notify('Linked into ' .. vim.fn.fnamemodify(target, ':t'), vim.log.levels.INFO)
            end)
            return true
          end,
        }
      end, { desc = '[O]rg [L]ink current file into note' })
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
