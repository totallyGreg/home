return {
  {
    -- IDE server for the pi agent: diffs, diagnostics, selection context.
    -- Claude compatibility stays off; claudecode.nvim already serves Claude.
    "ldelossa/pi-ide.nvim",
    event = "VeryLazy",
    config = function()
      require("pi-ide").setup()
    end,
    keys = {
      {
        "<leader>ap",
        function()
          require("util.omlx").pick("pi on oMLX profile", function(id)
            -- -e loads the agent half of the pi-ide protocol for this session only.
            Snacks.terminal.toggle({ "pi", "-e", "npm:@ldelossa/pi-ide", "--model", "omlx/" .. id }, {
              win = { position = "right", width = 0.35 },
            })
          end)
        end,
        desc = "pi on local oMLX profile",
      },
    },
  },
}
