local g   = vim.g   -- Global variables

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

-- ----------------------------------------------------------------------------
-- Core plugins
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- colorschemes
-- ----------------------------------------------------------------------------
vim.cmd [[ silent! colorscheme sonokai ]]
vim.cmd [[ highlight Normal guibg=black ]]
-- vim.cmd [[ highlight SignColumn guibg=black ]]

-- ----------------------------------------------------------------------------
-- nvim-treesitter
-- ----------------------------------------------------------------------------
if exists('nvim-treesitter.configs') then
    local tsconfig = require('nvim-treesitter.configs')
    tsconfig.setup {
      highlight = {
        enable = true,
      }
    }
end

-- ----------------------------------------------------------------------------
-- nvim-lspconfig + fzf-lsp
-- ----------------------------------------------------------------------------
if exists('lspconfig') then
    local lspconfig = require('lspconfig')
    -- Setup language server settings
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
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
        single_file_support = true
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

-- ----------------------------------------------------------------------------
-- nvim-cmp & autocompletion plugins
-- ----------------------------------------------------------------------------
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
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
end
