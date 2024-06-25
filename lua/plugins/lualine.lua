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
}
