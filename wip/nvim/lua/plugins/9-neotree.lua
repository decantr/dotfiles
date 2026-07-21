-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add({
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
})

if vim.g.have_nerd_font then
	vim.pack.add({'https://github.com/nvim-tree/nvim-web-devicons'})
end

vim.keymap.set(
	'n',
	'\\',
	'<Cmd>Neotree reveal<CR>',
	{ desc = 'NeoTree reveal', silent = true }
)
vim.keymap.set(
	{ 'n', 'v' },
	'<leader>e',
	'<Cmd>Neotree toggle<CR>' ,
	{ desc = 'Toggle [e]xplorer', silent = true }
)

require('neo-tree').setup {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}