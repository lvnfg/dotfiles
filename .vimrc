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
    " pass
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

	if has('nvim')
		" Vim-Plug
		" ------------------------------ 
		call plug#begin()
			Plug 'airblade/vim-gitgutter'
			Plug 'neovim/nvim-lsp'
			Plug 'nvim-lua/completion-nvim'
			Plug 'nvim-lua/diagnostic-nvim'
		call plug#end()
		" Settings for lua plugins must be loaded after vim-plug, otherwise lua scripts 
	    " not found error will be shown.
		if !empty(glob("~/.config/nvim/lua/init.lua"))
		    lua require'init'
		endif
		" On a newly created vm opening vim for the first time will show lua scripts
		" not found error if lua scripts are present but their plugins have not yet
		" been loaded. This prevents setup scripts from automatically setting up nvim.
		" Sourcing all lua configs from an external file solve this problem by first
		" creating a blank init.lua, open nvim, run :PlugInstall +qall, then replacing
		" the placeholder with the actual init.lua.

		" Autocomplete behavior
		" ------------------------------ 
		" Better autocompletion popup behavior
		set completeopt=menuone,noinsert,noselect
		" completion-nvim
		let g:completion_sorting = "alphabet"		" alphabet, length, none
		let g:completion_matching_strategy_list = ['substring', 'exact', 'fuzzy', 'all']
		let g:completion_matching_ignore_case = 1
		" Avoid showing message extra message when using completion
		set shortmess+=c
		" Select first match and navigate popup menu with Tab
		inoremap <expr> <Tab>	pumvisible() ? "<C-n>"	: "\<Tab>"
		inoremap <expr> <S-Tab>	pumvisible() ? "<C-p>"	: "\<S-Tab>"

		" Diagnostic behavior
		" ------------------------------ 
		" diagnostic-nvim
		let g:diagnostic_enable_virtual_text	= 1
		" let g:diagnostic_virtual_text_prefix	= '-> '
		" let g:diagnostic_trimmed_virtual_text	= '20'
		" let g:space_before_virtual_text			= 1
		let g:diagnostic_enable_underline		= 1
		let g:diagnostic_auto_popup_while_jump	= 1
		let g:diagnostic_insert_delay			= 1
		let g:diagnostic_show_sign				= 1
		let g:diagnostic_sign_priority			= 20
		call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
		call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
		call sign_define("LspDiagnosticsInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
		call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})
		
		" load all plugins at the end
		" ------------------------------ 
		packloadall
		" load all helptags after plugins and ignore errors
		silent! helptags ALL
	endif
endif
