-- lua/plugins/cmake-tools.lua
return {
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmake-tools").setup {
        cmake_command = "cmake",
        ctest_command = "ctest",
        cmake_use_preset = true,            -- использовать CMake Presets, если есть
        cmake_regenerate_on_save = true,    -- регенерировать при сохранении CMakeLists.txt
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_options = {},
        cmake_build_directory = "build",
        cmake_compile_commands_options = {
          action = "soft_link",
          target = vim.loop.cwd(),
        },
        cmake_variants_message = {
          short = { show = true },
          long = { show = true, max_length = 40 },
        },
        cmake_dap_configuration = {
          name = "cpp",
          type = "gdb",
          request = "launch",
          stopOnEntry = false,
          runInTerminal = true,
          console = "integratedTerminal",
        },
        cmake_executor = {
          name = "quickfix",
          opts = {},
        },
        cmake_runner = {
          name = "terminal",
          opts = {},
        },
        cmake_notifications = {
          runner = { enabled = true },
          executor = { enabled = true },
          spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          refresh_rate_ms = 100,
        },
        cmake_virtual_text_support = true,
        cmake_use_scratch_buffer = false,
      }
    end,
  },
}

