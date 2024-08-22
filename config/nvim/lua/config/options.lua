-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.o.guifont = 'SFMono Nerd Font:h14'
	vim.g.neovide_theme = 'auto'

	vim.keymap.set(
		{'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't'},
		'<D-v>',
		function()
			vim.api.nvim_paste(vim.fn.getreg('+'), true, -1)
		end,
		{ noremap = true, silent = true }
	)
else
	if os.getenv("TERM_PROGRAM") == "Apple_Terminal" then
		-- True color support

		vim.opt.termguicolors = false
		vim.colorscheme = 'lunaperche'
	end
end
