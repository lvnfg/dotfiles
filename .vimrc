" --------------------------------------------------------------------------
" Enable True color
" --------------------------------------------------------------------------
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
"
" Enable syntax highlighting. Must put here otherwise colorscheme
" customization does not work.
syntax on 

" --------------------------------------------------------------------------
" Plugins
" --------------------------------------------------------------------------
call plug#begin()

    " LSP support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
    " :CocInstall 
    "   Web        coc-css coc-eslint coc-html coc-tsserver 
    "   Markups    coc-json coc-xml coc-yaml
    "   Bash       coc-sh
    "   Python     coc-pyright
    "   SQL        coc-sql
    "   Latex      coc-texlab
    " :CocUpdate to update all extensions to the latest version
    " :CocConfig to open coc-settings.json
    
    " Python syntax highlighting
    Plug 'vim-python/python-syntax'
    let g:python_highlight_all = 1

    " Vim easy align
	Plug 'junegunn/vim-easy-align'
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

    " Ranger
    Plug 'francoiscabrol/ranger.vim'

    " FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    
    " Use fzf floating window for coc
    Plug 'antoinemadec/coc-fzf'
    
    " Git integration
    Plug 'airblade/vim-gitgutter'

    " Colorschemes
    Plug 'tomasr/molokai'
    Plug 'joshdick/onedark.vim'
    Plug 'christianchiarulli/nvcode-color-schemes.vim'
    Plug 'ayu-theme/ayu-vim'
    Plug 'vimoxide/vim-cinnabar'
    Plug 'mhartington/oceanic-next'
    
call plug#end()

" --------------------------------------------------------------------------
" Colorscheme customization
" --------------------------------------------------------------------------
" Set colorscheme
colorscheme molokai

" Predefined colors
let pure_black   = "#000000"
let black        = "#101010"
let gray         = "#303030"
let blue         = "#00afff"
let white        = "#e4e4e4"
let yellow       = "#ffff00"
let pink         = "#ff00af"
let bright_green = "#5fff00"
let light_gray   = "#8a8a8a"
let white        = "#e4e4e4"
let dark_gray    = "#080808"
let red          = "#d70000"
let white        = "#e4e4e4"
let light_blue   = "#66d9ef"
" Override colorscheme
let scheme = get(g:, 'colors_name', 'default')
if scheme == 'cinnabar'
    exe 'highlight VertSplit  guifg=' . black
elseif scheme == 'molokai'
    exe 'highlight Normal     guibg=' . black
    exe 'highlight SignColumn guibg=' . black
    exe 'highlight LineNr     guibg=' . black
elseif 0
    exe 'highlight Normal     guibg=' . black
    exe 'highlight SignColumn guibg=' . black
    exe 'highlight LineNr     guibg=' . black
endif

" --------------------------------------------------------------------------
" Keybindings
" --------------------------------------------------------------------------
" Remap leader key
let mapleader="\<Space>"
" Toggle nohighlight with Esc
noremap <Esc> :noh<cr>
" Select all
noremap <leader>a ggVG
" Close window
noremap <M-q> :q<cr>
" close buffer without closing split
noremap <M-w> :bd<CR>
" Save buffer
noremap <M-s> :w<cr>
" toggle netrw
noremap <M-d> :Lex<cr>
" Invoke FZF
noremap <M-f> :Files<cr>
" Invoke Ranger
let g:ranger_map_keys = 0 " Diable default invocation
noremap <M-r> :RangerWorkingDirectory<cr>
" Move between splits
noremap <M-h> <C-W>h
noremap <M-j> <C-W>j
noremap <M-k> <C-W>k
noremap <M-l> <C-W>l
" Split windows
noremap <M-H> :aboveleft vsplit<cr>
noremap <M-J> :split<cr>
noremap <M-K> :leftabove split<cr>
noremap <M-L> :belowright vsplit<cr>
" Resize split
noremap <M-Left>  :vertical resize -5<cr>
noremap <M-Down>  :resize -5<cr>
noremap <M-Up>    :resize +5<cr>
noremap <M-Right> :vertical resize +5<cr>
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" --------------------------------------------------------------------------
" Editor
" --------------------------------------------------------------------------
set hidden                          " Let fzf open file in window even if current buffer has unsaved changes
set ignorecase                      " Case insensitive matching
set nofoldenable                    " Disable folding by default
set splitbelow                      " Always split below
set splitright                      " Always split to the right
set mouse=a                         " enable scrolling with mouse
set nocompatible                    " disable vi compatibility and enable advanced vim features
set number                          " Show line numbers
set splitbelow                      " Always split below
set splitright                      " Always split to the right
set noruler                         " Disable ruler in command line
set hlsearch                        " Highlight search term
set updatetime=100                  " Reduce vim-gitgutter update time (affect nvim's swap update)
set signcolumn=yes                  " Always show the sign gutter
set encoding=UTF-8                  " Always use UTF8 encoding
let &t_SI.="\e[5 q"                 " Thin cursor for insert mode mode
let &t_RI.="\e[4 q"                 " Underline cursor for replace mode
let &t_EI.="\e[2 q"                 " Thick cursor for all other modes (EI = ELSE)
set clipboard+=unnamedplus          " Always use + register as clipboard
set backspace=indent,eol,start      " Let backspace delete

" --------------------------------------------------------------------------
" Tab completion
" --------------------------------------------------------------------------
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" --------------------------------------------------------------------------
" Indentation
" --------------------------------------------------------------------------
set autoindent                      " Enable auto indent
set expandtab                       " Expand tab as spaces
set copyindent
set preserveindent
set tabstop=4                       " Press Tab = insert 4 spaces
set softtabstop=4                   " SoftTabStop should = TabStop
set shiftwidth=4                    " Insert 4 spaces when indenting with > and new line
let g:pyindent_continue = '&sw * 2' " Continue indentation
let g:pyindent_nested_paren = '&sw' " Allow nested parentheses
let g:pyindent_open_paren = '&sw'   " Fix double indentation

" --------------------------------------------------------------------------
" netrw
" --------------------------------------------------------------------------
let g:netrw_banner = 0    " remove netrw help banner
let g:netrw_winsize = 20  " Set default width
let g:netrw_liststyle = 3 " show tree view by default

" --------------------------------------------------------------------------
" Status line
" --------------------------------------------------------------------------
set laststatus=2            " 0 = hide, 2 = show statusline
set noshowmode              " Hide mode indicator
set statusline=             " Prevent duplicating info when sourcing in place
set statusline+=%1*\ %<%F   " %F for full file path, set background color
set statusline+=%1*\        " Add a space to end of filename
exe 'highlight User1 guibg=' . blue . ' guifg=' . pure_black . ' cterm=bold gui=bold'
exe 'highlight StatusLineNC guibg=' . black . 'guifg=' . light_gray . ' cterm=None gui=None'

packloadall          " load all plugins at the end
silent! helptags ALL " load all helptags after plugins and ignore errors
