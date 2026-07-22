return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    config = function()
      require('treesitter-context').setup {
        multiline_threshold = 20000,
        trim_scope = 'inner',
        multiwindow = true,
        mode = 'topline',
      }

      -- Guard against a Neovim 0.12.x treesitter API change that makes
      -- context.get() raise "attempt to call method 'range' (a nil value)"
      -- while parsing injected langtrees (fenced code in markdown, embedded
      -- syntax in shell scripts). Wrapping the public entry point in pcall
      -- lives here (not in the plugin dir) so it survives plugin updates.
      local context = require('treesitter-context.context')
      if not context.__range_guard then
        local orig_get = context.get
        context.get = function(...)
          local ok, ranges, lines = pcall(orig_get, ...)
          if not ok then
            return nil
          end
          return ranges, lines
        end
        context.__range_guard = true
      end
    end,
  },
}
