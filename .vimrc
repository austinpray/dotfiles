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

" Spacing
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set expandtab
set autoindent
set smartindent
set smarttab

" Syntax
filetype plugin indent on
syntax enable

" Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <leader>" :sp<CR>
map <leader>% :vsp<CR>

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'kien/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'Valloric/YouCompleteMe'
Plug 'altercation/vim-colors-solarized'
Plug 'elixir-lang/vim-elixir'
Plug 'mxw/vim-jsx'
call plug#end()

" Colors
set background=dark
"colorscheme solarized

" Ignore
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip

