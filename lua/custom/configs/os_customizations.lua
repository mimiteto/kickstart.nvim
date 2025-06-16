local M = {}

function M.setup()
  if vim.fn.has 'macunix' ~= 0 then
    vim.o.clipboard = 'unnamed'
    OPEN_CMD = 'open'
  else
    vim.o.clipboard = 'unnamedplus'
    OPEN_CMD = 'xdg-open'
  end
end

return M
