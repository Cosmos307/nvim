-- workspace-diagnostics.nvim: Show LSP errors for all project files in Neo-tree, not just open buffers
-- https://github.com/artemave/workspace-diagnostics.nvim
--
-- This plugin sends textDocument/didOpen to LSP for all project files (via `git ls-files`),
-- triggering diagnostics without actually opening them. Neo-tree then shows error icons for all files.

return {
  'artemave/workspace-diagnostics.nvim',
  event = 'LspAttach',
  config = function()
    require('workspace-diagnostics').setup {
      -- Default: uses `git ls-files` to find project files
      -- You can customize if needed:
      -- workspace_files = function()
      --   return vim.fn.systemlist('find . -name "*.go"')
      -- end
    }
  end,
}
