return {
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    opts = {
      inlay_hints = { enabled = true },
      autoformat = false,
      capabilities = {
        textDocument = {
          documentFormattingProvider = false,
          codelens = { enable = true },
          completion = {
            completionItem = {
              snippetSupport = true,
              resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
            },
          },
        },
      },
      setup = {
        markdown_oxide = function(_, opts)
          opts.capabilities.workspace = { didChangeWatchedFiles = { dynamicRegistration = true } }
        end,
      },
      servers = {
        markdown_oxide = {},
        sourcekit = { cmd = { "xcrun", "sourcekit-lsp" } },
        -- marksman = {},
      },
    },
  },
}
