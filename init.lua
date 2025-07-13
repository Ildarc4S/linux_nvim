-- Загрузка основных настроек
require("core.options")
require("core.keymaps")

-- Инициализация Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Загрузка плагинов
require("lazy").setup("plugins", {
  ui = {
    border = "rounded",
  },
})
