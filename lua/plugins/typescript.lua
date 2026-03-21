-- TypeScript/JavaScript specific tooling

return {
  -- TypeScript Language Server with enhanced features
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        tsserver_max_memory = 'auto',
        complete_function_calls = true,
        expose_as_code_action = 'all',
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeCompletionsForModuleExports = true,
          quotePreference = 'auto',
        },
        tsserver_plugins = {
          '@react-router/dev', -- For React Router v7 generated types
        },
      },
    },
  },

  { -- JSON Schema Store for package.json, tsconfig.json validation
    'b0o/schemastore.nvim',
  },
}
