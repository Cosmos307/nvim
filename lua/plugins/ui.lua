-- UI Plugins: Colorscheme, Statusline, Which-key

return {
  -- Colorschemes: tokyonight (default) + catppuccin
  -- Switch with :Telescope colorscheme or :colorscheme <name>
  
  { -- Tokyonight (default)
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = true },
        },
        on_highlights = function(hl, c)
          -- Make cursor more visible in light mode
          hl.Cursor = { fg = c.bg, bg = c.fg }
          hl.CursorLine = { bg = c.bg_highlight }
        end,
      }
      -- Load tokyonight by default (comment out to use catppuccin instead)
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { -- Catppuccin (alternative)
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = false,
        custom_highlights = function(colors)
          return {
            -- Dark cursor in light mode, light cursor in dark mode
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
      -- Uncomment to use catppuccin as default:
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },
}
