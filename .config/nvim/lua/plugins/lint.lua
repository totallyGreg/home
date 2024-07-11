-- attempting to make the stupid line length warnings go away
-- did not work... disabling markdownlint for now
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- linters_by_ft = {
      --   fish = { "fish" },
      --   -- Use the "*" filetype to run linters on all filetypes.
      --   -- ['*'] = { 'global linter' },
      --   -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      --   -- ['_'] = { 'fallback linter' },
      --   -- ["*"] = { "typos" },
      -- },
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
      },
    },
  },
}
