local function def_workspace()
  if vim.fn.has 'macunix' ~= 0 then
    return 'sap'
  end
  return 'personal'
end

local function split_neorg(type, opts)
  vim.cmd(type)
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(false, true))
  vim.cmd('Neorg ' .. opts.args)
end

local function get_next_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local wday = tonumber(os.date('%w', time)) -- 0=Sunday, 1=Monday, ..., 6=Saturday
  local days_to_add = 1
  if wday == 5 then -- Friday
    days_to_add = 3
  elseif wday == 6 then -- Saturday
    days_to_add = 2
  elseif wday == 0 then -- Sunday
    days_to_add = 1
  end
  return time + days_to_add * 24 * 60 * 60
end

local function get_previous_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local wday = tonumber(os.date('%w', time)) -- 0=Sunday, 1=Monday, ..., 6=Saturday
  local days_to_subtract = 1
  if wday == 1 then -- Monday
    days_to_subtract = 3
  elseif wday == 0 then -- Sunday
    days_to_subtract = 2
  elseif wday == 6 then -- Saturday
    days_to_subtract = 1
  end
  return time - days_to_subtract * 24 * 60 * 60
end

local function get_effective_previous_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  -- If after 16:30, return current date; otherwise return previous workday
  if hour > 16 or (hour == 16 and min >= 30) then
    return time
  end
  return get_previous_workday(time)
end

local function get_effective_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  -- If after 16:30, return next workday; otherwise return current date as timestamp
  if hour > 16 or (hour == 16 and min >= 30) then
    return get_next_workday(time)
  end
  return time
end

local function get_effective_next_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  -- If after 16:30, return next workday from next workday; otherwise return next workday from current
  if hour > 16 or (hour == 16 and min >= 30) then
    return get_next_workday(get_next_workday(time))
  end
  return get_next_workday(time)
end

