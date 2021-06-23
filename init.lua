-- nvim-lsp
-- -----------------------------------------------------------------------
-- Enable nvim-diagnostic
local on_attach_vim = function()
	require'completion'.on_attach()
	require'diagnostic'.on_attach()
end

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
