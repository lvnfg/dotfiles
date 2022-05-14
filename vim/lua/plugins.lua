local g = vim.g
local map = vim.keymap.set

local plugins = {}

local function add(p)
    -- Add plugins for paq to load
    table.insert(plugins, p)
end

-- Check if module exists
function exists(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
             end
        end
        return false
    end
end

-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- add 'neovim/nvim-lspconfig'
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup{}

-- Treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
add 'nvim-treesitter/nvim-treesitter'
-- TSInstall python bash lua
-- Supported languages: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
if exists('nvim-treesitter.configs') then
    local tsconfig = require('nvim-treesitter.configs')
    tsconfig.setup {
      highlight = {
        enable = true,
      }
    }
end

-- https://github.com/neoclide/coc.nvim
table.insert(plugins, {'neoclide/coc.nvim', branch='release'})
-- CocInstall coc-pyright coc-lua coc-json coc-html coc-js
map('n', 'gR', '<Plug>(coc-rename)')
map('n', 'gd', '<Plug>(coc-definition)')
map('n', 'gy', '<Plug>(coc-type-definition)')
map('n', 'gi', '<Plug>(coc-implementation)')
map('n', 'gr', '<Plug>(coc-references)')

-- https://github.com/ntpeters/vim-better-whitespace
add 'ntpeters/vim-better-whitespace'
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0

-- Fzf integration
add 'junegunn/fzf'          -- https://github.com/junegunn/fzf
add 'junegunn/fzf.vim'      -- https://github.com/junegunn/fzf.vim

-- https://github.com/christoomey/vim-tmux-navigator
add 'christoomey/vim-tmux-navigator'
g.tmux_navigator_no_mappings = 1

-- https://github.com/airblade/vim-gitgutter
add 'airblade/vim-gitgutter'
g.gitgutter_map_keys = 0    -- Disable all key mappings
g.gitgutter_realtime = 1
g.gitgutter_eager = 1

-- https://github.com/junegunn/vim-easy-align
add 'junegunn/vim-easy-align'
map('x', 'ga', '<Plug>(EasyAlign)')
map('n', 'ga', '<Plug>(EasyAlign)')
-- g.easy_align_ignore_groups = '[]'  -- [] = Align everything, including strings and comments. C-g to cycle through options interactively.

-- Colorschemes
add {"catppuccin/nvim", as = "catppuccin"}       -- https://github.com/catppuccin/nvim
add {'srcery-colors/srcery-vim', as = 'srcery'}  -- https://github.com/srcery-colors/srcery-vim
add 'Rigellute/rigel'                            -- https://rigel.netlify.app/#vim
add 'andreypopp/vim-colors-plain'                -- https://github.com/andreypopp/vim-colors-plain
add 'ful1e5/onedark.nvim'                        -- https://github.com/ful1e5/onedark.nvim
add 'EdenEast/nightfox.nvim'                     -- https://github.com/EdenEast/nightfox.nvim
add 'Mofiqul/dracula.nvim'                       -- https://github.com/Mofiqul/dracula.nvim
vim.cmd [[ silent! colorscheme rigel ]]

-- Let Paq manage itself
add 'savq/paq-nvim'

-- Load plugins with Paq
-- https://github.com/savq/paq-nvim
require('paq')(plugins)
