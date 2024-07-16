return {
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
    config = function(_, opts)
      require('swenv').setup(opts)
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        callback = function(nested_opts)
          if vim.bo[nested_opts.buf].filetype == 'python' then
            local venv_path = nil
            local dir_template = '%:p:h'
            local dir_to_check = nil
            while not venv_path and dir_to_check ~= '/' do
              dir_to_check = vim.fn.expand(dir_template)
              if vim.fn.filereadable(dir_to_check .. '/.venv') == 1 then
                venv_path = dir_to_check .. '/.venv'
              else
                dir_template = dir_template .. ':h'
              end
            end
            if venv_path then
              local venv_file = io.open(venv_path)
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
          end
        end,
        group = vim.api.nvim_create_augroup('python_venv', { clear = true }),
      })
    end,
  },
}
