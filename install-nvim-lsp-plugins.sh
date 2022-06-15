#!/bin/bash
set -euo pipefail
echo 🚸 $0

# Require nodejs and npm

# ---------------------------------------------
# COC-NVIM
# ---------------------------------------------
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$path/vim/plugins"    # in .gitignore so not guaranteed to exists
cd "$path/vim/plugins"
git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1 || true
nvim -c "helptags coc.nvim/doc/ | q"

echo "✅ $0"
