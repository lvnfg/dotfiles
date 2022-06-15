#!/bin/bash
set -euo pipefail
echo 🚸 $0

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

echo "✅ $0"
