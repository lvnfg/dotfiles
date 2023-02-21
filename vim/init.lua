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
-- TERMINAL
-- ---------------------------------------------------------------------
-- Disable line numbers in terminal
-- Disable line numbers in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = {"*"},
    command = "setlocal nonumber norelativenumber",
})
-- Always start terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = {"*"},
    command = "startinsert",
})
-- Always enter terminal in insert mode
vim.api.nvim_create_autocmd("BufEnter,WinEnter", {
    pattern = {"*"},
    command = "if &buftype == 'terminal' | :startinsert | endif",
})

-- ---------------------------------------------------------------------
-- SEND TEXT TO BUILT-IN TERMINAL
-- Similar to emacs SLIME plugins to send existing text in vim to external interface, such as REPL.
-- Refactored and simplified code from source at: https://github.com/lvnfg/vim-slime
-- ---------------------------------------------------------------------
-- Set text channel id to last opened terminal
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = {"*"},
    command = "let g:last_terminal_channel_id = &channel",
})
-- Set text channel id to last entered terminal
vim.api.nvim_create_autocmd("BufEnter,WinEnter", {
    pattern = {"*"},
    command = "if &buftype == 'terminal' | exec 'let g:last_terminal_channel_id = b:terminal_job_id' | endif",
})
-- Core methods
vim.cmd [[
" Send to neovim terminal
function! s:NeovimSend(text)
    call chansend(str2nr(g:last_terminal_channel_id), a:text)
endfunction

function! Slime_send_visual() abort
    " Save cursor position
    let s:cur = winsaveview()

    silent exe "normal! `<V`>y"

    call setreg('"', @", 'V')
    call s:NeovimSend(@")

    " Restore cursor
    call winrestview(s:cur)
    unlet s:cur
endfunction

function! Slime_send_normal() abort
    let line=getline('.')
    echo "test normal"
    call setreg('"', line, 'V')
    call s:NeovimSend(@")
endfunction

" KEYBINDINGS
nmap <script> <silent> <M-e> :call Slime_send_normal()<cr>
xmap <script> <silent> <M-e> :<c-u>call Slime_send_visual()<cr>
]]

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
-- vim-better-whitespace
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0
-- vim-tmux-navigator
g.tmux_navigator_no_mappings = 1
-- vim-gitgutter
g.gitgutter_map_keys = 0    -- Disable all key mappings
g.gitgutter_realtime = 1
g.gitgutter_eager =
-- vim-easy-align
-- g.easy_align_ignore_groups = '[]'  -- [] = Align everything, including strings and comments.
-- C-g to cycle through options interactively.

-- colorschemes
vim.cmd [[ silent! colorscheme sonokai ]]
vim.cmd [[ highlight Normal guibg=black ]]
-- vim.cmd [[ highlight SignColumn guibg=black ]]

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
-- KEYBINDINGS
-- ---------------------------------------------------------------------
-- Remap leader key
vim.g.mapleader = ' '

-- TAB COMPLETION - COC-NVIM
-- Mappings for nvim-cmp is defined in init.lua
-- map('i', '<Tab>', function()
--     return vim.fn.pumvisible() == 1 and '<C-N>' or '<Tab>'
-- end, {expr = true})
-- map('i', '<S-Tab>', function()
--     return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-h>'
-- end, {expr = true})

-- Text editing
map('n', '<Esc>', ':noh<cr>') 	-- Toggle no highlight with Esc
-- Autoclose character pairs
-- map('i', '\'', '\'\'<left>')
-- map('i', '"', '""<left>')
-- map('i', '(', '()<left>')
-- map('i', '[', '[]<left>')
-- map('i', '{', '{}<left>')
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

-- Navigation
-- map('n', '<C-h>', ':bprevious<cr>')         -- Show previous buffer in current window
-- map('n', '<C-l>', ':bnext<cr>')             -- Show next buffer in current window
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

-- ---------------------------------------------------------------------
-- SPLIT RESIZING
-- Original: https://github.com/terryma/vim-smooth-scroll
-- ---------------------------------------------------------------------
map('n', '<C-h>', ':call ResizeSplit("left", 5)<cr>')
map('n', '<C-j>', ':call ResizeSplit("down", 5)<cr>')
map('n', '<C-k>', ':call ResizeSplit("up",   5)<cr>')
map('n', '<C-l>', ':call ResizeSplit("right",5)<cr>')

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
map('n', 'm',':call Smooth_scroll_down(20, 20, 2)<CR>')
map('n', ',',':call Smooth_scroll_up(20, 20, 2)<CR>')
map('n', '<M-m>',':call Smooth_scroll_down(75, 5, 2)<CR>')
map('n', '<M-,>',':call Smooth_scroll_up(75, 5, 2)<CR>')

-- ---------------------------------------------------------------------
-- COLORSCHEMES
-- ---------------------------------------------------------------------
-- Predefined colors
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

-- ---------------------------------------------------------------------
-- EDITOR SETTINGS
-- ------------------------------------------------------------------
o.mouse         = 'a'
o.syntax        = 'on'
o.termguicolors = false   -- true = enable true colors, false = only ansi 16 colors
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
o.cursorline    = true

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
    sline = sline .. '%1*%<(%n)' -- %n for buffer number, set background colors
    sline = sline .. ' %1*%<%F'  -- %F for full file path, set background color
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
function SaveAsAndKeepCurrentBuffer()
    local dir = vim.api.nvim_eval("expand('%:p:h')")
    local cmd = ':!cp % ' .. dir .. '/'
    vim.fn.feedkeys(cmd)
end
--
function SaveAsAndSwitchToNewBuffer()
    local dir = vim.api.nvim_eval("expand('%:p:h')")
    local cmd = ':saveas ' .. dir .. '/'
    vim.fn.feedkeys(cmd)
end

-- Refresh all editor states
function RefreshAll()
    vim.cmd [[ GitGutterAll ]]
end
