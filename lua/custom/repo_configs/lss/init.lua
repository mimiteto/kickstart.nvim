local M = {}

M.load = function()
  print 'Loading LS repos helpers'
  vim.api.nvim_create_user_command('WriteToLSRepos', function()
    local targets = {
      '~/repos/sap/landscapes/landscape-dev-garden/setup/',
      '~/repos/sap/landscapes/landscape-staging-garden/setup/',
      '~/repos/sap/landscapes/landscape-canary-garden/setup/',
      '~/repos/sap/landscapes/landscape-live-garden/setup/',
    }

    for _, target in ipairs(targets) do
      local relative_path = vim.fn.expand '%:.'
      local write_target = vim.fn.expand(target) .. relative_path
      print('Writing to ' .. write_target)
      vim.cmd('write! ' .. write_target)
    end
  end, {})
end

return M
