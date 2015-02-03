call plug#begin('~/.vim/plugged')

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

Plug 'gosukiwi/vim-atom-dark'
Plug 'altercation/vim-colors-solarized'

call plug#end()


syntax enable
set background=dark
colorscheme solarized

set t_Co=16
