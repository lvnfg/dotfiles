#!/bin/bash
set -euo pipefail
echo 🚸 $0

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$path/vim/plugins"    # in .gitignore so not guaranteed to exists
cd "$path/vim/plugins"

# ---------------------------------------------
# TREESITTER
# Require apt install build-essentials if not exists
# ---------------------------------------------
git clone https://github.com/nvim-treesitter/nvim-treesitter || true
nvim --headless +"TSInstall python bash lua" +'sleep 20' +'qa'

# ---------------------------------------------
# NVIM-LSP
# ---------------------------------------------
git clone https://github.com/neovim/nvim-lspconfig || true
# Use fzf to search & preview lsp actions
git clone https://github.com/lvnfg/fzf-lsp.nvim || true
# git clone https://github.com/lvnfg/nvim-lspfuzzy || true
# Autocompletion plugins
git clone https://github.com/hrsh7th/cmp-nvim-lsp || true
git clone https://github.com/hrsh7th/cmp-buffer || true
git clone https://github.com/hrsh7th/cmp-path || true
git clone https://github.com/hrsh7th/cmp-cmdline || true
git clone https://github.com/hrsh7th/nvim-cmp || true
git clone https://github.com/hrsh7th/cmp-vsnip || true
git clone https://github.com/hrsh7th/vim-vsnip || true

# ---------------------------------------------
# COC-NVIM
# ---------------------------------------------
# Require nodejs and npm
# path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# mkdir -p "$path/vim/plugins"    # in .gitignore so not guaranteed to exists
# cd "$path/vim/plugins"
# git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1 || true
# nvim -c "helptags coc.nvim/doc/ | q"

# FZF-coc nvim integration
# git clone https://github.com/lvnfg/coc-fzf || true

echo "✅ $0"
