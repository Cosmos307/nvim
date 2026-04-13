-- Git Integration Plugins: Gitsigns, LazyGit

return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
    },
  },

  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gl', '<cmd>LazyGit<cr>', desc = '[G]it [L]azyGit' },
    },
    config = function()
      -- Ensure delta is in PATH when LazyGit is called from Neovim
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      
      -- Add Homebrew bin to PATH if not already there (for delta)
      local homebrew_bin = '/opt/homebrew/bin'
      if vim.fn.isdirectory(homebrew_bin) == 1 then
        local current_path = vim.env.PATH or ''
        if not string.find(current_path, homebrew_bin, 1, true) then
          vim.env.PATH = homebrew_bin .. ':' .. current_path
        end
      end
    end,
  },
}
