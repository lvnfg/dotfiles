local o = vim.o     -- General settings. TODO: check out vim.opt. What's the difference vs vim.o?
local g = vim.g     -- Global variables
local wo = vim.wo   -- Window scoped options
local bo = vim.bo   -- Buffer scoped options
local env = vim.env -- Environment variables
local map = vim.keymap.set

-- Prevent netrw from loading
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

require('colorscheme')
o.termguicolors = true
o.syntax = 'on'

------------------------------------------------
-- Plugins
------------------------------------------------
local plugins = {}

-- Let Paq manage itself
table.insert(plugins, 'savq/paq-nvim')

-- colorscheme
-- TODO: Find a good colorscheme with treesitter support, clone and customize
table.insert(plugins, {"catppuccin/nvim", as = "catppuccin"})       -- https://github.com/catppuccin/nvim
table.insert(plugins, {'srcery-colors/srcery-vim', as = 'srcery'})  -- https://github.com/srcery-colors/srcery-vim
table.insert(plugins, 'Rigellute/rigel')                            -- https://rigel.netlify.app/#vim
table.insert(plugins, 'andreypopp/vim-colors-plain')                -- https://github.com/andreypopp/vim-colors-plain
table.insert(plugins, 'ful1e5/onedark.nvim')                        -- https://github.com/ful1e5/onedark.nvim
table.insert(plugins, 'EdenEast/nightfox.nvim')                     -- https://github.com/EdenEast/nightfox.nvim
table.insert(plugins, 'Mofiqul/dracula.nvim')                       -- https://github.com/Mofiqul/dracula.nvim
vim.cmd[[colorscheme rigel]]

-- LSP
table.insert(plugins, {'neoclide/coc.nvim', branch='release'})
map('n', 'gR', '<Plug>(coc-rename)')
map('n', 'gd', '<Plug>(coc-definition)')
map('n', 'gy', '<Plug>(coc-type-definition)')
map('n', 'gi', '<Plug>(coc-implementation)')
map('n', 'gr', '<Plug>(coc-references)')

-- Treesitter
table.insert(plugins, 'nvim-treesitter/nvim-treesitter')
-- TSInstall python bash lua
-- Supported languages: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local tsconfig = require('nvim-treesitter.configs')
tsconfig.setup {
  highlight = {
    enable = true,
  }
}

-- Manage trailing whitespaces
table.insert(plugins, 'ntpeters/vim-better-whitespace')
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0

-- Fzf integration
table.insert(plugins, 'junegunn/fzf')
table.insert(plugins, 'junegunn/fzf.vim')

-- Tmux integrated navigation
table.insert(plugins, 'christoomey/vim-tmux-navigator')
g.tmux_navigator_no_mappings = 1

-- Git status
table.insert(plugins, 'airblade/vim-gitgutter')
g.gitgutter_map_keys = 0    -- Disable all key mappings
g.gitgutter_realtime = 1
g.gitgutter_eager = 1

-- Text alignment
table.insert(plugins, 'junegunn/vim-easy-align')
map('x', 'ga', '<Plug>(EasyAlign)')
map('n', 'ga', '<Plug>(EasyAlign)')
g.easy_align_ignore_groups = '[]'     -- Align everything. C-g to cycle through options interactively.

-- Colorschemes
-- table.insert(plugins, 'tomasr/molokai')

-- Load plugins with Paq
require('paq')(plugins)


