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
    },
    formatters_by_ft = {
      toml = { "taplo" },
      markdown = { "prettier" },
    },
  },
}
