-- nvim-lsp
-- -----------------------------------------------------------------------
local nvim_lsp = require'nvim_lsp'
nvim_lsp.pyls_ms.setup{
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

-- completion-nvim
-- -----------------------------------------------------------------------
require'nvim_lsp'.pyls_ms.setup{on_attach=require'completion'.on_attach}
