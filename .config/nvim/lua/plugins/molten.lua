-- return {
--   {
--     "benlubas/molten-nvim",
--     version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
--     build = ":UpdateRemotePlugins",
--     init = function()
--       -- this is an example, not a default. Please see the readme for more configuration options
--       vim.g.molten_output_win_max_height = 12
--     end,
--   },
-- }

return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    -- https://github.com/3rd/image.nvim/issues/233
    "3rd/image.nvim",
    opts = {
      backend = "ghostty", -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