------------------------------------------------
-- Keybindings
------------------------------------------------
function CloseBuffer()
    local buffer_count = vim.api.nvim_eval("len(getbufinfo({'buflisted':1}))")
    local number_of_split_current_buffer_is_opened_in = vim.api.nvim_eval("len(win_findbuf(bufnr('%')))")
    if buffer_count > 1 then
        if number_of_split_current_buffer_is_opened_in > 1 then
            vim.cmd [[ bp]]
        else
            vim.cmd [[ bp|bd# ]]
        end
    else
        vim.cmd [[ q ]]
    end
end

function SaveAs()
    local dir = vim.api.nvim_eval("expand('%:p:h')")
    local cmd = ':saveas ' .. dir .. '/'
    vim.fn.feedkeys(cmd)
end

function RefreshAll()
    vim.cmd [[ GitGutterAll ]]
end

-- Tab completion
vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-N>' or '<Tab>'
end, {expr = true})
vim.keymap.set('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-h>'
end, {expr = true})

-- Closing & saving buffers & windows
map('n', '<M-q>', ':q<cr>')                 -- Close window
map('n', '<M-w>', ':lua CloseBuffer()<cr>') -- Call function close buffer
map('n', '<M-s>', ':w<cr>')                 -- Save file
map('n', '<M-S>', ':lua SaveAs()<cr>')      -- Call SaveAs
map('n', '<M-r>', ':lua RefreshAll()<cr>')  -- Call RefreshAll()

-- Fzf
map('n', '<M-f>', ':Files<cr>')             -- Invoke Fzf
-- Git
map('n', '<M-g>', ':GFiles?<cr>')           -- Fzf list git status for all files
map('n', '<M-c>', ':BCommits<cr>')          -- Fzf list git commit for this buffer
map('n', '<M-C>', ':Commits<cr>')           -- Fzf list git commit for entire repo
-- Buffer management
map('n', '<M-b>', ':Buffers<cr>')           -- Fzf list all buffers

-- Navigation
map('n', '<C-h>', ':bprevious<cr>')         -- Show previous buffer in current window
map('n', '<C-l>', ':bnext<cr>')             -- Show next buffer in current window
-- Tmux integrated movement
map('n', '<M-h>', ':TmuxNavigateLeft<cr>')
map('n', '<M-j>', ':TmuxNavigateDown<cr>')
map('n', '<M-k>', ':TmuxNavigateUp<cr>')
map('n', '<M-l>', ':TmuxNavigateRight<cr>')
-- Split window
map('n', '<M-H>', ':aboveleft vsplit<cr>')
map('n', '<M-J>', ':split<cr>')
map('n', '<M-K>', ':leftabove split<cr>')
map('n', '<M-L>', ':belowright vsplit<cr>')
-- Resize split
map('n', '<M-Left>',  ':vertical resize -5<cr>')
map('n', '<M-Down>',  ':resize -5<cr>')
map('n', '<M-Up>',    ':resize +5<cr>')
map('n', '<M-Right>', ':vertical resize +5<cr>')

-- Misc
map('n', '<Esc>', ':noh<cr>') 	-- Toggle no highlight with Esc


------------------------------------------------
-- Editor settings
------------------------------------------------
o.mouse       = 'a'
o.wrap        = false
o.hidden      = true	-- Allow changing buffer before saving
o.ignorecase  = true    -- Case insensitive search
o.foldenable  = false   -- Disable folding
o.equalalways = false   -- Close a split without resizing other split
o.splitbelow  = true    -- Always split below
o.splitright  = true    -- Always split to the right
o.number      = true    -- Show line numbers
o.updatetime  = 100     -- Reduce vim-gitgutter update time (affect nvim's swap update)
o.signcolumn  = 'yes'   -- Always show the sign gutter
o.encoding    = 'UTF-8' -- Always use UTF8 encoding

------------------------------------------------
-- Indentation
------------------------------------------------
o.autoindent     = true -- Enable auto indent
o.expandtab      = true -- Expand tab as spaces
o.copyindent     = true
o.preserveindent = true
o.tabstop        = 4    -- Press Tab = insert 4 spaces
o.softtabstop    = 4    -- SoftTabStop should = TabStop
o.shiftwidth     = 4    -- Insert 4 spaces when indenting with > and new line

------------------------------------------------
-- Predefined colors
------------------------------------------------
local pure_black   = "#000000"
local black        = "#101010"
local gray         = "#303030"
local blue         = "#00afff"
local white        = "#e4e4e4"
local yellow       = "#ffff00"
local pink         = "#ff00af"
local bright_green = "#5fff00"
local light_gray   = "#8a8a8a"
local white        = "#e4e4e4"
local dark_gray    = "#080808"
local red          = "#d70000"
local white        = "#e4e4e4"
local light_blue   = "#66d9ef"
local deep_blue    = "#070319"
local deep_green   = "#020C05"

------------------------------------------------
-- Statusline
------------------------------------------------
o.laststatus = 2            -- 0 = hide, 2 = show statusline
o.showmode = False          -- Hide mode indicator
function s_line()
    local sline = ''
    sline = sline .. '%1*%<%F'   -- %F for full file path, set background color
    sline = sline .. '%1*'        -- Add a space to end of filename
    return sline
end
vim.cmd[[ set statusline=%!luaeval('s_line()') ]]
vim.cmd[[ exe 'highlight User1 guifg=#00afff cterm=bold gui=bold']]
