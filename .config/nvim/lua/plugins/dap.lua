return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = "williamboman/mason.nvim",
  opts = function()
    local dap = require("dap")
    if not dap.adapters.lldb then
      local xcode_path = vim.fn.trim(vim.fn.system("xcode-select -p"))
      dap.adapters.lldb = {
        type = "executable",
        command = xcode_path .. "/usr/bin/lldb-dap",
        name = "lldb",
      }
    end

    dap.configurations.swift = {
      {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
  end,
}
