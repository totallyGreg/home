-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- make zsh files recognized as sh for bash-ls & treesitter

-- Trying to get shell parsing in treesitter to work
-- vim.filetype.add({
--   extension = {
--     zsh = "sh",
--     sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
--   },
--   filename = {
--     [".zshrc"] = "sh",
--     [".zshenv"] = "sh",
--   },
-- })
