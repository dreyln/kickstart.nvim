return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'fileformat', 'filetype' },
        lualine_y = {
          {
            'swenv',
            icon = '',
            cond = function()
              return vim.bo.filetype == 'python'
            end,
          },
        },
        lualine_z = { 'location' },
      },
    },
  },
  {
    'dreyln/swenv.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- Should return a list of tables with a `name` and a `path` entry each.
      -- Gets the argument `venvs_path` set below.
      -- By default just lists the entries in `venvs_path`.
      get_venvs = function(venvs_path)
        return require('swenv.api').get_venvs(venvs_path)
      end,
      -- Path passed to `get_venvs`.
      venvs_path = vim.fn.expand '~/.virtualenvs',
      -- Something to do after setting an environment, for example call vim.cmd.LspRestart
      -- post_set_venv = nil,
      post_set_venv = function()
        local client = vim.lsp.get_clients({ name = 'basedpyright' })[1]
        if not client then
          return
        end
        local venv = require('swenv.api').get_current_venv()
        if not venv then
          return
        end
        local venv_python = venv.path .. '/bin/python'
        if client.settings then
          client.settings = vim.tbl_deep_extend('force', client.settings, { python = { pythonPath = venv_python } })
        else
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = venv_python } })
        end
        client.notify('workspace/didChangeConfiguration', { settings = nil })
      end,
    },
  },
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
              local venv = string.gsub(venv_file:read '*a', '%s+', '')
              require('swenv.api').set_venv(venv)
              venv_file:close()
            end
          end
        end,
      },
    },
  },
  { 'natecraddock/sessions.nvim', opts = {} },
}
