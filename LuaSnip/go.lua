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

-- Stolen from https://cj.rs/blog/luasnip-and-treesitter-for-smarter-snippets/go.lua
-- Ported off the removed `nvim-treesitter.locals` / `nvim-treesitter.ts_utils`
-- modules (gone on the nvim-treesitter `main` branch) to core `vim.treesitter`.
local get_node_text = vim.treesitter.get_node_text

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
vim.treesitter.query.set(
  'go',
  'LuaSnip_Result',
  [[ [
    (method_declaration result: (_) @id)
    (function_declaration result: (_) @id)
    (func_literal result: (_) @id)
  ] ]]
)

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local transform = function(text, info)
  if text == 'int' then
    return t '0'
  elseif text == 'error' then
    if info then
      info.index = info.index + 1

      return c(info.index, {
        t(string.format('fmt.Errorf("%s: %%v", %s)', info.func_name, info.err_name)),
        t(info.err_name),
        -- Be cautious with wrapping, it makes the error part of the API of the
        -- function, see https://go.dev/blog/go1.13-errors#whether-to-wrap
        t(string.format('fmt.Errorf("%s: %%w", %s)', info.func_name, info.err_name)),
        -- Old style (pre 1.13, see https://go.dev/blog/go1.13-errors), using
        -- https://github.com/pkg/errors
        t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
      })
    else
      return t 'err'
    end
  elseif text == 'bool' then
    return t 'false'
  elseif text == 'string' then
    return t '""'
  elseif string.find(text, '*', 1, true) then
    return t 'nil'
  end

  return t(text)
end

local handlers = {
  ['parameter_list'] = function(node, info)
    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
      if idx ~= count - 1 then
        table.insert(result, t { ', ' })
      end
    end

    return result
  end,

  ['type_identifier'] = function(node, info)
    local text = get_node_text(node, 0)
    return { transform(text, info) }
  end,
}

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local function go_result_type(info)
  local function_node
  -- Walk up from the node at the cursor to the nearest enclosing function-like
  -- node (replaces ts_utils.get_node_at_cursor + ts_locals.get_scope_tree).
  local node = vim.treesitter.get_node()
  while node do
    local t = node:type()
    if t == 'function_declaration' or t == 'method_declaration' or t == 'func_literal' then
      function_node = node
      break
    end
    node = node:parent()
  end

  if not function_node then
    return { t 'nil' }
  end

  local query = vim.treesitter.query.get('go', 'LuaSnip_Result')
  for _, node in query:iter_captures(function_node, 0) do
    if handlers[node:type()] then
      return handlers[node:type()](node, info)
    end
  end

  return { t 'nil' }
end

-- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
local go_ret_vals = function(args)
  return snippet_from_nodes(
    nil,
    go_result_type {
      index = 0,
      err_name = args[1][1],
      func_name = args[2][1],
    }
  )
end
-- Stolen from https://cj.rs/blog/luasnip-and-treesitter-for-smarter-snippets/go.lua

return {
  s({ trig = 'catch', dscr = 'if err != nil { return nil, err }' }, { t { 'if err != nil {', '\t return nil, err', '}' } }),
  s({ trig = 'print', dscr = 'fmt.Print' }, { t 'fmt.Printf("', i(1), t '", ', i(2), t ')' }),
  s({ trig = 'printl', dscr = 'fmt.Println' }, { t 'fmt.Println("', i(1), t '", ', i(2), t ')' }),
  s({ trig = 'nerr', dscr = 'errors.New' }, { t 'errors.New("', i(1), t '")' }),
  s({ trig = 'jsone', dscr = 'JSON tags with empty' }, { t '`json:"', i(1), t ',omitempty"`' }),
  -- Adapted from https://github.com/tjdevries/config_manager/blob/1a93f03dfe254b5332b176ae8ec926e69a5d9805/xdg_config/nvim/lua/tj/snips/ft/go.lua
  s('smart_err', {
    i(1, { 'val' }),
    t ', ',
    i(2, { 'err' }),
    t ' := ',
    i(3, { 'f' }),
    t '(',
    i(4),
    t ')',
    t { '', 'if ' },
    i(2, { 'err' }),
    t { ' != nil {', '\treturn ' },
    d(5, go_ret_vals, { 2, 3 }),
    t { '', '}' },
    i(0),
  }),
  -- Produce validator method
  s({ trig = 'fuva', dscr = 'Validation function' }, {
    t 'func (',
    i(1, { 'reveiver' }),
    t ' ',
    i(2, { 'Validate' }),
    t '() error {',
    i(3),
    t { 'return nil', '}' },
  }),
  s({
    trig = 'vappend',
    dscr = 'Append to the current var',
  }, {
    i(1, { 'slice' }),
    t ' = append(',
    i(1, { 'slice' }),
    t ', ',
    i(2, { 'variadic_vals' }),
    t ' )',
  }),

  s({ trig = 'pubvar', dscr = 'Public variable declaration' }, {
    t '// ',
    i(1, 'VarName'),
    i(2, { ' description' }),
    t { '', '' },
    i(1, 'VarName'),
    i(3, ' Type'),
    t ' = ',
    i(4, 'value'),
  }),
  -- ginkgo/gomega
  s({ trig = 'imgo', dscr = 'Go testing imports' }, {
    t { 'import (', '\t"context"', '', '\t. "github.com/onsi/ginkgo/v2"', '\t. "github.com/onsi/gomega"', ')' },
  }),
  s({ trig = 'gdscr', dscr = 'Ginkgo Describe block' }, {
    t 'Describe("',
    i(1, { 'description' }),
    t '", func() {',
    t { '', '\t' },
    i(2),
    t { '', '})' },
  }),
  s({ trig = 'gcont', dscr = 'Ginkgo Context block' }, {
    t 'Context("',
    i(1, { 'description' }),
    t '", func() {',
    t { '', '\t' },
    i(2),
    t { '', '})' },
  }),
  s({ trig = 'git', dscr = 'Ginkgo It block' }, {
    t 'It("',
    i(1, { 'description' }),
    t '", func() {',
    t { '', '\t' },
    i(2),
    t { '', '})' },
  }),
  s({ trig = 'gexp', dscr = 'Gomega Expect statement' }, {
    t 'Expect(',
    i(1, { 'actual' }),
    t ').To(',
    c(2, {
      t 'BeTrue()',
      t 'BeFalse()',
      t 'BeNil()',
      t 'Equal(',
      i(1, { 'expected' }),
      t ')',
    }),
    t ')',
  }),
}
