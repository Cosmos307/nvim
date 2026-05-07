-- LSP Configuration: Language servers, Mason, and formatting

return {
  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          --  gD matches Vim convention (:help gD) and pairs with gd (definition) above.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end

          -- ESLint: Auto-fix on save
          if client and client.name == 'eslint' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = event.buf,
              callback = function() vim.cmd 'EslintFixAll' end,
            })
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>
      local servers = {
        -- Backend Languages
        gopls = {
          settings = {
            gopls = {
              -- Static analysis
              analyses = {
                unusedparams      = true,
                shadow            = true,
                unusedwrite       = true,
                useany            = true,
                nilness           = true,
                unusedvariable    = true,
                fieldalignment    = false, -- noisy, opt-in
              },
              staticcheck = true,
              gofumpt = true,
              -- Inlay hints (toggle with <leader>th)
              hints = {
                assignVariableTypes      = true,
                compositeLiteralFields   = true,
                compositeLiteralTypes    = true,
                constantValues           = true,
                functionTypeParameters   = true,
                parameterNames           = true,
                rangeVariableTypes       = true,
              },
              -- Code lenses
              codelenses = {
                generate           = true,
                gc_details         = true,
                test               = true,
                tidy               = true,
                upgrade_dependency = true,
                vendor             = true,
              },
              -- Build tags / experimental
              buildFlags    = { '-tags=integration' },
              completeUnimported = true,
              usePlaceholders    = true,
              semanticTokens     = true,
              experimentalPostfixCompletions = true,
            },
          },
          on_attach = function(client, bufnr)
            -- Populate workspace diagnostics for all Go files in the project
            require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)

            -- Auto-organize imports (add missing, remove unused) on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { 'source.organizeImports' } }
                local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 1000)
                if not result or vim.tbl_isempty(result) then return end
                for _, res in pairs(result) do
                  if res.result then
                    for _, action in pairs(res.result) do
                      if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                      end
                    end
                  end
                end
              end,
            })
          end,
        },

        intelephense = {
          settings = {
            intelephense = {
              files = {
                -- Larger files for big PHP projects (Laravel/Symfony)
                maxSize = 5000000,
                associations = { '*.php', '*.phtml', '*.blade.php' },
              },
              -- Bundled stubs cover stdlib + popular extensions/frameworks.
              -- Edit list to match your project (saves memory).
              stubs = {
                'apache', 'bcmath', 'bz2', 'calendar', 'com_dotnet', 'Core',
                'ctype', 'curl', 'date', 'dba', 'dom', 'enchant', 'exif',
                'FFI', 'fileinfo', 'filter', 'fpm', 'ftp', 'gd', 'gettext',
                'gmp', 'hash', 'iconv', 'imap', 'intl', 'json', 'ldap',
                'libxml', 'mbstring', 'meta', 'mysqli', 'oci8', 'odbc',
                'openssl', 'pcntl', 'pcre', 'PDO', 'pdo_ibm', 'pdo_mysql',
                'pdo_pgsql', 'pdo_sqlite', 'pgsql', 'Phar', 'posix', 'pspell',
                'readline', 'Reflection', 'session', 'shmop', 'SimpleXML',
                'snmp', 'soap', 'sockets', 'sodium', 'SPL', 'sqlite3',
                'standard', 'superglobals', 'sysvmsg', 'sysvsem', 'sysvshm',
                'tidy', 'tokenizer', 'xml', 'xmlreader', 'xmlrpc', 'xmlwriter',
                'xsl', 'Zend OPcache', 'zip', 'zlib',
                -- Popular frameworks (uncomment what you use):
                -- 'laravel', 'symfony', 'phpunit', 'wordpress', 'drupal',
              },
              environment = {
                phpVersion = '8.3.0',
              },
              completion = {
                insertUseDeclaration             = true,
                fullyQualifyGlobalConstantsAndFunctions = false,
                triggerParameterHints            = true,
                maxItems                         = 100,
              },
              format = {
                enable = false, -- use pint / php-cs-fixer via conform.nvim instead
              },
              diagnostics = {
                enable           = true,
                undefinedTypes   = true,
                undefinedFunctions = true,
                undefinedConstants = true,
                undefinedClassConstants = true,
                undefinedMethods = true,
                undefinedProperties = true,
                undefinedVariables = true,
                unusedSymbols    = true,
              },
              telemetry = { enabled = false },
            },
          },
        },
        -- clangd = {},
        -- pyright = {},
        -- rust_analyzer = {},
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},

        -- WebApp Development LSPs
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { 'cn\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {},
        html = {},
        cssls = {},
        eslint = {},
        marksman = {},

        -- Lua (for Neovim config)
        -- Note: stylua is a formatter (via conform.nvim), not an LSP server

        -- Special Lua Config, as recommended by neovim help docs
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end

            ---@diagnostic disable-next-line
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- Additional formatters and linters
        'stylua', -- Lua formatter (not an LSP)
        'prettier', -- JavaScript/TypeScript/CSS/HTML formatter
        'eslint_d', -- Faster ESLint daemon
        -- Go tooling
        'goimports',     -- Import management (replaces gofmt for save)
        'gofumpt',       -- Stricter gofmt
        'golangci-lint', -- Meta-linter (run via none-ls or :!)
        'delve',         -- Debugger (use with nvim-dap)
        -- PHP tooling
        'pint',          -- Laravel Pint formatter (wraps php-cs-fixer with sane defaults)
        'phpstan',       -- Static analysis
        -- AI (for sidekick.nvim NES feature — requires GitHub Copilot subscription)
        'copilot-language-server',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        -- Go: goimports (handles imports + gofmt) → gofumpt (stricter style)
        go = { 'goimports', 'gofumpt' },
        -- PHP: pint (Laravel) — works on any PHP project
        php = { 'pint' },
      },
    },
  },
}
