-- Go-specific tooling: test runner, struct tags, build tags, error wrapping
--
-- ray-x/go.nvim is a comprehensive Go IDE plugin built on gopls.
-- Heavy but worth it: provides :GoTest, :GoAddTag, :GoFillStruct, :GoIfErr,
-- :GoCoverage, :GoImpl, etc. — all the niceties from VS Code's Go extension.

return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod', 'gowork', 'gotmpl' },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require('go').setup {
        -- We already configure gopls in lsp.lua — disable go.nvim's own LSP setup
        lsp_cfg = false,
        lsp_keymaps = false,
        lsp_inlay_hints = { enable = true },
        -- Diagnostics handled by Neovim's defaults
        diagnostic = false,
        -- Use conform.nvim for formatting (already configured)
        lsp_document_formatting = false,
        lsp_codelens = true,
        -- Test runner output in floating window
        run_in_floaterm = false,
        -- Better :GoFillStruct / :GoFillSwitch placeholder values
        fillstruct = 'gopls',
        -- Go to Definition jumps to mocks too if available
        gofmt = 'gofumpt',
        max_line_len = 120,
        tag_transform = 'snakecase', -- snake_case for json tags
        tag_options = 'json=omitempty',
        -- DAP integration (requires nvim-dap + delve)
        dap_debug = true,
        dap_debug_keymap = false,
        dap_debug_gui = true,
        dap_debug_vt = true,
        -- Code lens for tests above each function
        test_runner = 'go', -- 'go' | 'richgo' | 'dlv' | 'ginkgo' | 'gotestsum'
        verbose_tests = true,
      }
    end,
    keys = {
      -- Tests
      { '<leader>Gtt', '<cmd>GoTest<cr>', ft = 'go', desc = '[G]o [t]est all' },
      { '<leader>Gtf', '<cmd>GoTestFunc<cr>', ft = 'go', desc = '[G]o [t]est [f]unction' },
      { '<leader>Gtp', '<cmd>GoTestPkg<cr>', ft = 'go', desc = '[G]o [t]est [p]ackage' },
      { '<leader>Gtc', '<cmd>GoCoverage<cr>', ft = 'go', desc = '[G]o [t]est [c]overage' },
      -- Code generation
      { '<leader>Gie', '<cmd>GoIfErr<cr>', ft = 'go', desc = '[G]o [i]f [e]rr block' },
      { '<leader>Gfs', '<cmd>GoFillStruct<cr>', ft = 'go', desc = '[G]o [f]ill [s]truct' },
      { '<leader>Gfw', '<cmd>GoFillSwitch<cr>', ft = 'go', desc = '[G]o [f]ill s[w]itch' },
      { '<leader>Gat', '<cmd>GoAddTag<cr>', ft = 'go', desc = '[G]o [a]dd struct [t]ags' },
      { '<leader>Grt', '<cmd>GoRmTag<cr>', ft = 'go', desc = '[G]o [r]emove struct [t]ags' },
      { '<leader>Gim', '<cmd>GoImpl<cr>', ft = 'go', desc = '[G]o [im]plement interface' },
      -- Run / build
      { '<leader>Grr', '<cmd>GoRun<cr>', ft = 'go', desc = '[G]o [r]un' },
      { '<leader>Grb', '<cmd>GoBuild<cr>', ft = 'go', desc = '[G]o build' },
      -- Mod
      { '<leader>Gmt', '<cmd>GoModTidy<cr>', ft = 'go', desc = '[G]o [m]od [t]idy' },
      -- Doc
      { '<leader>Gd', '<cmd>GoDoc<cr>', ft = 'go', desc = '[G]o [d]oc under cursor' },
    },
  },
}
