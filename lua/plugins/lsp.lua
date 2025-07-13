return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- Для интеграции LSP с автодополнением
      "hrsh7th/nvim-cmp",     -- Основной плагин автодополнения
      "hrsh7th/cmp-buffer",   -- Источник для текста из буфера
      "jose-elias-alvarez/null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Настройка Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
      })

      -- Настройка автодополнения
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Источник для LSP
          { name = "buffer" },   -- Источник для текста из буфера
        }),
      })

      -- Настройка clangd с проверкой стиля
      require("lspconfig").clangd.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--query-driver=/usr/bin/clang-format-18",
          "--all-scopes-completion",
        },
        settings = {
          clangd = {
            format = {
              style = "google",
              BasedOnStyle = "google",
              executable = "/usr/bin/clang-format-18",
            },
          },
        },
      })

      -- Интеграция cpplint через null-ls
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.cpplint.with({
            extra_args = {
              "--filter=-build/include_subdir",
              "--linelength=80",
            },
            filetypes = { "cpp" },
          }),
          null_ls.builtins.formatting.clang_format.with({
            extra_args = { "-style=google" },
          }),
        },
      })
    end,
  },
}
