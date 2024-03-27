vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- package manager folke/lazy.nvim :help lazy.nvim.txt
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
		'tpope/vim-fugitive', -- git related plugin
		'tpope/vim-rhubarb', -- go to github plugin

		-- 'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically

		{
			'neovim/nvim-lspconfig',
			dependencies = {
				-- Automatically install LSPs to stdpath for neovim
				{ 'williamboman/mason.nvim', config = true },
				'williamboman/mason-lspconfig.nvim',

				-- Useful status updates for LSP
				-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
				-- { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

				-- Additional lua configuration, makes nvim stuff amazing!
				'folke/neodev.nvim',
			},
		},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		opts = { suggestion = { auto_trigger = true, debounce = 150 } },
	},

		{
			-- Autocompletion
			'hrsh7th/nvim-cmp',
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',

				-- Adds LSP completion capabilities
				'hrsh7th/cmp-nvim-lsp',

				-- Adds a number of user-friendly snippets
				'rafamadriz/friendly-snippets',

				-- copilot
				'zbirenbaum/copilot.lua'
			},
			-- copilot binds
			opts = function(_, opts)
				local cmp, copilot = require "cmp", require "copilot.suggestion"

				if not opts.mapping then
					opts.mapping = {}
				end

				opts.mapping["<C-x>"] = cmp.mapping(function() if copilot.is_visible() then copilot.next() end end)
				opts.mapping["<C-z>"] = cmp.mapping(function() if copilot.is_visible() then copilot.prev() end end)
				opts.mapping["<C-right>"] = cmp.mapping(function() if copilot.is_visible() then copilot.accept_word() end end)
				opts.mapping["<C-l>"] = cmp.mapping(function() if copilot.is_visible() then copilot.accept_word() end end)
				opts.mapping["<C-down>"] = cmp.mapping(function() if copilot.is_visible() then copilot.accept_line() end end)
				opts.mapping["<C-j>"] = cmp.mapping(function() if copilot.is_visible() then copilot.accept_line() end end)
				opts.mapping["<C-c>"] = cmp.mapping(function() if copilot.is_visible() then copilot.dismiss() end end)

				return opts
			end,
		},

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim',  opts = {} },
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
					{ buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
					{ buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
	},

	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},
}, {})

-- [[ options ]]
-- See `:help vim.o`

vim.o.hlsearch = true	-- set highlight on search
vim.wo.number = true	-- make line numbers default
vim.o.mouse = 'a'		-- enable mouse mode
vim.o.clipboard = 'unnamedplus'			-- sync clipboard with os `:help 'clipboard'`
vim.o.breakindent = true				-- enable break indent
vim.o.undofile = true	-- save undo history
vim.wo.signcolumn = 'number'

vim.o.ignorecase = true	-- case-insensitive searching
vim.o.smartcase = true	-- unless \C or capital in search

vim.o.updatetime = 250	-- decrease update time
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'	-- better completion experience

vim.o.statusline = ''	-- status line is bloat
vim.o.laststatus = 0

vim.o.wrap = false		-- wrapping should be done in code
vim.o.expandtab = false					-- spaces are bloat & dumb
vim.o.shiftwidth = 4
vim.o.tabstop = 4
-- fix hideous bg colours everywhere
vim.o.termguicolors = false				-- macos terminal. truecolor is bloat
vim.cmd.colorscheme('lunaperche')	-- based builtin. supports light & dark
vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = '' })
vim.api.nvim_set_hl(0, "GitSignsChange", { bg = '' })
vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = '' })
vim.api.nvim_set_hl(0, "ALEErrorSign", { bg = '' })
vim.api.nvim_set_hl(0, "StatuslineWarn", { bg = '' })
vim.api.nvim_set_hl(0, "Normal", { bg = '' })
vim.api.nvim_set_hl(0, "SignColumn", { bg = '' })
vim.api.nvim_set_hl(0, "VertSplit", { bg = '' })
vim.api.nvim_set_hl(0, "MatchParen", { ctermbg = black, guibg = white })
vim.cmd([[highlight clear SignColumn]])

-- [[ keymaps ]]
-- `:help vim.keymap.set()`
vim.keymap.set('n', '<leader>c', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Write' })
vim.keymap.set('n', '<leader>h', ':noh<CR>', { desc = 'Clear Highlight', silent = true })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ highlight on yank ]]
-- `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
		callback = function()
			vim.highlight.on_yank()
		end,
		group = highlight_group,
		pattern = '*',
	})

-- [[ configure telescope ]]
-- `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			winblend = 10,
			previewer = false,
		})
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fe', require('telescope.builtin').live_grep, { desc = '[F]ind by Gr[e]p' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
--
require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { 'lua', 'typescript', 'php', 'phpdoc', 'html', 'css', 'javascript' },

	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = true,

	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
			scope_incremental = '<c-s>',
			node_decremental = '<M-space>',
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>s', ':%s//g<Left><Left>', 'Search and replace')

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>lf', vim.lsp.buf.format, '[L]sp [F]ormat')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

-- Create a command `:Format` local to the LSP buffer
vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
	vim.lsp.buf.format()
end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },
	html = { filetypes = { 'html', 'twig', 'blade', 'hbs'} },

	-- tailwindcss-language-server tailwindcss
	-- css-lsp cssls
	-- html-lsp html
	-- typescript-language-server tsserver
	-- angular-language-server angularls
	-- phpstan
	-- intelephense
	-- lua-language-server lua_ls


	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		}
	end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local copilot = require "copilot.suggestion"
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

-- local function has_words_before()
-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
-- 	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
-- end

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(
			function(fallback)
				if copilot.is_visible() then
					copilot.accept()
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				-- elseif has_words_before() then
				-- 	cmp.complete()
				else
					fallback()
				end
			end, { 'i', 's' }
		),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}