return {
  'nvim-neorg/neorg',
  build = function()
    -- Check if we're on macOS
    if vim.fn.has 'mac' == 1 then
      -- Use LLVM clang on macOS to build the parser
      local llvm_clang = '/opt/homebrew/opt/llvm/bin/clang'

      -- Check if the LLVM clang exists
      if vim.fn.filereadable(llvm_clang) == 1 then
        -- Set the environment variable for the compiler
        local old_cc = vim.env.CC
        vim.env.CC = llvm_clang

        -- Install the parser using the proper API call
        require('nvim-treesitter.install').commands.TSInstallSync['run'] { 'norg' }

        -- Restore original CC if there was one
        if old_cc then
          vim.env.CC = old_cc
        end
      else
        -- Try to install LLVM using Homebrew
        vim.notify('LLVM not found. Attempting to install it with Homebrew...', vim.log.levels.INFO)
        vim.fn.system 'brew install llvm'
        vim.notify('LLVM installation attempted. Please restart Neovim to complete Neorg setup.', vim.log.levels.INFO)
      end
    else
      -- Default build for non-macOS
      require('nvim-treesitter.install').commands.TSInstallSync['run'] { 'norg' }
    end
  end,
  version = 'v9.2.0',
  dependencies = {
    { 'nvim-lua/plenary.nvim', event = 'VeryLazy' },
    { 'nvim-treesitter/nvim-treesitter', event = 'VeryLazy' },
    { 'nvim-treesitter/nvim-treesitter-textobjects', event = 'VeryLazy' },
    { 'benlubas/neorg-interim-ls', event = 'VeryLazy' },
    { 'nvim-lua/plenary.nvim', event = 'VeryLazy' },
    { 'nvim-neorg/neorg-telescope', event = 'VeryLazy' },
    { 'bottd/neorg-worklog' },
    {
      'setupyourskills/dew-smartlink',
      ft = 'norg',
      dependencies = {
        'setupyourskills/neorg-dew',
        'setupyourskills/dew-crumb',
      },
    },
  },
  lazy = false,
  config = function()
    -- Append the custom parser path
    vim.opt.runtimepath:append(vim.fn.stdpath 'data' .. '/treesitter')

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'norg',
      callback = function()
        vim.keymap.set(
          'n',
          '<leader><space>',
          '<Plug>(neorg.qol.todo-items.todo.task-cycle)',
          { silent = true, buffer = true, noremap = true, desc = '[<space>] change task state' }
        )
      end,
    })

    vim.keymap.set('n', '<leader>ni', ':Neorg index<CR>', { desc = '[N]eorg [I]ndex' })
    vim.keymap.set('n', '<leader>nr', ':Neorg return<CR>', { desc = '[N]eorg [R]eturn' })
    vim.keymap.set('n', '<leader>ntoc', ':Neorg toc<CR>', { desc = '[N]eorg [T]able [o]f [C]ontents' })
    vim.keymap.set('n', '<leader>nsh', '<Plug>(neorg.telescope.search_headings)', { desc = '[N]eorg [S]earch [H]eadings' })
    vim.keymap.set('n', '<leader>nsl', '<Plug>(neorg.telescope.search_linkable)', { desc = '[N]eorg [S]earch [L]inkable' })

    vim.api.nvim_create_user_command('VSNeorg', function(opts)
      split_neorg('vsplit', opts)
    end, { nargs = '?', desc = 'Open Neorg in a vertical split' })

    vim.api.nvim_create_user_command('SNeorg', function(opts)
      split_neorg('split', opts)
    end, { nargs = '?', desc = 'Open Neorg in a split' })

    vim.api.nvim_create_user_command('StartNotes', function()
      vim.defer_fn(function()
        -- Get workspace path based on OS
        local workspace = def_workspace()
        local base_path = vim.fn.expand('~/notes/' .. workspace .. '/journal')

        -- Before 16:30: yesterday (left) + today (right)
        -- After 16:30: today (left) + tomorrow (right)
        local left_day = os.date('%Y-%m-%d', get_effective_previous_workday())
        local right_day = os.date('%Y-%m-%d', get_effective_workday())

        -- Build file paths (Neorg journal uses YYYY/MM/DD.norg structure)
        local left_year, left_month, left_day_num = left_day:match '(%d+)-(%d+)-(%d+)'
        local right_year, right_month, right_day_num = right_day:match '(%d+)-(%d+)-(%d+)'

        local left_file = string.format('%s/%s/%s/%s.norg', base_path, left_year, left_month, left_day_num)
        local right_file = string.format('%s/%s/%s/%s.norg', base_path, right_year, right_month, right_day_num)

        -- Create directories if they don't exist
        vim.fn.mkdir(vim.fn.fnamemodify(left_file, ':h'), 'p')
        vim.fn.mkdir(vim.fn.fnamemodify(right_file, ':h'), 'p')

        -- Open left file in current buffer, right file in vsplit
        vim.cmd('edit ' .. vim.fn.fnameescape(left_file))
        vim.cmd('vsplit ' .. vim.fn.fnameescape(right_file))
      end, 100)
    end, { desc = 'Open effective current and next workday journals in vsplits' })

    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            icon_preset = 'basic',
            -- icon_preset = 'diamond',
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              sap = '~/notes/sap',
              personal = '~/notes/personal',
            },
            default_workspace = def_workspace(),
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
            order_with_children = {
              { 'undone', ' ' },
              { 'done', 'x' },
              { 'pending', '-' },
            },
          },
        },
        ['core.export'] = {
          config = {
            export_dir = '~/notes/' .. def_workspace() .. '/export',
            export_format = 'markdown',
          },
        },
        ['core.completion'] = {
          config = { engine = { module_name = 'external.lsp-completion' } },
        },
        ['core.integrations.telescope'] = {
          config = {
            insert_file_link = {
              show_title_preview = true,
            },
          },
        },
        ['external.interim-ls'] = {
          config = { categories = true },
        },
        ['external.worklog'] = {
          -- default config
          config = {
            -- (Optional) Title for worklog in journal
            heading = 'Worklog',
            -- (Optional) Title for "default" workspace
            default_workspace_title = 'default',
          },
        },
        ['external.neorg-dew'] = {},
        ['external.dew-smartlink'] = {},
        ['external.dew-crumb'] = {
          config = {
            enabled = true, -- Enable or disable the module on startup
          },
        },
      },
    }
    -- print(vim.inspect(require("nvim-treesitter.parsers").get_parser_configs().norg))
  end,
}
