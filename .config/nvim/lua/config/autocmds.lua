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

-- Auto-reload buffers when files change externally (e.g., when Claude modifies them)
vim.opt.autoread = true

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("AutoReload", { clear = true })

autocmd({ "FocusGained", "TermLeave", "BufEnter", "WinEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup,
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check for external file changes and reload buffer",
})

autocmd("FileChangedShellPost", {
  group = augroup,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
  desc = "Notify when buffer is reloaded due to external changes",
})
