" Common settings for vim, nvim, vscode-nvim
" ------------------------------ 
noremap ; :
noremap r <C-r>
noremap <Esc> :noh<cr>
" Scroll up 1 line
noremap <C-k> <C-y>
" Scroll down 1 line 
noremap <C-j> <C-e>
" Scroll up half page
noremap <C-u> <C-d>
" Scroll down half page
noremap <C-i> <C-u>

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

	" Visual
	" ------------------------------ 
	set number			" Show line numbers
	set splitbelow		" Always split below	
	set splitright		" Always split to the right
	set laststatus=0	" Disable status line
	set noruler			" Disable ruler in command line
	set updatetime=100  " Reduce vim-gitgutter update time (affect nvim's swap update)
	set signcolumn=yes 	" Always show the sign gutter
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

	" Editing
	" ------------------------------ 
	syntax on			" Enable syntax highlighting
	set ignorecase		" Case insensitive matching
	set splitbelow		" Always split below
	set splitright		" Always split to the right
	" indenting
	set expandtab
	set autoindent
	set copyindent
	set preserveindent
	set tabstop=4		" Press Tab = insert 4 spaces
	set softtabstop=4	" SoftTabStop should = TabStop
	set shiftwidth=4	" Insert 4 spaces when indenting with > and new line
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
