#!/bin/bash
set -euo pipefail

NAME="nvim lsp pyright"
echo $NAME 🚸

# ---------------------------------------
# COC-NVIM
# ---------------------------------------
nvim --headless +'CocInstall coc-pyright' +qa

# ---------------------------------------
# NVIM LSP
# ---------------------------------------
# apt-get install nodejs -y
# apt-get install npm -y
# npm install -g pyright

echo $NAME ✅
