local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Helper functions
local function date_iso(date)
  local time = date and os.time(date) or os.time()
  return os.date('!%Y-%m-%dT%H:%M:%S', time) .. os.date('%z', time)
end

local function date_short(date)
  local time = date and os.time(date) or os.time()
  return os.date('%y/%m/%d', time)
end

local function datetime_short(date)
  local time = date and os.time(date) or os.time()
  return os.date('%y/%m/%dT%H:%M:%S', time)
end

local function get_next_workday(date)
  local time = date and os.time(date) or os.time()
  local wday = tonumber(os.date('%w', time)) -- 0=Sunday, 1=Monday, ..., 6=Saturday
  local days_to_add = 1
  if wday == 5 then -- Friday
    days_to_add = 3
  elseif wday == 6 then -- Saturday
    days_to_add = 2
  elseif wday == 0 then -- Sunday
    days_to_add = 1
  end
  return os.date('*t', time + days_to_add * 24 * 60 * 60)
end

local function get_previous_workday(date)
  local time = date and os.time(date) or os.time()
  local wday = tonumber(os.date('%w', time)) -- 0=Sunday, 1=Monday, ..., 6=Saturday
  local days_to_subtract = 1
  if wday == 1 then -- Monday
    days_to_subtract = 3
  elseif wday == 0 then -- Sunday
    days_to_subtract = 2
  elseif wday == 6 then -- Saturday
    days_to_subtract = 1
  end
  return os.date('*t', time - days_to_subtract * 24 * 60 * 60)
end

local function get_effective_workday(date)
  local time = date and os.time(date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  -- If after 16:30, return next workday; otherwise return current date as table
  if hour > 16 or (hour == 16 and min >= 30) then
    return get_next_workday(date)
  end
  return os.date('*t', time)
end

local function get_effective_previous_workday(date)
  local time = date and os.time(date) or os.time()
  local hour = tonumber(os.date('%H', time))
  local min = tonumber(os.date('%M', time))
  -- If after 16:30, return current date; otherwise return previous workday
  if hour > 16 or (hour == 16 and min >= 30) then
    return os.date('*t', time)
  end
  return get_previous_workday(date)
end

return {
  -- New Component Template (trigger: component)
  s('component', {
    t { '@document.meta', 'title: ' },
    i(1, 'ComponentName'),
    t { '', 'description: ' },
    i(2, 'Description'),
    t { '', 'categories: [', '\t' },
    i(3, 'category'),
    t { '', ']', 'created: ' },
    f(date_iso),
    t { '', 'updated: ' },
    f(date_iso),
    t { '', '@end', '* Component ' },
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t { '', '', 'URL: ' },
    i(4),
    t { '', 'CI: ' },
    i(5),
    t { '', '', '** How Tos', '', '' },
    i(0),
  }),

  -- Neorg Index Template (trigger: norg-index)
  s('norg-index', {
    t { '@document.meta', 'title: ' },
    i(1, 'Title'),
    t { '', 'description: ' },
    i(2, 'Description'),
    t { '', 'categories: [', '\t' },
    i(3, 'categories'),
    t { '', ']', 'created: ' },
    f(date_iso),
    t { '', 'updated: ' },
    f(date_iso),
    t { '', '@end', '* ' },
    i(4, 'dirname'),
    t { '', '', '** Items', '', '' },
    i(5, 'links'),
    t { '', '' },
    i(0),
  }),

  -- Journal Day of Duty Template (trigger: journal-dod)
  s('journal-dod', {
    t { '@document.meta', 'title: ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', 'description: Journal for ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', 'categories: [', '    journal', '    dod', ']', 'created: ' },
    f(datetime_short),
    t { '', 'updated: ' },
    f(datetime_short),
    t {
      '',
      '@end',
      '',
      '* Shortcuts:',
      '** Notifications',
      '*** Github issues - {https://github.tools.sap/notifications}',
      '*** VO - {https://portal.victorops.com/ui/sap-ti-ce/incidents}',
      '** Live',
      '*** Dashboard - {https://dashboard.garden.live.k8s.ondemand.com/namespace/_all/shoots}',
      '*** Issues filter - {https://github.tools.sap/kubernetes-live/issues-live/issues?q=is%3aissue+is%3aopen+-label%3astatus%2fowner-action++-label%3astatus%2fauthor-action+-label%3astatus%2fexternal-action}',
      '** Canary',
      '*** Dashboard - {https://dashboard.garden.canary.k8s.ondemand.com/namespace/_all/shoots}',
      '*** Issues filter - {https://github.tools.sap/kubernetes-canary/issues-canary/issues?q=is%3aissue+is%3aopen+-label%3astatus%2fowner-action++-label%3astatus%2fauthor-action+-label%3astatus%2fexternal-action}',
      '',
      '* Tasks from last working day {:$/journal/',
    },
    f(function()
      return date_short(get_effective_previous_workday())
    end),
    t { ':# Leftovers}', '', '', '* Journal for ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', '', '', '* Leftovers', '', '', '* Tomorrow {:$/journal/' },
    f(function()
      return date_short(get_next_workday(get_effective_workday()))
    end),
    t { ':}' },
  }),

  s('journal-first-workday', {
    t { '@document.meta', 'title: ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', 'description: Journal for ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', 'categories: [', '    journal', '    ' },
    i(1, 'period'),
    t { '', ']', 'created: ' },
    f(datetime_short),
    t { '', 'updated: ' },
    f(datetime_short),
    t { '', '@end', '', '* Tasks from last working day {:$/journal/' },
    f(function()
      return date_short(get_effective_previous_workday())
    end),
    t { ':# Leftovers}', '', '', '* Journal for ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t {
      '',
      '** ToDos:',
      '~ ( ) "Look at the graphs" event for AWS Route53 quota and rate limits',
      'Canary - {https://gardener-live.accounts.ondemand.com/saml2/idp/sso?sp=iaas-aws-canary} (Acc - 220986883970)',
      'Live - {https://gardener-live.accounts.ondemand.com/saml2/idp/sso?sp=iaas-aws-live} (Acc - 301167567572)',
      'Relevant link -  {https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#dashboards/dashboard/gardener-api-dashboard?start=PT2160H&end=null}',
      '~ ( ) {:$/tasks/compliance-reporting.norg:}',
      '~ ( ) {https://github.com/gardener/hyperkube}[Check hyperkube]',
      '',
      '',
      '* Leftovers',
      '',
      '',
      '* Tomorrow {:$/journal/',
    },
    f(function()
      return date_short(get_next_workday(get_effective_workday()))
    end),
    t { ':}' },
  }),

  s('journal-workday', {
    t { '@document.meta', 'title: ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', 'description: Journal for ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t { '', 'categories: [', '    journal', '    ' },
    i(1, 'period'),
    t { '', ']', 'created: ' },
    f(datetime_short),
    t { '', 'updated: ' },
    f(datetime_short),
    t { '', '@end', '', '* Tasks from last working day {:$/journal/' },
    f(function()
      return date_short(get_effective_previous_workday())
    end),
    t { ':# Leftovers}', '', '', '* Journal for ' },
    f(function()
      return date_short(get_effective_workday())
    end),
    t {
      '',
      '** ToDos:',
      '',
      '',
      '* Leftovers',
      '',
      '',
      '* Tomorrow {:$/journal/',
    },
    f(function()
      return date_short(get_next_workday(get_effective_workday()))
    end),
    t { ':}' },
  }),
}
