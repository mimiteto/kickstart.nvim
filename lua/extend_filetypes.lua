local autocmd = vim.api.nvim_create_autocmd

-- Reconfigures file matched by pattern to specified filetype
-- @param pattern string
-- @param filetype string
-- @return integer
local function reconfigure_filetype(pattern, filetype)
  return autocmd(
    {
      "BufNewFile",
      "BufRead",
    },
    {
      pattern = { pattern },
      callback = function()
        vim.bo.filetype = filetype
      end
    }
  )
end

-- Reconfigure the following filetypes on MacOS only
if vim.fn.has("mac") == 1 then
  reconfigure_filetype("pipeline_definitions", "yaml")
  reconfigure_filetype("branch.cfg", "yaml")
  reconfigure_filetype("config", "yaml")
  reconfigure_filetype("processing.cfg", "yaml")
end
