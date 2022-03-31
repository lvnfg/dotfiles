" --------------------------------------------------------------------------
" Plugins
" --------------------------------------------------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

    " Vim easy align
	Plug 'junegunn/vim-easy-align'
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

    if !exists('g:vscode') && !has("macunix")
        " coc-nvim
        " run install-nodejs.sh for coc-nvim to work
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

        " FZF integration
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'

        " Move between vim splits and tmux panes
        Plug 'christoomey/vim-tmux-navigator'
        let g:tmux_navigator_no_mappings = 1

        " Git integration
        Plug 'airblade/vim-gitgutter'
        let g:gitgutter_map_keys = 0    " Disable all key mappings
        let g:gitgutter_realtime = 1
        let g:gitgutter_eager = 1
        "
        " Manage trailing whitespace
        Plug 'ntpeters/vim-better-whitespace'
        let g:better_whitespace_enabled=1
        let g:strip_whitespace_on_save=1
        let g:strip_whitespace_confirm=0

        " Airline
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        " Enable tabline
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail'

        " Colorschemes
        Plug 'tomasr/molokai'

        " File manager
        Plug 'kyazdani42/nvim-web-devicons'
        Plug 'kyazdani42/nvim-tree.lua'
        let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
        let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
        let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
        let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
        let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
        let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
        let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
        let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
        let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
        let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
        let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
        let g:nvim_tree_show_icons = {
            \ 'git': 1,
            \ 'folders': 0,
            \ 'files': 1,
            \ 'folder_arrows': 0,
            \ }
        "If 0, do not show the icons for one of 'git' 'folder' and 'files'
        "1 by default, notice that if 'files' is 1, it will only display
        "if nvim-web-devicons is installed and on your runtimepath.
        "if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
        "but this will not work when you set indent_markers (because of UI conflict)
        " -----------------------------------------------------------------
        " default will show icon by default if no icon is provided
        " default shows no icon by default
        let g:nvim_tree_icons = {
            \ 'default': "",
            \ 'symlink': "",
            \ 'git': {
            \   'unstaged': "M",
            \   'staged': "A",
            \   'unmerged': "",
            \   'renamed': "R",
            \   'untracked': "?",
            \   'deleted': "D",
            \   'ignored': "◌"
            \   },
            \ 'folder': {
            \   'arrow_open': "",
            \   'arrow_closed': "",
            \   'default': "",
            \   'open': "",
            \   'empty': "",
            \   'empty_open': "",
            \   'symlink': "",
            \   'symlink_open': "",
            \   }
            \ }
        " -----------------------------------------------------------------
        " nnoremap <C-n> :NvimTreeToggle<CR>
        " nnoremap <leader>r :NvimTreeRefresh<CR>
        " nnoremap <leader>n :NvimTreeFindFile<CR>
        " More available functions:
        " NvimTreeOpen
        " NvimTreeClose
        " NvimTreeFocus
        " NvimTreeFindFileToggle
        " NvimTreeResize
        " NvimTreeCollapse
        " NvimTreeCollapseKeepBuffers
        " -----------------------------------------------------------------
        " a list of groups can be found at `:help nvim_tree_highlight`
        highlight NvimTreeFolderIcon guibg=blue
        " highlight NvimTreeGitDirty
        " highlight NvimTreeGitStaged
        " highlight NvimTreeGitMerge
        " highlight NvimTreeGitRenamed
        " highlight NvimTreeGitNew
        " highlight NvimTreeGitDeleted

    endif

call plug#end()

" Call lua scripts here
lua <<EOF
    require'nvim-web-devicons'.setup()
    require'nvim-tree'.setup()
EOF

" --------------------------------------------------------------------------
" Common settings for both vscode and vim/nvim
" --------------------------------------------------------------------------
set ignorecase   " Case insensitive matching
set nocompatible " disable vi compatibility and enable advanced vim features
" Remap leader key
let mapleader="\<Space>"
" Toggle nohighlight with Esc
noremap <Esc> :noh<cr>

