vim.g.mapleader = "," -- Устанавливаем лидер-клавишу

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"
-- Основные настройки
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

vim.opt.clipboard = "unnamedplus"

-- Прозрачный фон
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
