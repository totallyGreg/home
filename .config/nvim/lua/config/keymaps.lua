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

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

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
