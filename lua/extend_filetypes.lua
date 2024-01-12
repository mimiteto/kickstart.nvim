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

reconfigure_filetype("pipeline_definitions", "yaml")
reconfigure_filetype("branch.cfg", "yaml")
