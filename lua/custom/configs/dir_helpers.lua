local cwd = vim.fn.getcwd()
local home_matcher = '^' .. vim.fn.expand '~'

if cwd:match(home_matcher .. '/repos/sap/landscape%-setup') then
  require('custom.repo_configs.lss').load()
end
