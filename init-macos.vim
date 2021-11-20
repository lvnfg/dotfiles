set ignorecase   " Case insensitive matching
set nocompatible " disable vi compatibility and enable advanced vim features

call plug#begin()
"
    " Vim easy align
	Plug 'junegunn/vim-easy-align'
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

call plug#end()
