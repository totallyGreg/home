return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "seanbreckenridge/gitsigns-yadm.nvim",
      config = function()
        require("gitsigns-yadm").setup({ yadm_repo_git = "~/.config/yadm/repo.git " })
      end,
    },
  },
}
