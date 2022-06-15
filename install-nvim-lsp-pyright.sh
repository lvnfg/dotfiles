#!/bin/bash
set -euo pipefail
echo 🚸 $0

# Require nodejs and npm

# ---------------------------------------
# COC-NVIM
# ---------------------------------------
nvim --headless +"CocInstall -sync coc-pyright | qa"

# ---------------------------------------
# NVIM LSP
# ---------------------------------------
# npm install -g pyright

echo "✅ $0"
