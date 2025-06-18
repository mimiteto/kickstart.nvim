local M = {}

-- Automatically load all configuration modules from the configs directory
function M.load_all_configs()
  local config_dir = vim.fn.stdpath 'config' .. '/lua/custom/configs'

  -- Check if the directory exists
  if vim.fn.isdirectory(config_dir) == 0 then
    vim.notify("Config directory doesn't exist: " .. config_dir, vim.log.levels.WARN)
    return
  end

  -- Find all Lua files in the configs directory
  local config_files = vim.fn.glob(config_dir .. '/*.lua', false, true)

  for _, file in ipairs(config_files) do
    -- Extract the module name from the file path (without extension)
    local module_name = vim.fn.fnamemodify(file, ':t:r')

    -- Attempt to load the module and call setup() if it exists
    local ok, module = pcall(require, 'custom.configs.' .. module_name)

    if ok and type(module) == 'table' and type(module.setup) == 'function' then
      pcall(module.setup)
    end
  end
end

return M
