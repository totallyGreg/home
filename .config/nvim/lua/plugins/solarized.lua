return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  "maxmx03/solarized.nvim", -- Has to be run in iTerm as Apple Term is unreadable orange
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    vim.o.background = "dark" -- or 'light'
    vim.cmd.colorscheme("solarized") -- or selenized
    require("solarized").setup({
      colors = function(colors, colorhelper)
        local darken = colorhelper.darken
        local lighten = colorhelper.lighten
        local blend = colorhelper.blend

        return {
          fg = "#fff", -- output: #ffffff
          bg = darken(colors.base03, 100),
        }
      end,
      highlights = function(colors)
        return {
          Normal = { fg = colors.fg, bg = colors.bg },
        }
      end,
    })
  end,
}
