return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "akinsho/bufferline.nvim",
    },
    config = function()
      -- Настройка Lualine (статусная строка)
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- Настройка Bufferline (вкладки)
      require("bufferline").setup({
        options = {
          mode = "tabs",
          separator_style = "slant",
          always_show_bufferline = true,
          show_close_icon = false,
          color_icons = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true, -- Закрыть neo-tree, если это последнее окно
        window = {
          width = 25,
          mappings = {
            ["<space>"] = "none", -- Отключаем стандартный маппинг
          },
        },
        filesystem = {
          filtered_items = {
            visible = true, -- Показывать скрытые файлы
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true, -- Автоматически фокусироваться на текущем файле
          },
        },
        default_component_configs = {
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
          },
        },
      })
    end,
  },
}

