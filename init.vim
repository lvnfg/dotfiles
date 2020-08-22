" Visual
" ------------------------------ 
set number			" Show line numbers
set splitbelow		" Always split below	
set splitright		" Always split to the right
set signcolumn=yes 	" Always show the sign gutter
set updatetime=100  " Reduce vim-gitgutter update time (affect nvim's swap update)

" Editing
" ------------------------------ 
set ignorecase		" Case insensitive matching
set tabstop=4		" Press Tab = insert 4 spaces
set softtabstop=4	" SoftTabStop should = TabStop
set shiftwidth=4	" Insert 4 spaces when indenting with >

" Autocompletion
" ------------------------------ 
set completeopt=menuone,noinsert,noselect		" Setup completion menu popup behavior
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"		"Remap tab to act as C-n

" Vim-Plug
" ------------------------------ 
call plug#begin()
	Plug 'airblade/vim-gitgutter'
call plug#end()

" Color theme
" ------------------------------ 
" Element name references: http://vimdoc.sourceforge.net/htmldoc/syntax.html
" Color   name references: https://jonasjacek.github.io/colors/ 
" ----------
" Syntax highlighting
highlight Normal		ctermbg=black	ctermfg=white	" Default background and text foreground
highlight Comment						ctermfg=2
" ---------- 
highlight Constant						ctermfg=79		" Any constant
highlight String						ctermfg=172		" String constant
"			Character									" 'c', '\n'
"			Number										" 234, 0xff
"			Boolean										" True, false
"			Float										" 2.3e10...
" ----------
"			*Identifier									" Any variable name
"			Function									" Function name and methods for classes
" ----------
highlight Statement						ctermfg=171		" Any statement
highlight Conditional					ctermfg=171		" If, then, else, switch...
highlight Repeat						ctermfg=171		" while, for, loop...
highlight Label							ctermfg=171		" case, default...
highlight Operator						ctermfg=11		" +, -, *, /...
highlight Keyword						ctermfg=171		" Any other keyword
highlight Exception						ctermfg=171		" Try, catch, throw
" ----------
"			*Preproc									" Generic preprocessor
"			Include										" Preproc #include
"			Define										" Preproc #define
"			Macro										" Same as Define
"			PreCondit									" Preproc #if, #else...
" ----------
highlight Type							ctermfg=51		" int, long, char...
"			StorageClass								" static, register, volatile...
"			Structure									" struct, union, enum...
"			Typedef										" A typedef
" ----------
"			*Special									" Any special symbol
"			SpecialChar									" Special char in a constant
"			Tag											" Can use C-] on this
"			Delimiter									" Char that needs attention
"			SpecialComment								" Special thing inside a comment
"			Debug										" Debugging statement
" ----------
"			*Underlined									" Text that stands out, url, html link
" ----------
"			*Ignore										" Left blank, hidden
" ----------
"			*Error										" Any errorneous construct
" ----------
highlight Todo			ctermbg=black	ctermfg=33		" Anything that needs extra attention
														" mostly the keywords TODO, FIXME, XXX
" ----------
highlight EndOfBuffer	ctermbg=black	ctermfg=black	
highlight LineNr						ctermfg=grey
" ----------
highlight Pmenu			ctermbg=black	ctermfg=white	" Popup menu normal item
highlight PmenuSel		ctermbg=24		ctermfg=white	" Popup Selected item
highlight PmenuSbar		ctermbg=black					" Popup Scrollbar
highlight PmenuThumb	ctermbg=black					" Popup Scrollbar thumb
