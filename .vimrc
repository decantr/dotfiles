call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript', { 'for': 'js' }
call plug#end()

colorscheme nord

let g:lightline = {'colorscheme': 'nord','component': {'readonly': '%{&readonly?"x":""}'}}

let g:gitgutter_enabled = 1
