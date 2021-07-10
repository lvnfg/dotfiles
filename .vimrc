" Install plugins
call plug#begin()
    " vim-easy-align & settings
	Plug 'junegunn/vim-easy-align'
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
    " Colorschemes
    if !has('vscode')
        Plug 'Mofiqul/vscode.nvim'
    endif
    " Utilities
    if !has('vscode')
        Plug 'airblade/vim-gitgutter'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
    endif
    if !has('vscode') && has('nvim')
	    " Plug 'michaeljsmith/vim-indent-object'
        " Plug 'neoclide/coc.nvim', {'branch': 'release'}
        " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
        " :CocInstall 
        "   Web:        coc-css coc-eslint coc-html coc-tsserver 
        "   Markups:    coc-json coc-xml coc-yaml
        "   Bash:       coc-sh
        "   Python:     coc-pyright
        "   SQL:        coc-sql
        "   Latex:      coc-texlab
        " :CocUpdate to update all extensions to the latest version
        " :CocConfig to open coc-settings.json
        " Plug 'nvim-treesitter/nvim-treesitter'
    endif
call plug#end()

" Case insensitive matching
set ignorecase
" Global keybindings
let mapleader="\<Space>"
noremap <Esc> :noh<cr>
noremap <M-s> :w<cr>
noremap <M-w> :q<cr>
noremap <M-Q> :q!<cr>
noremap <leader>a ggVG

" Standalone vim settings
if !exists('g:vscode')
	" Keybindings
    noremap <M-d> :Lex<cr>
    noremap <M-f> :Files<cr>
    " Split pane
    noremap <M-E> :split<cr>
    noremap <M-R> :vsplit<cr>
    " Move between splits
    noremap <M-e> <C-W>h
    noremap <M-r> <C-W><C-W>
    " Move between buffers
    noremap <M-h> :bprevious<cr>
    noremap <M-l> :bnext<cr>
    " Resize splits
    noremap <M-H> :vertical resize -5<cr>
    noremap <M-J> :resize -5<cr>
    noremap <M-K> :resize +5<cr>
    noremap <M-L> :vertical resize +5<cr>

	syntax on                 " Enable syntax highlighting
	set nofoldenable          " Disable folding by default
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
	
    " Enable True color
    if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
    " Color schemes must be set below true color settings
    if 1                            " 1 = dark theme, 0 = light theme
        let g:vscode_style = "dark" " light for white theme
        colorscheme vscode          " dark themes: ghdark molokai vscode
        highlight Normal guibg=black  
    else
        let g:vscode_style = "light" " light for white theme
        colorscheme vscode           " light themes: vscode
    endif
    " Clearing highlight will use guibg -> compatibility with all themes
    highlight clear SignColumn
    highlight clear LineNr
    highlight LineNr  guifg=grey

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
