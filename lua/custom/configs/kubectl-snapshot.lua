-- [[ kubectl edit snapshot ]]
-- When editing a resource via `kubectl edit`, silently copy the buffer to
-- a stable, human-readable path (on open) so you keep a trace of the original.
--
-- kubectl writes its scratch file as `<TMPDIR>/kubectl-edit-XXXX.yaml`
-- (on macOS TMPDIR is /var/folders/.../T, NOT /tmp), and that name carries no
-- context/kind/namespace/name. We recover those from the buffer content
-- (kind, metadata.name, metadata.namespace) and the current kube context, then
-- write a copy to:
--
--   /tmp/<context>-<kind>-<namespace>-<name>
--   /tmp/<context>-<kind>--<name>          (cluster-scoped / no namespace)
--
-- All values are lower-cased and sanitized for the filename.

local M = {}

local SNAPSHOT_DIR = '/tmp'

-- Match the basename kubectl uses for its edit scratch file, regardless of dir.
-- Covers `kubectl edit` and `oc edit` which both use `kubectl-edit-*.yaml`.
local function is_kubectl_edit_file(path)
  local name = vim.fn.fnamemodify(path, ':t')
  return name:match '^kubectl%-edit%-.*%.yaml$' ~= nil
end

-- Pull a top-level or metadata field out of the YAML lines without a real
-- parser. kubectl output is machine-generated and predictable: `kind:` sits at
-- column 0, `metadata:` at column 0, and its children are indented two spaces.
local function extract_fields(lines)
  local kind, name, namespace
  local in_metadata = false

  for _, line in ipairs(lines) do
    -- kind: Deployment
    local k = line:match '^kind:%s*(%S+)'
    if k then
      kind = k
    end

    -- Enter/leave the metadata block by indentation.
    if line:match '^metadata:%s*$' then
      in_metadata = true
    elseif in_metadata and line:match '^%S' then
      -- A new column-0 key ends the metadata block.
      in_metadata = false
    end

    if in_metadata then
      local n = line:match '^%s%s+name:%s*(%S+)'
      if n then
        name = n
      end
      local ns = line:match '^%s%s+namespace:%s*(%S+)'
      if ns then
        namespace = ns
      end
    end
  end

  return kind, name, namespace
end

local function current_context()
  local out = vim.fn.systemlist { 'kubectl', 'config', 'current-context' }
  if vim.v.shell_error ~= 0 or not out[1] then
    return nil
  end
  return vim.trim(out[1])
end

-- Strip anything that would be awkward in a filename.
local function sanitize(s)
  if not s then
    return ''
  end
  s = s:gsub('["\']', '') -- kubectl sometimes quotes values
  s = s:gsub('[^%w%-_.]', '-') -- slashes, colons, spaces -> dash
  return s:lower()
end

local function snapshot(path)
  local bufnr = vim.fn.bufnr(path)
  if bufnr == -1 then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local kind, name, namespace = extract_fields(lines)
  -- Without a name there is nothing meaningful to key on; bail quietly.
  if not name then
    return
  end

  local ctx = current_context()

  local parts = {}
  if ctx and ctx ~= '' then
    table.insert(parts, sanitize(ctx))
  end
  table.insert(parts, sanitize(kind ~= '' and kind or 'resource'))
  -- Empty namespace yields the double-dash `<kind>--<name>` form requested.
  table.insert(parts, sanitize(namespace))
  table.insert(parts, sanitize(name))

  local dest = SNAPSHOT_DIR .. '/k-' .. table.concat(parts, '-') .. '.yaml'

  -- On collision, keep the old copy and append a timestamp to this one.
  if vim.uv.fs_stat(dest) then
    dest = SNAPSHOT_DIR .. '/k-' .. table.concat(parts, '-') .. '-' .. os.date '%Y%m%d-%H%M%S' .. '.yaml'
  end

  local ok, err = pcall(vim.fn.writefile, lines, dest)
  if not ok then
    vim.notify('kubectl-snapshot: failed to write ' .. dest .. ': ' .. tostring(err), vim.log.levels.WARN)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Snapshot kubectl edit buffers to /tmp on open',
    group = vim.api.nvim_create_augroup('kubectl-edit-snapshot', { clear = true }),
    callback = function(args)
      if is_kubectl_edit_file(args.file) then
        -- Defer so the buffer is fully loaded before we read its lines.
        vim.schedule(function()
          snapshot(args.file)
        end)
      end
    end,
  })
end

return M
