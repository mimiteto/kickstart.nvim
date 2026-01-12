return {
  'askfiy/smart-translate.nvim',
  cmd = { 'Translate' },
  dependencies = {
    'askfiy/http.nvim',
  },
  opts = {
    default = {
      cmds = {
        target = 'en-US',
      },
    },
  },
  event = 'VeryLazy',
}
