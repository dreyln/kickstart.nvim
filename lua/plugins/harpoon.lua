return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mike-jl/harpoonEx',
    },
    config = function()
      local harpoonEx = require 'harpoonEx'
      vim.keymap.set('n', '<leader>sa', function()
        require('telescope').extensions.harpoonEx.harpoonEx {
          -- Optional: modify mappings, default mappings:
          attach_mappings = function(_, map)
            local actions = require('telescope').extensions.harpoonEx.actions
            map({ 'n', 'i' }, '<C-d>', actions.delete_mark)
            map({ 'i' }, '<C-p>', actions.move_mark_up)
            map({ 'i' }, '<C-n>', actions.move_mark_down)
            return true
          end,
        }
        return true
      end, { desc = 'Open harpoon window' })

      require('harpoon'):setup()
    end,
    keys = {
      {
        '<leader>A',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'harpoon file',
      },
      {
        '<leader>a',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'harpoon quick menu',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'harpoon to file 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'harpoon to file 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'harpoon to file 3',
      },
      {
        '<leader>4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'harpoon to file 4',
      },
      {
        '<leader>5',
        function()
          require('harpoon'):list():select(5)
        end,
        desc = 'harpoon to file 5',
      },
    },
  },
}
