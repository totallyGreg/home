if true then
  return {}
end

return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
      root = {
        ".build",
        ".swiftpm",
        ".clang-format",
        "Package.resolved",
        "Package.swift",
      },
    })
  end,
  -- Add C/C++ to treesitter
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = { ensure_installed = { "cpp" } },
  -- },

  -- Correctly setup lspconfig for swift
  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = { enable = true },
      servers = {
        -- Ensure mason installs the server
        sourcekit = {
          keys = {},
          -- root_dir = function(fname)
          --   return require("lspconfig.util").root_pattern(
          -- end,
          capabilities = {
            textDocument = {
              documentFormattingProvider = false,
              completion = {
                completionItem = {
                  snippetSupport = true,
                  resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
                },
              },
              cmd = { "xcrun", "sourcekit-lsp" },
            },
          },
          setup = {
            sourcekit = function(_, opts)
              opts.capabilities.workspace = { didChangeWatchedFiles = { dynamicRegistration = true } }
            end,
          },
        },
      },

      {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
          opts.sorting = opts.sorting or {}
          opts.sorting.comparators = opts.sorting.comparators or {}
          table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
        end,
      },

      -- based on VSCODE extension: https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap
      -- lldb-dap is replacing codelldb for Swift >=6.0.0.
      -- https://forums.swift.org/t/rfc-improvements-to-swift-debugging-in-vs-code/77396
      -- https://github.com/llvm/llvm-project/blob/main/lldb/tools/lldb-dap/README.md
      {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
          -- Ensure C/C++ debugger is installed
          "williamboman/mason.nvim",
          optional = true,
          opts = { ensure_installed = { "codelldb" } },
        },
        opts = function()
          local dap = require("dap")
          if not dap.adapters["lldb-dap"] then
            require("dap").adapters["lldb"] = {
              type = "server",
              host = "localhost",
              port = "${port}",
              executable = {
                command = "lldb",
                -- args = {
                --   "--port",
                --   "${port}",
                -- },
              },
            }
          end
          for _, lang in ipairs({ "c", "cpp" }) do
            dap.configurations[lang] = {
              {
                type = "codelldb",
                request = "launch",
                name = "Launch file",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
              },
              {
                type = "codelldb",
                request = "attach",
                name = "Attach to process",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
            }
          end
        end,
      },
    },
  },
}
