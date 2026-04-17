-- Colorschemes
-- Switch with :Telescope colorscheme (live preview enabled in telescope.lua)
-- To change default: set vim.cmd.colorscheme in the active theme's config

return {
  { -- Tokyonight (default active theme)
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = true },
        },
        on_highlights = function(hl, c)
          hl.Cursor = { fg = c.bg, bg = c.fg }
          hl.CursorLine = { bg = c.bg_highlight }
        end,
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { -- Catppuccin (alternative)
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = true,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = false,
        custom_highlights = function(colors)
          return {
            Cursor = { fg = colors.base, bg = colors.text },
            CursorLine = { bg = colors.surface0 },
          }
        end,
        integrations = {
          treesitter = true,
          telescope = { enabled = true },
          which_key = true,
          gitsigns = true,
          mini = { enabled = true },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
          },
        },
      }
    end,
  },

  { -- Cyberdream (alternative)
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('cyberdream').setup {
        variant = 'default', -- "default" (dark) or "light"
        italic_comments = true,
        terminal_colors = true,
        extensions = {
          telescope = true,
          gitsigns = true,
          mini = true,
          treesitter = true,
          whichkey = true,
        },
      }
    end,
  },

  { -- Rose Pine (alternative) — rose-pine, rose-pine-moon, rose-pine-dawn
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    lazy = true,
    config = function()
      require('rose-pine').setup {
        variant = 'main', -- "main" (dark), "moon" (dark), "dawn" (light)
        styles = { italic = true },
      }
    end,
  },

  { -- Bluloco (alternative) — bluloco-dark, bluloco-light
    'uloco/bluloco.nvim',
    priority = 1000,
    lazy = true,
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      require('bluloco').setup {
        style = 'dark', -- "dark" or "light"
        italic = true,
      }
    end,
  },

  { 'shaunsingh/nord.nvim', priority = 1000, lazy = true },
  { 'neanias/everforest-nvim', priority = 1000, lazy = true },
  { 'AlexvZyl/nordic.nvim', priority = 1000, lazy = true },
}
