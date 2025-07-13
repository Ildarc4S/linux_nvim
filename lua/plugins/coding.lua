return {
  {
    "sbdchd/neoformat",
    ft = { "c", "cpp" },
    config = function()
      vim.g.neoformat_cpp_clangformat = {
        exe = "clang-format-18",
        args = { "-style=google" },
      }
      vim.g.neoformat_enabled_cpp = { "clangformat" }
    end,
  },
}
