return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = { 'UIEnter' },
    keys = {
      { '<leader>bk', ':BufferLinePick<CR>', desc = '[B]uffer pic[k]' },
      { '<leader>bn', '<cmd>BufferLineCycleNext<cr>', desc = '[B]uffer [n]ext' },
      { '<leader>bp', '<cmd>BufferLineCyclePrev<cr>', desc = '[B]uffer [p]rev' },
      { '<leader>bi', '<cmd>BufferLineTogglePin<cr>', desc = '[B]uffer toggle p[i]n' },
    },
    opts = {
      options = {
        offsets = {
          {
            filetype = '',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
    end,
  },
}
