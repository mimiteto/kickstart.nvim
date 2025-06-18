-- bg_layout_fix.lua
-- Fixes Bulgarian Phonetic layout for Neovim command/normal/visual modes

local M = {}

function M.setup()
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  local bg_to_qwerty = {
    ['а'] = 'a',
    ['б'] = 'b',
    ['в'] = 'w',
    ['г'] = 'g',
    ['д'] = 'd',
    ['е'] = 'e',
    ['ж'] = 'v',
    ['з'] = 'z',
    ['и'] = 'i',
    ['й'] = 'j',
    ['к'] = 'k',
    ['л'] = 'l',
    ['м'] = 'm',
    ['н'] = 'n',
    ['о'] = 'o',
    ['п'] = 'p',
    ['р'] = 'r',
    ['с'] = 's',
    ['т'] = 't',
    ['у'] = 'u',
    ['ф'] = 'f',
    ['х'] = 'h',
    ['ц'] = 'c',
    ['ч'] = '`',
    ['ш'] = '[',
    ['щ'] = ']',
    ['ъ'] = 'y',
    ['ь'] = 'x',
    ['ю'] = '\\',
    ['я'] = 'q',
  }

  for cyr, lat in pairs(bg_to_qwerty) do
    -- Normal + Visual mode
    map('n', cyr, lat, opts)
    map('v', cyr, lat, opts)
    -- Command-line mode
    vim.cmd(string.format('cmap %s %s', cyr, lat))
  end
end

return M
