-- Treesitter: Advanced syntax highlighting and code understanding

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- Config läuft erst, wenn das Plugin geladen ist
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if not ok or not configs then
        vim.notify('nvim-treesitter.configs not found', vim.log.levels.WARN)
        return
      end
      configs.setup {
        ensure_installed = {
          'bash',
          'c',
          'css',
          'diff',
          'go',
          'gomod',
          'gowork',
          'html',
          'javascript',
          'json',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'php',
          'query',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
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
        '[c',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc = 'Jump to context (sticky header)',
      },
    },
  },
}
