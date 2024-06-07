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
