" disable vi compatibility and enable advanced vim features
set nocompatible 

" let backspace delete:
" indent = indentation
" eol = end of line character
" start = everything else, not just the start of insert
set backspace=indent,eol,start

" show line numbers
set number 

" change line num color
highlight LineNr ctermfg=grey

" do case insensitive matching
set ignorecase 

" disable matching parentheses
" :let loaded_matchparen = 1

" enable syntax highlighting
syntax on 
filetype plugin on

" hide tilde (~) characters by changing color to black
highlight EndOfBuffer ctermfg=black ctermbg=black

" fix wrong colors in tmux by forcing 256 colors
set background=dark
set t_Co=256

let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_EI.="\e[2 q" "EI = All other modes (ELSE)
"Cursor settings:
"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

" indenting
set autoindent
set copyindent
set preserveindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4 " when identing with >

" netrw config
let g:netrw_banner = 0 " remove help banner
let g:netrw_liststyle = 3 " show tree view by default

" always split below
set splitbelow
set splitright

" set sign column to always shows (helps for vim-git-gutter
set signcolumn=yes

" vim-git-gutter plugin config
" reduce vim-gitgtter update time and consequently vim's swap file delaya
set updatetime=100  " this in is milisecond

" Enable lightline
set laststatus=2
set noshowmode  " turn off vim's statusline
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ]],
    \ }
\}

" load all plugins at the end
packloadall
" load all helptags after plugins and ignore errors
silent! helptags ALL
