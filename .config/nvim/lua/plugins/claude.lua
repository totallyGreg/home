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
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude terminal" },
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
