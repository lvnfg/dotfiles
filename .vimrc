set nocompatible "disable vi compatibility and enable advanced vim features
set number "show line numbers
highlight LineNr ctermfg=grey "change line num color
set ignorecase "do case insensitive matching (?)
:let loaded_matchparen = 1 "disable show matching parentheses
syntax on "enable syntax highlighting
highlight EndOfBuffer ctermfg=black ctermbg=black "set tilde ~ character color to background's

"indenting
set autoindent
set copyindent
set preserveindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4 "when identing with >

"netrw config
let g:netrw_banner = 0 "remove help banner
let g:netrw_liststyle = 3 "show tree view by default
