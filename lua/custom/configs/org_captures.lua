-- Org capture helpers: dynamic workday-date logic ported from the old Neorg
-- setup (LuaSnip/norg.lua + plugins/neorg.lua). These return plain strings and
-- are meant to be called from capture templates via the `%(...)` expansion,
-- e.g.  %(return require('custom.configs.org_captures').eff_short())
--
-- Journal files live at ~/notes/<workspace>/journal/YYYY/MM/DD.org
-- Workspace: `sap` on macOS, `personal` elsewhere.

local M = {}

-- ---------------------------------------------------------------------------
-- workspace
-- ---------------------------------------------------------------------------

local function def_workspace()
  if vim.fn.has 'macunix' ~= 0 then
    return 'sap'
  end
  return 'personal'
end

-- ---------------------------------------------------------------------------
-- date helpers (verbatim behaviour from the neorg config)
-- ---------------------------------------------------------------------------

local function get_next_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local wday = tonumber(os.date('%w', time)) -- 0=Sunday, 1=Monday, ..., 6=Saturday
  local days_to_add = 1
  if wday == 5 then -- Friday
    days_to_add = 3
  elseif wday == 6 then -- Saturday
    days_to_add = 2
  elseif wday == 0 then -- Sunday
    days_to_add = 1
  end
  return time + days_to_add * 24 * 60 * 60
end

local function get_previous_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local wday = tonumber(os.date('%w', time)) -- 0=Sunday, 1=Monday, ..., 6=Saturday
  local days_to_subtract = 1
  if wday == 1 then -- Monday
    days_to_subtract = 3
  elseif wday == 0 then -- Sunday
    days_to_subtract = 2
  elseif wday == 6 then -- Saturday
    days_to_subtract = 1
  end
  return time - days_to_subtract * 24 * 60 * 60
end

-- If it's past 16:30 we consider the "effective" workday to have rolled over to
-- the next workday; otherwise it's today.
local function get_effective_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  if hour > 16 or (hour == 16 and min >= 30) then
    return get_next_workday(time)
  end
  return time
end

local function get_effective_previous_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  if hour > 16 or (hour == 16 and min >= 30) then
    return time
  end
  return get_previous_workday(time)
end

local function get_effective_next_workday(date)
  local time = date and (type(date) == 'table' and os.time(date) or date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  if hour > 16 or (hour == 16 and min >= 30) then
    return get_next_workday(get_next_workday(time))
  end
  return get_next_workday(time)
end

local function short(time)
  return os.date('%y/%m/%d', time)
end

-- ---------------------------------------------------------------------------
-- exported string builders (called from %(...) in capture templates)
-- ---------------------------------------------------------------------------

-- <ws>/journal/YYYY/MM/DD  (no extension) for the effective workday.
-- Used to build the capture `target` path: '~/notes/' .. journal_relpath() .. '.org'
function M.journal_relpath()
  return def_workspace() .. os.date('/journal/%Y/%m/%d', get_effective_workday())
end

-- Absolute org file link to the journal of a given time, optional heading anchor.
local function journal_link(time, anchor)
  local path = '~/notes/' .. def_workspace() .. os.date('/journal/%Y/%m/%d.org', time)
  if anchor and anchor ~= '' then
    return '[[file:' .. path .. '::*' .. anchor .. ']]'
  end
  return '[[file:' .. path .. ']]'
end

-- Short %y/%m/%d strings for headings / meta.
function M.eff_short()
  return short(get_effective_workday())
end

function M.prev_short()
  return short(get_effective_previous_workday())
end

function M.next_short()
  return short(get_effective_next_workday())
end

-- Link to previous workday's "Leftovers" heading.
function M.prev_leftovers_link()
  return journal_link(get_effective_previous_workday(), 'Leftovers')
end

-- Link to next workday's journal.
function M.tomorrow_link()
  return journal_link(get_effective_next_workday())
end

-- Current directory name (for the dir-index capture).
function M.dirname()
  return vim.fn.fnamemodify(vim.fn.expand '%:p:h', ':t')
end

return M
