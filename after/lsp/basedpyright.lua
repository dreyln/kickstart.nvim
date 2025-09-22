---@type vim.lsp.Config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'standard',
      },
      disableOrganizedImports = true,
    },
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          ignore = { '*' },
        },
      },
    },
  },
  on_init = function(client)
    local venv = require('swenv.api').get_current_venv()
    if venv ~= nil then
      local venv_python = venv.path .. '/bin/python'
      client.config.settings.python.pythonPath = venv_python
    end
  end,
  on_attach = function(client, bufnr)
    require('nvim-navic').attach(client, bufnr)
  end,
}
