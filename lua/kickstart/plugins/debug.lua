-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'go-debug-adapter',
        'debugpy'
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug: Start/[C]ontinue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug: Step [I]nto' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = '[D]ebug: Step [O]ver' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = '[D]ebug: Step O[u]t' })
    vim.keymap.set('n', '<leader>db', dap.step_back, { desc = '[D]ebug: Step [B]ack' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = '[D]ebug: [T]erminate' })
    vim.keymap.set('n', '<leader>dd', dap.disconnect, { desc = '[D]ebug: [D]isconnect' })
    vim.keymap.set('n', '<leader>dr', dap.restart, { desc = '[D]ebug: [R]estart' })
    vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = '[D]ebug: Run [L]ast' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸(c)',
          play = '▶(c)',
          step_into = '⏎(i)',
          step_over = '⏭(o)',
          step_out = '⏮(u)',
          step_back = 'b(b)',
          run_last = '▶▶(l)',
          terminate = '⏹(t)',
          disconnect = '⏏(d)',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F9>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()
    local python_path
    -- Setup python debugger
    local python_paths = {
      '.venv/bin/python3',
      'venv/bin/python3',
      '/usr/bin/python3',
      '/usr/local/bin/python3',
      '/opt/homebrew/bin/python3',
    }
    for _, path in ipairs(python_paths) do
      if vim.fn.executable(path) == 1 then
        pthon_path = path
        break
      end
    end
    require('dap-python').setup(python_path)
  end,
}
