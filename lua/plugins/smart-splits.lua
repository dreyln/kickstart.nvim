return {
  {
    'mrjones2014/smart-splits.nvim',
    event = 'VimEnter',
    keys = {
      -- moving between splits
      {
        '<C-h>',
        function()
          require('smart-splits').move_cursor_left()
        end,
      },
      {
        '<C-j>',
        function()
          require('smart-splits').move_cursor_down()
        end,
      },
      {
        '<C-k>',
        function()
          require('smart-splits').move_cursor_up()
        end,
      },
      {
        '<C-l>',
        function()
          require('smart-splits').move_cursor_right()
        end,
      },
      -- resize mode
      -- {
      --   '<leader>m',
      --   function()
      --     require('smart-splits').start_resize_mode()
      --   end,
      -- },
    },
    dependencies = {
      'pogyomo/submode.nvim',
    },
    config = function()
      -- Resize
      local submode = require 'submode'
      submode.create('WinResize', {
        mode = 'n',
        enter = '<leader>m',
        leave = '<CR>',
        hook = {
          on_enter = function()
            vim.notify 'Use { h, j, k, l } to resize the window'
          end,
          on_leave = function()
            vim.notify ''
          end,
        },
        default = function(register)
          register('h', require('smart-splits').resize_left, { desc = 'Resize left' })
          register('j', require('smart-splits').resize_down, { desc = 'Resize down' })
          register('k', require('smart-splits').resize_up, { desc = 'Resize up' })
          register('l', require('smart-splits').resize_right, { desc = 'Resize right' })
        end,
      })
    end,
    -- opts = {
    --   ignored_filetypes = { 'NvimTree', 'neo-tree' },
    --   resize_mode = {
    --     quit_key = '<CR>',
    --   },
    -- },
  },
}
