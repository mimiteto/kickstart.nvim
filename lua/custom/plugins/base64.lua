return {
  'deponian/nvim-base64',
  version = '*',
  event = 'VeryLazy',
  keys = {
    -- Decode/encode selected sequence from/to base64
    -- (mnemonic: [b]ase64)
    { '<Leader>b64', '<Plug>(FromBase64)', mode = 'x' },
    { '<Leader>B64', '<Plug>(ToBase64)', mode = 'x' },
  },
  config = function()
    require('nvim-base64').setup()
  end,
}
