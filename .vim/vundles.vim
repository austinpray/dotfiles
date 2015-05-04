call plug#begin('~/.vim/plugged')

Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'godlygeek/tabular'
Plug 'greyblake/vim-preview'
Plug 'heavenshell/vim-jsdoc'
Plug 'junegunn/vim-easy-align'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mikewest/vimroom'
Plug 'mxw/vim-jsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'plasticboy/vim-markdown'
Plug 'reedes/vim-pencil'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'vim-scripts/gitignore'
Plug 'wikitopian/hardmode'

Plug 'kchmck/vim-coffee-script',  { 'for': 'coffee' }
Plug 'digitaltoad/vim-jade',      { 'for': 'jade' }
Plug 'pangloss/vim-javascript',   { 'for': 'javascript' }
Plug 'elzr/vim-json',             { 'for': 'json' }
Plug 'LaTeX-Box-Team/LaTeX-Box',  { 'for': 'tex' }
Plug 'ingydotnet/yaml-vim',       { 'for': 'yaml' }
Plug 'fatih/vim-go',              { 'for': 'go' }
Plug 'evidens/vim-twig'

call plug#end()

" Plugin Settings
set t_Co=256
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

let g:vim_json_syntax_conceal = 0

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black   ctermbg=8
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=brgreen ctermbg=0
let g:indent_guides_enable_on_vim_startup = 1

let vimpager_disable_ansiesc = 1

let g:jsdoc_default_mapping = 0

let g:vim_markdown_folding_disabled=1

let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': ['javascript'],
  \ 'passive_filetypes': ['html'] }
let g:syntastic_check_on_open = 1
let g:syntastic_javascript_checkers = ['jscs']

nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

filetype plugin indent on

let g:instant_markdown_slow = 1

" unite
let g:unite_source_history_yank_enable = 1  

"call unite#filters#matcher_default#use(['matcher_fuzzy'])

if executable('ag')
  let g:unite_source_rec_async_ignore_pattern = ''
  let g:unite_source_rec_async_command= 'ag --nocolor --nogroup --hidden -g ""'

  " Use ag in unite grep source.
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <C-p>    :Unite -no-split -start-insert file_rec/git<cr>
nnoremap <space>p :Unite -no-split -start-insert -default-action=vsplit file_rec/git<cr>
nnoremap <space><space>p :Unite -no-split -start-insert file_rec/async:!<cr>
nnoremap <space>/ :Unite -no-split -start-insert grep:.<cr>
nnoremap <space>y :Unite -no-split -start-insert -buffer-name=yank    history/yank<cr>
nnoremap <space>e :Unite -no-split -start-insert -buffer-name=buffer  buffer<cr>
nnoremap <space>r :Unite -no-split -start-insert -buffer-name=mru     file_mru<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

" neocomplete

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
