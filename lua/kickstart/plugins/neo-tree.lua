-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- ──────────────────────────────────────────────────────────────────────────────
-- OPTIONAL: cycle Neo-tree source without focusing the sidebar (<leader>< / <leader>>)
-- Set to `false` to disable; to remove entirely, delete this block up to the next banner below.
-- ──────────────────────────────────────────────────────────────────────────────
local NEO_TREE_GLOBAL_SOURCE_CYCLE = true

local neo_tree_cycle_keymaps = {}
if NEO_TREE_GLOBAL_SOURCE_CYCLE then
  ---@param delta integer -1 = previous, +1 = next (order = source_selector.sources)
  local function neotree_cycle_source(delta)
    local ok, cmd = pcall(require, 'neo-tree.command')
    if not ok then return end
    local nt = require 'neo-tree'
    nt.ensure_config()

    local sources_cfg = (nt.config.source_selector and nt.config.source_selector.sources) or nt.config.sources
    local src_list = {}
    for _, s in ipairs(sources_cfg) do
      if type(s) == 'string' then
        table.insert(src_list, { source = s })
      else
        table.insert(src_list, s)
      end
    end
    if #src_list == 0 then return end

    local current_name = nil
    local position = nil ---@type string?
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == 'neo-tree' then
        local ok1, name = pcall(vim.api.nvim_buf_get_var, buf, 'neo_tree_source')
        local ok2, pos = pcall(vim.api.nvim_buf_get_var, buf, 'neo_tree_position')
        if ok1 and ok2 then
          current_name = name
          position = pos
          break
        end
      end
    end

    if not current_name then
      current_name = cmd._last.source or nt.config.default_source
      position = cmd._last.position
    end

    local idx = 1
    for i, si in ipairs(src_list) do
      if si.source == current_name then
        idx = i
        break
      end
    end
    local next_idx = idx + delta
    if next_idx < 1 then
      next_idx = #src_list
    elseif next_idx > #src_list then
      next_idx = 1
    end
    local next_src = src_list[next_idx]

    cmd.execute {
      source = next_src.source,
      position = position,
      action = 'show',
    }
  end

  neo_tree_cycle_keymaps = {
    {
      '<leader><lt>',
      function() neotree_cycle_source(-1) end,
      desc = 'Neo-tree: previous source (keep focus)',
    },
    {
      '<leader>>',
      function() neotree_cycle_source(1) end,
      desc = 'Neo-tree: next source (keep focus)',
    },
  }
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Lazy plugin spec (main Neo-tree config)
-- ──────────────────────────────────────────────────────────────────────────────

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = vim.list_extend({
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>tg', '<cmd>Neotree git_status<CR>', desc = 'NeoTree [G]it status view', silent = true },
    { '<leader>tS', '<cmd>Neotree document_symbols<CR>', desc = 'NeoTree document [S]ymbols (LSP)', silent = true },
  }, neo_tree_cycle_keymaps),
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    sort_case_insensitive = true,

    close_if_last_window = true,

    enable_diagnostics = false,

    -- Git: symbols next to files in the tree + dedicated git_status source (see source_selector / <leader>tg)
    enable_git_status = true,
    -- MUST be true: false runs git synchronously and can trigger E5560 (systemlist in fast event) with file watcher / scan
    git_status_async = true,

    -- all sources available for neotree
    sources = {
      'filesystem',
      'git_status',
      'buffers',
      'document_symbols', -- LSP: outline of the current file
    },

    default_component_configs = {
      git_status = {
        symbols = {
          added = 'A',
          deleted = 'D',
          modified = 'M',
          renamed = 'R',
          untracked = '?',
          ignored = '!',
          unstaged = 'M',
          staged = 'M',
          conflict = 'U',
        },
        align = 'right',
      },
      name = {
        use_git_status_colors = true,
      },
    },

    -- winbar source tabs
    source_selector = {
      winbar = true,
      truncation_character = '…', -- required by neotree.Config.SourceSelector (tab labels)
      sources = {
        { source = 'filesystem' },
        { source = 'document_symbols' },
        { source = 'git_status' },
        { source = 'buffers' },
      },
    },

    filesystem = {
      bind_to_cwd = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },

    -- winbar git_status source tab - ? for mappings (ga, gt, gc, …)
    git_status = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },

    -- winbar buffers source tab
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },

    -- winbar document_symbols source tab - LSP must provide `textDocument/documentSymbol`
    document_symbols = {
      follow_cursor = true,
      window = {
        mappings = {
          ['Space'] = 'jump_to_symbol',
          ['<cr>'] = 'jump_to_symbol',
          ['o'] = 'jump_to_symbol',
          ['/'] = 'filter',
          ['z'] = 'close_all_nodes',
          ['f'] = 'filter_on_submit',
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
