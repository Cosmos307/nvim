-- Alpha (Dashboard): Cool ASCII-Art beim Neovim-Start
-- ASCII-Arts liegen in lua/ascii-art/*.lua

return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Zufälliges ASCII-Art aus lua/ascii-art/ laden
    local ascii_art_files = {
      'guts-portrait',
      'guts-fullbody',
      'guts-pyramid',
      'guts-cascade',
      'guts-scene',
      'guts-strip',
      'berserk-logo',
    }
    
    -- Zufälliges ASCII-Art wählen
    math.randomseed(os.time())
    local random_art = ascii_art_files[math.random(#ascii_art_files)]
    dashboard.section.header.val = require('ascii-art.' .. random_art)
    
    -- Oder: Immer das gleiche ASCII-Art (auskommentieren und random_art ersetzen):
    -- dashboard.section.header.val = require('ascii-art.guts-portrait')

    -- Buttons (Shortcuts)
    dashboard.section.buttons.val = {
      dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
      dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('r', '  Recent files', ':Telescope oldfiles <CR>'),
      dashboard.button('g', '  Find text', ':Telescope live_grep <CR>'),
      dashboard.button('c', '  Config', ':e $MYVIMRC <CR>'),
      dashboard.button('l', '  Lazy', ':Lazy<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>'),
    }

    -- Footer (optional: zeigt Neovim-Version + Plugin-Count)
    local function footer()
      local total_plugins = require('lazy').stats().count
      local datetime = os.date ' %d-%m-%Y   %H:%M:%S'
      local version = vim.version()
      local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch

      return datetime .. '   ' .. total_plugins .. ' plugins' .. nvim_version_info
    end

    dashboard.section.footer.val = footer()

    -- Layout
    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'padding', val = 1 },
      dashboard.section.footer,
    }

    -- Disable folding on alpha buffer
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]

    alpha.setup(dashboard.config)
  end,
}
