" Visual
" ------------------------------ 
set number			" Show line numbers
set splitbelow		" Always split below	
set splitright		" Always split to the right
set signcolumn=yes 	" Always show the sign gutter
set updatetime=100  " Reduce vim-gitgutter update time (affect nvim's swap update)
set laststatus=0	" Disable status line
set noruler			" Disable ruler in command line

" Editing
" ------------------------------ 
set ignorecase		" Case insensitive matching
set tabstop=4		" Press Tab = insert 4 spaces
set softtabstop=4	" SoftTabStop should = TabStop
set shiftwidth=4	" Insert 4 spaces when indenting with > and new line
" Python indenting
let g:pyindent_continue = '&sw * 2'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_open_paren = '&sw'		" Fix double indentation
set clipboard+=unnamedplus				" Always use + register as clipboard
" Remap r (replace char under cursor) to C-r (redo) as C-r is captured by
" tmux for switch to next pane
noremap r <C-R>

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
lua require'init'
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
inoremap <expr> <Tab>	pumvisible() ? "\<Space>"	: "\<Tab>"

" Diagnostic behavior
" ------------------------------ 
" diagnostic-nvim
let g:diagnostic_enable_virtual_text	= 1
let g:diagnostic_virtual_text_prefix	= ' '
let g:diagnostic_trimmed_virtual_text	= '20'
let g:space_before_virtual_text			= 1
let g:diagnostic_enable_underline		= 1
let g:diagnostic_auto_popup_while_jump	= 1
let g:diagnostic_insert_delay			= 1
let g:diagnostic_show_sign				= 1
let g:diagnostic_sign_priority			= 20
call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

" Color theme
" ------------------------------ 
" All highlight elements' current colors	:highlight
" All highlight groups						:help highlight-groups
" All syntax rules							:syntax
" ------------------------------ 
" * Normal: default background and text foreground
  highlight Normal			ctermbg=black	ctermfg=white
  highlight Comment							ctermfg=2
" ------------------------------ 
" * Constants: string, 234, 0x3ff, +, -, *, /, true, false, 1.3e1000...
  highlight Constant						ctermfg=79	
  highlight String							ctermfg=172
" highlight Character
" highlight Number	
" highlight Boolean	
" highlight Float	
" ------------------------------ 
" * Identifiers: function names, methods, classes...
" highlight Identifier
" highlight Function
" ------------------------------ 
" * Statements: if, else, case, switch, loop, for, while, try, catch, throw...
  highlight Statement						ctermfg=171
" highlight Conditional
" highlight Repeat	
" highlight Label
  highlight Operator						ctermfg=11
" highlight Keyword
" highlight Exception
" ------------------------------ 
" * Preprocessor: #include, #exclude, #define
" highlight Preproc								
" highlight Include							
" highlight Define						
" highlight Macro					
" highlight PreCondit			
" ------------------------------ 
" * Type: int, long, chair, static, register, struct, union, enum, typedef
  highlight Type							ctermfg=51
" highlight StorageClass
" highlight Structure
" highlight Typedef	
" ------------------------------ 
" * Special: special symbols, debugging statements, char that needs attention
" highlight *Special
" highlight SpecialChar
" highlight Tag		
" highlight Delimiter
" highlight SpecialComment
" highlight Debug
" ------------------------------ 
" highlight *Underlined
" ------------------------------ 
" highlight *Ignore	
" ------------------------------ 
" highlight *Error
" ------------------------------ 
" * TODO, FIXME....
  highlight Todo			ctermbg=black	ctermfg=33
" ------------------------------ 
" * Editor elements
  highlight SignColumn		ctermbg=black
  highlight EndOfBuffer		ctermbg=black	ctermfg=black	
  highlight LineNr							ctermfg=grey
" ------------------------------ 
" * Popup menu
  highlight Pmenu			ctermbg=234		ctermfg=white
  highlight PmenuSel		ctermbg=25		ctermfg=white
  highlight PmenuSbar		ctermbg=234	
  highlight PmenuThumb		ctermbg=25
  highlight Tooltip			ctermbg=red
" ------------------------------ 
" * Diagnostic sign & virtual text
" highlight LspDiagnosticsErrorSign			ctermbg=red		ctermfg=grey
" highlight LspDiagnosticsWarningSign		ctermbg=red		ctermfg=grey
" highlight LspDiagnosticsInformationSign	ctermbg=		ctermfg=	
" highlight LspDiagnosticsHintSign			ctermbg=		ctermfg=	
