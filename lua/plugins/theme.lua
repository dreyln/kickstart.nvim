return {
  {
    'loctvl842/monokai-pro.nvim',
    config = function()
      require('monokai-pro').setup {
        filter = 'ristretto', -- classic | machine | octagon | ristretto | spectrum
        override = function(c)
          local hp = require("monokai-pro.color_helper")
          local common_fg = hp.lighten(c.sideBar.foreground, 30)
          return {
            SnacksPicker = { bg = c.editor.background, fg = common_fg },
            SnacksPickerBorder = { bg = c.editor.background, fg = c.tab.unfocusedActiveBorder },
            SnacksPickerTree = { fg = c.editorLineNumber.foreground },
            NonText = { fg = c.base.dimmed3 }, -- not sure if this should be broken into all hl groups importing NonText
            -- SnacksPickerDirectory = { fg = c.editorLineNumber.foreground },
          }
        end,
      }
      vim.cmd 'colorscheme monokai-pro'
    end
  }
}
-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   priority = 1000,
--   opts = {
--     integrations = {
--       native_lsp = {
--         enabled = true,
--         underlines = {
--           errors = { 'undercurl' },
--           hints = { 'undercurl' },
--           warnings = { 'undercurl' },
--         },
--       },
--     },
--   },
--   init = function()
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'catppuccin'
--   end,
-- }
--
-- return {
--   { -- You can easily change to a different colorscheme.
--     -- Change the name of the colorscheme plugin below, and then
--     -- change the command in the config to whatever the name of that colorscheme is.
--     --
--     -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--     'folke/tokyonight.nvim',
--     priority = 1000, -- Make sure to load this before all the other start plugins.
--     init = function()
--       -- Load the colorscheme here.
--       -- Like many other themes, this one has different styles, and you could load
--       -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--       vim.cmd.colorscheme 'tokyonight'
--
--       -- You can configure highlights by doing something like:
--       vim.cmd.hi 'Comment gui=none'
--     end,
--   },
-- }
