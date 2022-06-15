local o   = vim.o   -- General settings. TODO: check out vim.opt. What's the difference vs vim.o?
local g   = vim.g   -- Global variables
local wo  = vim.wo  -- Window scoped options
local bo  = vim.bo  -- Buffer scoped options
local env = vim.env -- Environment variables
local map = vim.keymap.set

-- Prevent netrw from loading
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

require('keybindings')
require('colorscheme')

-- ---------------------------------------------------------------------
-- CHECK IF PACKAGE EXISTS
-- ---------------------------------------------------------------------
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
-- TREESITTER
-- https://github.com/nvim-treesitter/nvim-treesitter
-- TSInstall python bash lua
-- Supported languages: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
-- ---------------------------------------------------------------------
if exists('nvim-treesitter.configs') then
    local tsconfig = require('nvim-treesitter.configs')
    tsconfig.setup {
      highlight = {
        enable = true,
      }
    }
end

-- ---------------------------------------------------------------------
-- LSP
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- ---------------------------------------------------------------------
if exists('lspconfig') then
    local lspconfig = require('lspconfig')
    lspconfig.pyright.setup{
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        --root_dir = function(startpath)
        --       return M.search_ancestors(startpath, matcher)
        --  end,
        settings = {
          python = {
            pythonPath = "/usr/local/bin/python3",
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true
            },
          },
        },
        single_file_support = true
    }
end

-- ---------------------------------------------------------------------
-- COC-NVIM
-- https://github.com/neoclide/coc.nvim
-- ---------------------------------------------------------------------
-- table.insert(plugins, {'neoclide/coc.nvim', branch='release'})
-- CocInstall coc-pyright coc-lua coc-json coc-html coc-js

-- ---------------------------------------------------------------------
-- COC-FZF
-- ---------------------------------------------------------------------
-- add 'antoinemadec/coc-fzf'  -- https://github.com/antoinemadec/coc-fzf
vim.cmd [[
    let g:coc_fzf_preview = 'right:50%'
    let g:coc_fzf_opts = []
]]
--
-- ---------------------------------------------------------------------
-- BETTER-WHITESPACE
-- https://github.com/ntpeters/vim-better-whitespace
-- ---------------------------------------------------------------------
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0

-- ---------------------------------------------------------------------
-- TMUX KEYBIND COMPATIBILITY
-- https://github.com/christoomey/vim-tmux-navigator
-- ---------------------------------------------------------------------
g.tmux_navigator_no_mappings = 1
--
-- ---------------------------------------------------------------------
-- GIT GUTTER
-- https://github.com/airblade/vim-gitgutter
-- ---------------------------------------------------------------------
g.gitgutter_map_keys = 0    -- Disable all key mappings
g.gitgutter_realtime = 1
g.gitgutter_eager =

-- ---------------------------------------------------------------------
-- EASY ALIGN
-- https://github.com/junegunn/vim-easy-align
-- ---------------------------------------------------------------------
-- g.easy_align_ignore_groups = '[]'  -- [] = Align everything, including strings and comments.
-- C-g to cycle through options interactively.

-- ---------------------------------------------------------------------
-- COLORSCHEMES
-- ---------------------------------------------------------------------
vim.cmd [[ silent! colorscheme sonokai ]]
vim.cmd [[ highlight Normal guibg=black ]]
-- vim.cmd [[ highlight SignColumn guibg=black ]]

-- ---------------------------------------------------------------------
-- EDITOR SETTINGS
-- ---------------------------------------------------------------------
o.mouse         = 'a'
o.syntax        = 'on'
o.termguicolors = true
o.wrap          = false
o.hidden        = true	  -- Allow changing buffer before saving
o.ignorecase    = true    -- Case insensitive search
o.foldenable    = false   -- Disable folding
o.equalalways   = false   -- Close a split without resizing other split
o.splitbelow    = true    -- Always split below
o.splitright    = true    -- Always split to the right
o.number        = true    -- Show line numbers
o.updatetime    = 100     -- Reduce vim-gitgutter update time (affect nvim's swap update)
o.signcolumn    = 'yes'   -- Always show the sign gutter
o.encoding      = 'UTF-8' -- Always use UTF8 encoding

-- Indentation
o.autoindent     = true -- Enable auto indent
o.expandtab      = true -- Expand tab as spaces
o.copyindent     = true
o.preserveindent = true
o.tabstop        = 4    -- Press Tab = insert 4 spaces
o.softtabstop    = 4    -- SoftTabStop should = TabStop
o.shiftwidth     = 4    -- Insert 4 spaces when indenting with > and new line

-- Statusline
o.laststatus = 2            -- 0 = hide, 2 = show statusline
o.showmode = false          -- Hide mode indicator
function s_line()
    local sline = ''
    sline = sline .. '%1*%<%F'   -- %F for full file path, set background color
    sline = sline .. '%1*'       -- Add a space to end of filename
    return sline
end
vim.cmd[[ set statusline=%!luaeval('s_line()') ]]
vim.cmd[[ exe 'highlight User1 guifg=#00afff cterm=bold gui=bold']]

-- Buffer & window management
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

-- Quick functin to duplicate file
function SaveAs()
    local dir = vim.api.nvim_eval("expand('%:p:h')")
    local cmd = ':saveas ' .. dir .. '/'
    vim.fn.feedkeys(cmd)
end

-- Refresh all editor states
function RefreshAll()
    vim.cmd [[ GitGutterAll ]]
end
