-- Command the managed Claude terminal runs; nil means plain `claude`.
local current_cmd

local function claude_running()
  return require("claudecode.terminal").get_active_terminal_bufnr() ~= nil
end

---Point claudecode.nvim at `cmd`, then toggle its terminal.
---Refuses to swap backends while a session is running, since only one terminal is managed.
---@param cmd string?
local function toggle_claude(cmd)
  if cmd ~= current_cmd then
    if claude_running() then
      vim.notify("Close the running Claude session before switching backends", vim.log.levels.WARN)
      return
    end
    current_cmd = cmd
    -- An empty table keeps the terminal settings from setup; only the command changes.
    ---@diagnostic disable-next-line: missing-fields
    require("claudecode.terminal").setup({}, cmd, require("claudecode").state.config.env)
  end
  vim.cmd("ClaudeCode")
end

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Focus Claude terminal after sending selections for quick feedback
      focus_after_send = true,

      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.35,
        provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
        auto_close = true,
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
      },
    },
    keys = {
      -- AI/Claude Code prefix
      { "<leader>a", nil, desc = "AI/Claude Code" },

      -- Core Commands
      -- Toggles whichever session is running; starts plain Claude when none is.
      {
        "<leader>ac",
        function()
          toggle_claude(claude_running() and current_cmd or nil)
        end,
        desc = "Toggle Claude terminal",
      },
      {
        "<leader>al",
        function()
          require("util.omlx").pick("Claude on oMLX profile", function(id)
            toggle_claude("omlx launch claude --model " .. vim.fn.shellescape(id))
          end)
        end,
        desc = "Claude on local oMLX profile",
      },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude terminal" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume previous Claude session" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model (opus/sonnet/haiku)" },

      -- Context Management
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to Claude context" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send visual selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file from tree",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },

      -- Diff Management (when Claude proposes changes)
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude's proposed changes" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude's proposed changes" },
    },
  },
}
