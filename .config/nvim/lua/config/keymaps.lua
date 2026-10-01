-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Moving text with auto indention
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
-- Center curson on page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Navigate/resize across nvim splits (incl. terminals) and tmux panes; see plugins/smart-splits.lua
local ss = require("smart-splits")
vim.keymap.set({ "n", "t" }, "<C-h>", ss.move_cursor_left, { desc = "Go to Left Window/Pane" })
vim.keymap.set({ "n", "t" }, "<C-j>", ss.move_cursor_down, { desc = "Go to Lower Window/Pane" })
vim.keymap.set({ "n", "t" }, "<C-k>", ss.move_cursor_up, { desc = "Go to Upper Window/Pane" })
vim.keymap.set({ "n", "t" }, "<C-l>", ss.move_cursor_right, { desc = "Go to Right Window/Pane" })
vim.keymap.set({ "n", "t" }, "<M-h>", ss.resize_left, { desc = "Resize Left" })
vim.keymap.set({ "n", "t" }, "<M-j>", ss.resize_down, { desc = "Resize Down" })
vim.keymap.set({ "n", "t" }, "<M-k>", ss.resize_up, { desc = "Resize Up" })
vim.keymap.set({ "n", "t" }, "<M-l>", ss.resize_right, { desc = "Resize Right" })

-- Move lines on Option-Shift (LazyVim's Option-j/k now resize); H/L shift indent
vim.keymap.del({ "i", "v" }, "<A-j>")
vim.keymap.del({ "i", "v" }, "<A-k>")
vim.keymap.set("n", "<M-J>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<M-K>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<M-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<M-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<M-J>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<M-K>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set("n", "<M-H>", "<<", { desc = "Indent Left" })
vim.keymap.set("n", "<M-L>", ">>", { desc = "Indent Right" })
vim.keymap.set("i", "<M-H>", "<C-d>", { desc = "Indent Left" })
vim.keymap.set("i", "<M-L>", "<C-t>", { desc = "Indent Right" })
vim.keymap.set("v", "<M-H>", "<gv", { desc = "Indent Left" })
vim.keymap.set("v", "<M-L>", ">gv", { desc = "Indent Right" })

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank visual selection with file path (for pasting into coding agents)
vim.keymap.set("v", "<leader>yr", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.fn.getline(start_line, end_line)
  local rel_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  local header = rel_path .. ":" .. start_line
  if start_line ~= end_line then
    header = header .. "-" .. end_line
  end
  local content = header .. "\n" .. table.concat(lines, "\n")
  vim.fn.setreg("+", content)
  vim.notify("Yanked with relative path", vim.log.levels.INFO)
end, { desc = "Yank selection with relative file path" })

vim.keymap.set("v", "<leader>ya", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.fn.getline(start_line, end_line)
  local abs_path = vim.fn.expand("%:p")
  local header = abs_path .. ":" .. start_line
  if start_line ~= end_line then
    header = header .. "-" .. end_line
  end
  local content = header .. "\n" .. table.concat(lines, "\n")
  vim.fn.setreg("+", content)
  vim.notify("Yanked with absolute path", vim.log.levels.INFO)
end, { desc = "Yank selection with absolute file path" })

-- local kube_utils_mappings = {
--   { "<leader>k", group = "Kubernetes" }, -- Main title for all Kubernetes related commands
--   -- Helm Commands
--   { "<leader>kh", group = "Helm" },
--   { "<leader>khT", "<cmd>HelmDryRun<CR>", desc = "Helm DryRun Buffer" },
--   { "<leader>khb", "<cmd>HelmDependencyBuildFromBuffer<CR>", desc = "Helm Dependency Build" },
--   { "<leader>khd", "<cmd>HelmDeployFromBuffer<CR>", desc = "Helm Deploy Buffer to Context" },
--   { "<leader>khr", "<cmd>RemoveDeployment<CR>", desc = "Helm Remove Deployment From Buffer" },
--   { "<leader>kht", "<cmd>HelmTemplateFromBuffer<CR>", desc = "Helm Template From Buffer" },
--   { "<leader>khu", "<cmd>HelmDependencyUpdateFromBuffer<CR>", desc = "Helm Dependency Update" },
--   -- Kubectl Commands
--   { "<leader>kk", group = "Kubectl" },
--   { "<leader>kkC", "<cmd>SelectSplitCRD<CR>", desc = "Download CRD Split" },
--   { "<leader>kkD", "<cmd>DeleteNamespace<CR>", desc = "Kubectl Delete Namespace" },
--   { "<leader>kkK", "<cmd>OpenK9s<CR>", desc = "Open K9s" },
--   { "<leader>kka", "<cmd>KubectlApplyFromBuffer<CR>", desc = "Kubectl Apply From Buffer" },
--   { "<leader>kkc", "<cmd>SelectCRD<CR>", desc = "Download CRD" },
--   { "<leader>kkk", "<cmd>OpenK9sSplit<CR>", desc = "Split View K9s" },
--   { "<leader>kkl", "<cmd>ToggleYamlHelm<CR>", desc = "Toggle YAML/Helm" },
--   -- Logs Commands
--   { "<leader>kl", group = "Logs" },
--   { "<leader>klf", "<cmd>JsonFormatLogs<CR>", desc = "Format JSON" },
--   { "<leader>klv", "<cmd>ViewPodLogs<CR>", desc = "View Pod Logs" },
-- }
-- -- Register the Kube Utils keybindings
-- require("which-key").add(kube_utils_mappings)
