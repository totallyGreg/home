-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Enable the 'trim_trailing_whitespace' option in LazyVim
-- vim.opt.trim_trailing_whitespace = { true }

-- define the characters used for displaying invisible characters
vim.opt.listchars = {
  tab = "▸ ", -- tab requires a string of two characters
  trail = "▫",
}
-- finally found out to disable this shit
-- when enabled all scrolling navigation is broke including going to line numbers!
vim.g.snacks_animate_scroll = false

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = true
