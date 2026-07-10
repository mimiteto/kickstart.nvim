local function get_prev_working_date()
  local current_time = os.time()
  local current_date = os.date('*t', current_time)
  local day_of_week = current_date.wday -- 1 is Sunday, 2 is Monday, etc.

  local days_to_subtract
  if day_of_week == 2 then -- Monday
    days_to_subtract = 3 -- Go back to Friday
  else
    days_to_subtract = 1 -- Go back one day for any other day
  end

  local prev_time = current_time - (days_to_subtract * 86400) -- 86400 seconds in a day
  return os.date('%Y/%m/%d', prev_time)
end

local function get_next_working_date()
  local current_time = os.time()
  local current_date = os.date('*t', current_time)
  local day_of_week = current_date.wday -- 1 is Sunday, 2 is Monday, etc.

  local days_to_add
  if day_of_week == 6 then -- Saturday
    days_to_add = 2 -- Go to Monday
  elseif day_of_week == 7 then -- Sunday
    days_to_add = 1 -- Go to Monday
  else
    days_to_add = 1 -- Go to next day for any other day
  end

  local next_time = current_time + (days_to_add * 86400) -- 86400 seconds in a day
  return os.date('%Y/%m/%d', next_time)
end

-- Decide on the previous date:
-- if current time is past 16:30 - return current date
-- otherwise return tomorrows date
local function decide_on_previous_date()
  if os.date '%H:%M' > '16:30' then
    return os.date '%Y/%m/%d'
  else
    return get_prev_working_date()
  end
end

-- Decide on the previous date
local function decide_on_next_date()
  if os.date '%H:%M' > '16:30' then
    return get_next_working_date()
  else
    return os.date '%Y/%m/%d'
  end
end

-- Get dir content as a list of strings
local function get_dir_content(path)
  local content = {}
  local handle = io.popen('ls -1 ' .. path)
  if handle then
    for line in handle:lines() do
      table.insert(content, line)
    end
    handle:close()
  end
  return content
end

-- Get a list of strings and return a list of org-style link strings
local function org_links_items(lines)
  local org_links = {}
  for _, link in ipairs(lines) do
    table.insert(org_links, '[[' .. link .. ']]')
  end
  return org_links
end

local function setup()
  local tpl = require 'template'
  tpl.setup {
    temp_dir = '~/.config/nvim/templates',
    author = 'Dimitar Ivanov',
    email = function()
      if vim.fn.has 'macunix' ~= 0 then
        return 'dimitar.ivanov04@sap.com'
      end
      return 'mimiteto@gmail.com'
    end,
  }
  tpl.register('{{_dirname_}}', function()
    return vim.fn.fnamemodify(vim.fn.expand '%:p:h', ':t')
  end)
  tpl.register('{{_prev_working_date_}}', decide_on_previous_date)
  tpl.register('{{_next_working_date_}}', decide_on_next_date)

  -- Next two render improperly, `templates` can't render correctly for the life of it
  tpl.register('{{_org_linkified_dir_content_}}', function()
    return table.concat(org_links_items(get_dir_content(vim.fn.fnamemodify(vim.fn.expand '%:p:h', ':p'))), '\\n')
  end)
  tpl.register('{{_dir_content_}}', function()
    return table.concat(get_dir_content(vim.fn.fnamemodify(vim.fn.expand '%:p:h', ':p')), '\\n')
  end)

  -- Add easy way to template the current file
  require('telescope').load_extension 'find_template'
end

return {
  {
    'glepnir/template.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
    keys = {
      { '<leader>tt', '<cmd>Telescope find_template type=insert<CR>', desc = '[T]template [t]this' },
      { '<leader>tT', '<cmd>Telescope find_template filter_ft=false type=insert<CR>', desc = '[T]emplate [T]his regardless' },
    },
    cmd = { 'Template', 'TemProject' },
    config = setup,
  },
}
