if true then
  return {}
end
return {
  {
    "benlubas/molten-nvim",
    -- version = "^1", -- Use version pinning recommended by the author
    -- Lazy load based on filetype; keymaps are deferred via VimEnter anyway
    ft = { "python", "markdown", "quarto", "json" }, -- Added 'json' for .ipynb files
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = true },
      { "nvim-tree/nvim-web-devicons", lazy = true }, -- Optional: for icons
      "folke/snacks.nvim",
      "benomahony/uv.nvim",
    },
    build = ":UpdateRemotePlugins", -- Run UpdateRemotePlugins post-install/update
    init = function()
      -- Options set before plugin loads (optional)
      -- vim.g.molten_virt_text_output = true -- Use virtual text for output (alternative)
      -- vim.g.molten_output_win_max_height = 15 -- Control output window height
      -- Enable molten by default
      vim.g.molten_auto_open_hover_preview = true
      vim.g.molten_output_win_max_height = 20

      -- Set the kernel manager if needed
      -- vim.g.molten_kernel_manager = "vim"  -- or "auto"

      -- Enable virtual text for output
      -- vim.g.molten_auto_open_output = true -- Show output automatically
      vim.g.molten_virt_lines_off = false
      vim.g.molten_virt_text_output = true

      -- Automatically show notebook info
      vim.g.molten_auto_init_notebook = true
    end,
    config = function()
      -- Helper function to run Molten commands safely
      local function run_molten_command(cmd_name, args_str, success_msg, error_msg)
        args_str = args_str or ""
        local full_cmd = cmd_name .. " " .. args_str
        local cmd_exists_name = ":" .. cmd_name

        vim.defer_fn(function() -- Delay execution slightly
          if vim.fn.exists(cmd_exists_name) == 2 then -- Check if command exists *before* running
            vim.cmd(full_cmd)
            if success_msg then
              vim.notify(success_msg, vim.log.levels.INFO, { title = "Molten" })
            end
          else
            local default_error = "Command '" .. cmd_exists_name .. "' not available. Molten init incomplete or failed?"
            vim.notify(error_msg or default_error, vim.log.levels.ERROR, { title = "Molten" })
          end
        end, 50) -- 50ms delay
      end

      -- Helper function for visual mode evaluation
      local function run_molten_visual_evaluate()
        local cmd_exists_name = ":MoltenEvaluateVisual"
        vim.defer_fn(function()
          if vim.fn.exists(cmd_exists_name) == 2 then
            -- Use nvim_command for reliable execution of range command in callback
            vim.api.nvim_command("normal! '<,'>:MoltenEvaluateVisual<CR>")
            vim.notify("Evaluating selection...", vim.log.levels.INFO, { title = "Molten" })
            -- Exit visual mode
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
          else
            vim.notify("Command ':MoltenEvaluateVisual' not available.", vim.log.levels.ERROR, { title = "Molten" })
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
          end
        end, 50)
      end

      -- Define Keymaps after Neovim is fully loaded (using VimEnter)
      local group = vim.api.nvim_create_augroup("MoltenPostLoadKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        pattern = "*",
        desc = "Define Molten keymaps after plugins likely initialized",
        once = true,
        callback = function()
          local map = vim.keymap.set
          local leader = "<leader>" -- Assumes leader key is set globally

          -- Initialization / Kernel Selection
          map("n", leader .. "ji", function()
            run_molten_command("MoltenInit", nil, "Molten Initializing...")
          end, { desc = "Molten: Initialize/Attach Kernel", noremap = true, silent = true })
          map("n", leader .. "jca", function()
            run_molten_command("MoltenSelectKernel", nil, "Select Kernel...")
          end, { desc = "Molten: Select Kernel", noremap = true, silent = true })

          -- Evaluate (Line/Selection focused for .ipynb JSON view)
          map("n", leader .. "jl", function()
            run_molten_command("MoltenEvaluateLine", nil, "Evaluating line...")
          end, { desc = "Molten: Evaluate Line", noremap = true, silent = true })
          map(
            "v",
            leader .. "js",
            run_molten_visual_evaluate,
            { desc = "Molten: Evaluate Selection", noremap = true, silent = true }
          )
          map("n", leader .. "jr", function()
            run_molten_command("MoltenReevaluateCell", nil, "Re-evaluating cell (?)")
          end, { desc = "Molten: Re-evaluate Cell (?)", noremap = true, silent = true })

          -- Cell Commands (NOTE: Use with caution in raw .ipynb JSON view)
          map("n", leader .. "jc", function()
            run_molten_command("MoltenEvaluateCell", nil, "Evaluating cell...")
          end, { desc = "Molten: Evaluate Cell (?)", noremap = true, silent = true })
          map("n", leader .. "jj", function()
            run_molten_command("MoltenEvaluateCell", nil, "Evaluating cell...")
            run_molten_command("MoltenNextCell")
          end, { desc = "Molten: Evaluate Cell & Next (?)", noremap = true, silent = true })

          -- Navigation (NOTE: Use with caution in raw .ipynb JSON view)
          map("n", leader .. "jn", function()
            run_molten_command("MoltenNextCell")
          end, { desc = "Molten: Next Cell (?)", noremap = true, silent = true })
          map("n", leader .. "jp", function()
            run_molten_command("MoltenPrevCell")
          end, { desc = "Molten: Previous Cell (?)", noremap = true, silent = true })

          -- Output/Kernel Management
          map("n", leader .. "jo", function()
            run_molten_command("MoltenClearOutput")
          end, { desc = "Molten: Clear Cell Output", noremap = true, silent = true })
          map("n", leader .. "jk", function()
            run_molten_command("MoltenInterruptKernel", nil, "Interrupting kernel...")
          end, { desc = "Molten: Interrupt Kernel", noremap = true, silent = true })
          map("n", leader .. "jR", function()
            run_molten_command("MoltenRestartKernel", nil, "Restarting kernel...")
          end, { desc = "Molten: Restart Kernel", noremap = true, silent = true })

          -- Register WhichKey group
          local wk_status_ok, wk = pcall(require, "which-key")
          if wk_status_ok then
            wk.register({ { "", group = "Molten" } }) -- Register group name
          end
        end, -- End VimEnter callback
      }) -- End autocmd definition

      -- Optional: Autocommand for syntax adjustments in .ipynb JSON view
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "json", -- Trigger on json for .ipynb files
        group = vim.api.nvim_create_augroup("MoltenCustomJsonSyntax", { clear = true }),
        callback = function()
          -- Add any custom syntax matching or concealing for JSON here if desired
          -- Example: Conceal quotes around keys (use cautiously)
          -- vim.cmd([[syntax match JsonKey #"\v(\w+)"\ze\s*:# contains=@NoSpell conceal cchar= ]])
        end,
      })
    end, -- End config function
  },
  {
    "benomahony/uv.nvim",
    -- Optional filetype to lazy load when you open a python file
    ft = { "python" },

    -- Optional dependency, but recommended:
    -- or
    --   "nvim-telescope/telescope.nvim"
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      picker_integration = true,
    },
  },
} -- End return table

