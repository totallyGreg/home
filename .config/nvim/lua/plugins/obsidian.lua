local user_home = vim.fn.expand("~")
local notes_path = user_home .. "/Notes"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. notes_path .. "/**.md",
      "BufNewFile " .. notes_path .. "/**.md",
    },
    ---@module 'obsidian'
    ---@type obsidian.config

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter",
    },
    keys = {
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian" },
      { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Open Obsidian Daily Note" },
      {
        "<leader>ont",
        "<cmd>Obsidian new_from_template<cr>",
        desc = "new note with TITLE from a template with the name TEMPLATE",
      },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Open Obsidian Rename" },
      { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Open Obsidian Quick Switch" },
      { "<leader>ch", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle Checkbox", ft = "markdown" },
      { "gf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link", ft = "markdown" },
      { "<cr>", "<cmd>Obsidian smart_action<cr>", desc = "Follow Link / Toggle Checkbox", ft = "markdown" },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
    opts = {
      app_path = "~/Applications/Comm/Written/Obsidian.app",
      workspaces = {
        {
          name = "notes",
          path = notes_path,
        },
      },
      daily_notes = {
        folder = "500 ♽ Cycles/520 🌄 Days",
        date_format = "%Y/%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "900 📐 Templates/🌄 New Day.md",
      },
      new_notes_location = "700 Vaults/Notes",

      ---@param url string
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
      ---@param img string
      follow_img_func = function(img)
        vim.fn.jobstart({ "qlmanage", "-p", img })
      end,

      open = {
        func = function(uri)
          vim.ui.open(uri, { cmd = { "open", "-a", vim.fn.expand("~/Applications/Comm/Written/Obsidian.app") } })
        end,
      },

      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },
      sort_by = "modified",
      sort_reversed = true,
      search_max_lines = 1000,
      open_notes_in = "current",

      attachments = {
        img_folder = "700 Vaults/Notes/Attachments",
        ---@param client obsidian.Client
        ---@param path obsidian.Path
        ---@return string
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "wiki",
      disable_frontmatter = false,

      ---@return table
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      templates = {
        folder = "900 📐 Templates",
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
