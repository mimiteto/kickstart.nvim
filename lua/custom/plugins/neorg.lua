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
    -- Automatically keep worklog written for today:
    { 'bottd/neorg-worklog', event = 'VeryLazy' },
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

    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          config = {
            icon_preset = 'diamond',
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              sap = '~/notes/sap',
              personal = '~/notes/personal',
            },
            default_workspace = function()
              if vim.fn.has 'macunix' ~= 0 then
                return 'sap'
              end
              return 'personal'
            end,
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
          },
        },
      },
    }
    -- print(vim.inspect(require("nvim-treesitter.parsers").get_parser_configs().norg))
  end,
}
