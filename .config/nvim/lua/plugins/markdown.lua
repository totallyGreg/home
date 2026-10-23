local user_home = vim.fn.expand("~")
local notes_path = user_home .. "/Notes"
local obsidian_app = user_home .. "/Applications/Comm/Written/Obsidian.app"

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>m", group = "markdown", icon = { icon = " ", color = "purple" } },
      },
    },
  },

  -- Markdown rendering (headings, code blocks, tables, checkboxes, bullets, etc.)
  -- Replaces the deprecated 'ui' option from obsidian.nvim v3.x
  {
    "blackhat-7/vellum.nvim",
    ft = "markdown",
    keys = {
      { "<leader>ms", "<cmd>Vellum<cr>", ft = "markdown", desc = "Markdown Split Preview " },
      {
        "<leader>mz",
        function()
          require("vellum").zoom()
        end,
        ft = "markdown",
        desc = "Markdown zoom image",
      },
    },
    opts = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>mr",
        function()
          require("render-markdown").buf_toggle()
        end,
        ft = "markdown",
        desc = "Toggle render (buffer)",
      },
      {
        "<leader>me",
        function()
          require("render-markdown").expand()
        end,
        ft = "markdown",
        desc = "Expand raw lines",
      },
      {
        "<leader>mc",
        function()
          require("render-markdown").contract()
        end,
        ft = "markdown",
        desc = "Contract raw lines",
      },
      -- {
      --   "<leader>ms",
      --   function()
      --     require("render-markdown").preview()
      --   end,
      --   ft = "markdown",
      --   desc = "Rendered preview in split",
      -- },
    },
    opts = {
      render_modes = true,
      -- Checkbox/callout completions via in-process LSP (picked up by blink.cmp)
      completions = { lsp = { enabled = true } },
      heading = {
        enabled = true,
        render_modes = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        position = "overlay",
        signs = { "󰫎 " },
        width = "full",
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      code = {
        enabled = true,
        render_modes = true,
        sign = true,
        style = "full",
        position = "left",
        language_pad = 0,
        language_name = true,
        disable_background = { "diff" },
        width = "full",
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = "thin",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      },
      dash = { enabled = true },
      link = { enabled = true },
      sign = { enabled = false },
      bullet = {
        enabled = true,
        icons = { "•", "◦", "▸", "▹" },
      },
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
        -- Obsidian-style callouts
        todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { highlight = "RenderMarkdownChecked", scope_highlight = "@markup.strikethrough", icon = " " },
        custom = {
          todo = { raw = "[>]", rendered = " ", highlight = "RenderMarkdownWarn" },
          cancelled = { raw = "[~]", rendered = "󰰱 ", highlight = "RenderMarkdownError" },
          important = { raw = "[!]", rendered = " ", highlight = "DiagnosticError" },
        },
      },
    },
  },

  -- Obsidian
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
      { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Obsidian" },
      { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Open Obsidian Daily Note" },
      {
        "<leader>ont",
        "<cmd>Obsidian new_from_template<cr>",
        desc = "new note with TITLE from a template with the name TEMPLATE",
      },
      { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Open Obsidian Rename" },
      { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Open Obsidian Quick Switch" },
      { "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle Checkbox", ft = "markdown" },
      { "gf", "<cmd>Obsidian follow_link<cr>", desc = "Follow Link", ft = "markdown" },
      { "<cr>", "<cmd>Obsidian smart_action<cr>", desc = "Follow Link / Toggle Checkbox", ft = "markdown" },
    },
    opts = {
      legacy_commands = false,
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
        -- Relative to templates.folder below.
        template = "910 File Templates/🌄 New Day.md",
      },
      new_notes_location = "notes_subdir",
      notes_subdir = "700 Notes/Notes",
      open_notes_in = "current",

      open = {
        func = function(uri)
          vim.ui.open(uri, { cmd = { "open", "-a", obsidian_app } })
        end,
      },

      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      search = {
        sort_by = "modified",
        sort_reversed = true,
        max_lines = 1000,
      },

      attachments = {
        folder = "700 Notes/Notes/Attachments",
      },

      link = {
        style = "wiki",
        format = "shortest",
      },

      frontmatter = {
        enabled = true,
        ---@param note obsidian.Note
        ---@return table
        func = function(note)
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
      },

      templates = {
        folder = "900 📐Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
    },
  },
}
