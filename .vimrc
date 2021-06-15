" Common settings for vim, nvim, vscode-nvim
" ------------------------------ 
noremap ; :
noremap <Esc> :noh<cr>
 
" Install plugins
call plug#begin()
	Plug 'junegunn/vim-easy-align'
	Plug 'michaeljsmith/vim-indent-object'
	
    if exists('g:vscode')
        " Skip install
    else
        Plug 'airblade/vim-gitgutter'
    endif
call plug#end()

" vim-easy-align settings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Editing
set ignorecase		" Case insensitive matching

if exists('g:vscode')
    " Do nothing to avoid conflicts when loaded as extension in vscode
else
	" General
	" ------------------------------ 
	" disable vi compatibility and enable advanced vim features
	set nocompatible 
	" netrw config
	let g:netrw_banner = 0 " remove help banner
	let g:netrw_liststyle = 3 " show tree view by default

    " enable scrolling with mouse
    set mouse=a

	" Visual
	" ------------------------------ 
	set number			" Show line numbers
	set splitbelow		" Always split below	
	set splitright		" Always split to the right
	set laststatus=0	" Disable status line
	set noruler			" Disable ruler in command line
	set updatetime=100  " Reduce vim-gitgutter update time (affect nvim's swap update)
	set signcolumn=yes 	" Always show the sign gutter
	set hlsearch        " Highlight search term
	" Minimize visual prominence of sign column & end of buffer
	highlight SignColumn        ctermbg=black
    highlight EndOfBuffer		ctermbg=None    ctermfg=black	
    highlight LineNr							ctermfg=grey
	" fix wrong colors in tmux by forcing 256 colors
	set background=dark
	set t_Co=256
	" Modal cursor
	let &t_SI.="\e[5 q" "SI = INSERT mode
	let &t_EI.="\e[2 q" "EI = All other modes (ELSE)
	"Cursor settings:
	"  1 -> blinking block
	"  2 -> solid block
	"  3 -> blinking underscore
	"  4 -> solid underscore
	"  5 -> blinking vertical bar
	"  6 -> solid vertical bar

	" Indenting
	set autoindent
	set expandtab       " Expand tab as spaces
	set copyindent
	set preserveindent
	set tabstop=4		" Press Tab = insert 4 spaces
	set softtabstop=4	" SoftTabStop should = TabStop
	set shiftwidth=4	" Insert 4 spaces when indenting with > and new line
	" Editing
	" ------------------------------ 
	syntax on			" Enable syntax highlighting
	set splitbelow		" Always split below
	set splitright		" Always split to the right
	" Python indenting
	let g:pyindent_continue = '&sw * 2'
	let g:pyindent_nested_paren = '&sw'
	let g:pyindent_open_paren = '&sw'		" Fix double indentation
	set clipboard+=unnamedplus				" Always use + register as clipboard
	set backspace=indent,eol,start			" Let backspace delete

	" load all plugins at the end
	" ------------------------------ 
	packloadall
	" load all helptags after plugins and ignore errors
	silent! helptags ALL
endif
