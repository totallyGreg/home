return 
{
  "echasnovski/mini.align",
  version = false,
  mappings = {
    start = "ga",
    start_with_preview = "gA",
  },
  config = function(_, opts)
    require("mini.align").setup(opts)
  end,
}
