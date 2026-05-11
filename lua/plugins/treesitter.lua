-- Treesitter: Advanced syntax highlighting and code understanding

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- nvim-treesitter MAIN branch API: parsers are installed via the new install() function.
      -- The old `configs.setup({ ensure_installed = ... })` is gone.
      -- Highlighting itself is enabled by the FileType autocmd in config/autocmds.lua.
      local parsers = {
        'go', 'gomod', 'gowork', 'gotmpl',
        'php', 'phpdoc',
        'lua', 'luadoc',
        'vim', 'vimdoc',
        'query', 'regex',
      }

      local ts = require 'nvim-treesitter'
      -- Install missing parsers asynchronously on first run
      local installed = ts.get_installed and ts.get_installed('parsers') or {}
      local installed_set = {}
      for _, p in ipairs(installed) do installed_set[p] = true end

      local missing = {}
      for _, p in ipairs(parsers) do
        if not installed_set[p] then table.insert(missing, p) end
      end
      if #missing > 0 then
        ts.install(missing):await(function()
          vim.notify('Treesitter: installed ' .. #missing .. ' parsers', vim.log.levels.INFO)
        end)
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 5,
        multiline_threshold = 10,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
        line_numbers = true,
      }
    end,
    keys = {
      {
        '[x',
        function() require('treesitter-context').go_to_context(vim.v.count1) end,
        desc = 'Jump to context (sticky header)',
      },
    },
  },

  -- Language-agnostic [f/]f navigation for functions, classes, etc.
  -- Works for any language with a textobjects.scm query (Go, PHP, TS, Lua, Python, ...)
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'BufReadPost',
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@function.outer'] = 'V',
            ['@class.outer']    = 'V',
          },
          include_surrounding_whitespace = false,
        },
        move = { set_jumps = true },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local rep = require 'nvim-treesitter-textobjects.repeatable_move'

      -- Text objects: af / if (a function / inner function), ac / ic (class)
      local function map_select(lhs, capture)
        for _, mode in ipairs { 'x', 'o' } do
          vim.keymap.set(mode, lhs, function() select.select_textobject(capture, 'textobjects') end, { desc = 'TS: select ' .. capture })
        end
      end
      map_select('af', '@function.outer')
      map_select('if', '@function.inner')
      map_select('ac', '@class.outer')
      map_select('ic', '@class.inner')
      map_select('aa', '@parameter.outer')
      map_select('ia', '@parameter.inner')

      -- Movement: [f / ]f (function start), [F / ]F (function end), [C / ]C (class)
      local function jump(lhs, fn, capture, desc)
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function() fn(capture, 'textobjects') end, { desc = desc })
      end
      jump(']f', move.goto_next_start,     '@function.outer', 'Next function start')
      jump('[f', move.goto_previous_start, '@function.outer', 'Prev function start')
      jump(']F', move.goto_next_end,       '@function.outer', 'Next function end')
      jump('[F', move.goto_previous_end,   '@function.outer', 'Prev function end')
      jump(']C', move.goto_next_start,     '@class.outer',    'Next class start')
      jump('[C', move.goto_previous_start, '@class.outer',    'Prev class start')
      jump(']a', move.goto_next_start,     '@parameter.inner','Next parameter')
      jump('[a', move.goto_previous_start, '@parameter.inner','Prev parameter')

      -- Make ; and , repeat the last [f/]f/etc. movement (Vim-idiomatic)
      vim.keymap.set({ 'n', 'x', 'o' }, ';', rep.repeat_last_move_next,     { desc = 'Repeat last TS move forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, ',', rep.repeat_last_move_previous, { desc = 'Repeat last TS move backward' })
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', rep.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', rep.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', rep.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', rep.builtin_T_expr, { expr = true })
    end,
  },
}
