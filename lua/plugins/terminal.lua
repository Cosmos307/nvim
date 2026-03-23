-- Toggleterm.nvim: persistent, togglable terminals (no manual :term / exit dance)
-- https://github.com/akinsho/toggleterm.nvim
--
-- Keymaps use <leader>t + letter. We use <leader>tF (capital F) for float to avoid
-- clashing with TypeScript <leader>tf (fix all) in lua/config/keymaps.lua.

---@module 'toggleterm'
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    {
      '<leader>tt',
      '<cmd>ToggleTerm direction=horizontal<CR>',
      desc = 'Toggle [t]erminal (horizontal)',
      silent = true,
    },
    {
      '<leader>tv',
      '<cmd>ToggleTerm direction=vertical<CR>',
      desc = 'Toggle [t]erminal (vertical split)',
      silent = true,
    },
    {
      '<leader>tF',
      '<cmd>ToggleTerm direction=float<CR>',
      desc = 'Toggle [t]erminal (float)',
      silent = true,
    },
  },
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return math.floor(vim.o.lines * 0.35)
        elseif term.direction == 'vertical' then
          return math.floor(vim.o.columns * 0.38)
        end
      end,
      direction = 'horizontal',
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = false,
      persist_mode = true,
      persist_size = true,
      close_on_exit = true,
      auto_scroll = true,
      float_opts = {
        border = 'rounded',
        winblend = 0,
      },
    }
  end,
}
