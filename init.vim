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

" Vim-Plug
" ------------------------------ 
call plug#begin()
	Plug 'airblade/vim-gitgutter'
	Plug 'neovim/nvim-lsp'
	Plug 'nvim-lua/completion-nvim'
call plug#end()
" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" completion-nvim
" ------------------------------ 
" Attach to language servers (1 line for each LS)
lua require'nvim_lsp'.pyls_ms.setup{on_attach=require'completion'.on_attach}
" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
" Better autocompletion popup behavior
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
" Select first match and navigate popup menu with Tab
inoremap <expr> <Tab>	pumvisible() ? "\<C-n>"	: "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <C-j>	pumvisible() ? "\<C-n>"	: "\<C-j>"
inoremap <expr> <C-k>	pumvisible() ? "\<C-p>"	: "\<C-k>"

" nvim-lsp sever
" ------------------------------ 
" https://github.com/neovim/nvim-lsp#configurations
" Microsoft python language server
lua <<pyls_ms
local nvim_lsp = require'nvim_lsp'
nvim_lsp.pyls_ms.setup{
	init_options = {
      analysisUpdates = true,
      asyncStartup = true,
      displayOptions = {},
      interpreter = {
        properties = {
          InterpreterPath = "/usr/bin/python3",
          Version = "3.7"
        }
      }
    }
}
pyls_ms

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
highlight SignColumn	ctermbg=black
highlight EndOfBuffer	ctermbg=black	ctermfg=black	
highlight LineNr						ctermfg=grey
" ----------
highlight Pmenu			ctermbg=black	ctermfg=white	" Popup menu normal item
highlight PmenuSel		ctermbg=24		ctermfg=white	" Popup Selected item
highlight PmenuSbar		ctermbg=black					" Popup Scrollbar
highlight PmenuThumb	ctermbg=black					" Popup Scrollbar thumb
