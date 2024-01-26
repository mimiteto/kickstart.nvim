function SetColors(colorscheme, line_colorscheme)
  local lcolorscheme = line_colorscheme or colorscheme
  vim.o.termguicolors = true
  vim.cmd.colorscheme(colorscheme)
  require('lualine').setup {
    options = {
      theme = lcolorscheme,
    },
  }

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- SetColors('deus', 'auto')
-- SetColors('molocayo', 'auto')
-- SetColors('deep-space', 'auto')
SetColors('onedark', 'auto')
