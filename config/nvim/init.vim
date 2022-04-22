let mapleader =","

call plug#begin("~/.config/nvim/plugged")
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-telescope/telescope.nvim'

Plug 'airblade/vim-gitgutter'
Plug 'andymass/vim-matchup' "extends % lang aware
Plug 'ap/vim-css-color'
"Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'qpkorr/vim-bufkill'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'machakann/vim-highlightedyank'

Plug 'ntpeters/vim-better-whitespace'
Plug 'justinmk/vim-sneak' "precise motioning
" Plug 'mcchrish/nnn.vim' "file explorer
" Plug 'prettier/vim-prettier', { 'do': 'yarn install' } "code formatter
Plug 'jiangmiao/auto-pairs' "auto clode brackets
" 
Plug 'ellisonleao/gruvbox.nvim'
call plug#end()

set bg=light
let g:goyo_width = 84
" disable error bells
set noeb vb t_vb=
set clipboard=unnamed
set fillchars+=vert:│
set incsearch
set laststatus=0
set mouse=a
set noet
set nohls
set nowrap
set nu
set scrolloff=8
set shortmess+=c
set showmatch
set signcolumn=number
set splitbelow splitright
set sw=2
set ts=2
set tw=80
set udf
set updatetime=300
" au ColorScheme * hi Normal ctermbg=NONE guibg=NONE
" au ColorScheme * hi SignColumn cterm=NONE guibg=NONE
" au ColorScheme * hi VertSplit ctermbg=NONE guibg=NONE
" au ColorScheme * hi ALEErrorSign ctermbg=NONE guibg=NONE
" au ColorScheme * hi ALEWarningSign ctermbg=NONE guibg=NONE
" au ColorScheme * hi MatchParen ctermbg=black guibg=white
highlight clear SignColumn


" PHP
au BufRead,BufNewFile .ebextensions/*.config setl ft=yaml
au BufRead,BufNewFile *.blade.php setl ft=blade
au FileType php,blade setl sw=4 ts=4 et
au FileType php noremap <space>p <esc>:PhpactorImportClass<enter>
au FileType html,blade setl tw=0

" Set hyphens as part of the word when working on web files
au! FileType css,html,scss setl iskeyword+=-
au BufReadPost README set filetype=markdown
aug VimDiff
	au!
	au VimEnter,FilterWritePre * if &diff | GitGutterDisable | ALEDisable | endif
aug END

" rebinds
" fzf
nmap <Leader>r :Tags<CR>
nmap <Leader>t :GFiles<CR>
nmap <Leader>a :Buffers<CR>

nnoremap <leader>n :NERDTreeToggle<CR>

" F5 to clear line endings
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Goyo plugin makes text more readable when writing prose:
map <leader>f :Goyo \| highlight clear SignColumn \| set linebreak<CR>
" spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_gb<CR>
" shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" replace ex mode with gq
map Q gq

" replace all is aliased to S.
nnoremap S :%s//g<Left><Left>
nnoremap Y y$


set udir=~/.config/nvim/undo
set directory=~/.config/nvim
set backupdir=~/.config/nvim/backup
" big files have issues with syntax
syntax sync minlines=10000

" typescript svelt
let g:vim_svelte_plugin_use_typescript = 1

"setlocal omnifunc=lsp#complete
set completeopt=menu,menuone,noselect

" nvimlsp
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { 'pyright', 'tsserver', 'intelephense', 'angularls', 'bashls', 'ccls' }
--  -- Setup lspconfig.
--  require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--  }
local servers = { 'tsserver', 'intelephense', 'angularls', 'bashls', 'svelte' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }
  }
end

local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}

local on_attach = function(client, bufnr)
    local buf_map = vim.api.nvim_buf_set_keymap
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspOrganize lua lsp_organize_imports()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
    vim.cmd(
        "command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
	--	buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "gr", ":LspRename<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "gR", ":LspRefs<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "gs", ":LspOrganize<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", {silent = true})
  --	  buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>", {silent = true})
  --	  buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", {silent = true})
if client.resolved_capabilities.document_formatting then
        vim.api.nvim_exec([[
         augroup LspAutocommands
             autocmd! * <buffer>
             autocmd BufWritePost <buffer> LspFormatting
         augroup END
         ]], true)
    end
end

local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end
vim.lsp.handlers["textDocument/formatting"] = format_async

_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

-- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

        -- For `luasnip` user.
        -- require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      -- { name = 'vsnip' },

      -- For luasnip user.
      -- { name = 'luasnip' },

      -- For ultisnips user.
      -- { name = 'ultisnips' },

      { name = 'buffer' },
    }
  })
EOF
