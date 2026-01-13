return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "pkl",
        "python",
        "query",
        "regex",
        "swift",
        "vim",
        "yaml",
      },
      filetype_to_parsername = {
        zsh = "bash",
      },
    },
  },
}
