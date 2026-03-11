return {
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  {
    "maxmx03/solarized.nvim", -- Has to be run in iTerm as Apple Term is unreadable orange
    -- enabled = true,
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

  {
    "craftzdog/solarized-osaka.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "normal", -- style for sidebars, see below
        floats = "normal", -- style for floating windows },, see below
      },
      sidebars = { "qf", "help", "terminal" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      -- day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = true, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      -- lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      -- TODO:
      on_colors = function(colors)
        -- colors.hint = colors.orange
        colors.border = colors.blue
        colors.bg_util = colors.base03
      end,
    },
  },

  { "ellisonleao/gruvbox.nvim", lazy = true },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = { style = "moon" },
  },

  -- configure LazyVim to load solarized
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
      -- colorscheme = "tokyonight",
    },
  },
}
