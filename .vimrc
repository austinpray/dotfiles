" Essential
filetype off
set visualbell
set number
set ruler
set autoread
set colorcolumn=80
set nocompatible

" Misc
set laststatus=2
set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either

" Syntax
filetype plugin indent on
syntax enable

" Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
call plug#end()
