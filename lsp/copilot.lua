-- Copilot Language Server config for Neovim 0.11+
-- Installed via Mason: :MasonInstall copilot-language-server
-- Sign in after install: :LspCopilotSignIn
return {
  cmd = { "copilot-language-server", "--stdio" },
  filetypes = { "*" },
  root_markers = { ".git" },
  init_options = {
    editorInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = "copilot.lua",
      version = "0.0.1",
    },
  },
}
