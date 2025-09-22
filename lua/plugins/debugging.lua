return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',
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
        { '<leader>Di', dapui.eval, desc = 'Debug: Evaluate expression.' },
        { '<leader>Dl', dap.list_breakpoints, desc = 'Debug: List breakpoints.' },
        unpack(keys),
      }
    end,
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

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

      if vim.fn.filereadable '.vscode/launch.json' then
        require('dap.ext.vscode').load_launchjs(nil, {})
      end
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#D03939' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = 'mfussenegger/nvim-dap',
    config = function()
      -- venv with debugpy installed
      local debugpy_python_path = vim.fn.expand '~/sd/debugpy' .. '/.venv/bin/python'
      local dap_python = require 'dap-python'
      dap_python.setup(debugpy_python_path, {}) ---@diagnostic disable-line: missing-fields
      dap_python.test_runner = 'pytest'
      vim.keymap.set({ 'n', 'v' }, '<Leader>Dt', function()
        dap_python.test_method { config = { justMyCode = false } } ---@diagnostic disable-line: missing-fields
      end, { desc = 'Run unit test' })
    end,
  },
}
