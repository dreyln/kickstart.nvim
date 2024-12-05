return {
  {
    'propet/toggle-fullscreen.nvim',
    keys = {
      {
        '<leader><CR>',
        function()
          require('toggle-fullscreen'):toggle_fullscreen()
        end,
      },
    },
  },
}
