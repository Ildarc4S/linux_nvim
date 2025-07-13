return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "mfussenegger/nvim-lint",  -- Для линтинга (cpplint)
      "stevearc/conform.nvim",   -- Для форматирования (clang-format)
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Оригинальные настройки Mason и автодополнения остаются без изменений
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
      })

      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
        }),
      })

      -- Настройка clangd без изменений
      require("lspconfig").clangd.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--query-driver=/usr/bin/clang-format",
          "--all-scopes-completion",
        },
        settings = {
          clangd = {
            format = {
              style = "google",
              BasedOnStyle = "google",
              executable = "/usr/bin/clang-format",
            },
          },
        },
      })

      -- Замена null-ls диагностики (cpplint) на nvim-lint
      if vim.fn.executable("cpplint") == 1 then
        require("lint").linters.cpplint = {
          cmd = "cpplint",
          args = {
            "--filter=-legal/copyright,-build/include_subdir,+whitespace/trailing",
            "%f"
          },
          stdin = false,
          ignore_exitcode = true,
          parser = require("lint.parser").from_errorformat(
            "%f:%l: %m",
            { source = "cpplint" }
          )
        }

        require("lint").linters_by_ft = {
          cpp = { "cpplint" },
          hpp = { "cpplint" },
          cc = { "cpplint" },
          h = { "cpplint" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      end

      -- Замена null-ls форматирования на conform.nvim
      require("conform").setup({
        formatters_by_ft = {
          cpp = { "clang_format" },
          hpp = { "clang_format" },
          cc = { "clang_format" },
          h = { "clang_format" },
        },
        formatters = {
          clang_format = {
            command = "/usr/bin/clang-format",
            args = { "-style=google", "--assume-filename=%:p" },
            stdin = true,
          }
        },
      })

      -- Все остальные оригинальные autocmd и настройки остаются без изменений
      local cpp_group = vim.api.nvim_create_augroup("CppConfig", { clear = true })

      vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff0000" })
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        group = cpp_group,
        pattern = { "*.cpp", "*.hpp", "*.cc", "*.h" },
        callback = function()
          vim.fn.matchadd("TrailingWhitespace", "\\s\\+$")
        end
      })

      vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
        group = cpp_group,
        pattern = { "*.cpp", "*.hpp", "*.cc", "*.h" },
        callback = function()
          vim.fn.clearmatches()
        end
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = cpp_group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.name == "clangd" then
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
              vim.lsp.diagnostic.on_publish_diagnostics, {
                update_in_insert = true,
                virtual_text = {
                  prefix = "■",
                  spacing = 4,
                  severity_sort = true,
                },
                signs = true,
                underline = true,
              }
            )

            vim.keymap.set('n', '<leader>cf', function()
              require("conform").format({ async = true })
            end, { buffer = args.buf, desc = "Format with Google Style" })
          end
        end
      })
    end,
  },
}
