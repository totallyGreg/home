return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "seanbreckenridge/gitsigns-yadm.nvim",
      opts = {
        shell_timeout_ms = 1000,
      },
    },
  },
  opts = {
    _on_attach_pre = function(_, callback)
      require("gitsigns-yadm").yadm_signs(callback)
    end,
    -- other configuration for gitsigns...
  },
}
