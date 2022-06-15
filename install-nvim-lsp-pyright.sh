#!/bin/bash
set -euo pipefail
echo 🚸 $0

# Require nodejs and npm

# ---------------------------------------
# NVIM LSP
# ---------------------------------------
npm install -g pyright

# ---------------------------------------
# COC-NVIM
# ---------------------------------------
# nvim --headless +"CocInstall -sync coc-pyright | qa"


echo "✅ $0"
