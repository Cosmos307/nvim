-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Treesitter highlighting (nvim-treesitter main branch)
-- Tries to start TS for the buffer; falls back to vim's syntax highlighting if no parser.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kickstart-ts-highlight', { clear = true }),
  pattern = {
    'bash', 'c', 'css', 'diff', 'go', 'gomod', 'gowork', 'html',
    'javascript', 'javascriptreact', 'json', 'jsdoc', 'lua', 'luadoc',
    'markdown', 'markdown_inline', 'php', 'phpdoc', 'query', 'regex',
    'tsx', 'typescript', 'typescriptreact', 'vim', 'vimdoc', 'yaml',
  },
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if not ok then
      -- Parser missing — fall back to built-in regex syntax so we still get colors
      vim.bo[args.buf].syntax = 'on'
    end
  end,
})

-- PHP: tab width 4 (PSR-12 standard)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  group = vim.api.nvim_create_augroup('kickstart-php-indent', { clear = true }),
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})

-- Go: tabs (Go convention) + show special go file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  group = vim.api.nvim_create_augroup('kickstart-go-indent', { clear = true }),
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
  end,
})
