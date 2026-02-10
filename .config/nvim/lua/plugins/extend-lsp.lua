return {
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "mason-org/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    opts = {
      inlay_hints = { enabled = true },
      autoformat = false,
      codelens = { enable = true },
      -- capabilities = {
      --   textDocument = {
      --     documentFormattingProvider = false,
      --     completion = {
      --       completionItem = {
      --         snippetSupport = true,
      --         resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
      --       },
      --     },
      --   },
      -- },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        ["*"] = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        markdown_oxide = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = { dynamicRegistration = true },
            },
          },
          on_attach = function(client, bufnr)
            vim.api.nvim_create_user_command(
              "Daily",
              function(args)
                local input = args.args
                vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
              end,
              { desc = "Open daily note", nargs = "*" }
            )
          end,
        },
        sourcekit = {
          mason = false,
          cmd = { "xcrun", "sourcekit-lsp" },
          filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
          settings = {},
          capabilities = {
            workspace = {
              didChangeWatchedFiles = { dynamicRegistration = true },
            },
          },
        },
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
        -- pkl-lang = {},

        -- marksman = {},
      },
      setup = {
        -- stupid    Error  21:33:16 notify.error sourcekit: -32001: sourcekitd request timed out
        -- https://github.com/neovim/nvim-lspconfig/issues/3445
        -- pkg-lang = function(_, opts)
        --   opts.capabilities.workspace = { didChangeWatchedFiles = { dynamicRegistration = true } }
        -- end,
        -- yamlls = function()
        --   -- Neovim < 0.10 does not have dynamic registration for formatting
        --   if vim.fn.has("nvim-0.10") == 0 then
        --     LazyVim.lsp.on_attach(function(client, _)
        --       client.server_capabilities.documentFormattingProvider = true
        --     end, "yamlls")
        --   end
        -- end,
      },
    },
  },
  -- Example configuration for bashls using nvim-lspconfig
  require("lspconfig").bashls.setup({
    filetypes = { "sh", "bash", "zsh" },
  }),

  -- -- Helm LSP setup
  -- require("lspconfig").helm_ls.setup({
  --   filetypes = { "helm" },
  -- }),
}
