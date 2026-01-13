return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci", "-bn" },
      },
      taplo = {
        prepend_args = { "fmt" },
      },
      -- swift_format = {
      --   command = "xcrun -find swift-format",
      --   stdin = false,
      --   args = { "$FILENAME", "--in-place" },
      -- },
    },
    formatters_by_ft = {
      ["bash"] = { "shfmt" },
      ["toml"] = { "taplo" },
      ["markdown"] = { "prettier" },
      ["sh"] = { "shfmt" },
      ["swift"] = { "swift" },
      ["yaml"] = { "prettier" },
      ["zsh"] = { "shfmt" },
    },
  },
}
