local function get_correct_model()
  if vim.fn.has 'mac' == 1 then
    return 'claude-opus-4.6'
  else
    return 'gemini-3.1-pro-preview'
  end
end

-- On mac, mirror the `claude` shell alias: route through the local proxy at
-- http://localhost:6655/anthropic/ with the same auth token as
-- ~/.config/llms/claude-config.json. Non-mac falls back to copilot.
local function get_chat_adapter()
  if vim.fn.has 'mac' == 1 then
    return 'anthropic_proxy'
  end
  return {
    name = 'copilot',
    model = get_correct_model(),
  }
end

-- Generates ~/.config/github-copilot/hosts.json for tools that read the legacy
-- JSON token store (e.g. CodeCompanion). copilot.lua now stores tokens in a
-- sqlite auth.db, so the JSON file must be created separately. Run once with
-- :CopilotAuthJson and follow the device-flow prompts.
local function copilot_auth_json()
  local CLIENT_ID = 'Iv1.b507a08c87ecfe98' -- GitHub Copilot public OAuth client_id
  local DEVICE_URL = 'https://github.com/login/device/code'
  local TOKEN_URL = 'https://github.com/login/oauth/access_token'
  local USER_URL = 'https://api.github.com/user'

  local function curl_post(url, body)
    local out = vim.fn.system({
      'curl', '-sS', '-X', 'POST', url,
      '-H', 'Accept: application/json',
      '-H', 'Content-Type: application/json',
      '-d', vim.json.encode(body),
    })
    if vim.v.shell_error ~= 0 then
      error('curl failed: ' .. out)
    end
    return vim.json.decode(out)
  end

  local function curl_get(url, token)
    local out = vim.fn.system({
      'curl', '-sS', url,
      '-H', 'Accept: application/json',
      '-H', 'Authorization: token ' .. token,
      '-H', 'User-Agent: nvim-copilot-auth',
    })
    if vim.v.shell_error ~= 0 then
      error('curl failed: ' .. out)
    end
    return vim.json.decode(out)
  end

  vim.notify('Requesting device code...', vim.log.levels.INFO)
  local dev = curl_post(DEVICE_URL, { client_id = CLIENT_ID, scope = 'read:user' })
  if not dev.device_code then
    error('No device_code: ' .. vim.inspect(dev))
  end

  vim.fn.setreg('+', dev.user_code)
  vim.notify(string.format('Open %s and enter code: %s (copied to clipboard)', dev.verification_uri, dev.user_code), vim.log.levels.WARN)
  vim.fn.input('Press <Enter> after you authorized in browser: ')

  local interval = dev.interval or 5
  local deadline = os.time() + (dev.expires_in or 900)
  local access_token

  while os.time() < deadline do
    local resp = curl_post(TOKEN_URL, {
      client_id = CLIENT_ID,
      device_code = dev.device_code,
      grant_type = 'urn:ietf:params:oauth:grant-type:device_code',
    })
    if resp.access_token then
      access_token = resp.access_token
      break
    elseif resp.error == 'authorization_pending' then
      vim.cmd('sleep ' .. interval)
    elseif resp.error == 'slow_down' then
      interval = interval + 5
      vim.cmd('sleep ' .. interval)
    else
      error('OAuth error: ' .. vim.inspect(resp))
    end
  end

  if not access_token then
    error('Timed out waiting for authorization')
  end

  local user = curl_get(USER_URL, access_token)
  if not user.login then
    error('Failed to fetch user: ' .. vim.inspect(user))
  end

  local dir = vim.fn.expand('~/.config/github-copilot')
  vim.fn.mkdir(dir, 'p')
  local path = dir .. '/hosts.json'

  local hosts = {
    ['github.com'] = {
      user = user.login,
      oauth_token = access_token,
    },
  }

  local f = assert(io.open(path, 'w'))
  f:write(vim.json.encode(hosts))
  f:close()
  vim.fn.system({ 'chmod', '600', path })

  vim.notify('Wrote ' .. path .. ' for user ' .. user.login, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('CopilotAuthJson', copilot_auth_json, {
  desc = 'Run GitHub device-flow auth and write ~/.config/github-copilot/hosts.json',
})

return {
  {
    -- Completion
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    -- Buddy
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'franco-ruggeri/codecompanion-spinner.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>cc', ':CodeCompanion', { noremap = true, silent = true, desc = '[C]ode [C]ompanion' })
      vim.keymap.set('n', '<leader>ccc', ':CodeCompanionChat Toggle<CR>', { noremap = true, silent = true, desc = '[C]ode [C]ompanion [C]hat' })
      vim.keymap.set('n', '<leader>cca', ':CodeCompanionActions<CR>', { noremap = true, silent = true, desc = '[C]ode [C]ompanion [A]ctions' })
      require('codecompanion').setup {
        log_level = 'DEBUG',
        adapters = {
          http = {
            anthropic_proxy = function()
              return require('codecompanion.adapters').extend('anthropic', {
                name = 'anthropic_proxy',
                url = 'http://localhost:6655/anthropic/v1/messages',
                env = {
                  api_key = 'cmd:cat ~/.hai-key',
                },
                headers = {
                  ['content-type'] = 'application/json',
                  ['authorization'] = 'Bearer ${api_key}',
                  ['anthropic-version'] = '2023-06-01',
                },
                schema = {
                  model = {
                    default = 'claude-opus-latest',
                  },
                },
              })
            end,
          },
        },
        strategies = {
          chat = {
            adapter = get_chat_adapter(),
          },
        },
        inline = {
          keymaps = {
            accept_change = {
              modes = { n = '<leader>ca' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = '<leader>cr' },
              opts = { nowait = true },
              description = 'Reject the suggested change',
            },
          },
        },
        display = {
          action_palette = {
            width = 95,
            height = 10,
            prompt = '## ¯\\_(ツ)_/¯', -- '## (╯°□°)╯︵ ┻━┻' , '## [[°⏠°]]'
            provider = 'telescope',
            opts = {
              show_default_actions = true, -- Show the default actions in the action palette?
              show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            },
          },
        },
        extensions = {
          spinner = {
            opts = {},
          },
        },
      }
    end,
  },
}
