-- sidekick.nvim: AI CLI integration + Copilot Next Edit Suggestions
--
-- Two independent features:
--   1. NES (Next Edit Suggestions) — requires GitHub Copilot subscription
--   2. CLI terminal — works with Claude, opencode, etc.
--
-- Prerequisites:
--   • Claude CLI:   npm install -g @anthropic-ai/claude-code
--   • ANTHROPIC_API_KEY in ~/.zprofile (loaded from macOS Keychain)
--   • For NES:      GitHub Copilot subscription
--                   :MasonInstall copilot-language-server
--                   :LspCopilotSignIn (once after install)

return {
  -- blink.cmp: give sidekick NES priority on <Tab> (after snippets)
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<Tab>"] = {
          "snippet_forward",
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          "fallback",
        },
      },
    },
  },

  -- sidekick.nvim
  {
    "folke/sidekick.nvim",
    init = function()
      -- Enable the Copilot LSP (config lives in lsp/copilot.lua)
      vim.lsp.enable("copilot")
    end,
    opts = {
      nes = {
        -- Disable if you don't have a GitHub Copilot subscription
        enabled = true,
      },
      cli = {
        win = {
          layout = "right",
          split = { width = 85 },
          keys = {
            -- <Esc> im insert mode (terminal) → normal mode, prompt bleibt erhalten
            esc_insert = { "<Esc>", "stopinsert", mode = "t", desc = "exit insert mode" },
            -- <Esc> im normal mode → zurück zum Code-Fenster, terminal bleibt offen
            esc_normal = { "<Esc>", "blur", mode = "n", desc = "go back to previous window" },
          },
        },
        mux = {
          -- Persist CLI sessions across nvim restarts (requires tmux: brew install tmux)
          enabled = false,
          backend = "tmux",
        },
        tools = {
          claude   = {},
          opencode = {},
          gemini   = {},
          codex    = {},
        },
      },
    },
    keys = {
      -- NES: jump to or apply next edit suggestion, fall back to normal <Tab>
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Sidekick: Goto/Apply Next Edit Suggestion",
      },
      -- CLI: focus toggle from any mode
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "t", "i", "x" },
        desc = "Sidekick: Focus CLI",
      },
      -- CLI: main controls
      { "<leader>aa", function() require("sidekick.cli").toggle() end,                                   desc = "Sidekick: Toggle CLI" },
      { "<leader>as", function() require("sidekick.cli").select() end,                                   desc = "Sidekick: Select CLI tool" },
      { "<leader>ad", function() require("sidekick.cli").close() end,                                    desc = "Sidekick: Detach CLI session" },
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,  desc = "Sidekick: Toggle Claude" },
      -- Context sending
      { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end,                   mode = { "x", "n" }, desc = "Sidekick: Send this" },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,                   desc = "Sidekick: Send file" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end,              mode = { "x" },      desc = "Sidekick: Send selection" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end,                                   mode = { "n", "x" }, desc = "Sidekick: Select prompt" },
    },
  },
}
