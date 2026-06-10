return { -- Autocompletion
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    { 'folke/lazydev.nvim' },
    { 'Kaiser-Yang/blink-cmp-git' },
    { 'fang2hou/blink-copilot' },
    -- { 'bydlw98/blink-cmp-env', ft = { 'sh', 'bash', 'zsh' } },
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = 'super-tab',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      menu = {
        auto_show = true,
      },
      trigger = {
        show_on_trigger_character = true,
      },
    },

    sources = {
      -- default = { 'copilot', 'lsp', 'path', 'snippets', 'git', 'lazydev', 'env' },
      default = { 'snippets', 'copilot', 'lsp', 'path', 'git', 'lazydev' },
      per_filetype = {
        org = { 'orgmode' },
      },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          opts = {}, -- Passed to the source directly, varies by source

          --- NOTE: All of these options may be functions to get dynamic behavior
          --- See the type definitions for more information
          enabled = true, -- Whether or not to enable the provider
          async = false, -- Whether we should show the completions before this provider returns, without waiting for it
          timeout_ms = 2000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
          transform_items = nil, -- Function to transform the items before they're returned
          should_show_items = true, -- Whether or not to show the items
          max_items = nil, -- Maximum number of items to display in the menu
          min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
          -- If this provider returns 0 items, it will fallback to these providers.
          -- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
          fallbacks = {},
          score_offset = 0, -- Boost/penalize the score of the items
          override = nil, -- Override the source's functions
        },
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          score_offset = 110,
          async = true,
        },
        git = {
          --- Do - https://github.com/Kaiser-Yang/blink-cmp-git?tab=readme-ov-file#how-to-customize-for-enterprise-github-or-gitlab
          module = 'blink-cmp-git',
          name = 'Git',
          opts = {
            github = {
              issue = {
                get_token = function()
                  return vim.env.GITHUB_GITHUB
                end,
              },
              pull_request = {
                get_token = function()
                  return vim.env.GITHUB_GITHUB
                end,
              },
              mention = {
                get_token = function()
                  return vim.env.GITHUB_GITHUB
                end,
                get_documentation = function(item)
                  local default = require('blink-cmp-git.default.github').mention.get_documentation(item)
                  default.get_token = function()
                    return vim.env.GITHUB_GITHUB
                  end
                  return default
                end,
              },
            },
          },
        },
        orgmode = {
          name = 'Orgmode',
          module = 'orgmode.org.autocompletion.blink',
          fallbacks = { 'buffer' },
        },
        -- env = {
        --   name = 'Env',
        --   module = 'blink-cmp-env',
        --   opts = {
        --     show_documentation_window = false,
        --   },
        -- },
      },
    },

    snippets = {
      preset = 'luasnip',
      score_offset = 70,
    },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
}
