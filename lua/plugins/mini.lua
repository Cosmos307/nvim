-- Mini.nvim: consolidated setup for all mini modules
-- Previously split across editor.lua and ui.lua, causing mini.ai/surround/comment
-- to silently not load (lazy.nvim only runs one config when two specs conflict).

return {
  {
    'nvim-mini/mini.nvim',
    event = 'VimEnter',
    config = function()
      -- Statusline
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      -- Better Around/Inside textobjects (va), yi), ci', etc.)
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings: saiw), sd', sr)'
      require('mini.surround').setup()

      -- Comment toggle: gcc, gc (visual), gcip
      require('mini.comment').setup()
    end,
  },
}
