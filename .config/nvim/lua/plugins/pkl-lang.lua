return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function(_)
      vim.cmd("TSUpdate")
    end,
  },
  {
    "https://github.com/apple/pkl-neovim",
    lazy = true,
    event = {
      "BufReadPre *.pkl",
      "BufReadPre *.pcf",
      "BufReadPre PklProject",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  build = function()
    vim.cmd("TSInstall! pkl")
  end,
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- pkl lsp maybe
  --       pkl-lsp = {},
  --     },
  --   },
  -- },
}
