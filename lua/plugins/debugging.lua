return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',
      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    keys = function(_, keys)
      local dap = require 'dap'
      local dapui = require 'dapui'
      return {
        -- Basic debugging keymaps, feel free to change to your liking!
        { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
        { '<F7>', dap.step_into, desc = 'Debug: Step Into' },
        { '<F8>', dap.step_over, desc = 'Debug: Step Over' },
        { '<F9>', dap.step_out, desc = 'Debug: Step Out' },
        { '<leader>tB', dap.toggle_breakpoint, desc = '[T]oggle [B]reakpoint' },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        { '<F6>', dapui.toggle, desc = 'Debug: See last session result.' },
        unpack(keys),
      }
    end,
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,
        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},
        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'python',
        },
      }

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup { ---@diagnostic disable-line: missing-fields
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = 'mfussenegger/nvim-dap',
    config = function()
      -- uses the debugypy installation by mason
      local debugpy_python_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python3'
      local dap_python = require 'dap-python'
      dap_python.setup(debugpy_python_path, {}) ---@diagnostic disable-line: missing-fields
      dap_python.test_runner = 'pytest'
      vim.keymap.set({ 'n', 'v' }, '<Leader>Dt', function()
        dap_python.test_method()
      end, { desc = 'Run unit test' })
    end,
  },
}
