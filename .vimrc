" disable vi compatibility and enable advanced vim features
set nocompatible 

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

" hide tilde (~) characters by changing color to black
highlight EndOfBuffer ctermfg=black ctermbg=black

" fix wrong colors in tmux by forcing 256 colors
set background=dark
set t_Co=256

" prevent the cursor from moving back one character when exiting insert mode
" by overloading the Esc key in insert mode to additionall run then `^
" command which moves the rcusor to the position where it had been the last time
" insert mode was left
" not recommended since the mess with the default cursor mechanics
" :inoremap <silent> <Esc> <Esc>`^

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

" vim-git-gutter plugin config
" reduce vim-gitgtter update time and consequently vim's swap file delaya
set updatetime=100  " this in is milisecond

" vim ale plugin config
" enable built-in autocompletion in ale. must enable before ale is loaded
let g:ale_completion_enabled = 0    " use deoplete instead
let g:ale_completion_delay = 100
" always show ale gutter
let g:ale_sign_column_always = 1
" only run linters when files are saved
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

" always keep the following at bottom:
packloadall             " load all packages to generate helptaps (from ale)
silent! helptags ALL    " load all helptags now, after plugins have been loaded
