local ls = require 'luasnip'
local ev = require 'luasnip.util.events'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep
local snippet_from_nodes = ls.sn

return {
  s('p3', {
    t { '#! /usr/bin/env python3', '', '"""' },
    i(1, 'Docstring'),
    t { '"""', '', '' },
  }),
}
