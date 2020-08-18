" Visual
" ----------------------------
"  Show line numbers
set number
highlight LineNr ctermfg=grey
" hide tilde (~) character by changing color to black
highlight EndOfBuffer ctermfg=black ctermbg=black
" Always split below / to the right
set splitbelow
set splitright
" Always show the sign gutter
set signcolumn=yes
" Reduce vim-gitgutter update time (affect nvim's swap update)
set updatetime=100
" Turn of statusline (replace with lightline)"
set laststatus=2
set noshowmode

" Editing
" ---------------------------
" Case insensitive matching
set ignorecase
" Set tab width
set tabstop=4
set softtabstop=4
set shiftwidth=4	" when indenting with >

" vim-plug
call plug#begin()
	Plug 'itchyny/lightline.vim'
	Plug 'airblade/vim-gitgutter'
call plug#end()
