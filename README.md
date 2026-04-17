# My Neovim Configuration

A modern, modular Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), optimized for web development (TypeScript, React, Tailwind) and backend development (Go, PHP).

## Features

### Language Support
- **TypeScript/JavaScript**: Full LSP with inlay hints, auto-imports, React Router v7 support
- **Go**: gopls with auto-imports on save (organize imports: add missing, remove unused)
- **PHP**: intelephense
- **Lua**: lua_ls optimized for Neovim config development
- **Web**: Tailwind CSS, HTML, CSS, JSON (with schema validation), YAML, Markdown

### Key Plugins
- **Telescope**: Fuzzy finder with performance optimizations
- **Treesitter**: Advanced syntax highlighting + sticky context (function/class headers stay visible when scrolling)
- **Blink.cmp**: Fast autocompletion with Rust fuzzy matcher
- **LSP**: Full IDE features (go-to-definition, references, rename, code actions)
- **Mini.nvim**: Text objects, surround, commenting, statusline
- **Gitsigns**: Git integration with inline diff
- **LazyGit**: Terminal UI for Git
- **Which-key**: Discover keybindings
- **Toggleterm.nvim**: Toggle integrated terminal (horizontal / vertical / float) without `:term` / `exit` friction
- **Workspace-diagnostics.nvim**: Project-wide LSP errors visible in Neo-tree for all files (not just open buffers)
- **Conform.nvim**: Auto-formatting on save

### Special Features
- ESLint auto-fix on save
- TypeScript inlay hints (parameter names, types, return types)
- Tailwind CSS IntelliSense with `cn()` and `clsx()` support
- JSON schema validation for `package.json`, `tsconfig.json`, etc.
- Telescope performance optimizations (ignores node_modules, build folders, large files)

## Directory Structure

```
~/.config/
├── nvim/                       # Neovim config
│   ├── init.lua                # Entry point (loads all modules)
│   ├── lua/
│   │   ├── config/
│   │   │   ├── options.lua     # Vim options (line numbers, clipboard, etc.)
│   │   │   ├── keymaps.lua     # Keybindings (splits, diagnostics, TypeScript, terminal)
│   │   │   ├── autocmds.lua    # Autocommands (yank highlight, Treesitter)
│   │   │   └── lazy.lua        # Plugin manager bootstrap
│   │   ├── plugins/
│   │   │   ├── ui.lua          # Colorscheme (tokyonight), which-key, statusline
│   │   │   ├── editor.lua      # Mini.nvim (ai, surround, comment), todo-comments
│   │   │   ├── git.lua         # Gitsigns, LazyGit
│   │   │   ├── telescope.lua   # Fuzzy finder + all keymaps
│   │   │   ├── treesitter.lua  # Syntax highlighting
│   │   │   ├── lsp.lua         # LSP servers, Mason, conform.nvim
│   │   │   ├── completion.lua  # Blink.cmp, LuaSnip
│   │   │   ├── terminal.lua    # Toggleterm (shell toggles)
│   │   │   └── typescript.lua  # TypeScript-tools, schemastore
│   │   └── kickstart/
│   │       └── plugins/        # Optional plugins (autopairs, neo-tree, indent-line)
│   ├── lazy-lock.json          # Plugin versions lockfile
│   └── README.md               # This file
├── lazygit/
│   └── config.yml              # LazyGit config (symlinked from macOS default path)
└── delta/
    └── config                  # Delta theme/colors (for git diff + LazyGit)
```

## Installation

### Prerequisites

**Required:**
- Neovim >= 0.11.0
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope grep)
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/) (for icons)
- C compiler (gcc/clang) and `make` (for fzf-native)

