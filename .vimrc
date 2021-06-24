" Plugin installation & settings
call plug#begin()
	Plug 'junegunn/vim-easy-align'
	Plug 'michaeljsmith/vim-indent-object'
    if !exists('g:vscode')
        Plug 'airblade/vim-gitgutter'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'vim-airline/vim-airline'
        if has('nvim')
            Plug 'hrsh7th/nvim-compe'
            Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
            " :TSInstall bash, css, html, javascript, typescript, json, latex, lua, python, yaml
        endif
        " Colorschemes
        Plug 'tomasr/molokai'
        Plug 'sonph/onehalf', { 'rtp': 'vim' }
    endif
call plug#end()
" vim-easy-align settings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" General settings
colorscheme molokai
let g:airline_theme='onehalfdark'
set ignorecase                " Case insensitive matching
let mapleader="\<Space>"      " Remap leader key
noremap <Esc> :noh<cr>
noremap <leader>a ggVG
noremap <leader>w :w<cr>
noremap <leader>W :wq<cr>
noremap <leader>q :q<cr>
noremap <leader>Q :q!<cr>
if !exists('g:vscode')
    set mouse=a               " enable scrolling with mouse
	set nocompatible          " disable vi compatibility and enable advanced vim features
	let g:netrw_banner = 0    " remove netrw help banner
	let g:netrw_liststyle = 3 " show tree view by default
    map <leader>E :Vexplore<cr>
    " fzf
    map <M-f> :Files<cr>
    map <leader>p :Files<cr>
    " Tab completion
    inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    " Enable True color
    if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
	" Indenting
	set autoindent
	set expandtab       " Expand tab as spaces
	set copyindent
	set preserveindent
	set tabstop=4		" Press Tab = insert 4 spaces
	set softtabstop=4	" SoftTabStop should = TabStop
	set shiftwidth=4	" Insert 4 spaces when indenting with > and new line
	" Visual
	set number			" Show line numbers
	set splitbelow		" Always split below	
	set splitright		" Always split to the right
	set laststatus=0	" Disable status line
	set noruler			" Disable ruler in command line
	set updatetime=100  " Reduce vim-gitgutter update time (affect nvim's swap update)
	set signcolumn=yes 	" Always show the sign gutter
	set hlsearch        " Highlight search term
	" Modal cursor
	let &t_SI.="\e[5 q" "SI = INSERT mode
	let &t_EI.="\e[2 q" "EI = All other modes (ELSE)
	" Editing
	syntax on			" Enable syntax highlighting
	set splitbelow		" Always split below
	set splitright		" Always split to the right
	" Python indenting
	let g:pyindent_continue = '&sw * 2' " Continue indentation
	let g:pyindent_nested_paren = '&sw' " Allow nested parentheses
	let g:pyindent_open_paren = '&sw'   " Fix double indentation
	set clipboard+=unnamedplus          " Always use + register as clipboard
	set backspace=indent,eol,start      " Let backspace delete

	packloadall          " load all plugins at the end
	silent! helptags ALL " load all helptags after plugins and ignore errors
endif
