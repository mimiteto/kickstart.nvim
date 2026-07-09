-- Auto-commit and force-push changes to ~/notes on file save.
-- Non-blocking: uses vim.system() with detached jobs.
-- Debounced: coalesces rapid saves into a single commit/push.

local M = {}

local NOTES_DIR = vim.fn.expand '~/notes'
local BRANCH = 'master'
local DEBOUNCE_MS = 5000

local timer = nil
local pending_files = {}

local function is_under_notes(path)
  local abs = vim.fn.fnamemodify(path, ':p')
  return abs:sub(1, #NOTES_DIR + 1) == NOTES_DIR .. '/'
end

local function relpath(path)
  local abs = vim.fn.fnamemodify(path, ':p')
  return abs:sub(#NOTES_DIR + 2)
end

local function run_sync_job()
  local files = vim.tbl_keys(pending_files)
  pending_files = {}
  if #files == 0 then
    return
  end

  local msg
  if #files == 1 then
    msg = 'Updated ' .. files[1]
  else
    msg = 'Updated ' .. #files .. ' files: ' .. table.concat(files, ', ')
  end

  -- Chained shell command; runs fully in background.
  local cmd = {
    'sh',
    '-c',
    string.format(
      'cd %q && git add -A && git commit -m %q && git push origin %s --force',
      NOTES_DIR,
      msg,
      BRANCH
    ),
  }

  vim.system(cmd, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        vim.notify(
          'notes sync failed (' .. obj.code .. '): ' .. (obj.stderr or ''),
          vim.log.levels.WARN
        )
      end)
    end
  end)
end

local function schedule_sync(file)
  pending_files[relpath(file)] = true
  if timer then
    timer:stop()
    timer:close()
  end
  timer = vim.uv.new_timer()
  timer:start(DEBOUNCE_MS, 0, function()
    timer:close()
    timer = nil
    vim.schedule(run_sync_job)
  end)
end

function M.setup()
  if vim.fn.isdirectory(NOTES_DIR) == 0 then
    return
  end
  if vim.fn.isdirectory(NOTES_DIR .. '/.git') == 0 then
    return
  end

  local group = vim.api.nvim_create_augroup('NotesAutoSync', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = NOTES_DIR .. '/*',
    callback = function(args)
      if is_under_notes(args.file) then
        schedule_sync(args.file)
      end
    end,
  })
end

return M
