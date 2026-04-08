local M = {}

-- Update all treesitter parsers except norg (known C++ compile issues on macOS)
local function ts_update_excluding_norg()
  local installed = require('nvim-treesitter.info').installed_parsers()
  local to_update = vim.tbl_filter(function(lang)
    return lang ~= 'norg'
  end, installed)
  if #to_update > 0 then
    vim.cmd('TSUpdate ' .. table.concat(to_update, ' '))
  end
end

function M.setup()
  vim.api.nvim_create_user_command('UpdateAllPlugins', function()
    -- Step 1: Lazy sync
    vim.notify('UpdateAllPlugins: Starting Lazy sync...', vim.log.levels.INFO)

    -- Listen for Lazy finish, then run TSUpdate
    local lazy_done = vim.api.nvim_create_autocmd('User', {
      pattern = 'LazySync',
      once = true,
      callback = function()
        vim.notify('UpdateAllPlugins: Lazy sync complete. Running TSUpdate...', vim.log.levels.INFO)

        -- TSUpdate is async, so chain via schedule
        vim.schedule(function()
          ts_update_excluding_norg()

          vim.notify('UpdateAllPlugins: TSUpdate complete. Running MasonToolsUpdate...', vim.log.levels.INFO)

          -- Listen for mason-tool-installer finish
          vim.api.nvim_create_autocmd('User', {
            pattern = 'MasonToolsUpdateCompleted',
            once = true,
            callback = function()
              vim.notify('UpdateAllPlugins: All updates complete!', vim.log.levels.INFO)
            end,
          })

          vim.cmd 'MasonToolsUpdate'
        end)
      end,
    })

    vim.cmd 'Lazy sync'
  end, { desc = 'Update all plugins: Lazy sync, TSUpdate, MasonToolsUpdate' })
end

return M
