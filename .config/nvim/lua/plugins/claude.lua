return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.35,
        provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
        auto_close = true,
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
      },
    },
    keys = {
      -- WARN: Doesn't seem to work, still requires 3 escapes to go left
      -- { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", mode = "t" },
      -- { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = "t" },
    },
  },
}
