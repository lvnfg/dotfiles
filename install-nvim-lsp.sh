#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

# echo "Installing nvim LSP and associated plugins"
# PLUGDIR="$HOME/.local/share/nvim/site/pack/plugins/start"
# mkdir -p $PLUGDIR
# cd $PLUGDIR
# # ----------------------------------------------------------------------------
# # nvim-lspconfig + fzf-lsp
# # ----------------------------------------------------------------------------
# git clone https://github.com/lvnfg/nvim-lspconfig --depth 1 || true
# git clone https://github.com/lvnfg/fzf-lsp.nvim   --depth 1 || true
# # ----------------------------------------------------------------------------
# # nvim-cmp & autocompletion plugins
# # ----------------------------------------------------------------------------
# git clone https://github.com/lvnfg/cmp-nvim-lsp --depth 1 || true
# git clone https://github.com/lvnfg/cmp-buffer   --depth 1 || true
# git clone https://github.com/lvnfg/cmp-path     --depth 1 || true
# git clone https://github.com/lvnfg/cmp-cmdline  --depth 1 || true
# git clone https://github.com/lvnfg/nvim-cmp     --depth 1 || true
# git clone https://github.com/lvnfg/cmp-vsnip    --depth 1 || true
# git clone https://github.com/lvnfg/vim-vsnip    --depth 1 || true
