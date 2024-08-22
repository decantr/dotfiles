return {
	{ 'folke/lazy.nvim', version = false },
	-- Configure LazyVim to load gruvbox
	{
		'LazyVim/LazyVim',
		version = false,
		opts = {
			colorscheme = 'alabaster'
			-- colorscheme = function ()
			-- 	if vim.g.neovide then
			-- 		return 'alabaster'
			-- 	end
			-- 	return 'default'
			-- end,
		},
	},
	{
		'neovim/nvim-lspconfig',
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- intelephense will be automatically installed with mason and loaded with lspconfig
				intelephense = {
					files = {
						maxSize = 1000000000,
					}
				},
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = 'ignore'
							}
						},
						scss = {
							validate = true,
							lint = {
								unknownAtRules = 'ignore'
							}
						},
						less = {
							validate = true,
							lint = {
								unknownAtRules = 'ignore'
							}
						},
					},

				}
			},
		},
	},
}
