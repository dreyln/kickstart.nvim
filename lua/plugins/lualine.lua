return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {
          'fileformat',
          'filetype',
          {
            'swenv',
            icon = '',
            cond = function()
              return vim.bo.filetype == 'python'
            end,
          },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
}
