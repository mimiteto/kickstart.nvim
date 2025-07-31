local temp_colorscheme_path = vim.fn.expand '~/.temp_colorscheme'
local default_colorscheme = 'everforest'
local colorscheme = default_colorscheme
local background = ''

if vim.fn.filereadable(temp_colorscheme_path) == 1 then
  colorscheme = vim.fn.trim(vim.fn.readfile(temp_colorscheme_path)[1] or default_colorscheme)
  background = vim.fn.trim(vim.fn.readfile(temp_colorscheme_path)[2] or '')
end

if background ~= '' then
  vim.o.background = background
end
vim.cmd.colorscheme(colorscheme)
