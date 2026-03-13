return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open git diff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: branch history" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { winbar_info = true },
      },
    },
  },
}
