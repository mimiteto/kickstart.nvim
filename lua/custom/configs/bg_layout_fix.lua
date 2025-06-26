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
    ['А'] = 'A',
    ['Б'] = 'B',
    ['В'] = 'W',
    ['Г'] = 'G',
    ['Д'] = 'D',
    ['Е'] = 'E',
    ['Ж'] = 'V',
    ['З'] = 'Z',
    ['И'] = 'I',
    ['Й'] = 'J',
    ['К'] = 'K',
    ['Л'] = 'L',
    ['М'] = 'M',
    ['Н'] = 'N',
    ['О'] = 'O',
    ['П'] = 'P',
    ['Р'] = 'R',
    ['С'] = 'S',
    ['Т'] = 'T',
    ['У'] = 'U',
    ['Ф'] = 'F',
    ['Х'] = 'H',
    ['Ц'] = 'C',
    ['Ъ'] = 'Y',
    ['Ь'] = 'X',
    ['Я'] = 'Q',
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