-- {
--   "benlubas/molten-nvim",
--   version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
--   build = ":UpdateRemotePlugins",
--   dependencies = { "3rd/image.nvim" },
--   init = function()
--     -- Enable molten by default
--     vim.g.molten_auto_open_hover_preview = true
--     vim.g.molten_output_win_max_height = 20
--
--     -- Set the kernel manager if needed
--     -- vim.g.molten_kernel_manager = "vim"  -- or "auto"
--
--     -- Enable virtual text for output
--     vim.g.molten_virt_lines_off = false
--     vim.g.molten_virt_text_output = true
--
--     -- Automatically show notebook info
--     vim.g.molten_auto_init_notebook = true
--   end,
-- },
-- {
--   -- see the image.nvim readme for more information about configuring this plugin
--   -- https://github.com/3rd/image.nvim/issues/233
--   "3rd/image.nvim",
--   opts = {
--     backend = "ghostty", -- whatever backend you would like to use
--     max_width = 100,
--     max_height = 12,
--     max_height_window_percentage = math.huge,
--     max_width_window_percentage = math.huge,
--     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
--     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
--   },
-- },
-- {
--   "andythigpen/nvim-uv",
--   dependencies = { "neovim/nvim-lspconfig" },
--   init = function()
--     -- Configure uv settings
--     vim.g.uv_auto_activate = true
--     vim.g.uv_show_diagnostics = true
--   end,
--   config = function()
--     require("uv").setup({
--       use_on_open = true,
--       prefix = "uv run",
--       venv_dirs = { ".venv", "venv", ".pyenv" },
--     })
--
--     local map = vim.keymap.set
--     map("n", "<leader>uv", "<cmd>UvSelectVenv<CR>", { desc = "Select Python environment" })
--     map("n", "<leader>uS", "<cmd>UvShowVenv<CR>", { desc = "Show current Python environment" })
--   end,
-- },
