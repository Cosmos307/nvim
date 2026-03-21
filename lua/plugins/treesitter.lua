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
          'diff',
          'go',
          'gomod',
          'gowork',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}