"
" --------------------------------------------------------------------------
" VIM/NVIM only settings
" --------------------------------------------------------------------------
if !exists('g:vscode')
    " --------------------------------------------------------------------------
    " Colorscheme customization
    " --------------------------------------------------------------------------
    " Enable true colors
    if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif
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
    let deep_blue    = "#070319"
    let deep_green   = "#020C05"
    " Override colorscheme
    let scheme = get(g:, 'colors_name', 'default')
    if scheme == 'onedark'
        exe 'highlight Normal     guibg=' . pure_black
        exe 'highlight SignColumn guibg=' . pure_black
        exe 'highlight LineNr     guibg=' . pure_black
    elseif scheme == 'cinnabar'
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
    " CloseBufferOrWindow
    " --------------------------------------------------------------------------
    func CloseBufferOrWindow()
        let win_count = win_findbuf(bufnr('%'))
        if len(win_count) > 1
            call feedkeys(":q\<CR>")
        else
            call feedkeys(":bd\<CR>")
        endif
    endfunction

    " --------------------------------------------------------------------------
    " Keybindings
    " --------------------------------------------------------------------------
    " Select all
    noremap <leader>a ggVG
    " Close window
    noremap <M-q> :q<cr>
    " close buffer without closing split
    " noremap <M-w> :bd<CR>
    noremap <M-w> :call CloseBufferOrWindow()<cr>
    " Save buffer
    noremap <M-s> :w<cr>
    " Toggle file explorer
    " toggle netrw: noremap <M-d> :Lexplore<cr>
    noremap <M-d> :NvimTreeToggle<cr>
    noremap <M-r> :NvimTreeRefresh<cr>
    " Invoke FZF
    noremap <M-f> :Files<cr>
    " Tmux integrated move between splits
    nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
    " Split windows
    noremap <M-H> :aboveleft vsplit<cr>
    noremap <M-J> :split<cr>
    noremap <M-K> :leftabove split<cr>
    noremap <M-L> :belowright vsplit<cr>
    " Resize split
    noremap <C-h> :bprevious<cr>
    noremap <C-l> :bnext<cr>
    noremap <M-Left> :vertical resize -5<cr>
    noremap <M-Down> :resize -5<cr>
    noremap <M-Up> :resize +5<cr>
    noremap <M-Right> :vertical resize +5<cr>
    " GoTo code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " --------------------------------------------------------------------------
    " Editor
    " --------------------------------------------------------------------------
    syntax on                      " Enable syntax highlighting. Put above colorscheme and/or plugins load if not working
    set nowrap                     " Do not wrap long line
    set hidden                     " Let fzf open file in window even if current buffer has unsaved changes
    set ignorecase                 " Case insensitive matching
    set nocompatible               " disable vi compatibility and enable advanced vim features
    set nofoldenable               " Disable folding by default
    set noequalalways              " Close a split without resizing the other splits
    set splitbelow                 " Always split below
    set splitright                 " Always split to the right
    set mouse=a                    " enable scrolling with mouse
    set number                     " Show line numbers
    set splitbelow                 " Always split below
    set splitright                 " Always split to the right
    set noruler                    " Disable ruler in command line
    set hlsearch                   " Highlight search term
    set updatetime=100             " Reduce vim-gitgutter update time (affect nvim's swap update)
    set signcolumn=yes             " Always show the sign gutter
    set encoding=UTF-8             " Always use UTF8 encoding
    let &t_SI.="\e[5 q"            " Thin cursor for insert mode mode
    let &t_RI.="\e[4 q"            " Underline cursor for replace mode
    let &t_EI.="\e[2 q"            " Thick cursor for all other modes (EI = ELSE)
    set clipboard+=unnamedplus     " Always use + register as clipboard
    set backspace=indent,eol,start " Let backspace delete

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
    " set statusline=             " Prevent duplicating info when sourcing in place
    " set statusline+=%1*\ %<%F   " %F for full file path, set background color
    " set statusline+=%1*\        " Add a space to end of filename
    " exe 'highlight User1 guibg=' . blue . ' guifg=' . pure_black . ' cterm=bold gui=bold'
    " exe 'highlight StatusLineNC guibg=' . black . 'guifg=' . light_gray . ' cterm=None gui=None'
    " File name formatter: default / jsformatter / unique_tail / unique_tail_improved
    let g:airline#extensions#tabline#formatter = 'default'
    " Show buffer number in tabline
    let g:airline#extensions#tabline#buffer_nr_show = 1
    " Colorscheme
    let g:airline_theme='tomorrow'
    " Configure statusline section
    let g:airline_section_a = airline#section#create(['%F'])
    let g:airline_section_b = airline#section#create([])
    let g:airline_section_c = airline#section#create([])
    let g:airline_section_x = airline#section#create([])
    let g:airline_section_y = airline#section#create([])
    let g:airline_section_z = airline#section#create(['branch'])

endif

packloadall          " load all plugins at the end
silent! helptags ALL " load all helptags after plugins and ignore errors
