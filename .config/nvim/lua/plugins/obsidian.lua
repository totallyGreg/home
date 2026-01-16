return {
  -- I'd like to incorporate markdown-oxide landguage server https://github.com/Feel-ix-343/markdown-oxide?tab=readme-ov-file
  -- I have no idea if the mason install configures lsp correctly or not
  --
  -- opts.root_dir = lspconfig.util.root_pattern(".git", ".obsidian", ".moxide.toml", "*.md"),
  --
  -- Enable opening daily notes with natural langauge
  -- Modify your lsp on_attach function to support opening daily notes with, for example, :Daily two days ago or :Daily next monday.
  -- -- setup Markdown Oxide daily note commands
  -- opts.on_attach = function(client, _)
  --   vim.api.nvim_create_user_command(
  --     "Daily",
  --     function(args)
  --       local input = args.args
  --
  --       vim.lsp.buf.execute_command({command="jump", arguments={input}})
  --
  --     end,
  --     {desc = 'Open daily note', nargs = "*"}
  --   )
  -- end
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- Personal laptop
      "BufReadPre /Users/totally/Notes/**.md",
      "BufNewFile /Users/totally/Notes/**.md",
      -- Work laptop
      "BufReadPre /Users/gregwilliams/Notes/**.md",
      "BufNewFile /Users/gregwilliams/Notes/**.md",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:

    dependencies = {
      -- Required.
      -- "hrsh7th/nvim-cmp",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter",

      -- see below for full list of optional dependencies 👇
    },
    keys = {
      { "<leader>o", "<cmd>ObsidianOpen<cr>", desc = "Obsidian" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian" },
      { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Open Obsidian Daily Note" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Open Obsidian Rename" },
      { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open Obsidian Quick Switch" },
      { "<leader>ch", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle Checkbox", ft = "markdown" },
      { "gf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link", ft = "markdown" },
      { "<cr>", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link / Toggle Checkbox", ft = "markdown" },
    },
    opts = {
      -- If you're using MacOS and your 'Obsidian.app' happens to be in a non-standard location,
      -- (i.e. not '/Applications/Obsidian.app') you can set the path here.
      app_path = "~/Applications/Comm/Written/Obsidian.app",
      workspaces = {
        {
          name = "personal",
          path = "/Users/totally/Notes",
        },
        {
          name = "work",
          path = "/Users/gregwilliams/Notes",
        },
      },
      -- Completion is now handled via native sources or blink.cmp
      -- The old nvim_cmp option is deprecated
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
        date_format = "%Y/%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "900 📐Templates/🌄 New Day.md",
      },
      -- Keymaps are now configured via lazy.nvim keys or autocmds
      -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps
      new_notes_location = "700 Vaults/Notes",

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      end,

      -- Configure how to open notes in Obsidian app
      open = {
        func = function(uri)
          vim.ui.open(uri, { cmd = { "open", "-a", vim.fn.expand("~/Applications/Comm/Written/Obsidian.app") } })
        end,
      },

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

      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      search_max_lines = 1000,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",

      -- Optional, define your own callbacks to further customize behavior.
      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        ---@param client obsidian.Client
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        -- Runs anytime you enter the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        enter_note = function(client, note) end,

        -- Runs anytime you leave the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        leave_note = function(client, note) end,

        -- Runs right before writing the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        pre_write_note = function(client, note) end,

        -- Runs anytime the workspace is set/changed.
        ---@param client obsidian.Client
        ---@param workspace obsidian.Workspace
        post_set_workspace = function(client, workspace) end,
      },

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
      -- Optional, customize how wiki links are formatted. You can set this to one of:
      --  * "use_alias_only", e.g. '[[Foo Bar]]'
      --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
      --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      --  * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      templates = {
        folder = "900 Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
    },
  },

  -- Markdown rendering (headings, code blocks, tables, checkboxes, bullets, etc.)
  -- Replaces the deprecated 'ui' option from obsidian.nvim v3.x
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      heading = { enabled = true },
      code = { enabled = true },
      dash = { enabled = true },
      link = { enabled = true },
      sign = { enabled = false },
      bullet = {
        enabled = true,
        icons = { "•", "◦", "▸", "▹" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = " " },
        custom = {
          todo = { raw = "[>]", rendered = " ", highlight = "RenderMarkdownWarn" },
          cancelled = { raw = "[~]", rendered = "󰰱 ", highlight = "RenderMarkdownError" },
          important = { raw = "[!]", rendered = " ", highlight = "DiagnosticError" },
        },
      },
    },
  },
}
