" Plugin installation & settings
call plug#begin()
	Plug 'junegunn/vim-easy-align'
	Plug 'michaeljsmith/vim-indent-object'
    if !exists('g:vscode')
        Plug 'airblade/vim-gitgutter'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
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

set ignorecase                " Case insensitive matching
let mapleader="\<Space>"      " Remap leader key

noremap <Esc> :noh<cr>
noremap <leader>a ggVG
noremap <leader>q :q<cr>
noremap <leader>Q :q!<cr>

if !exists('g:vscode')
	" Keybindings
    map <leader>E :Vexplore<cr>
    map <M-f> :Files<cr>
    map <leader>p :Files<cr>
    " Split pane
    map <leader>e :split<cr>
    map <leader>r :vsplit<cr>
    " Move between panes
    map <leader>d <C-W>h
    map <leader>f <C-W>l
    " Move between buffers
    map <leader>j :bprevious<cr>
    map <leader>k :bnext<cr>
    map <leader>w :bd<cr>

	syntax on                 " Enable syntax highlighting
	set splitbelow            " Always split below
	set splitright            " Always split to the right
    set mouse=a               " enable scrolling with mouse
	set nocompatible          " disable vi compatibility and enable advanced vim features
	set number                " Show line numbers
	set splitbelow            " Always split below
	set splitright            " Always split to the right
	set laststatus=0          " Enable status line
	set noruler               " Disable ruler in command line
	set updatetime=100        " Reduce vim-gitgutter update time (affect nvim's swap update)
	set signcolumn=yes        " Always show the sign gutter
	set hlsearch              " Highlight search term
    let &t_SI.="\e[5 q"       " Thin cursor for insert mode mode
    let &t_RI.="\e[4 q"       " Underline cursor for replace mode 
    let &t_EI.="\e[2 q"       " Thick cursor for all other modes (EI = ELSE)
	let g:netrw_banner = 0    " remove netrw help banner
	let g:netrw_liststyle = 3 " show tree view by default
	
    colorscheme molokai
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
	
	" Python indenting
	let g:pyindent_continue = '&sw * 2' " Continue indentation
	let g:pyindent_nested_paren = '&sw' " Allow nested parentheses
	let g:pyindent_open_paren = '&sw'   " Fix double indentation
	set clipboard+=unnamedplus          " Always use + register as clipboard
	set backspace=indent,eol,start      " Let backspace delete
	 
    " Tab completion
    inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	
	packloadall          " load all plugins at the end
	silent! helptags ALL " load all helptags after plugins and ignore errors
endif
