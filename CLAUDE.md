# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Neovim configuration built on kickstart.nvim, heavily extended for web (TypeScript/React/Tailwind), backend (Go, PHP), and AI-assisted development. Uses lazy.nvim for plugin management.

## Structure

```
init.lua                  # Entry point: sets leader, loads config.* modules in order
lua/config/
  options.lua             # Vim settings
  lazy.lua                # Plugin manager bootstrap + imports lua/plugins/ and kickstart/plugins/
  keymaps.lua             # Core keybindings
  autocmds.lua            # Autocommands (treesitter fallback, per-filetype indent, etc.)
lua/plugins/              # One file per plugin/feature group (lazy-loaded)
lua/kickstart/plugins/    # Optional kickstart extras (neo-tree, gitsigns, autopairs, indent_line)
lsp/copilot.lua           # Copilot LSP config (loaded by sidekick.nvim, not lsp.lua)
lua/ascii-art/            # Dashboard art (7 Berserk variations, randomly selected)
```

## Key Architectural Decisions

**Plugin loading order matters:** `init.lua` loads `options` → `lazy` → `keymaps` → `autocmds`. The leader key must be set before lazy loads plugins.

**Mini.nvim is a single config block:** All mini.nvim modules (statusline, ai, surround, comment) are configured in one `config` function in `lua/plugins/mini.lua`. Splitting across multiple specs causes lazy.nvim to silently run only one config block — do not split them.

**LSP architecture:** `nvim-lspconfig` + Mason + mason-lspconfig handle server installation/config. `conform.nvim` handles formatting on save (not LSP format). Go uses a custom `on_attach` that fires `source.organizeImports` via `textDocument/codeAction` on `BufWritePre`. Go.nvim is configured with many features disabled (`lsp = false`, `lsp_keymaps = false`, `lsp_format_on_save = false`) because lsp.lua and conform already cover those.

**Transparent theme:** All themes use `transparent = true`. A `ColorScheme` autocommand strips backgrounds from `Normal`, `NormalNC`, `NormalFloat`, `SignColumn` for terminal transparency (Ghostty). The custom Telescope colorscheme picker (`<leader>sC`) re-runs theme `setup()` before applying and sorts dark themes first.

**Workspace diagnostics:** `workspace-diagnostics.nvim` populates LSP errors for all project files (not just open buffers) by sending `textDocument/didOpen` for each `git ls-files` result. This makes Neo-tree show project-wide error counts.

**Copilot isolation:** The Copilot LSP is configured in `lsp/copilot.lua` and loaded by sidekick.nvim's `init`. Keep it separate from `lua/plugins/lsp.lua`.

## LSP Servers & Formatters

| Language | LSP | Formatter |
|----------|-----|-----------|
| Go | gopls | goimports → gofumpt |
| PHP | intelephense | pint |
| TypeScript/JS | typescript-tools (ts_ls) | prettier |
| Lua | lua_ls | stylua |
| Web (CSS/HTML/YAML/JSON) | cssls, html, yamlls, jsonls | prettier |

TypeScript uses `typescript-tools.nvim` (not plain ts_ls) for enhanced inlay hints, auto-imports, and React Router v7.

## Important Keybindings

- **Leader:** `<Space>`
- **Fuzzy find:** `<leader>sf` (files), `<leader>sg` (grep), `<leader>sw` (word), `<leader>sC` (colorschemes)
- **LSP:** `gd` (definition), `gr` (references), `gi` (implementation), `K` (hover), `grn` (rename), `gra` (action)
- **TypeScript:** `<leader>to/ts/tu/ti/tf/tr/tg` (organize/sort/remove-unused/add-imports/fix-all/rename-file/source-def)
- **Go:** `<leader>G*` prefix — tests (`<leader>Gtt/tf/tp`), codegen (`<leader>Gie/Gfs/Gfw/Gat/Grt/Gim`), run (`<leader>Grr/Grb`)
- **Git:** `<leader>gl` (LazyGit), `]g`/`[g` (hunks), `<leader>gp/gd/gb/gs/gr`
- **Terminal:** `<leader>tt/tv/tF` (horizontal/vertical/float)
- **AI/Sidekick:** `<leader>aa` (Claude CLI), `<C-.>` (focus CLI), `<Tab>` (apply Copilot NES suggestion)
- **Treesitter moves:** `]f`/`[f` (function), `]C`/`[C` (class), `]a`/`[a` (parameter); `;`/`,` repeat

## Plugin Lock File

`lazy-lock.json` pins all plugin versions. Run `:Lazy update` inside Neovim to update plugins and regenerate the lock file. There is no separate build/test step for this config.

