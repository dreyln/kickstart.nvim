return {
  {
    'natecraddock/workspaces.nvim',
    opts = {
      hooks = {
        open_pre = {
          -- If recording, save current session state and stop recording
          'SessionsStop',

          -- delete all buffers (does not save changes)
          'silent %bdelete!',
        },
        open = function()
          require('sessions').load('.session', { silent = true })
          if vim.fn.filereadable '.venv' then
            local venv_file = io.open '.venv'
            if venv_file then
              local swenv_api = require 'swenv.api'
              local current_venv_name = nil
              local current_venv = swenv_api.get_current_venv()
              if current_venv then
                current_venv_name = current_venv.name
              end
              local ws_venv = string.gsub(venv_file:read '*a', '%s+', '')
              if ws_venv ~= current_venv_name then
                swenv_api.set_venv(ws_venv)
              end
              venv_file:close()
            end
          end
        end,
      },
    },
  },
  { 'natecraddock/sessions.nvim', opts = {} },
}
