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
        end,
      },
    },
  },
  { 'natecraddock/sessions.nvim', opts = {} },
}
