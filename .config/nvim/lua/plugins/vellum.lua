return {
  "blackhat-7/vellum.nvim",
  ft = "markdown",
  keys = {
    { "<leader>mp", "<cmd>Vellum<cr>", ft = "markdown", desc = "Markdown preview" },
    { "<leader>mz", function() require("vellum").zoom() end, ft = "markdown", desc = "Markdown zoom image" },
  },
  opts = {},
}
