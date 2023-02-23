local o   = vim.o   -- General settings. TODO: check out vim.opt. What's the difference vs vim.o?
local g   = vim.g   -- Global variables
local wo  = vim.wo  -- Window scoped options
local bo  = vim.bo  -- Buffer scoped options
local env = vim.env -- Environment variables
local map = vim.keymap.set

-- Prevent netrw from loading
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

-- ---------------------------------------------------------------------
-- PLUGINS
-- ---------------------------------------------------------------------
-- Check if package exists before attempting to call setup to prevent errors
-- on new nvim install with possible missing plugins
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

-- Core plugins
-- vim-gitgutter
g.gitgutter_map_keys = 0    -- Disable all key mappings
g.gitgutter_realtime = 1
g.gitgutter_eager = 0
-- vim-easy-align
-- g.easy_align_ignore_groups = '[]'  -- [] = Align everything, including strings and comments.
-- C-g to cycle through options interactively.

-- nvim-treesitter
if exists('nvim-treesitter.configs') then
    local tsconfig = require('nvim-treesitter.configs')
    tsconfig.setup {
      highlight = {
        enable = true,
      }
    }
end

-- nvim-lspconfig + fzf-lsp
if exists('lspconfig') then
    local lspconfig = require('lspconfig')
    -- Setup language server settings
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    -- -------------------------------------
    -- Python
    -- -------------------------------------
    lspconfig.pyright.setup{
        capabilities = capabilities,    -- Autocompletion
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
        single_file_support = true,
    }
    -- -------------------------------------
    -- Javascript & Typescript
    -- -------------------------------------
    lspconfig.tsserver.setup{
        single_file_support = true,
        cmd = { "typescript-language-server", "--stdio" },
        -- root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    }
    -- -------------------------------------
    -- HTML, CSS, JSON, ESLINT
    -- All share the same LSP: npm install -g vscode-langservers-extracted
    -- https://github.com/hrsh7th/vscode-langservers-extracted
    -- -------------------------------------
    -- vscode-json-language-server only provides completions when snippet support is enabled.
    -- To enable completion, install a snippet plugin and add the following override to your
    -- language client capabilities during setup.
    local vscode_capabilities = vim.lsp.protocol.make_client_capabilities()
    vscode_capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- HTML
    lspconfig.html.setup{
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        -- root_dir = see source file,
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = {css = true, javascript = true},
          provideFormatter = true,
        },
        capabilities = vscode_capabilities,
        single_file_support = true,
    }
    -- CSS
    lspconfig.cssls.setup{
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        -- root_dir = root_pattern("package.json", ".git") or bufdir,
        settings = { css = { validate = true }, less = { validate = true }, scss = { validate = true } },
        capabilities = vscode_capabilities,
        single_file_support = true,
    }
    -- JSON
    lspconfig.jsonls.setup{
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        init_options = { provideFormatter = true },
        -- root_dir = util.find_git_ancestor,
        capabilities = vscode_capabilities,
        single_file_support = true,
    }
end
if exists('fzf_lsp') then
    -- Automatically replace all handlers:
    --     require'fzf_lsp'.setup()
    -- Else manually replace handlers:
    local fzf_lsp = require('fzf_lsp')
    vim.lsp.handlers["textDocument/codeAction"]     = fzf_lsp.code_action_handler
    vim.lsp.handlers["textDocument/definition"]     = fzf_lsp.definition_handler
    vim.lsp.handlers["textDocument/declaration"]    = fzf_lsp.declaration_handler
    vim.lsp.handlers["textDocument/typeDefinition"] = fzf_lsp.type_definition_handler
    vim.lsp.handlers["textDocument/implementation"] = fzf_lsp.implementation_handler
    vim.lsp.handlers["textDocument/references"]     = fzf_lsp.references_handler
    vim.lsp.handlers["textDocument/documentSymbol"] = fzf_lsp.document_symbol_handler
    vim.lsp.handlers["workspace/symbol"]            = fzf_lsp.workspace_symbol_handler
    vim.lsp.handlers["callHierarchy/incomingCalls"] = fzf_lsp.incoming_calls_handler
    vim.lsp.handlers["callHierarchy/outgoingCalls"] = fzf_lsp.outgoing_calls_handler
end

-- nvim-cmp & autocompletion plugins
if exists('cmp') then
    local cmp = require'cmp'
    cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },

    -- TAB COMPLETION
    mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping.select_next_item({behavior=cmp.SelectBehavior.Insert}),
      ["<S-Tab>"] = cmp.mapping.select_prev_item({behavior=cmp.SelectBehavior.Insert}),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

