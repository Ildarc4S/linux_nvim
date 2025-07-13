return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dap.defaults.fallback.force_external_terminal = true
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }
      -- codelldb
      dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
              command = "/usr/bin/codelldb",
              args = { "--port", "${port}" },
          },
      }
      -- Конфигурация отладки
      dap.configurations.cpp = {
      {
        type = "codelldb",
        request = "launch",
        program = function ()
            -- Compile and return exec name
            local filetype = vim.bo.filetype
            local filename = vim.fn.expand("%")
            local basename = vim.fn.expand('%:t:r')
            local makefile = os.execute("(ls | grep -i makefile)")
            if makefile == "makefile" or makefile == "Makefile" then
                os.execute("make debug")
            else
                if filetype == "c" then
                    os.execute(string.format("gcc -g -o %s %s", basename, filename))
                else
                    os.execute(string.format("g++ -g -o %s %s", basename, filename))
                end
            end
            return basename
        end,
        args = function ()
            local argv = {}
            arg = vim.fn.input(string.format("argv: "))
            for a in string.gmatch(arg, "%S+") do
                table.insert(argv, a)
            end
            vim.cmd('echo ""')
            return argv
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        setupCommands = {
            {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
            },
        }, 
      }, 
    }
    dap.configurations.c = dap.configurations.cpp
      -- Настройка интерфейса DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Виртуальный текст
      require("nvim-dap-virtual-text").setup()

      -- Автоматическое открытие/закрытие DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Горячие клавиши
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
    end,
  },
}
