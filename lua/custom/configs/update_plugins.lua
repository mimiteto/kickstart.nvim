local M = {}

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
          vim.cmd 'TSUpdate'

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
