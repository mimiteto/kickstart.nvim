-- Exiting with a blinking cursor

local M = {}

function M.setup()
  vim.opt.guicursor =
    'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
  vim.api.nvim_create_autocmd('VimLeave', {
    once = true,
    callback = function()
      vim.opt.guicursor =
        'n-v-c-i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
    end,
  })
end

return M
