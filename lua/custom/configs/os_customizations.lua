local M = {}

function M.setup()
  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
    OPEN_CMD = 'xdg-open'
    SHELL = 'bash'
    if vim.fn.has 'macunix' ~= 0 then
      vim.o.clipboard = 'unnamed'
      OPEN_CMD = 'open'
      SHELL = 'zsh'
    end
  end)
end

return M
