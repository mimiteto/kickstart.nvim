function SetColors(colorscheme, line_colorscheme, do_transparent)
  local lcolorscheme = line_colorscheme or colorscheme
  vim.o.termguicolors = true
  vim.cmd.colorscheme(colorscheme)
  require('lualine').setup {
    options = {
      theme = lcolorscheme,
    },
  }
  if do_transparent then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end
end

-- SetColors('deus', 'auto')
-- SetColors('molocayo', 'auto')
-- SetColors('deep-space', 'auto')
-- SetColors('onedark', 'auto')
SetColors('atom', 'atom', false)
