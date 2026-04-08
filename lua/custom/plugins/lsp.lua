return { -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },

        -- Can switch between these as you prefer
        virtual_text = true, -- Text shows up at the end of the line
        virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

        -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
        jump = {
          on_jump = function()
            vim.diagnostic.open_float()
          end,
        },
      }

      -- DiagLevel: set minimum severity for diagnostic jumping
      -- Usage: :DiagLevel WARN   (only jump to WARN and above)
      --        :DiagLevel HINT   (jump to everything, the default)
      --        :DiagLevel        (show current level)
      local severity_names = { 'ERROR', 'WARN', 'INFO', 'HINT' }
      vim.api.nvim_create_user_command('DiagLevel', function(args)
        if args.args == '' then
          local current = vim.diagnostic.config().jump and vim.diagnostic.config().jump.severity
          if current then
            vim.notify('DiagLevel: ' .. (severity_names[current.min] or 'HINT') .. '+', vim.log.levels.INFO)
          else
            vim.notify('DiagLevel: HINT+ (all)', vim.log.levels.INFO)
          end
          return
        end

        local level = args.args:upper()
        local sev = vim.diagnostic.severity[level]
        if not sev then
          vim.notify('Invalid severity: ' .. args.args .. '. Use: ERROR, WARN, INFO, HINT', vim.log.levels.ERROR)
          return
        end

        local jump_opts = {
          on_jump = function()
            vim.diagnostic.open_float()
          end,
        }
        -- HINT (4) means everything, no filter needed
        if sev < vim.diagnostic.severity.HINT then
          jump_opts.severity = { min = sev }
        end

        vim.diagnostic.config { jump = jump_opts }
        vim.notify('DiagLevel: ' .. level .. '+', vim.log.levels.INFO)
      end, {
        desc = 'Set minimum diagnostic severity for jumping',
        nargs = '?',
        complete = function()
          return severity_names
        end,
      })

      -- Broadcast blink.cmp capabilities to all LSP servers
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- Per-server settings via the native vim.lsp.config() API.
      -- These are deep-merged with the defaults from nvim-lspconfig's lsp/*.lua files.
      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            hints = {
              constantValues = true,
              parameterNames = true,
            },
            annotations = {
              vulncheck = 'Imports',
            },
            analyses = {
              QF1001 = true,
              QF1010 = true,
              S1001 = true,
              S1002 = true,
              S1004 = true,
              S1006 = true,
              S1009 = true,
              S1016 = true,
              S1021 = true,
              S1023 = true,
              S1028 = true,
            },
          },
        },
      })

      vim.lsp.config('pyright', {
        settings = {
          python = {
            analysis = {
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = 'none',
                reportOptionalMemberAccess = 'none',
                reportOptionalSubscript = 'none',
                reportPrivateImportUsage = 'none',
              },
              autoImportCompletions = false,
            },
            linting = { pylintEnabled = false },
          },
        },
      })

      -- vim.lsp.config('jedi_language_server', {})

      vim.lsp.config('pylsp', {
        settings = {
          pylsp = {
            builtin = {
              installExtraArgs = { 'flake8', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint', 'yapf' },
            },
            plugins = {
              rope = { enabled = true },
              flake8 = { enabled = false },
              pyflakes = { enabled = false },
              ruff = {
                enabled = true,
                formatEnabled = true,
                extendSelect = { 'I' },
                unsafeFixes = true,
              },
              pylsp_mypy = { enabled = true, live_mode = true },
              jedi_completion = { fuzzy = true },
            },
          },
        },
      })

      vim.lsp.config('yamlls', {
        filetypes = { 'yaml', 'yaml.kubernetes' },
        settings = {
          yaml = {
            schemaStore = { enable = true },
            schemas = {
              ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.34.0/all.json'] = 'yaml.kubernetes',
            },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      })

      -- LSP servers to install. Servers with no custom settings use defaults
      -- from nvim-lspconfig's lsp/*.lua files.
      local lsp_servers = {
        'gopls',
        'pyright',
        'pylsp',
        'ansiblels',
        'autotools_ls',
        'bashls',
        'diagnosticls',
        'dockerls',
        'gh_actions_ls',
        'golangci_lint_ls',
        'helm_ls',
        'marksman',
        -- 'pylyzer',
        -- 'pyre',
        'terraformls',
        'yamlls',
        'systemd_lsp',
        'lua_ls',
      }

      -- mason-lspconfig: install LSP servers and auto-enable them via vim.lsp.enable()
      require('mason-lspconfig').setup {
        ensure_installed = lsp_servers,
        automatic_enable = true,
      }

      -- Non-LSP tools installed via mason-tool-installer
      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua', -- Used to format Lua code
          'jq',
          'actionlint',
          'alex',
          'misspell',
          'gofumpt',
          'golines',
          'goimports',
          'gomodifytags',
          'gotests',
          'nilaway',
          'revive',
          'pylint',
          'isort',
          'reorder-python-imports',
          'pyproject-fmt',
          'mypy',
          'pydocstyle',
          'autoflake',
          'autopep8',
          'black',
          'vulture',
          'debugpy',
          -- 'docformatter',
          'flake8',
          'pyflakes',
          'pylama',
          'pyproject-flake8',
          'bandit',
          'markdownlint',
          'alex',
          'vale',
          'shellcheck',
          'bash-debug-adapter',
          'shellharden',
          'hadolint',
          'hclfmt',
          'yamllint',
          'jsonlint',
          'gitleaks',
          'sourcery',
          'trivy',
          'usort',
          'yapf',
          'pyment',
          'ruff',
          'semgrep',
          -- 'snyk', # Err about auth
          'systemdlint',
          'kube-linter',
          'kubescape',
          'codebook',
          'delve',
          'gci',
          'go-debug-adapter',
          'golangci-lint',
          'iferr',
          'staticcheck',
        },
      }
    end,
  },
}
