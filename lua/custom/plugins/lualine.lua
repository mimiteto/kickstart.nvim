local function current_symbol()
  -- Check if symbols are enabled for current buffer
  if not vim.b.symbols_enabled then
    return ''
  end
  
  local trouble = require 'trouble'
  local symbols = trouble.statusline {
    mode = 'lsp_document_symbols',
    groups = {},
    title = false,
    filter = { range = true },
    format = '{kind_icon}{symbol.name:Normal}',
    hl_group = 'lualine_c_normal',
  }
  return symbols.get()
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/trouble.nvim' },
  config = function()
    -- Create the command to enable symbols for current buffer
    vim.api.nvim_create_user_command('LineToggleSymbols', function()
      vim.b.symbols_enabled = not vim.b.symbols_enabled
      require('lualine').refresh()
    end, { desc = 'Enable symbols in lualine for current buffer' })

    require('lualine').setup {
      extensions = { 'trouble', 'neo-tree', 'quickfix' },
      always_divide_middle = false,
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_c = { 'filename', 'lsp_status', current_symbol },
        lualine_y = { 'progress', 'searchcount' },
      },
    }
  end,
}

