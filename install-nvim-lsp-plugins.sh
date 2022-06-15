#!/bin/bash
set -euo pipefail

NAME="neovim lsp plugins"
echo $NAME 🚸

# Install core plugins
cd "$path/vim/plugins"
# coc-nvim. Requires nodejs and npm
apt-get install nodejs -y
apt-get install npm -y
git clone https://github.com/neoclide/coc.nvim || true

echo $NAME ✅
