" Common settings for vim, nvim, vscode-nvim
" ----------------------------- 
let mapleader="\<Space>"
noremap <Esc> :noh<cr>
" Select all
noremap <leader>a ggVG
" File saving & quitting
noremap <leader>w :w<cr>
noremap <leader>W :wq<cr>
noremap <leader>q :q<cr>
noremap <leader>Q :q!<cr>
 
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
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        " Install parser for language with :TSInstall
        " Supported languges: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
        " bash, css, html, javascript, typescript, json, latex, lua, python, yaml
        " Colorscheme
        Plug 'tomasr/molokai'
        Plug 'sonph/onehalf', { 'rtp': 'vim' }
    endif
call plug#end()

" Colorscheme
colorscheme molokai
let g:airline_theme='onehalfdark'

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
	set nocompatible 
	" disable vi compatibility and enable advanced vim features
	
	" netrw config
	let g:netrw_banner = 0 " remove help banner
	let g:netrw_liststyle = 3 " show tree view by default
    map <leader>E :Vexplore<cr>

    " enable scrolling with mouse
    set mouse=a
    
    " fzf
    map <M-f> :Files<cr>
    map <leader>p :Files<cr>

    " Tab completion
    inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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
