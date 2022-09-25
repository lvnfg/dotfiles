local o   = vim.o   -- General settings. TODO: check out vim.opt. What's the difference vs vim.o?
local g   = vim.g   -- Global variables
local wo  = vim.wo  -- Window scoped options
local bo  = vim.bo  -- Buffer scoped options
local env = vim.env -- Environment variables
local map = vim.keymap.set

-- Prevent netrw from loading
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

require('plugins')
require('keybindings')
require('colorscheme')

-- ---------------------------------------------------------------------
-- TERMINAL
-- ---------------------------------------------------------------------
-- Disable line numbers in terminal
-- vim.cmd [[ autocmd TermOpen * setlocal nonumber norelativenumber ]]
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = { "*" },
    command = "setlocal nonumber norelativenumber",
})

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
