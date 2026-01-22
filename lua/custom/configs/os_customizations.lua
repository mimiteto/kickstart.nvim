local M = {}

function M.setup()
  vim.o.clipboard = 'unnamedplus'
  OPEN_CMD = 'xdg-open'
  SHELL = 'bash'
  if vim.fn.has 'macunix' ~= 0 then
    vim.o.clipboard = 'unnamed'
    OPEN_CMD = 'open'
    SHELL = 'zsh'
  end
end

return M
