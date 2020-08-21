" plugins
call plug#begin("~/.config/vim/plug")
Plug '/usr/bin/fzf'
Plug 'airblade/vim-gitgutter'
Plug 'andymass/vim-matchup'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'phpstan/vim-phpstan'
Plug 'qpkorr/vim-bufkill'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vimwiki/vimwiki'
Plug 'neoclide/coc.nvim'
Plug 'lifepillar/vim-gruvbox8'
call plug#end()

" settings
set bg=light
set clipboard=unnamed
set clipboard+=unnamedplus
set ts=2
set sw=2
set tw=79
set noet
set nowrap
set nu
set splitbelow splitright
set ruler
set cc=80
set scrolloff=3
set sidescroll=3
set t_Co=256
set laststatus=0
set mouse=a
set incsearch
set showmatch
set backupdir=~/.cache/vim/backup
set directory=~/.cache/vim
set nofoldenable
set signcolumn=number
set completeopt=menuone,noinsert,noselect
let g:goyo_width = 84
let mapleader =","
au ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
colo gruvbox8_hard
highlight clear SignColumn

" rebinds
" fzf
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>a :Buffers<CR>

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

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler <c-r>%<CR>

" open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>

" enable Goyo by default for mutt writting
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo |
autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" automatically deletes all trailing whitespace and newlines on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e
augroup rainbow
	au!
	au FileType * RainbowParentheses
augroup END

" navigating with guides
inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
map <leader><leader> <Esc>/<++><Enter>"_c4l

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" snippets

"""HTML
autocmd FileType html inoremap ,b <b></b><Space><++><Esc>FbT>i
autocmd FileType html inoremap ,it <em></em><Space><++><Esc>FeT>i
autocmd FileType html inoremap ,1 <h1></h1><Enter><Enter><++><Esc>2kf<i
autocmd FileType html inoremap ,2 <h2></h2><Enter><Enter><++><Esc>2kf<i
autocmd FileType html inoremap ,3 <h3></h3><Enter><Enter><++><Esc>2kf<i
autocmd FileType html inoremap ,p <p></p><Enter><Enter><++><Esc>02kf>a
autocmd FileType html inoremap ,a <a<Space>href=""><++></a><Space><++><Esc>14hi
autocmd FileType html inoremap ,e <a<Space>target="_blank"<Space>href=""><++></a><Space><++><Esc>14hi
autocmd FileType html inoremap ,ul <ul><Enter><li></li><Enter></ul><Enter><Enter><++><Esc>03kf<i
autocmd FileType html inoremap ,li <Esc>o<li></li><Esc>F>a
autocmd FileType html inoremap ,ol <ol><Enter><li></li><Enter></ol><Enter><Enter><++><Esc>03kf<i
autocmd FileType html inoremap ,im <img src="" alt="<++>"><++><esc>Fcf"a
autocmd FileType html inoremap ,td <td></td><++><Esc>Fdcit
autocmd FileType html inoremap ,tr <tr></tr><Enter><++><Esc>kf<i
autocmd FileType html inoremap ,tc <tc></tc><Enter><++><Esc>kf<i
autocmd FileType html inoremap ,th <th></th><++><Esc>Fhcit
autocmd FileType html inoremap ,tab <table><Enter></table><Esc>O
autocmd FileType html inoremap ,gr <font color="green"></font><Esc>F>a
autocmd FileType html inoremap ,rd <font color="red"></font><Esc>F>a
autocmd FileType html inoremap ,yl <font color="yellow"></font><Esc>F>a
autocmd FileType html inoremap ,dt <dt></dt><Enter><dd><++></dd><Enter><++><esc>2kcit
autocmd FileType html inoremap ,dl <dl><Enter><Enter></dl><enter><enter><++><esc>3kcc
autocmd FileType html inoremap ,sp <span></span><++><esc>F>a
autocmd FileType html inoremap ,di <div><Enter><Enter></div><Enter><++><esc>2kcc
autocmd FileType html inoremap &<space> &amp;<space>
autocmd FileType html inoremap ,m <code></code><Space><++><Esc>FcT>i
autocmd FileType html inoremap ,cb <esc>o<code><pre><enter></pre></code><enter><++><esc>kO
autocmd FileType html inoremap ,ac }<Esc>O  <++><Esc>O. {<Esc>F.a
autocmd FileType css  inoremap ,ac }<Esc>O  <++><Esc>O. {<Esc>F.a

""" groff
" Code snippets
autocmd FileType groff inoremap ,b <Enter>.B ""<Enter><++><Esc>ka
autocmd FileType groff inoremap ,i <Enter>.I ""<Enter><++><Esc>ka
autocmd FileType groff inoremap ,cw <Enter>.CW ""<Enter><++><Esc>kf"a
autocmd FileType groff inoremap ,li <Enter>.IP \[bu]<Enter>
autocmd FileType groff inoremap ,gli <Enter>.RS<Enter>.RS<Enter>.IP \[bu]<Enter>.RE<Enter>.RE<Esc>2kA<Enter>
autocmd FileType groff inoremap ,gcode <Enter>.CW<Enter>.TS<Enter>box centre;<Enter>l.<Enter>.SM<Enter>$<Enter>.TE<Enter>.R<Enter>.REF "<++>"<Enter><++><Esc>4kA

" PHP
au FileType php,blade setl sw=4 ts=4 et
au FileType blade setl tw=120

" mail
au FileType mail inoremap ,d Hi ,<Enter><Enter><++><Enter><Enter>Cheers,<Enter>Shaw Eastwood.<Enter><Enter><Esc>gg$i

" Set hyphens as part of the word when working on CSS files
au! FileType css,scss setl iskeyword+=-

" limelight
let g:limelight_conceal_ctermfg = "darkgray"
map <leader>l :Limelight!!<CR>

" README rice
au BufReadPost README set filetype=markdown

" Git Gutter
nmap ]g :GitGutterNextHunk<CR>
nmap [g :GitGutterPrevHunk<CR>
aug VimDiff
	au!
	au VimEnter,FilterWritePre * if &diff | GitGutterDisable | ALEDisable | endif
aug END

" ale
let g:ale_sign_warning = "#"
let g:ale_sign_error = "!"
nmap ]w :ALENextWrap<CR>
nmap [w :ALEPreviousWrap<CR>

let g:ale_fixers = {
\	"javascript": ["prettier"],
\	"html": ["prettier"],
\	"xml": ["xmllint"],
\	"sql": ["sqlformat"],
\	"php": ["phpstan"],
\ "sh" : ["shellcheck"],
\}
