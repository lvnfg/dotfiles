local g = vim.g
local map = vim.keymap.set

local plugins = {}

-- ---------------------------------------------------------------------
-- CONFIGURE PLUGINS OUTSIDE OF PAQ
-- By default paq requires listing a list of plugins by calling:
--      require('paq')([list of plugins here])
-- which doesn't allow settings configs / kebind next to plugin url.
-- The functions below add the passed plugin url into a waiting list,
-- which can be passed to require('paq') at EOF. We can then configure
-- any settings specific to each plugin right next to their url. This
-- makes tracking and cleaning up plugins much more manageable.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- LSP
-- ---------------------------------------------------------------------
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- add 'neovim/nvim-lspconfig'
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup{}

-- ---------------------------------------------------------------------
-- TREESITTER
-- https://github.com/nvim-treesitter/nvim-treesitter
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- COC-NVIM
-- https://github.com/neoclide/coc.nvim
-- ---------------------------------------------------------------------
table.insert(plugins, {'neoclide/coc.nvim', branch='release'})
-- CocInstall coc-pyright coc-lua coc-json coc-html coc-js

-- ---------------------------------------------------------------------
-- FZF INTEGRATION
-- ---------------------------------------------------------------------
add 'junegunn/fzf'          -- https://github.com/junegunn/fzf
add 'junegunn/fzf.vim'      -- https://github.com/junegunn/fzf.vim
-- ---------------------------------------------------------------------
-- FZF & COC-NVIM INTEGRATION
-- ---------------------------------------------------------------------
-- add 'antoinemadec/coc-fzf'  -- https://github.com/antoinemadec/coc-fzf
add 'lvnfg/coc-fzf'         -- https://github.com/lvnfg/coc-fzf
vim.cmd [[
    let g:coc_fzf_preview = 'right:50%'
    let g:coc_fzf_opts = []
]]

-- ---------------------------------------------------------------------
-- BETTER-WHITESPACE
-- https://github.com/ntpeters/vim-better-whitespace
-- ---------------------------------------------------------------------
add 'ntpeters/vim-better-whitespace'
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0

-- ---------------------------------------------------------------------
-- TMUX KEYBIND COMPATIBILITY
-- https://github.com/christoomey/vim-tmux-navigator
-- ---------------------------------------------------------------------
add 'christoomey/vim-tmux-navigator'
g.tmux_navigator_no_mappings = 1

-- ---------------------------------------------------------------------
-- GIT GUTTER
-- https://github.com/airblade/vim-gitgutter
-- ---------------------------------------------------------------------
add 'airblade/vim-gitgutter'
g.gitgutter_map_keys = 0    -- Disable all key mappings
g.gitgutter_realtime = 1
g.gitgutter_eager = 1

-- ---------------------------------------------------------------------
-- EASY ALIGN
-- https://github.com/junegunn/vim-easy-align
-- ---------------------------------------------------------------------
add 'junegunn/vim-easy-align'
-- g.easy_align_ignore_groups = '[]'  -- [] = Align everything, including strings and comments.
-- C-g to cycle through options interactively.

-- ---------------------------------------------------------------------
-- COLORSCHEMES
-- ---------------------------------------------------------------------
-- add {"catppuccin/nvim", as = "catppuccin"}      -- https://github.com/catppuccin/nvim
-- add {'srcery-colors/srcery-vim', as = 'srcery'} -- https://github.com/srcery-colors/srcery-vim
-- add 'Rigellute/rigel'                           -- https://rigel.netlify.app/#vim
-- add 'andreypopp/vim-colors-plain'               -- https://github.com/andreypopp/vim-colors-plain
-- add 'ful1e5/onedark.nvim'                       -- https://github.com/ful1e5/onedark.nvim
-- add 'EdenEast/nightfox.nvim'                    -- https://github.com/EdenEast/nightfox.nvim
-- add 'Mofiqul/dracula.nvim'                      -- https://github.com/Mofiqul/dracula.nvim
-- add 'sainnhe/everforest'                        -- https://github.com/sainnhe/everforest
-- add 'folke/tokyonight.nvim'                     -- https://github.com/folke/tokyonight.nvim
-- add 'sainnhe/gruvbox-material'                  -- https://github.com/sainnhe/gruvbox-material
-- add 'sainnhe/edge'                              -- https://github.com/sainnhe/edge
add 'sainnhe/sonokai'                              -- https://github.com/sainnhe/sonokai
-- add 'bluz71/vim-nightfly-guicolors'             -- https://github.com/bluz71/vim-nightfly-guicolors
-- add 'mhartington/oceanic-next'                  -- https://github.com/mhartington/oceanic-next
-- add 'fenetikm/falcon'                           -- https://github.com/fenetikm/falcon
-- add 'marko-cerovac/material.nvim'               -- https://github.com/marko-cerovac/material.nvim
-- add 'shaunsingh/nord.nvim'                      -- https://github.com/shaunsingh/nord.nvim
-- add 'rebelot/kanagawa.nvim'                     --  https://github.com/rebelot/kanagawa.nvim
-- add 'navarasu/onedark.nvim'                     -- https://github.com/navarasu/onedark.nvim
-- add 'olimorris/onedarkpro.nvim'                 -- https://github.com/olimorris/onedarkpro.nvim
-- add 'mcchrish/zenbones.nvim'                    -- https://github.com/mcchrish/zenbones.nvim
-- add 'pineapplegiant/spaceduck'                  -- https://pineapplegiant.github.io/spaceduck/
-- add 'luisiacc/gruvbox-baby'                     -- https://github.com/luisiacc/gruvbox-baby
vim.cmd [[ silent! colorscheme sonokai ]]
vim.cmd [[ highlight Normal guibg=black ]]
-- vim.cmd [[ highlight SignColumn guibg=black ]]

-- ---------------------------------------------------------------------
-- PAQ-NVIM PLUGIN MANAGER
-- https://github.com/savq/paq-nvim
-- ---------------------------------------------------------------------
add 'savq/paq-nvim'     -- Let paq manage itself

-- Load plugins with Paq
-- https://github.com/savq/paq-nvim
require('paq')(plugins)
