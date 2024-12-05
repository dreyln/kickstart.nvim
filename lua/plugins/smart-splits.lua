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
      {
        '<leader>m',
        function()
          require('smart-splits').start_resize_mode()
        end,
      },
    },
    opts = {
      ignored_filetypes = { 'NvimTree', 'neo-tree' },
      resize_mode = {
        quit_key = '<CR>',
      },
    },
  },
}
