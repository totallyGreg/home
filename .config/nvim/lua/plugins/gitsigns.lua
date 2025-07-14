return {
  {
    "purarue/gitsigns-yadm.nvim",
    lazy = true,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  "lewis6991/gitsigns.nvim",
  opts = {
    _on_attach_pre = function(_, callback)
      require("gitsigns-yadm").yadm_signs(callback)
    end,
    -- other configuration for gitsigns...
  },
}

-- dependencies = {
--   "nvim-lua/plenary.nvim",
--   {
--     "purarue/gitsigns-yadm.nvim",
--     opts = {
--       shell_timeout_ms = 1000,
--     },
--   },
-- },
