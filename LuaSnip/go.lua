local ls = require 'luasnip'
local ev = require 'luasnip.util.events'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
  s({ trig = 'catch', dscr = 'if err != nil { return nil, err }' }, { t { 'if err != nil {', '\t return nil, err', '}' } }),
  s({ trig = 'print', dscr = 'fmt.Print' }, { t 'fmt.Print("', i(1), t '", ', i(2), t ')' }),
  s({ trig = 'printl', dscr = 'fmt.Println' }, { t 'fmt.Println("', i(1), t '", ', i(2), t ')' }),
  s({ trig = 'nerr', dscr = 'errors.New' }, { t 'errors.New("', i(1), t '")' }),
}
