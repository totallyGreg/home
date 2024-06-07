return {
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    event = "LazyFile",
    opts = {
      indent = { char = "¦" },
    },
    main = "ibl",
  },
}
