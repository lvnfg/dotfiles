-- nvim-lsp
-- -----------------------------------------------------------------------
-- Enable nvim-diagnostic
local on_attach_vim = function()
	require'completion'.on_attach()
	require'diagnostic'.on_attach()
end

-- nvim-compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

-- Enable nvim_lsp
local nvim_lsp = require'nvim_lsp'

-- Setup MS python language server in nvim-lsp
nvim_lsp.pyls_ms.setup{
	on_attach=on_attach_vim;	-- require'completion'.on_attach() if not using diag-nvim 
	init_options = {
		analysisUpdates = true,
		asyncStartup = true,
		displayOptions = {},
		interpreter = {
			properties = {
				InterpreterPath = "/usr/bin/python3",
				Version = "3.7"
			}
		}
	}
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
