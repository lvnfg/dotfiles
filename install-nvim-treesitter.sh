#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

echo "Installing nvim treesitter plugin"
PLUGDIR="$HOME/.local/share/nvim/site/pack/plugins/start"
mkdir -p $PLUGDIR
cd $PLUGDIR
# ----------------------------------------------------------------------------
# nvim-treesitter
# Require apt install build-essential to build language parsers (vim, lua, python...)
# ----------------------------------------------------------------------------
git clone https://github.com/nvim-treesitter/nvim-treesitter --depth 1 || true
