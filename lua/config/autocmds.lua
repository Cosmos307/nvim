-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Go: Jump to previous/next function (start of func declaration)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  group = vim.api.nvim_create_augroup('kickstart-go-func-jump', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', '[f', '?^func <CR>', { buffer = event.buf, desc = 'Go: previous function' })
    vim.keymap.set('n', ']f', '/^func <CR>', { buffer = event.buf, desc = 'Go: next function' })
  end,
})

-- Treesitter highlighting (nvim-treesitter main branch)
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
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
  callback = function() vim.treesitter.start() end,
})