-- ---------------------------------------------------------------------
-- SPLIT RESIZING
-- Use same resize direction even if the split is at right-most and/or
-- bottom-most edge
-- ---------------------------------------------------------------------
vim.cmd [[
func! ResizeSplit(direction, count) abort

    " ---------------------------------------------------
    " Get immediate neighbor to determine resize direction
    " ---------------------------------------------------
    let current_window = winnr()
    let neighbor_left = winnr('h')
    let neighbor_down = winnr('j')
    let neighbor_up = winnr('k')
    let neighbor_right = winnr('l')
    let command = ''

    " ---------------------------------------------------
    " Resize left
    " ---------------------------------------------------
    if (a:direction ==# 'left')
        if (neighbor_left == current_window)
            let command = 'vertical resize -' . a:count
        elseif (neighbor_right == current_window)
            let command = 'vertical resize +' . a:count
        else
            let command = 'vertical resize -' . a:count
        endif

    " ---------------------------------------------------
    " Resize down
    " ---------------------------------------------------
    elseif (a:direction ==# 'down')
        if (neighbor_up == current_window)
            let command = 'resize +' . a:count
        elseif (neighbor_down == current_window)
            let command = 'resize -' . a:count
        else
            let command = 'resize +' . a:count
        endif

    " ---------------------------------------------------
    " Resize up
    " ---------------------------------------------------
    elseif (a:direction ==# 'up')
        if (neighbor_up == current_window)
            let command = 'resize -' . a:count
        elseif (neighbor_down == current_window)
            let command = 'resize +' . a:count
        else
            let command = 'resize -' . a:count
        endif

    " ---------------------------------------------------
    " Resize right
    " ---------------------------------------------------
    elseif (a:direction ==# 'right')
        if (neighbor_right == current_window)
            let command = 'vertical resize -' . a:count
        elseif (neighbor_right == current_window)
            let command = 'vertical resize -' . a:count
        else
            let command = 'vertical resize +' . a:count
        endif

    endif

    " ---------------------------------------------------
    " Execute command
    " ---------------------------------------------------
    " echo('Dir: ' . a:direction . '. Left: ' . neighbor_left . '. Down: ' . neighbor_down . '. Up: ' . neighbor_up . '. Right: ' . neighbor_right . '. Cur: ' . current_window . '. Cmd:' . command)
    execute command
endfunc
]]

-- ---------------------------------------------------------------------
-- SCROLLING
-- Original: https://github.com/terryma/vim-smooth-scroll
-- ---------------------------------------------------------------------
vim.cmd [[
function! s:smooth_scroll(direction, row_count, duration, speed)
  for i in range(a:row_count/a:speed)
    " -------------------------------------------------------------------
    " Detect if cursor is already at end of scroll zone and
    " terminate loop early to avoid screen freeze
    " -------------------------------------------------------------------
    let first_visible_line = line("w0")
    let last_visible_line = line("w$")
    let last_buffer_line = line("$")
    let cursor_current_line = line(".")
    " -------------------------------------------------------------------
    " Scroll logic
    " -------------------------------------------------------------------
    let start = reltime()
    if a:direction ==# 'down'
      if (cursor_current_line == last_buffer_line)
          break
      else
        exec "normal! ".a:speed."\<C-e>".a:speed."j"
      endif
    else
      if (cursor_current_line == 1)
          break
      else
        exec "normal! ".a:speed."\<C-y>".a:speed."k"
      endif
    endif
    redraw
    let elapsed = s:smooth_scroll_get_ms_since(start)
    let snooze = float2nr(a:duration-elapsed)
    if snooze > 0
          exec "sleep ".snooze."m"
    endif
  endfor
endfunction

function! s:smooth_scroll_get_ms_since(time)
  let cost = split(reltimestr(reltime(a:time)), '\.')
  return str2nr(cost[0])*1000 + str2nr(cost[1])/1000.0
endfunction

function! Smooth_scroll_up(row_count, duration, speed)
  call s:smooth_scroll('up', a:row_count, a:duration, a:speed)
endfunction

function! Smooth_scroll_down(row_count, duration, speed)
  call s:smooth_scroll('down', a:row_count, a:duration, a:speed)
endfunction
]]

-- ---------------------------------------------------------------------
-- BUFFER HANDLING
-- ---------------------------------------------------------------------

-- Close buffer without closing split.
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

-- Save current buffer as a new file, but keep current buffer in split
function SaveAsAndKeepCurrentBuffer()
    local dir = vim.api.nvim_eval("expand('%:p:h')")
    local cmd = ':!cp % ' .. dir .. '/'
    vim.fn.feedkeys(cmd)
end

-- Save current buffer as a new file and switch to editing that buffer
function SaveAsAndSwitchToNewBuffer()
    local dir = vim.api.nvim_eval("expand('%:p:h')")
    local cmd = ':saveas ' .. dir .. '/'
    vim.fn.feedkeys(cmd)
end

-- Refresh all editor states
function RefreshAll()
    vim.cmd [[ GitGutterAll ]]
end

-- ---------------------------------------------------------------------
-- REMOVE TRAILING WHITESPACE
-- ---------------------------------------------------------------------
vim.cmd [[
    " On leaving insert mode, match trailing whitespace pattern and
    " assign to highlight group ExtraWhitespace
    autocmd InsertLeave * match ExtraWhitespace /\s\+\%#\@<!$/

    function! Remove_trailing_whitespace()

        " Store cursor's current position
        let l = line('.')
        let c = col('.')

        " /e = not raising errors if pattern not found
        " |norm!`` = store cursor position and return after
        " execute '%s/\s\+$//eg|norm!``'
        execute '%s/\s\+$//e'

        " Return cursor to original position
        call cursor(l, c)

    endfunction

    " Remove trailling whitespace on save
    autocmd BufWritePost * call Remove_trailing_whitespace()
]]

-- ---------------------------------------------------------------------
-- TMUX INTEGRATION
-- https://github.com/christoomey/vim-tmux-navigator
-- ---------------------------------------------------------------------
--
-- Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are
-- no more windows in that direction, forwards the operation to tmux.
-- Additionally, <C-\> toggles between last active vim splits/tmux panes.
--
-- The solution has 3 parts:
--   1. In ~/.tmux.conf, I bind the keys I want to execute a custom
--      tmux-vim-select-pane command;
--   2. tmux-vim-select-pane checks if the foreground process in the current
--      tmux pane is Vim, then forwards the original keystroke to the vim
--      process. Otherwise it simply switches tmux panes.
--   3. In Vim, I set bindings for the same keystrokes to a custom function.
--      The function tries to switch windows in the given direction. If the
--      window didn't change, that means there are no more windows in the
--      given direction inside vim, and it forwards the pane switching command
--      to tmux by shelling out to tmux select-pane.
--
-- The following scripts must be added to .tmux.conf (mind the keybindings
-- that must match with vim)
--[[
is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
--]]

vim.cmd [[
" ----------------------------------------------------------------------
" /plugin/tmux_navigator.vim.vim   [41ea9d2 on Dec 9, 2022]
" ----------------------------------------------------------------------
function! s:VimNavigate(direction)
try
    execute 'wincmd ' . a:direction
catch
    echohl ErrorMsg | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k' | echohl None
endtry
endfunction

if empty($TMUX)
command! TmuxNavigateLeft call s:VimNavigate('h')
command! TmuxNavigateDown call s:VimNavigate('j')
command! TmuxNavigateUp call s:VimNavigate('k')
command! TmuxNavigateRight call s:VimNavigate('l')
command! TmuxNavigatePrevious call s:VimNavigate('p')
finish
endif

command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
command! TmuxNavigateRight call s:TmuxAwareNavigate('l')
command! TmuxNavigatePrevious call s:TmuxAwareNavigate('p')

if !exists("g:tmux_navigator_save_on_switch")
let g:tmux_navigator_save_on_switch = 0
endif

if !exists("g:tmux_navigator_disable_when_zoomed")
let g:tmux_navigator_disable_when_zoomed = 0
endif

if !exists("g:tmux_navigator_preserve_zoom")
let g:tmux_navigator_preserve_zoom = 0
endif

if !exists("g:tmux_navigator_no_wrap")
let g:tmux_navigator_no_wrap = 0
endif

let s:pane_position_from_direction = {'h': 'left', 'j': 'bottom', 'k': 'top', 'l': 'right'}

function! s:TmuxOrTmateExecutable()
return (match($TMUX, 'tmate') != -1 ? 'tmate' : 'tmux')
endfunction

function! s:TmuxVimPaneIsZoomed()
return s:TmuxCommand("display-message -p '#{window_zoomed_flag}'") == 1
endfunction

function! s:TmuxSocket()
" The socket path is the first value in the comma-separated list of $TMUX.
return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
let l:x=&shellcmdflag
let &shellcmdflag='-c'
let retval=system(cmd)
let &shellcmdflag=l:x
return retval
endfunction

function! s:TmuxNavigatorProcessList()
echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxNavigatorProcessList call s:TmuxNavigatorProcessList()

let s:tmux_is_last_pane = 0
augroup tmux_navigator
au!
autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

function! s:NeedsVitalityRedraw()
return exists('g:loaded_vitality') && v:version < 704 && !has("patch481")
endfunction

function! s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
endif
return a:tmux_last_pane || a:at_tab_page_edge
endfunction

function! s:TmuxAwareNavigate(direction)
let nr = winnr()
let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
if !tmux_last_pane
    call s:VimNavigate(a:direction)
endif
let at_tab_page_edge = (nr == winnr())
" Forward the switch panes command to tmux if:
" a) we're toggling between the last tmux pane;
" b) we tried switching windows in vim but it didn't have effect.
if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    if g:tmux_navigator_save_on_switch == 1
        try
            update " save the active buffer. See :help update
        catch /^Vim\%((\a\+)\)\=:E32/ " catches the no file name error
        endtry
    elseif g:tmux_navigator_save_on_switch == 2
        try
            wall " save all the buffers. See :help wall
        catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
        endtry
    endif
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    if g:tmux_navigator_preserve_zoom == 1
        let l:args .= ' -Z'
    endif
    if g:tmux_navigator_no_wrap == 1
        let args = 'if -F "#{pane_at_' . s:pane_position_from_direction[a:direction] . '}" "" "' . args . '"'
    endif
    silent call s:TmuxCommand(args)
    if s:NeedsVitalityRedraw()
        redraw!
    endif
    let s:tmux_is_last_pane = 1
else
    let s:tmux_is_last_pane = 0
endif
endfunction
]]

-- ---------------------------------------------------------------------
-- EDITOR SETTINGS
-- ---------------------------------------------------------------------
o.mouse         = 'a'
o.syntax        = 'on'
o.wrap          = false
o.hidden        = true	   -- Allow changing buffer before saving
o.ignorecase    = true     -- Case insensitive search
o.foldenable    = false    -- Disable folding
o.equalalways   = false    -- Close a split without resizing other split
o.splitbelow    = true     -- Always split below
o.splitright    = true     -- Always split to the right
o.number        = true     -- Show line numbers
o.updatetime    = 100      -- Reduce vim-gitgutter update time (affect nvim's swap update)
o.signcolumn    = 'yes'    -- Always show the sign gutter
o.encoding      = 'UTF-8'  -- Always use UTF8 encoding
o.cursorline    = true     -- Needed to turn on CursorLineNr highlight
o.cursorlineopt = 'number' -- Only highlight CursorLineNr, no CursorLine

-- Indentation
o.autoindent     = true -- Enable auto indent
o.expandtab      = true -- Expand tab as spaces
o.copyindent     = true
o.preserveindent = true
o.tabstop        = 4    -- Press Tab = insert 4 spaces
o.softtabstop    = 4    -- SoftTabStop should = TabStop
o.shiftwidth     = 4    -- Insert 4 spaces when indenting with > and new line

-- ---------------------------------------------------------------------
-- STATUSLINE
-- ---------------------------------------------------------------------
o.laststatus = 2            -- 0 = hide, 2 = show statusline
o.showmode = false          -- Hide mode indicator
function s_line()
    local sline = ''
    sline = sline .. '%1*%<(%n)' -- %n for buffer number (highlight group = User1 for colorscheme)
    sline = sline .. ' %1*%<%F'  -- %F for full file path
    sline = sline .. '%1*'       -- Add a space to end of filename
    return sline
end
vim.cmd [[ set statusline=%!luaeval('s_line()') ]]

-- ---------------------------------------------------------------------
-- KEYBINDINGS
-- ---------------------------------------------------------------------
-- Remap leader key
vim.g.mapleader = ' '

-- Text editing
map('n', '<Esc>', ':noh<cr>') 	-- Toggle no highlight with Esc

-- Autoclose character pairs
-- map('i', '\'', '\'\'<left>')
-- map('i', '"', '""<left>')
-- map('i', '(', '()<left>')
-- map('i', '[', '[]<left>')
-- map('i', '{', '{}<left>')
--
-- Text alignment
map('x', 'ga', '<Plug>(EasyAlign)')
map('n', 'ga', '<Plug>(EasyAlign)')

-- Closing & saving buffers & windows
map('n', '<M-q>', ':q<cr>')                 -- Close window
map('n', '<M-w>', ':lua CloseBuffer()<cr>') -- Call function close buffer
map('n', '<M-s>', ':w<cr>')                 -- Save file
map('n', '<M-S>', ':lua SaveAsAndSwitchToNewBuffer()<cr>')      -- Call SaveAs
map('n', '<M-r>', ':lua RefreshAll()<cr>')  -- Call RefreshAll()

-- Fzf
map('n', '<M-f>', ':Files<cr>')             -- Fzf: search for file

-- Git
map('n', '<M-g>', ':GFiles?<cr>')           -- Fzf list git status for all files
map('n', '<M-c>', ':BCommits<cr>')          -- Fzf Git commits for the current buffer; visual-select lines to track changes in the range
map('n', '<M-C>', ':Commits<cr>')           -- Fzf Git commits

-- Buffer management
map('n', '<M-b>', ':Buffers<cr>')           -- Fzf list all buffers
map('n', '<M-u>', ':bprevious<cr>')         -- Show previous buffer in current window
map('n', '<M-i>', ':bnext<cr>')             -- Show next buffer in current window
--
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

-- Split resize
map('n', '<C-h>', ':call ResizeSplit("left", 5)<cr>')
map('n', '<C-j>', ':call ResizeSplit("down", 5)<cr>')
map('n', '<C-k>', ':call ResizeSplit("up",   5)<cr>')
map('n', '<C-l>', ':call ResizeSplit("right",5)<cr>')

-- Scrolling
map('n', 'm',':call Smooth_scroll_down(20, 20, 2)<CR>')
map('n', ',',':call Smooth_scroll_up(20, 20, 2)<CR>')
map('n', '<M-m>',':call Smooth_scroll_down(75, 5, 2)<CR>')
map('n', '<M-,>',':call Smooth_scroll_up(75, 5, 2)<CR>')


-- NVIM-LSP
local opts = { noremap=true, silent=true }
map('n', '<M-d>', ':Diagnostics<cr>')  -- List diagnostic for buffer 0 (current buffer)
map('n', '<M-D>', ':DiagnosticsAll<cr>') -- List diagnostick for all buffers
-- map('n', '<M-d>', ':LspDiagnostics 0<cr>')  -- List diagnostic for buffer 0 (current buffer)
-- map('n', '<M-D>', ':LspDiagnosticsAll<cr>') -- List diagnostick for all buffers
map('n', 'gR', vim.lsp.buf.rename)
map('n', 'gr', vim.lsp.buf.references)
map('n', 'gD', vim.lsp.buf.type_definition)
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'gi', vim.lsp.buf.implementation)
map('n', 'gs', vim.lsp.buf.signature_help)
map('n', 'gh', vim.lsp.buf.hover)

-- COC-NVIM
-- map('n', '<M-d>', ':CocFzfList diagnostics<cr>')               -- List diagnostics
-- map('n', '<M-E>', ":call CocAction('diagnosticPrevious')<CR>") -- Go to previous error
-- map('n', '<M-e>', ":call CocAction('diagnosticNext')<CR>")     -- Go to next error
-- -- Do not change the default coc keybindings below so fzf-coc can work
-- map('n', 'gR', '<Plug>(coc-rename)')          -- Rename symbol
-- map('n', 'gd', '<Plug>(coc-definition)')      -- Jump to definition
-- map('n', 'gy', '<Plug>(coc-type-definition)') -- Jump to type definition
-- map('n', 'gi', '<Plug>(coc-implementation)')  -- Jump to implementation
-- map('n', 'gr', '<Plug>(coc-references)')      -- List references

-- TAB COMPLETION - COC-NVIM
-- Mappings for nvim-cmp is defined in init.lua
-- map('i', '<Tab>', function()
--     return vim.fn.pumvisible() == 1 and '<C-N>' or '<Tab>'
-- end, {expr = true})
-- map('i', '<S-Tab>', function()
--     return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-h>'
-- end, {expr = true})

-- ---------------------------------------------------------------------
-- COLORSCHEME
-- :runtime syntax/colortest.vim
-- https://www.ditig.com/256-colors-cheat-sheet
-- ---------------------------------------------------------------------
-- Disable true colors in terminal, since tmux doesn't support it anyway
-- and will convert to 256 approximation, possibly affecting performance.
o.termguicolors = false

-- Helper function to check highlight group of word under cursor
map('n', '<M-v>', ':call ListHighlightGroupWordUnderCursor()<cr>')
vim.cmd [[
    " List all highlighting groups for word under cursor
    function! ListHighlightGroupWordUnderCursor()
        if !exists("*synstack")
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunc
]]

-- Apply colorschemes
vim.cmd [[
" Force GUI vim to follow terminal colors
highlight Normal guifg=none guibg=none gui=none

" Always use same background
highlight Normal ctermbg=black

" -------------------------------------------------
" GUTTER & SIGN COLUMN
" -------------------------------------------------
" highlight SignColumn ctermbg=00
" highlight LineNr     ctermbg=00 ctermfg=08 cterm=none

let xtest='red'

  highlight CursorLine ctermbg=None ctermfg=None cterm=none
  highlight CursorLineNr ctermbg=None ctermfg=white cterm=None

  highlight VertSplit  ctermfg=23
  highlight StatusLine ctermbg=23
  highlight User1      ctermbg=00 ctermfg=23 cterm=bold,underline

  highlight ExtraWhiteSpace ctermbg=red

function! ColorschemeHighlight(group, fg, bg, ...)
  execute 'highlight' a:group
        \ 'guifg=' . a:fg[0]
        \ 'guibg=' . a:bg[0]
        \ 'ctermfg=' . a:fg[1]
        \ 'ctermbg=' . a:bg[1]
        \ 'gui=' . (a:0 >= 1 ?
          \ a:1 :
          \ 'NONE')
        \ 'cterm=' . (a:0 >= 1 ?
          \ a:1 :
          \ 'NONE')
        \ 'guisp=' . (a:0 >= 2 ?
          \ a:2[0] :
          \ 'NONE')
endfunction

let xcc = {
\ 'bgx':        ['#000000',   '00'],
\ 'black':      ['#181819',   '237'],
\ 'bg0':        ['#2c2e34',   '235'],
\ 'bg1':        ['#33353f',   '236'],
\ 'bg2':        ['#363944',   '236'],
\ 'bg3':        ['#3b3e48',   '237'],
\ 'bg4':        ['#414550',   '237'],
\ 'bg_red':     ['#ff6077',   '203'],
\ 'diff_red':   ['#55393d',   '52'],
\ 'bg_green':   ['#a7df78',   '107'],
\ 'diff_green': ['#394634',   '22'],
\ 'bg_blue':    ['#85d3f2',   '110'],
\ 'diff_blue':  ['#354157',   '17'],
\ 'diff_yellow':['#4e432f',   '54'],
\ 'fg':         ['#e2e2e3',   '250'],
\ 'red':        ['#fc5d7c',   '203'],
\ 'orange':     ['#f39660',   '215'],
\ 'yellow':     ['#e7c664',   '179'],
\ 'green':      ['#9ed072',   '107'],
\ 'blue':       ['#76cce0',   '110'],
\ 'purple':     ['#b39df3',   '176'],
\ 'grey':       ['#7f8490',   '246'],
\ 'grey_dim':   ['#595f6f',   '240'],
\ 'none':       ['NONE',      'NONE']
\ }

call ColorschemeHighlight('EndOfBuffer', xcc.bg4, xcc.none)
call ColorschemeHighlight('EndOfBuffer', xcc.bg4, xcc.bg0)
call ColorschemeHighlight('Folded', xcc.grey, xcc.bg1)
call ColorschemeHighlight('ToolbarLine', xcc.fg, xcc.bg2)
call ColorschemeHighlight('FoldColumn', xcc.grey_dim, xcc.none)
call ColorschemeHighlight('SignColumn', xcc.fg, xcc.none)
call ColorschemeHighlight('IncSearch', xcc.bg0, xcc.bg_red)
call ColorschemeHighlight('Search', xcc.bg0, xcc.bg_green)
call ColorschemeHighlight('ColorColumn', xcc.none, xcc.bg1)
call ColorschemeHighlight('Conceal', xcc.grey_dim, xcc.none)
call ColorschemeHighlight('Cursor', xcc.none, xcc.none, 'reverse')
highlight! link vCursor Cursor
highlight! link iCursor Cursor
highlight! link lCursor Cursor
highlight! link CursorIM Cursor
call ColorschemeHighlight('CursorLine', xcc.none, xcc.none, 'underline')
call ColorschemeHighlight('CursorColumn', xcc.none, xcc.none, 'bold')
call ColorschemeHighlight('LineNr', xcc.grey_dim, xcc.none)
" call ColorschemeHighlight('CursorLineNr', xcc.fg, xcc.none, 'underline')
call ColorschemeHighlight('DiffAdd', xcc.none, xcc.diff_green)
call ColorschemeHighlight('DiffChange', xcc.none, xcc.diff_blue)
call ColorschemeHighlight('DiffDelete', xcc.none, xcc.diff_red)
call ColorschemeHighlight('DiffText', xcc.bg0, xcc.blue)
call ColorschemeHighlight('Directory', xcc.green, xcc.none)
call ColorschemeHighlight('ErrorMsg', xcc.red, xcc.none, 'bold,underline')
call ColorschemeHighlight('WarningMsg', xcc.yellow, xcc.none, 'bold')
call ColorschemeHighlight('ModeMsg', xcc.fg, xcc.none, 'bold')
call ColorschemeHighlight('MoreMsg', xcc.blue, xcc.none, 'bold')
call ColorschemeHighlight('MatchParen', xcc.none, xcc.bg4)
call ColorschemeHighlight('NonText', xcc.bg4, xcc.none)
call ColorschemeHighlight('Whitespace', xcc.bg4, xcc.none)
call ColorschemeHighlight('SpecialKey', xcc.bg4, xcc.none)
call ColorschemeHighlight('Pmenu', xcc.fg, xcc.bg2)
call ColorschemeHighlight('PmenuSbar', xcc.none, xcc.bg2)
call ColorschemeHighlight('PmenuSel', xcc.bg0, xcc.bg_blue)
highlight! link WildMenu PmenuSel
call ColorschemeHighlight('PmenuThumb', xcc.none, xcc.grey)
call ColorschemeHighlight('NormalFloat', xcc.fg, xcc.bg2)
call ColorschemeHighlight('FloatBorder', xcc.grey, xcc.bg2)
call ColorschemeHighlight('Question', xcc.yellow, xcc.none)
call ColorschemeHighlight('SpellBad', xcc.none, xcc.none, 'undercurl', xcc.red)
call ColorschemeHighlight('SpellCap', xcc.none, xcc.none, 'undercurl', xcc.yellow)
call ColorschemeHighlight('SpellLocal', xcc.none, xcc.none, 'undercurl', xcc.blue)
call ColorschemeHighlight('SpellRare', xcc.none, xcc.none, 'undercurl', xcc.purple)
call ColorschemeHighlight('VertSplit', xcc.black, xcc.none)
call ColorschemeHighlight('Visual', xcc.none, xcc.bg3)
call ColorschemeHighlight('VisualNOS', xcc.none, xcc.bg3, 'underline')
call ColorschemeHighlight('QuickFixLine', xcc.blue, xcc.none, 'bold')
call ColorschemeHighlight('Debug', xcc.yellow, xcc.none)
call ColorschemeHighlight('debugPC', xcc.bg0, xcc.green)
call ColorschemeHighlight('debugBreakpoint', xcc.bg0, xcc.red)
call ColorschemeHighlight('ToolbarButton', xcc.bg0, xcc.bg_blue)
if has('nvim')
  call ColorschemeHighlight('Substitute', xcc.bg0, xcc.yellow)
  highlight! link DiagnosticFloatingError ErrorFloat
  highlight! link DiagnosticFloatingWarn WarningFloat
  highlight! link DiagnosticFloatingInfo InfoFloat
  highlight! link DiagnosticFloatingHint HintFloat
  highlight! link DiagnosticError ErrorText
  highlight! link DiagnosticWarn WarningText
  highlight! link DiagnosticInfo InfoText
  highlight! link DiagnosticHint HintText
  highlight! link DiagnosticVirtualTextError VirtualTextError
  highlight! link DiagnosticVirtualTextWarn VirtualTextWarning
  highlight! link DiagnosticVirtualTextInfo VirtualTextInfo
  highlight! link DiagnosticVirtualTextHint VirtualTextHint
  highlight! link DiagnosticUnderlineError ErrorText
  highlight! link DiagnosticUnderlineWarn WarningText
  highlight! link DiagnosticUnderlineInfo InfoText
  highlight! link DiagnosticUnderlineHint HintText
  highlight! link DiagnosticSignError RedSign
  highlight! link DiagnosticSignWarn YellowSign
  highlight! link DiagnosticSignInfo BlueSign
  highlight! link DiagnosticSignHint GreenSign
  highlight! link LspDiagnosticsFloatingError ErrorFloat
  highlight! link LspDiagnosticsFloatingWarning WarningFloat
  highlight! link LspDiagnosticsFloatingInformation InfoFloat
  highlight! link LspDiagnosticsFloatingHint HintFloat
  highlight! link LspDiagnosticsDefaultError ErrorText
  highlight! link LspDiagnosticsDefaultWarning WarningText
  highlight! link LspDiagnosticsDefaultInformation InfoText
  highlight! link LspDiagnosticsDefaultHint HintText
  highlight! link LspDiagnosticsVirtualTextError VirtualTextError
  highlight! link LspDiagnosticsVirtualTextWarning VirtualTextWarning
  highlight! link LspDiagnosticsVirtualTextInformation VirtualTextInfo
  highlight! link LspDiagnosticsVirtualTextHint VirtualTextHint
  highlight! link LspDiagnosticsUnderlineError ErrorText
  highlight! link LspDiagnosticsUnderlineWarning WarningText
  highlight! link LspDiagnosticsUnderlineInformation InfoText
  highlight! link LspDiagnosticsUnderlineHint HintText
  highlight! link LspDiagnosticsSignError RedSign
  highlight! link LspDiagnosticsSignWarning YellowSign
  highlight! link LspDiagnosticsSignInformation BlueSign
  highlight! link LspDiagnosticsSignHint GreenSign
  highlight! link LspReferenceText CurrentWord
  highlight! link LspReferenceRead CurrentWord
  highlight! link LspReferenceWrite CurrentWord
  highlight! link LspCodeLens VirtualTextInfo
  highlight! link LspCodeLensSeparator VirtualTextHint
  highlight! link LspSignatureActiveParameter Search
  highlight! link TermCursor Cursor
  highlight! link healthError Red
  highlight! link healthSuccess Green
  highlight! link healthWarning Yellow
endif


" ------------------------------------------------------------------------------------------
" SYNTAX
" ------------------------------------------------------------------------------------------
call ColorschemeHighlight('Type', xcc.blue, xcc.none, 'italic')
call ColorschemeHighlight('Structure', xcc.blue, xcc.none, 'italic')
call ColorschemeHighlight('StorageClass', xcc.blue, xcc.none, 'italic')
call ColorschemeHighlight('Identifier', xcc.orange, xcc.none, 'italic')
call ColorschemeHighlight('Constant', xcc.orange, xcc.none, 'italic')
call ColorschemeHighlight('PreProc', xcc.red, xcc.none)
call ColorschemeHighlight('PreCondit', xcc.red, xcc.none)
call ColorschemeHighlight('Include', xcc.red, xcc.none)
call ColorschemeHighlight('Keyword', xcc.red, xcc.none)
call ColorschemeHighlight('Define', xcc.red, xcc.none)
call ColorschemeHighlight('Typedef', xcc.red, xcc.none)
call ColorschemeHighlight('Exception', xcc.red, xcc.none)
call ColorschemeHighlight('Conditional', xcc.red, xcc.none)
call ColorschemeHighlight('Repeat', xcc.red, xcc.none)
call ColorschemeHighlight('Statement', xcc.red, xcc.none)
call ColorschemeHighlight('Macro', xcc.purple, xcc.none)
call ColorschemeHighlight('Error', xcc.red, xcc.none)
call ColorschemeHighlight('Label', xcc.purple, xcc.none)
call ColorschemeHighlight('Special', xcc.purple, xcc.none)
call ColorschemeHighlight('SpecialChar', xcc.purple, xcc.none)
call ColorschemeHighlight('Boolean', xcc.purple, xcc.none)
call ColorschemeHighlight('String', xcc.yellow, xcc.none)
call ColorschemeHighlight('Character', xcc.yellow, xcc.none)
call ColorschemeHighlight('Number', xcc.purple, xcc.none)
call ColorschemeHighlight('Float', xcc.purple, xcc.none)
call ColorschemeHighlight('Function', xcc.green, xcc.none)
call ColorschemeHighlight('Operator', xcc.red, xcc.none)
call ColorschemeHighlight('Title', xcc.red, xcc.none, 'bold')
call ColorschemeHighlight('Tag', xcc.orange, xcc.none)
call ColorschemeHighlight('Delimiter', xcc.fg, xcc.none)
call ColorschemeHighlight('Comment', xcc.grey, xcc.none, 'italic')
call ColorschemeHighlight('SpecialComment', xcc.grey, xcc.none, 'italic')
call ColorschemeHighlight('Todo', xcc.blue, xcc.none, 'italic')
call ColorschemeHighlight('Ignore', xcc.grey, xcc.none)
call ColorschemeHighlight('Underlined', xcc.none, xcc.none, 'underline')

" ------------------------------------------------------------------------------------------
" PREDEFINED HIGHLIGHT GROUPS
" ------------------------------------------------------------------------------------------
call ColorschemeHighlight('Fg', xcc.fg, xcc.none)
call ColorschemeHighlight('Grey', xcc.grey, xcc.none)
call ColorschemeHighlight('Red', xcc.red, xcc.none)
call ColorschemeHighlight('Orange', xcc.orange, xcc.none)
call ColorschemeHighlight('Yellow', xcc.yellow, xcc.none)
call ColorschemeHighlight('Green', xcc.green, xcc.none)
call ColorschemeHighlight('Blue', xcc.blue, xcc.none)
call ColorschemeHighlight('Purple', xcc.purple, xcc.none)
call ColorschemeHighlight('RedItalic', xcc.red, xcc.none, 'italic')
call ColorschemeHighlight('OrangeItalic', xcc.orange, xcc.none, 'italic')
call ColorschemeHighlight('YellowItalic', xcc.yellow, xcc.none, 'italic')
call ColorschemeHighlight('GreenItalic', xcc.green, xcc.none, 'italic')
call ColorschemeHighlight('BlueItalic', xcc.blue, xcc.none, 'italic')
call ColorschemeHighlight('PurpleItalic', xcc.purple, xcc.none, 'italic')
call ColorschemeHighlight('RedSign', xcc.red, xcc.none)
call ColorschemeHighlight('OrangeSign', xcc.orange, xcc.none)
call ColorschemeHighlight('YellowSign', xcc.yellow, xcc.none)
call ColorschemeHighlight('GreenSign', xcc.green, xcc.none)
call ColorschemeHighlight('BlueSign', xcc.blue, xcc.none)
call ColorschemeHighlight('PurpleSign', xcc.purple, xcc.none)

" ------------------------------------------------------------------------------------------
" DIAGNOSTIC
" ------------------------------------------------------------------------------------------
call ColorschemeHighlight('ErrorText', xcc.none, xcc.diff_red, 'undercurl', xcc.red)
call ColorschemeHighlight('WarningText', xcc.none, xcc.diff_yellow, 'undercurl', xcc.yellow)
call ColorschemeHighlight('InfoText', xcc.none, xcc.diff_blue, 'undercurl', xcc.blue)
call ColorschemeHighlight('HintText', xcc.none, xcc.diff_green, 'undercurl', xcc.green)
call ColorschemeHighlight('ErrorLine', xcc.none, xcc.diff_red)
call ColorschemeHighlight('WarningLine', xcc.none, xcc.diff_yellow)
call ColorschemeHighlight('InfoLine', xcc.none, xcc.diff_blue)
call ColorschemeHighlight('HintLine', xcc.none, xcc.diff_green)
highlight! link VirtualTextWarning Yellow
highlight! link VirtualTextError Red
highlight! link VirtualTextInfo Blue
highlight! link VirtualTextHint Green
call ColorschemeHighlight('ErrorFloat', xcc.red, xcc.bg2)
call ColorschemeHighlight('WarningFloat', xcc.yellow, xcc.bg2)
call ColorschemeHighlight('InfoFloat', xcc.blue, xcc.bg2)
call ColorschemeHighlight('HintFloat', xcc.green, xcc.bg2)
call ColorschemeHighlight('CurrentWord', xcc.bg0, xcc.green)

" ------------------------------------------------------------------------------------------
" nvim-treesitter/nvim-treesitter
" ------------------------------------------------------------------------------------------
call ColorschemeHighlight('TSStrong', xcc.none, xcc.none, 'bold')
call ColorschemeHighlight('TSEmphasis', xcc.none, xcc.none, 'italic')
call ColorschemeHighlight('TSUnderline', xcc.none, xcc.none, 'underline')
call ColorschemeHighlight('TSNote', xcc.bg0, xcc.blue, 'bold')
call ColorschemeHighlight('TSWarning', xcc.bg0, xcc.yellow, 'bold')
call ColorschemeHighlight('TSDanger', xcc.bg0, xcc.red, 'bold')
highlight! link TSAnnotation BlueItalic
highlight! link TSAttribute BlueItalic
highlight! link TSBoolean Purple
highlight! link TSCharacter Yellow
highlight! link TSComment Comment
highlight! link TSConditional Red
highlight! link TSConstBuiltin OrangeItalic
highlight! link TSConstMacro OrangeItalic
highlight! link TSConstant OrangeItalic
highlight! link TSConstructor Green
highlight! link TSException Red
highlight! link TSField Green
highlight! link TSFloat Purple
highlight! link TSFuncBuiltin Green
highlight! link TSFuncMacro Green
highlight! link TSFunction Green
highlight! link TSInclude Red
highlight! link TSKeyword Red
highlight! link TSKeywordFunction Red
highlight! link TSKeywordOperator Red
highlight! link TSLabel Red
highlight! link TSMethod Green
highlight! link TSNamespace BlueItalic
highlight! link TSNone Fg
highlight! link TSNumber Purple
highlight! link TSOperator Red
highlight! link TSParameter Fg
highlight! link TSParameterReference Fg
highlight! link TSProperty Fg
highlight! link TSPunctBracket Grey
highlight! link TSPunctDelimiter Grey
highlight! link TSPunctSpecial Yellow
highlight! link TSRepeat Red
highlight! link TSStorageClass Red
highlight! link TSString Yellow
highlight! link TSStringEscape Green
highlight! link TSStringRegex Green
highlight! link TSStructure OrangeItalic
highlight! link TSSymbol Fg
highlight! link TSTag BlueItalic
highlight! link TSTagDelimiter Red
highlight! link TSText Green
highlight! link TSStrike Grey
highlight! link TSMath Yellow
highlight! link TSType BlueItalic
highlight! link TSTypeBuiltin BlueItalic
highlight! link TSURI markdownUrl
highlight! link TSVariable Fg
highlight! link TSVariableBuiltin OrangeItalic

" ------------------------------------------------------------------------------------------
" junegunn/fzf.vim {{{
" ------------------------------------------------------------------------------------------
let g:fzf_colors = {
      \ 'fg': ['fg', 'Normal'],
      \ 'bg': ['bg', 'Normal'],
      \ 'hl': ['fg', 'Green'],
      \ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+': ['fg', 'Green'],
      \ 'info': ['fg', 'Yellow'],
      \ 'border':  ['fg', 'Grey'],
      \ 'prompt': ['fg', 'Red'],
      \ 'pointer': ['fg', 'Blue'],
      \ 'marker': ['fg', 'Blue'],
      \ 'spinner': ['fg', 'Yellow'],
      \ 'header': ['fg', 'Blue']
      \ }

" ------------------------------------------------------------------------------------------
" airblade/vim-gitgutter {{{
" ------------------------------------------------------------------------------------------
highlight! link GitGutterAdd GreenSign
highlight! link GitGutterChange BlueSign
highlight! link GitGutterDelete RedSign
highlight! link GitGutterChangeDelete PurpleSign
highlight! link GitGutterAddLine DiffAdd
highlight! link GitGutterChangeLine DiffChange
highlight! link GitGutterDeleteLine DiffDelete
highlight! link GitGutterChangeDeleteLine DiffChange
highlight! link GitGutterAddLineNr Green
highlight! link GitGutterChangeLineNr Blue
highlight! link GitGutterDeleteLineNr Red
highlight! link GitGutterChangeDeleteLineNr Purple

" ------------------------------------------------------------------------------------------
if has('nvim')
    " hrsh7th/nvim-cmp
" ------------------------------------------------------------------------------------------
    call ColorschemeHighlight('CmpItemAbbrMatch', xcc.green, xcc.none, 'bold')
    call ColorschemeHighlight('CmpItemAbbrMatchFuzzy', xcc.green, xcc.none, 'bold')
    highlight! link CmpItemAbbr Fg
    highlight! link CmpItemAbbrDeprecated Fg
    highlight! link CmpItemMenu Fg
    highlight! link CmpItemKind Blue
    highlight! link CmpItemKindText Fg
    highlight! link CmpItemKindMethod Green
    highlight! link CmpItemKindFunction Green
    highlight! link CmpItemKindConstructor Green
    highlight! link CmpItemKindField Green
    highlight! link CmpItemKindVariable Orange
    highlight! link CmpItemKindClass Blue
    highlight! link CmpItemKindInterface Blue
    highlight! link CmpItemKindModule Blue
    highlight! link CmpItemKindProperty Orange
    highlight! link CmpItemKindUnit Purple
    highlight! link CmpItemKindValue Purple
    highlight! link CmpItemKindEnum Blue
    highlight! link CmpItemKindKeyword Red
    highlight! link CmpItemKindSnippet Yellow
    highlight! link CmpItemKindColor Yellow
    highlight! link CmpItemKindFile Yellow
    highlight! link CmpItemKindReference Yellow
    highlight! link CmpItemKindFolder Yellow
    highlight! link CmpItemKindEnumMember Purple
    highlight! link CmpItemKindConstant Orange
    highlight! link CmpItemKindStruct Blue
    highlight! link CmpItemKindEvent Red
    highlight! link CmpItemKindOperator Red
    highlight! link CmpItemKindTypeParameter Blue
endif
]]
