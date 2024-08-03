return {
  -- I'd like to incorporate markdown-oxide landguage server https://github.com/Feel-ix-343/markdown-oxide?tab=readme-ov-file
  -- I have no idea if the mason install configures lsp correctly or not
  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = function()
  --     return {
  --       -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
  --       -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
  --       capabilities = {
  --         workspace = {
  --           didChangeWatchedFiles = {
  --             dynamicRegistration = true,
  --           },
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre /Users/totally/Library/Mobile Documents/iCloud~md~obsidian/Documents/**.md",
      "BufNewFile /Users/totally/Library/Mobile Documents/iCloud~md~obsidian/Documents/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter",

      -- see below for full list of optional dependencies 👇
    },
    keys = {
      { "<leader>o", "<cmd>ObsidianOpen<cr>", desc = "Obsidian" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian" },
      { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Open Obsidian Daiy Note" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Open Obsidian Rename" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open Obsidian Quick Switch" },
    },
    opts = {
      workspaces = {
        -- {
        --   name = "personal-iCloud",
        --   path = "/Users/totally/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes",
        -- },
        {
          name = "personal-local",
          path = "/Users/totally/Notes",
        },
      },
      -- Optional, completion.
      completion = {
        nvim_cmp = false, -- if using nvim-cmp, otherwise set to false
      },
      config = function(_, opts)
        require("obsidian").setup(opts)

        -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
        -- see also: 'follow_url_func' config option above.
        -- vim.keymap.set("n", "<leader>gf", function()
        --   if require("obsidian").util.cursor_on_markdown_link() then
        --     return "<cmd>ObsidianFollowLink<CR>"
        --   else
        --     return "gf"
        --   end
        -- end, { noremap = false, expr = true })

        -- vim.keymap.set("n", "<leader>O", "<cmd>ObsidianOpen<CR>")
      end,
      -- see below for full list of options 👇
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "500 ♽ Cycles/520 🌄 Days",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "900 Templates/910 File Templates/🌄 New Day.md",
      },
      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      new_notes_location = "700 Vaults/Notes",
      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = false,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = false,

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
      },
      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      sort_by = "modified",
      sort_reversed = true,

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "700 Vaults/Notes/Attachments", -- This is the default
        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path obsidian.Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
      templates = {
        folder = "900 Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
      },
    },
  },
}
