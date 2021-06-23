" Common settings for vim, nvim, vscode-nvim
" ----------------------------- 
let mapleader="\<Space>"
noremap <Esc> :noh<cr>
noremap <leader>a ggVG
 
" Install plugins
call plug#begin()
	Plug 'junegunn/vim-easy-align'
	Plug 'michaeljsmith/vim-indent-object'
    if exists('g:vscode')
        " Skip install
    else
        Plug 'airblade/vim-gitgutter'
        Plug 'hrsh7th/nvim-compe'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'vim-airline/vim-airline'
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
    map <leader>E :Vexplore<cr>

    " enable scrolling with mouse
    set mouse=a
    
    " fzf
    map <leader>p :Files<cr>

    " Tab completion
    inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " nvim-compe settings
    set completeopt=menuone,noselect
    let g:compe = {}
    let g:compe.enabled = v:true
    let g:compe.autocomplete = v:true
    let g:compe.debug = v:false
    let g:compe.min_length = 1
    let g:compe.preselect = 'enable'
    let g:compe.throttle_time = 80
    let g:compe.source_timeout = 200
    let g:compe.resolve_timeout = 800
    let g:compe.incomplete_delay = 400
    let g:compe.max_abbr_width = 100
    let g:compe.max_kind_width = 100
    let g:compe.max_menu_width = 100
    let g:compe.documentation = v:true
    let g:compe.source = {}
    let g:compe.source.path = v:true
    let g:compe.source.buffer = v:true
    let g:compe.source.calc = v:true
    let g:compe.source.nvim_lsp = v:true
    let g:compe.source.nvim_lua = v:true
    let g:compe.source.vsnip = v:true
    let g:compe.source.ultisnips = v:true

    " True color
    if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif

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
	"highlight SignColumn        ctermbg=black
    "highlight EndOfBuffer		ctermbg=None    ctermfg=black	
    "highlight LineNr							ctermfg=black
	" fix wrong colors in tmux by forcing 256 colors
	"set background=dark
	"set t_Co=256
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
