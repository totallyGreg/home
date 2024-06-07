return {
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  {
    "maxmx03/solarized.nvim", -- Has to be run in iTerm as Apple Term is unreadable orange
    lazy = true,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      transparent = false,
      palette = "solarized",
      styles = {
        comments = {},
        keywords = { bold = false },
      },
      theme = "default", -- or "neo",
    },
  },

  -- add gruvbox
  { "ellisonleao/gruvbox.nvim", lazy = true },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  -- configure LazyVim to load solarized
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
