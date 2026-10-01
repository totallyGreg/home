return {
  {
    -- Seamless C-h/j/k/l navigation and M-h/j/k/l resizing across nvim splits and tmux panes.
    -- Keymaps live in config/keymaps.lua so they win over LazyVim's <A-j>/<A-k> move-line defaults.
    "mrjones2014/smart-splits.nvim",
    -- Not lazy: tmux reads the @pane-is-vim option this sets on load.
    lazy = false,
    opts = {},
  },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          -- LazyVim's terminal nav keys only move within nvim; drop them so the global
          -- smart-splits terminal-mode maps can continue into tmux panes.
          keys = { nav_h = false, nav_j = false, nav_k = false, nav_l = false },
        },
      },
    },
  },
}
