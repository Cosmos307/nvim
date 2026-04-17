-- Editor Enhancement Plugins: Text objects, commenting, indentation, todo highlighting

return {
  -- Automatically detect and set indentation
  { 'NMAC427/guess-indent.nvim', event = 'BufReadPost', opts = {} },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'BufReadPost',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

}
