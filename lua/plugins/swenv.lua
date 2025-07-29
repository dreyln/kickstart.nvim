return {
  {
    'dreyln/swenv.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- Should return a list of tables with a `name` and a `path` entry each.
      -- Gets the argument `venvs_path` set below.
      -- By default just lists the entries in `venvs_path`.
      get_venvs = function(venvs_path)
        local venvs = {}
        -- Check current dir for a .venv folder
        local cwd_venv = venvs_path .. '/.venv'
        if vim.fn.isdirectory(cwd_venv) == 1 then
          local parent_dir = vim.fn.fnamemodify(venvs_path, ':t') -- Get the parent directory name
          table.insert(venvs, { path = cwd_venv, name = parent_dir, source = 'venv' }) -- Add to the table
        end
        -- Read the immediate subdirectories
        local subdirs = vim.fn.readdir(venvs_path)
        for _, entry in ipairs(subdirs) do
          local full_path = venvs_path .. '/' .. entry
          if vim.fn.isdirectory(full_path) == 1 then
            local venv_path = full_path .. '/.venv'
            if vim.fn.isdirectory(venv_path) == 1 then
              local parent_dir = vim.fn.fnamemodify(full_path, ':t') -- Get the parent directory name
              table.insert(venvs, { path = venv_path, name = parent_dir, source = 'venv' }) -- Add to the table
            end
          end
        end
        return venvs
        -- return require('swenv.api').get_venvs(venvs_path)
      end,
      -- Path passed to `get_venvs`.
      -- venvs_path = vim.fn.expand '~/.virtualenvs',
      venvs_path = vim.fn.getcwd(),
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
          local isRealPath = vim.fn.expand('%:p:h'):sub(1, 1) == '/'
          if isRealPath and vim.bo[nested_opts.buf].filetype == 'python' then
            -- Search up, trying to find a .venv dir
            local venv_path = vim.fn.finddir('.venv', './;')
            if venv_path and venv_path ~= '' then
              local venv_name = vim.fn.fnamemodify(venv_path, ':h:t')
              -- vim.api.nvim_echo({ { 'NAME: ' .. venv_name, 'None' } }, true, {})
              local swenv_api = require 'swenv.api'
              local current_venv_name = nil
              local current_venv = swenv_api.get_current_venv()
              if current_venv then
                current_venv_name = current_venv.name
              end
              if venv_name ~= current_venv_name then
                swenv_api.set_venv(venv_name)
              end
              -- old way with a .venv file with the virtualenv name inside
              -- local venv_file = io.open(venv_path)
              -- if venv_file then
              --   local swenv_api = require 'swenv.api'
              --   local current_venv_name = nil
              --   local current_venv = swenv_api.get_current_venv()
              --   if current_venv then
              --     current_venv_name = current_venv.name
              --   end
              --   local ws_venv = string.gsub(venv_file:read '*a', '%s+', '')
              --   if ws_venv ~= current_venv_name then
              --     swenv_api.set_venv(ws_venv)
              --   end
              --   venv_file:close()
              -- end
            end
          end
        end,
        group = vim.api.nvim_create_augroup('python_venv', { clear = true }),
      })
    end,
  },
}
