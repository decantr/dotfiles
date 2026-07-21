vim.loader.enable()

vim.g.have_nerd_font = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true
-- vim.o.signcolumn = "yes"
vim.o.signcolumn = "number"
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.list = true

vim.o.wrap = false

vim.schedule(function()
	--  Schedule the setting after `UiEnter` because it can increase startup-time.
	vim.o.clipboard = "unnamedplus"
end)