**Optional (for better performance):**
- [fd](https://github.com/sharkdp/fd) (faster file finding)

**Language-specific:**
- Node.js + npm (for TypeScript/JavaScript development)
- Go (for Go development)
- PHP (for PHP development)

### Install on macOS

```bash
# Install Neovim
brew install neovim

# Install dependencies
brew install ripgrep fd
brew install font-jetbrains-mono-nerd-font

# Clone this config
git clone <your-repo-url> ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

### First Launch

On first launch, lazy.nvim will automatically:
1. Install all plugins
2. Compile fzf-native
3. Download LSP servers via Mason

Wait for all installations to complete, then restart Neovim.

## Key Mappings

Leader key: `<Space>`

### Essential Keymaps

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sf` | Normal | Search Files (Telescope) |
| `<leader>sg` | Normal | Search by Grep (find text in files) |
| `<leader>sb` | Normal | Search Buffers |
| `<leader><leader>` | Normal | Find existing buffers |
| `<leader>/` | Normal | Fuzzy search in current buffer |
| `<leader>sn` | Normal | Search Neovim config files |

### Terminal (toggleterm.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tt` | Normal | Toggle terminal (horizontal split, bottom) |
| `<leader>tv` | Normal | Toggle terminal (vertical split) |
| `<leader>tF` | Normal | Toggle terminal (floating; capital **F** avoids clash with TypeScript `<leader>tf`) |
| `<C-h/j/k/l>` | Terminal | Focus other windows (after `<Esc><Esc>` or while using Neovim terminal mode) |

### LSP Keymaps (when LSP is active)

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | Normal | Go to Definition |
| `gD` | Normal | Go to Declaration |
| `gr` | Normal | Go to References |
| `gi` | Normal | Go to Implementation |
| `grt` | Normal | Go to Type Definition |
| `grn` | Normal | Rename symbol |
| `gra` | Normal/Visual | Code Action |
| `K` | Normal | Hover documentation |
| `<leader>th` | Normal | Toggle inlay hints |

### TypeScript Keymaps

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>to` | Normal | Organize imports |
| `<leader>ts` | Normal | Sort imports |
| `<leader>tu` | Normal | Remove unused |
| `<leader>ti` | Normal | Add missing imports |
| `<leader>tf` | Normal | Fix all |
| `<leader>tr` | Normal | Rename file |
| `<leader>tg` | Normal | Go to source definition |

### Editor Keymaps

| Key | Mode | Description |
|-----|------|-------------|
| `gcc` | Normal | Toggle comment line |
| `gc` | Visual | Toggle comment selection |
| `saiw)` | Normal | Surround word with parentheses |
| `sd"` | Normal | Delete surrounding quotes |
| `sr)"` | Normal | Replace ) with " |
| `<C-h/j/k/l>` | Normal | Navigate splits |
| `[c` | Normal | Jump to context (sticky header: function/class start) |

### Git Keymaps

All git commands under `<leader>g`:

| Key | Mode | Description |
|-----|------|-------------|
| `]g` / `[g` | Normal | Next/previous git change (hunk) |
| `<leader>gl` | Normal | Open LazyGit |
| `<leader>gp` | Normal | Preview hunk (popup) |
| `<leader>gd` | Normal | Diff against index (split) |
| `<leader>gD` | Normal | Diff against last commit |
| `<leader>gb` | Normal | Blame line |
| `<leader>gs` | Normal/Visual | Stage hunk |
| `<leader>gr` | Normal/Visual | Reset hunk |
| `<leader>gS` | Normal | Stage buffer |
| `<leader>gR` | Normal | Reset buffer |
| `<leader>gu` | Normal | Undo stage hunk |
| `<leader>hs` | Normal/Visual | Stage hunk |
| `<leader>hr` | Normal/Visual | Reset hunk |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line |

## Customization

### Adding a New Plugin

Create a new file in `lua/plugins/` or add to an existing one:

```lua
-- lua/plugins/myplugin.lua
return {
  {
    'author/plugin-name',
    event = 'VeryLazy',
    opts = {
      -- your config here
    },
  },
}
```

lazy.nvim automatically loads all files in `lua/plugins/`.

### Adding a New LSP Server

Edit `lua/plugins/lsp.lua` and add to the `servers` table:

```lua
local servers = {
  -- ... existing servers ...
  rust_analyzer = {},  -- Add Rust support
  pyright = {},        -- Add Python support
}
```

Mason will automatically install the server on next launch.

### Changing Colorscheme

Edit `lua/plugins/ui.lua`:

```lua
-- Replace 'folke/tokyonight.nvim' with your preferred theme
'catppuccin/nvim',
-- Update the colorscheme command
vim.cmd.colorscheme 'catppuccin'
```

### Modifying Options

Edit `lua/config/options.lua` to change Vim settings:

```lua
vim.o.relativenumber = false  -- Disable relative line numbers
vim.o.scrolloff = 5           -- Change scroll offset
```

### Adding Keymaps

Edit `lua/config/keymaps.lua`:

```lua
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
```

## Useful Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Lazy update` | Update all plugins |
| `:Mason` | Open LSP/tool installer |
| `:checkhealth` | Verify configuration health |
| `:Telescope` | Open Telescope picker |
| `:TSUpdate` | Update Treesitter parsers |
| `:ConformInfo` | Show formatter info |
| `:LspInfo` | Show LSP server status |

## Troubleshooting

### Plugins not loading
```bash
# Remove plugin cache and reinstall
rm -rf ~/.local/share/nvim
nvim
```

### LSP not working
```bash
# Check LSP status
:LspInfo

# Reinstall LSP servers
:Mason
# Press 'X' on server, then 'i' to reinstall
```

### Telescope slow
- Ensure ripgrep is installed: `brew install ripgrep`
- Check fzf-native is compiled: `ls ~/.local/share/nvim/lazy/telescope-fzf-native.nvim/build/`
- Performance optimizations are already configured in `lua/plugins/telescope.lua`

### Completion not working
```bash
# Check blink.cmp health
:checkhealth blink

# Verify Rust fuzzy matcher is downloaded
# It downloads automatically on first use
```

## Performance

This configuration is optimized for fast startup and smooth operation:
- Lazy loading: Plugins load on-demand (event, ft, keys)
- Telescope: Ignores large directories, limits preview size
- Blink.cmp: Uses Rust fuzzy matcher for fast completion
- Treesitter: Only loads parsers for active filetypes

## Credits

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries.

## License

MIT
