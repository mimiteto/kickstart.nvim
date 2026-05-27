local temp_colorscheme_path = vim.fn.expand '~/.temp_colorscheme'
local default_colorscheme = 'everforest'

local function apply()
  local colorscheme = default_colorscheme
  local background = ''
  if vim.fn.filereadable(temp_colorscheme_path) == 1 then
    local lines = vim.fn.readfile(temp_colorscheme_path)
    colorscheme = vim.fn.trim(lines[1] or default_colorscheme)
    background = vim.fn.trim(lines[2] or '')
  end
  if background ~= '' and vim.o.background ~= background then
    vim.o.background = background
  end
  if vim.g.colors_name ~= colorscheme then
    pcall(vim.cmd.colorscheme, colorscheme)
  end
end

apply()

if vim.uv.os_uname().sysname == 'Darwin' then
  local watcher = vim.uv.new_fs_event()
  if watcher then
    local function start()
      watcher:start(temp_colorscheme_path, {}, vim.schedule_wrap(function()
        apply()
        watcher:stop()
        vim.defer_fn(start, 50)
      end))
    end
    start()
  end
end
