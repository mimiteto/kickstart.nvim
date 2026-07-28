-- Highlight, edit, and navigate code.
--
-- Migrated to the nvim-treesitter `main` branch (rewrite), required by Neovim
-- 0.12+. The legacy `master` branch is incompatible with 0.12's treesitter core
-- and caused `attempt to call method 'range' (a nil value)` on md/sh files.
--
-- `main` has no `nvim-treesitter.configs` / `setup(opts)`. Parsers install via
-- `require('nvim-treesitter').install{}`; highlight is per-buffer via
-- `vim.treesitter.start()`; indent via the experimental `indentexpr`.

local ensure_installed = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}

-- Filetypes that should keep Vim's regex highlighting (formerly
-- `additional_vim_regex_highlighting`) and should NOT use the treesitter
-- indentexpr (formerly indent `disable`).
local regex_highlight_fts = { ruby = true }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    -- The `main` branch does not support lazy-loading.
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- The `main` branch compiles parsers on-machine, which needs a C compiler
      -- in PATH. macOS ships one via Xcode CLT; a fresh Fedora/Linux box does
      -- not (nvim can't install it — that needs the system package manager).
      -- Warn with the exact command instead of failing with cryptic build errors.
      local function has_c_compiler()
        return vim.fn.executable 'cc' == 1 or vim.fn.executable 'gcc' == 1 or vim.fn.executable 'clang' == 1
      end

      if not has_c_compiler() then
        vim.schedule(function()
          vim.notify(
            'nvim-treesitter (main) needs a C compiler to build parsers. Install one:\n'
              .. '  Fedora/RHEL:  sudo dnf install gcc\n'
              .. '  Debian/Ubuntu: sudo apt install gcc\n'
              .. '  macOS:        xcode-select --install\n'
              .. 'Then restart Neovim (or run :TSUpdate).',
            vim.log.levels.WARN,
            { title = 'nvim-treesitter' }
          )
        end)
      end

      -- Install parsers (replaces `ensure_installed`). The `main` branch shells
      -- out to the `tree-sitter` CLI, which Mason installs (see the
      -- `tree-sitter-cli` entry in mason-tool-installer). On a fresh machine
      -- Mason may not have finished installing it when this runs, so install
      -- parsers now if the CLI is present, otherwise wait for Mason to finish.
      local function install_parsers()
        require('nvim-treesitter').install(ensure_installed)
      end

      if vim.fn.executable 'tree-sitter' == 1 then
        install_parsers()
      else
        -- mason-tool-installer fires this once its ensure_installed set is done.
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MasonToolsUpdateCompleted',
          once = true,
          callback = function()
            if vim.fn.executable 'tree-sitter' == 1 then
              install_parsers()
            else
              vim.notify(
                'nvim-treesitter: `tree-sitter` CLI not found after Mason install; '
                  .. 'parsers were not built. Install it and run :TSUpdate.',
                vim.log.levels.WARN
              )
            end
          end,
        })
      end

      -- Enable highlighting per-buffer, and auto-install a missing parser on
      -- first open (restores the old `auto_install = true`, which `main` drops).
      local function start_treesitter(buf)
        local ft = vim.bo[buf].filetype
        if ft == '' then
          return
        end

        -- Resolve filetype -> treesitter language.
        local lang = vim.treesitter.language.get_lang(ft) or ft

        local nts = require 'nvim-treesitter'
        local installed = nts.get_installed()
        if not vim.tbl_contains(installed, lang) then
          -- Only attempt langs treesitter actually ships a parser for, and only
          -- when the CLI is present, so we don't spam errors on a fresh machine.
          if vim.fn.executable 'tree-sitter' == 1 and vim.tbl_contains(nts.get_available(), lang) then
            nts.install({ lang }, { summary = true }):await(function(err)
              -- Re-run once installed so highlighting turns on without a reopen.
              if not err and vim.api.nvim_buf_is_valid(buf) then
                vim.schedule(function()
                  start_treesitter(buf)
                end)
              end
            end)
          end
          return
        end

        -- Enable treesitter highlighting; guard so a broken parser never aborts.
        local ok = pcall(vim.treesitter.start, buf, lang)
        if not ok then
          return
        end

        if regex_highlight_fts[ft] then
          -- Keep Vim's regex highlighting alongside treesitter (some langs,
          -- e.g. ruby, rely on it for indent rules).
          vim.bo[buf].syntax = 'on'
        else
          -- Experimental treesitter-based indentation (skip regex-indent fts).
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('custom_treesitter_start', { clear = true }),
        callback = function(args)
          start_treesitter(args.buf)
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = false,
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      -- Select
      local selections = {
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
        aa = '@parameter.outer',
        ia = '@parameter.inner',
      }
      for lhs, capture in pairs(selections) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(capture, 'textobjects')
        end, { desc = 'Select ' .. capture })
      end

      -- Move
      local moves = {
        [']f'] = { move.goto_next_start, '@function.outer' },
        [']c'] = { move.goto_next_start, '@class.outer' },
        [']a'] = { move.goto_next_start, '@parameter.inner' },
        ['[f'] = { move.goto_previous_start, '@function.outer' },
        ['[c'] = { move.goto_previous_start, '@class.outer' },
        ['[a'] = { move.goto_previous_start, '@parameter.inner' },
      }
      for lhs, spec in pairs(moves) do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          spec[1](spec[2], 'textobjects')
        end, { desc = 'Move to ' .. spec[2] })
      end

      -- Swap
      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap parameter with next' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap parameter with previous' })
    end,
  },
}
